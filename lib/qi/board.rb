# frozen_string_literal: true

class Qi
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
    # Validation is performed in a single recursive pass that simultaneously
    # infers the board shape, verifies structural regularity, checks dimension
    # limits, and counts squares and pieces.
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
      unless board.is_a?(::Array)
        raise ::ArgumentError, "board must be an Array"
      end

      if board.empty?
        raise ::ArgumentError, "board must not be empty"
      end

      validate_recursive(board, nil, 0)
    end

    # Single-pass recursive validation.
    #
    # At each level, determines whether this is a leaf rank (contains
    # non-Array elements) or an intermediate dimension (contains Arrays).
    # Infers expected sizes from the first element at each level,
    # validates all siblings match, and enforces dimension limits.
    #
    # @param node [Array] the current sub-array being validated.
    # @param expected_size [Integer, nil] expected length (nil if first sibling).
    # @param depth [Integer] current nesting depth (0-based).
    # @return [Array(Integer, Integer)] +[square_count, piece_count]+.
    def self.validate_recursive(node, expected_size, depth)
      if expected_size && node.size != expected_size
        raise ::ArgumentError, "non-rectangular board: expected #{expected_size} elements, got #{node.size}"
      end

      if node.size > MAX_DIMENSION_SIZE
        raise ::ArgumentError, "dimension size #{node.size} exceeds maximum of #{MAX_DIMENSION_SIZE}"
      end

      if node.first.is_a?(::Array)
        # Intermediate dimension: validate depth, then recurse.
        if depth >= MAX_DIMENSIONS - 1
          raise ::ArgumentError, "board exceeds #{MAX_DIMENSIONS} dimensions"
        end

        inner_size = node.first.size

        if inner_size == 0
          raise ::ArgumentError, "board must not be empty"
        end

        total_squares = 0
        total_pieces  = 0

        node.each do |sub|
          unless sub.is_a?(::Array)
            raise ::ArgumentError, "inconsistent board structure: mixed arrays and non-arrays at same level"
          end

          sq, pc = validate_recursive(sub, inner_size, depth + 1)
          total_squares += sq
          total_pieces  += pc
        end

        [total_squares, total_pieces]
      else
        # Leaf rank: count pieces.
        piece_count = 0

        node.each do |square|
          if square.is_a?(::Array)
            raise ::ArgumentError, "inconsistent board structure: expected flat squares at this level"
          end

          piece_count += 1 unless square.nil?
        end

        [node.size, piece_count]
      end
    end

    private_class_method :validate_recursive
  end
end
