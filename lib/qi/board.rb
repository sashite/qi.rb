# frozen_string_literal: true

module Qi
  # Pure validation functions for multi-dimensional board structures.
  #
  # A board is represented as a nested Array where:
  #
  # - A *1D board* is a flat array of squares: +[nil, "K^", nil]+
  # - A *2D board* is an array of ranks: +[[nil, nil], ["K^", nil]]+
  # - A *3D board* is an array of layers, each an array of ranks.
  #
  # Each leaf element (square) is either +nil+ (empty) or any non-nil object (a piece).
  #
  # == Constraints
  #
  # - Maximum dimensionality: 3
  # - Maximum size per dimension: 255
  # - At least one square (non-empty board)
  # - Rectangular structure: all sub-arrays at the same depth must have
  #   identical length (enforced globally, not just per-sibling).
  #
  # @example Validate a 2D board
  #   Qi::Board.validate([[:a, nil], [nil, :b]]) #=> [4, 2]
  #
  # @example Validate an empty board
  #   Qi::Board.validate([[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]]) #=> [9, 0]
  module Board
    MAX_DIMENSIONS    = 3
    MAX_DIMENSION_SIZE = 255

    # Validates a board and returns its square and piece counts.
    #
    # Validation proceeds in order of increasing cost: type check, emptiness,
    # shape inference (first-path walk), dimension limits, then a single-pass
    # structural verification with counting.
    #
    # @param board [Object] the board structure to validate.
    # @return [Array(Integer, Integer)] +[square_count, piece_count]+.
    # @raise [ArgumentError] if the board is structurally invalid.
    #
    # @example A 2D board
    #   Qi::Board.validate([[:r, nil, nil], [nil, nil, :R]]) #=> [6, 2]
    #
    # @example A 1D board
    #   Qi::Board.validate([:k, nil, nil, :K]) #=> [4, 2]
    #
    # @example A 3D board (2 layers × 2 ranks × 2 files)
    #   Qi::Board.validate([[[:a, nil], [nil, :b]], [[nil, :c], [:d, nil]]]) #=> [8, 4]
    #
    # @example Non-rectangular boards are rejected
    #   Qi::Board.validate([[:a, :b], [:c]])
    #   # => ArgumentError: non-rectangular board: expected 2 elements, got 1
    def self.validate(board)
      validate_is_array(board)
      validate_non_empty(board)
      shape = compute_shape(board)
      validate_max_dimensions(shape)
      validate_dimension_sizes(shape)
      verify_and_count(board, shape)
    end

    # --- Step 1: basic type checks -------------------------------------------

    def self.validate_is_array(board)
      return if board.is_a?(::Array)

      raise ::ArgumentError, "board must be an Array"
    end

    def self.validate_non_empty(board)
      return unless board.empty?

      raise ::ArgumentError, "board must not be empty"
    end

    # --- Step 2: compute expected shape by walking the first element ----------

    # The shape is an array of dimension sizes, e.g. [2, 3, 8] for
    # 2 layers × 3 ranks × 8 files. We derive it by following the first
    # child at each nesting level.
    def self.compute_shape(board)
      shape = []
      current = board

      while current.is_a?(::Array) && current.first.is_a?(::Array)
        shape << current.size
        current = current.first
      end

      shape << current.size
      shape
    end

    # --- Step 3: validate dimension count and sizes ---------------------------

    def self.validate_max_dimensions(shape)
      dim = shape.size
      return if dim <= MAX_DIMENSIONS

      raise ::ArgumentError, "board exceeds #{MAX_DIMENSIONS} dimensions (got #{dim})"
    end

    def self.validate_dimension_sizes(shape)
      oversized = shape.find { |size| size > MAX_DIMENSION_SIZE }
      return unless oversized

      raise ::ArgumentError, "dimension size #{oversized} exceeds maximum of #{MAX_DIMENSION_SIZE}"
    end

    # --- Step 4: verify structure and count in a single pass ------------------

    def self.verify_and_count(board, shape)
      if shape.size == 1
        verify_and_count_rank(board, shape[0])
      else
        verify_and_count_multi(board, shape)
      end
    end

    # For a 1D shape [n]: single-pass over the rank, verifying all elements are
    # leaves (not arrays) while counting squares and pieces simultaneously.
    def self.verify_and_count_rank(rank, expected)
      unless rank.size == expected
        raise ::ArgumentError, "non-rectangular board: expected #{expected} elements, got #{rank.size}"
      end

      piece_count = 0

      rank.each do |square|
        if square.is_a?(::Array)
          raise ::ArgumentError, "inconsistent board structure: expected flat squares at this level"
        end

        piece_count += 1 unless square.nil?
      end

      [expected, piece_count]
    end

    # For a multi-dimensional shape [n, *rest]: check length, then recurse
    # into each sub-array, accumulating counts.
    def self.verify_and_count_multi(board, shape)
      expected = shape[0]
      rest = shape[1..]

      unless board.size == expected
        raise ::ArgumentError, "non-rectangular board: expected #{expected} elements, got #{board.size}"
      end

      total_squares = 0
      total_pieces  = 0

      board.each do |sub|
        unless sub.is_a?(::Array)
          raise ::ArgumentError, "inconsistent board structure: mixed arrays and non-arrays at same level"
        end

        sq, pc = verify_and_count(sub, rest)
        total_squares += sq
        total_pieces  += pc
      end

      [total_squares, total_pieces]
    end

    private_class_method :validate_is_array,
                         :validate_non_empty,
                         :compute_shape,
                         :validate_max_dimensions,
                         :validate_dimension_sizes,
                         :verify_and_count,
                         :verify_and_count_rank,
                         :verify_and_count_multi
  end
end
