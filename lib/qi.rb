# frozen_string_literal: true

require_relative "qi/board"
require_relative "qi/hands"
require_relative "qi/styles"

# A minimal, format-agnostic library for representing positions in
# two-player, turn-based board games.
#
# Qi models the components of a position as defined by the
# Sashité Game Protocol:
#
# - *Board* — a multi-dimensional rectangular grid (1D, 2D, or 3D)
#   where each square is either empty (+nil+) or occupied by a piece
#   (+String+).
# - *Hands* — collections of off-board pieces (+String+) held by each player.
# - *Styles* — one style +String+ per player side.
# - *Turn* — which player is active (+:first+ or +:second+).
#
# Pieces and styles are normalized to +String+ via interpolation
# (<tt>"#{value}"</tt>), aligning naturally with the notation formats
# in the Sashité ecosystem (FEEN, EPIN, PON, SIN). Qi validates
# structural integrity, not game semantics.
#
# == Construction
#
# A position is constructed from the board shape and player styles.
# The board starts empty (all squares +nil+), both hands start empty,
# and the turn starts as +:first+.
#
#   pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
#
# == Accessors
#
# Use +board+, +first_player_hand+, +second_player_hand+, +turn+,
# +first_player_style+, +second_player_style+, and +shape+ to read
# field values. Mutable fields return defensive copies.
#
# == Transformations
#
# Use +board_diff+, +first_player_hand_diff+, +second_player_hand_diff+,
# and +toggle+ to derive new positions. Transformation methods return
# a new frozen +Qi+ instance and can be chained:
#
#   pos2 = pos.board_diff(12 => nil, 28 => "C:P").first_player_hand_diff("c:p": 1).toggle
#
# @example A chess starting position
#   pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
#     .board_diff(
#       0 => "r", 1 => "n", 2 => "b", 3 => "q", 4 => "k", 5 => "b", 6 => "n", 7 => "r",
#       8 => "p", 9 => "p", 10 => "p", 11 => "p", 12 => "p", 13 => "p", 14 => "p", 15 => "p",
#       48 => "P", 49 => "P", 50 => "P", 51 => "P", 52 => "P", 53 => "P", 54 => "P", 55 => "P",
#       56 => "R", 57 => "N", 58 => "B", 59 => "Q", 60 => "K", 61 => "B", 62 => "N", 63 => "R"
#     )
#   pos.turn               #=> :first
#   pos.first_player_hand  #=> []
class Qi
  MAX_DIMENSIONS     = Board::MAX_DIMENSIONS
  MAX_DIMENSION_SIZE = Board::MAX_DIMENSION_SIZE

  # Creates a validated, immutable position with an empty board.
  #
  # The board starts with all squares empty (+nil+), both hands empty,
  # and the turn set to +:first+. Styles are normalized to +String+
  # and frozen.
  #
  # @param shape [Array<Integer>] dimension sizes (1 to 3 integers, each 1–255).
  # @param first_player_style [#to_s] style for the first player (non-nil,
  #   normalized to +String+).
  # @param second_player_style [#to_s] style for the second player (non-nil,
  #   normalized to +String+).
  # @return [Qi] an immutable, validated position.
  # @raise [ArgumentError] if any constraint is violated.
  #
  # @example 2D chess board
  #   Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  #
  # @example 3D board
  #   Qi.new(5, 5, 5, first_player_style: "R", second_player_style: "r")
  def initialize(*shape, first_player_style:, second_player_style:)
    validate_shape(shape)
    validate_not_nil(:first, first_player_style)
    validate_not_nil(:second, second_player_style)

    @shape               = shape.freeze
    @chunk_sizes         = compute_chunk_sizes(shape).freeze
    @square_count        = shape.reduce(:*)
    @board               = ::Array.new(@square_count)
    @first_hand          = []
    @second_hand         = []
    @first_player_style  = "#{first_player_style}".freeze
    @second_player_style = "#{second_player_style}".freeze
    @turn                = :first
    @board_piece_count   = 0

    freeze
  end

  # --- Accessors ---------------------------------------------------------------

  # Returns the board as a nested array matching the board shape.
  #
  # Each leaf element is +nil+ (empty square) or a +String+ (a piece).
  # The returned structure is an independent copy.
  #
  # @return [Array] nested array (1D, 2D, or 3D depending on shape).
  #
  # @example
  #   pos = Qi.new(2, 3, first_player_style: "C", second_player_style: "c")
  #     .board_diff(0 => "a", 5 => "b")
  #   pos.board #=> [["a", nil, nil], [nil, nil, "b"]]
  def board
    unflatten(@board, @chunk_sizes, 0)
  end

  # Returns the pieces held by the first player.
  #
  # @return [Array<String>] independent copy of the first player's hand.
  def first_player_hand
    @first_hand.dup
  end

  # Returns the pieces held by the second player.
  #
  # @return [Array<String>] independent copy of the second player's hand.
  def second_player_hand
    @second_hand.dup
  end

  # Returns the active player's side.
  #
  # @return [Symbol] +:first+ or +:second+.
  def turn
    @turn
  end

  # Returns the first player's style.
  #
  # @return [String] frozen style value.
  def first_player_style
    @first_player_style
  end

  # Returns the second player's style.
  #
  # @return [String] frozen style value.
  def second_player_style
    @second_player_style
  end

  # Returns the board dimensions.
  #
  # @return [Array<Integer>] independent copy of the shape (e.g., +[8, 8]+).
  def shape
    @shape.dup
  end

  # --- Transformations ---------------------------------------------------------

  # Returns a new position with modified squares on the board.
  #
  # Accepts keyword arguments where each key is a flat index (Integer,
  # 0-based, row-major order) and each value is a piece (normalized to
  # +String+) or +nil+ (empty square).
  #
  # @param squares [Hash{Integer => #to_s, nil}] flat index to piece mapping.
  # @return [Qi] a new immutable position with the updated board.
  # @raise [ArgumentError] if a key is not a valid flat index.
  # @raise [ArgumentError] if the resulting piece count exceeds the board size.
  #
  # @example Move a piece from index 12 to index 28
  #   pos2 = pos.board_diff(12 => nil, 28 => "C:P")
  def board_diff(**squares)
    new_board = @board.dup
    delta = 0

    squares.each do |flat_index, value|
      unless flat_index.is_a?(::Integer) && flat_index >= 0 && flat_index < @square_count
        raise ::ArgumentError, "invalid flat index: #{flat_index} (board has #{@square_count} squares)"
      end

      value = "#{value}" unless value.nil?

      old_value = new_board[flat_index]
      # Track net change in piece count: +1 if filling, -1 if emptying, 0 if replacing.
      delta += (value.nil? ? 0 : 1) - (old_value.nil? ? 0 : 1)
      new_board[flat_index] = value
    end

    derive(new_board, @first_hand, @second_hand, @turn, @board_piece_count + delta)
  end

  # Returns a new position with the first player's hand modified.
  #
  # Accepts keyword arguments where each key is a piece identifier
  # (normalized to +String+) and each value is an integer delta:
  # positive adds copies, negative removes matching pieces (by value
  # equality). A delta of zero is a no-op.
  #
  # @param pieces [Hash{#to_s => Integer}] piece to delta mapping.
  # @return [Qi] a new immutable position with the updated hand.
  # @raise [ArgumentError] if a delta is not an Integer.
  # @raise [ArgumentError] if removing more pieces than present.
  # @raise [ArgumentError] if the resulting piece count exceeds the board size.
  #
  # @example Add a pawn and remove a bishop
  #   pos2 = pos.first_player_hand_diff("S:P": 1, "S:B": -1)
  def first_player_hand_diff(**pieces)
    new_hand = apply_hand_changes(@first_hand, pieces)
    derive(@board, new_hand, @second_hand, @turn, @board_piece_count)
  end

  # Returns a new position with the second player's hand modified.
  #
  # Accepts keyword arguments where each key is a piece identifier
  # (normalized to +String+) and each value is an integer delta:
  # positive adds copies, negative removes matching pieces (by value
  # equality). A delta of zero is a no-op.
  #
  # @param pieces [Hash{#to_s => Integer}] piece to delta mapping.
  # @return [Qi] a new immutable position with the updated hand.
  # @raise [ArgumentError] if a delta is not an Integer.
  # @raise [ArgumentError] if removing more pieces than present.
  # @raise [ArgumentError] if the resulting piece count exceeds the board size.
  #
  # @example Add a captured pawn
  #   pos2 = pos.second_player_hand_diff("c:p": 1)
  def second_player_hand_diff(**pieces)
    new_hand = apply_hand_changes(@second_hand, pieces)
    derive(@board, @first_hand, new_hand, @turn, @board_piece_count)
  end

  # Returns a new position with the active player swapped.
  #
  # All other fields (board, hands, styles) are preserved unchanged.
  #
  # @return [Qi] a new immutable position with the opposite turn.
  #
  # @example
  #   pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  #   pos.turn           #=> :first
  #   pos.toggle.turn    #=> :second
  def toggle
    derive(@board, @first_hand, @second_hand, other_turn, @board_piece_count)
  end

  # Returns a developer-friendly string representation.
  #
  # The format is not stable and should not be parsed.
  #
  # @return [String]
  def inspect
    "#<#{self.class} shape=#{@shape.inspect} turn=#{@turn.inspect}>"
  end

  private

  def other_turn
    @turn == :first ? :second : :first
  end

  # Fast-path constructor for derived positions.
  #
  # Skips shape and style validation since the source position already
  # guarantees these invariants. Only checks cardinality.
  #
  # Unchanged fields are shared by reference — safe because both positions
  # are frozen and accessors return defensive copies.
  def derive(board, first_hand, second_hand, turn, board_piece_count)
    hand_piece_count = first_hand.size + second_hand.size
    validate_cardinality(@square_count, board_piece_count + hand_piece_count)

    instance = self.class.allocate
    instance.send(:init_derived, board, first_hand, second_hand, turn,
                  @shape, @chunk_sizes, @square_count, board_piece_count,
                  @first_player_style, @second_player_style)
    instance
  end

  # Assigns instance variables for a derived position and freezes it.
  def init_derived(board, first_hand, second_hand, turn, shape, chunk_sizes,
                   square_count, board_piece_count, first_player_style,
                   second_player_style)
    @board               = board
    @first_hand          = first_hand
    @second_hand         = second_hand
    @turn                = turn
    @shape               = shape
    @chunk_sizes         = chunk_sizes
    @square_count        = square_count
    @board_piece_count   = board_piece_count
    @first_player_style  = first_player_style
    @second_player_style = second_player_style

    freeze
  end

  # --- Validation --------------------------------------------------------------

  def validate_shape(shape)
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
  end

  def validate_not_nil(side, style)
    raise ::ArgumentError, "#{side} player style must not be nil" if style.nil?
  end

  def validate_cardinality(square_count, piece_count)
    return if piece_count <= square_count

    raise ::ArgumentError, "too many pieces for board size (#{piece_count} pieces, #{square_count} squares)"
  end

  # --- Hand helpers ------------------------------------------------------------

  # Applies delta changes to a hand array, returning a new array.
  #
  # Piece keys are normalized to String via interpolation.
  def apply_hand_changes(hand, changes)
    result = hand.dup

    changes.each do |piece_key, delta|
      unless delta.is_a?(::Integer)
        raise ::ArgumentError, "delta must be an Integer, got #{delta.class} for piece #{piece_key.inspect}"
      end

      next if delta == 0

      piece = "#{piece_key}"

      if delta > 0
        delta.times { result << piece }
      else
        (-delta).times do
          idx = result.index(piece)

          unless idx
            raise ::ArgumentError, "cannot remove #{piece.inspect}: not found in hand"
          end

          result.delete_at(idx)
        end
      end
    end

    result
  end

  # --- Board helpers -----------------------------------------------------------

  # Pre-computes chunk sizes for each dimension level.
  # For shape [8, 8], returns [8, 1].
  # For shape [5, 5, 5], returns [25, 5, 1].
  # For shape [8], returns [1].
  def compute_chunk_sizes(shape)
    sizes = ::Array.new(shape.size)
    sizes[-1] = 1
    (shape.size - 2).downto(0) do |i|
      sizes[i] = sizes[i + 1] * shape[i + 1]
    end
    sizes
  end

  # Reconstructs a nested board structure from a flat Array and
  # pre-computed chunk sizes. Returns an independent copy.
  def unflatten(flat, chunk_sizes, dim)
    if dim == chunk_sizes.size - 1
      return flat.dup
    end

    chunk = chunk_sizes[dim]
    flat.each_slice(chunk).map do |slice|
      unflatten(slice, chunk_sizes, dim + 1)
    end
  end

  freeze
end
