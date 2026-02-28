# frozen_string_literal: true

class Qi
  # Pure functions for flat board operations.
  #
  # A board is stored as a flat +Array+ in row-major order where each
  # element is either +nil+ (empty square) or a +String+ (a piece).
  # The board shape (dimensions) is maintained separately.
  #
  # This module provides three categories of functions:
  #
  # - *Shape validation* — checks dimension count, types, and bounds.
  # - *Diff application* — applies index-to-piece changes to a flat board.
  # - *Nested conversion* — reconstructs a nested array from a flat board
  #   and its shape, for display or serialization.
  #
  # All functions are stateless and side-effect-free.
  #
  # @example Validate a shape
  #   Qi::Board.validate_shape([8, 8]) #=> 64
  #
  # @example Apply a diff
  #   board = Array.new(4)
  #   new_board, new_count = Qi::Board.apply_diff(board, 4, 0, { 0 => "K", 3 => "k" })
  #   new_board #=> ["K", nil, nil, "k"]
  #   new_count #=> 2
  #
  # @example Convert to nested
  #   Qi::Board.to_nested(["a", nil, nil, "b"], [2, 2]) #=> [["a", nil], [nil, "b"]]
  module Board
    MAX_DIMENSIONS     = 3
    MAX_DIMENSION_SIZE = 255

    # Validates board dimensions and returns the total square count.
    #
    # @param shape [Array<Integer>] dimension sizes (1 to 3 integers, each 1–255).
    # @return [Integer] the total number of squares.
    # @raise [ArgumentError] if the shape is invalid.
    #
    # @example
    #   Qi::Board.validate_shape([8, 8])    #=> 64
    #   Qi::Board.validate_shape([9, 9])    #=> 81
    #   Qi::Board.validate_shape([5, 5, 5]) #=> 125
    def self.validate_shape(shape)
      if shape.empty?
        raise ::ArgumentError, "at least one dimension is required"
      end

      if shape.size > MAX_DIMENSIONS
        raise ::ArgumentError, "board exceeds #{MAX_DIMENSIONS} dimensions (got #{shape.size})"
      end

      shape.each do |dim|
        unless dim.is_a?(::Integer)
          raise ::ArgumentError, "dimension size must be an Integer, got #{dim.class}"
        end

        if dim < 1
          raise ::ArgumentError, "dimension size must be at least 1, got #{dim}"
        end

        if dim > MAX_DIMENSION_SIZE
          raise ::ArgumentError, "dimension size #{dim} exceeds maximum of #{MAX_DIMENSION_SIZE}"
        end
      end

      shape.reduce(:*)
    end

    # Applies changes to a flat board, returning a new array and updated piece count.
    #
    # Each change maps a flat index to a piece (+String+) or +nil+ (empty).
    # The original board is not modified.
    #
    # @param board [Array] the current flat board.
    # @param square_count [Integer] number of squares on the board.
    # @param board_piece_count [Integer] current number of pieces on the board.
    # @param changes [Hash{Integer => String, nil}] flat index to piece mapping.
    # @return [Array(Array, Integer)] +[new_board, new_board_piece_count]+.
    # @raise [ArgumentError] if an index is invalid or a piece is not a String.
    #
    # @example Place two pieces
    #   Qi::Board.apply_diff(Array.new(4), 4, 0, { 0 => "K", 3 => "k" })
    #   #=> [["K", nil, nil, "k"], 2]
    #
    # @example Move a piece
    #   Qi::Board.apply_diff(["K", nil, nil, nil], 4, 1, { 0 => nil, 2 => "K" })
    #   #=> [[nil, nil, "K", nil], 1]
    def self.apply_diff(board, square_count, board_piece_count, changes)
      new_board = board.dup
      delta = 0

      changes.each do |index, piece|
        unless index.is_a?(::Integer) && index >= 0 && index < square_count
          raise ::ArgumentError, "invalid flat index: #{index} (board has #{square_count} squares)"
        end

        unless piece.nil? || piece.is_a?(::String)
          raise ::ArgumentError, "piece must be a String, got #{piece.class}"
        end

        old = new_board[index]
        delta += (piece.nil? ? 0 : 1) - (old.nil? ? 0 : 1)
        new_board[index] = piece
      end

      [new_board, board_piece_count + delta]
    end

    # Converts a flat board into a nested array matching the given shape.
    #
    # This is an O(n) operation intended for display or serialization,
    # not for the hot path.
    #
    # @param board [Array] the flat board.
    # @param shape [Array<Integer>] the board dimensions.
    # @return [Array] a nested array. For a 1D shape, returns a flat array copy.
    #
    # @example 1D board
    #   Qi::Board.to_nested(["a", nil, "b"], [3])
    #   #=> ["a", nil, "b"]
    #
    # @example 2D board
    #   Qi::Board.to_nested(["a", nil, nil, "b"], [2, 2])
    #   #=> [["a", nil], [nil, "b"]]
    #
    # @example 3D board (2×2×2)
    #   flat = ["a", nil, nil, "b", nil, "c", "d", nil]
    #   Qi::Board.to_nested(flat, [2, 2, 2])
    #   #=> [[["a", nil], [nil, "b"]], [[nil, "c"], ["d", nil]]]
    def self.to_nested(board, shape)
      return board.dup if shape.size == 1

      nest(board, compute_chunk_sizes(shape), 0)
    end

    # Pre-computes chunk sizes for each dimension level.
    #
    # For shape [8, 8], returns [8, 1].
    # For shape [5, 5, 5], returns [25, 5, 1].
    # For shape [8], returns [1].
    def self.compute_chunk_sizes(shape)
      sizes = ::Array.new(shape.size)
      sizes[-1] = 1
      (shape.size - 2).downto(0) do |i|
        sizes[i] = sizes[i + 1] * shape[i + 1]
      end
      sizes
    end

    # Recursively slices a flat array into nested sub-arrays.
    def self.nest(flat, chunk_sizes, dim)
      if dim == chunk_sizes.size - 1
        return flat.dup
      end

      chunk = chunk_sizes[dim]
      flat.each_slice(chunk).map { |slice| nest(slice, chunk_sizes, dim + 1) }
    end

    private_class_method :compute_chunk_sizes,
                         :nest
  end
end
