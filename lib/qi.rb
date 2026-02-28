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
# - *Board* — a flat array in row-major order (1D, 2D, or 3D) where
#   each element is either empty (+nil+) or occupied by a piece (+String+).
# - *Hands* — piece-to-count hashes (String keys, Integer values) for
#   each player.
# - *Styles* — one style +String+ per player side.
# - *Turn* — which player is active (+:first+ or +:second+).
#
# Pieces and styles must be +String+ values. Non-string inputs are
# rejected at the boundary to avoid per-operation coercion overhead.
#
# == Construction
#
# A position is constructed from the board shape and player styles.
# The board starts empty (all squares +nil+), both hands start empty,
# and the turn starts as +:first+.
#
#   pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
#
# == Accessors
#
# Use +board+, +first_player_hand+, +second_player_hand+, +turn+,
# +first_player_style+, +second_player_style+, and +shape+ to read
# field values. Accessors return internal state directly — callers
# must not mutate the returned objects.
#
# == Transformations
#
# Use +board_diff+, +first_player_hand_diff+, +second_player_hand_diff+,
# and +toggle+ to derive new positions. Transformation methods return
# a new +Qi+ instance and can be chained:
#
#   pos2 = pos.board_diff(12 => nil, 28 => "C:P").first_player_hand_diff("c:p": 1).toggle
#
# @example A chess starting position
#   pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
#     .board_diff(
#       0 => "r", 1 => "n", 2 => "b", 3 => "q", 4 => "k", 5 => "b", 6 => "n", 7 => "r",
#       8 => "p", 9 => "p", 10 => "p", 11 => "p", 12 => "p", 13 => "p", 14 => "p", 15 => "p",
#       48 => "P", 49 => "P", 50 => "P", 51 => "P", 52 => "P", 53 => "P", 54 => "P", 55 => "P",
#       56 => "R", 57 => "N", 58 => "B", 59 => "Q", 60 => "K", 61 => "B", 62 => "N", 63 => "R"
#     )
#   pos.turn               #=> :first
#   pos.first_player_hand  #=> {}
class Qi
  MAX_DIMENSIONS     = Board::MAX_DIMENSIONS
  MAX_DIMENSION_SIZE = Board::MAX_DIMENSION_SIZE

  # Creates a validated position with an empty board.
  #
  # The board starts with all squares empty (+nil+), both hands empty,
  # and the turn set to +:first+. Styles must be +String+ values.
  #
  # @param shape [Array<Integer>] dimension sizes (1 to 3 integers, each 1–255).
  # @param first_player_style [String] style for the first player (non-nil string).
  # @param second_player_style [String] style for the second player (non-nil string).
  # @return [Qi] a validated position.
  # @raise [ArgumentError] if any constraint is violated.
  #
  # @example 2D chess board
  #   Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  #
  # @example 3D board
  #   Qi.new([5, 5, 5], first_player_style: "R", second_player_style: "r")
  def initialize(shape, first_player_style:, second_player_style:)
    @square_count        = Board.validate_shape(shape)
    @first_player_style  = Styles.validate(:first, first_player_style)
    @second_player_style = Styles.validate(:second, second_player_style)
    @shape               = shape
    @board               = ::Array.new(@square_count)
    @first_hand          = {}
    @second_hand         = {}
    @turn                = :first
    @board_piece_count   = 0
    @first_hand_count    = 0
    @second_hand_count   = 0
  end

  # --- Accessors ---------------------------------------------------------------

  # Returns the board as a flat array in row-major order.
  #
  # Each element is +nil+ (empty square) or a +String+ (a piece).
  # The returned array is the internal structure — do not mutate it.
  # Use +to_nested+ when a nested structure is needed.
  #
  # @return [Array<String, nil>] the flat board.
  #
  # @example
  #   pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  #     .board_diff(0 => "k", 3 => "K")
  #   pos.board #=> ["k", nil, nil, "K"]
  def board
    @board
  end

  # Returns the pieces held by the first player.
  #
  # @return [Hash{String => Integer}] piece to count map. Do not mutate.
  def first_player_hand
    @first_hand
  end

  # Returns the pieces held by the second player.
  #
  # @return [Hash{String => Integer}] piece to count map. Do not mutate.
  def second_player_hand
    @second_hand
  end

  # Returns the active player's side.
  #
  # @return [Symbol] +:first+ or +:second+.
  def turn
    @turn
  end

  # Returns the first player's style.
  #
  # @return [String] style value.
  def first_player_style
    @first_player_style
  end

  # Returns the second player's style.
  #
  # @return [String] style value.
  def second_player_style
    @second_player_style
  end

  # Returns the board dimensions.
  #
  # @return [Array<Integer>] the shape (e.g., +[8, 8]+). Do not mutate.
  def shape
    @shape
  end

  # --- Conversions --------------------------------------------------------------

  # Returns the board as a nested array matching the shape.
  #
  # This is an O(n) operation intended for display or serialization,
  # not for the hot path.
  #
  # @return [Array] nested array (1D, 2D, or 3D depending on shape).
  #
  # @example
  #   pos = Qi.new([2, 3], first_player_style: "C", second_player_style: "c")
  #     .board_diff(0 => "a", 5 => "b")
  #   pos.to_nested #=> [["a", nil, nil], [nil, nil, "b"]]
  def to_nested
    Board.to_nested(@board, @shape)
  end

  # --- Transformations ---------------------------------------------------------

  # Returns a new position with modified squares on the board.
  #
  # Accepts keyword arguments where each key is a flat index (Integer,
  # 0-based, row-major order) and each value is a piece (+String+) or
  # +nil+ (empty square).
  #
  # @param squares [Hash{Integer => String, nil}] flat index to piece mapping.
  # @return [Qi] a new position with the updated board.
  # @raise [ArgumentError] if a key is not a valid flat index.
  # @raise [ArgumentError] if a piece is not a String.
  # @raise [ArgumentError] if the resulting piece count exceeds the board size.
  #
  # @example Move a piece from index 12 to index 28
  #   pos2 = pos.board_diff(12 => nil, 28 => "C:P")
  def board_diff(**squares)
    new_board, new_board_piece_count = Board.apply_diff(
      @board, @square_count, @board_piece_count, squares
    )

    validate_cardinality(new_board_piece_count + @first_hand_count + @second_hand_count)

    derive(new_board, @first_hand, @second_hand, @turn,
           new_board_piece_count, @first_hand_count, @second_hand_count)
  end

  # Returns a new position with the first player's hand modified.
  #
  # Accepts keyword arguments where each key is a piece identifier
  # and each value is an integer delta: positive adds copies, negative
  # removes. A delta of zero is a no-op.
  #
  # @param pieces [Hash{Symbol => Integer}] piece to delta mapping.
  # @return [Qi] a new position with the updated hand.
  # @raise [ArgumentError] if a delta is not an Integer.
  # @raise [ArgumentError] if removing more pieces than present.
  # @raise [ArgumentError] if the resulting piece count exceeds the board size.
  #
  # @example Add a pawn and remove a bishop
  #   pos2 = pos.first_player_hand_diff("S:P": 1, "S:B": -1)
  def first_player_hand_diff(**pieces)
    new_hand, new_count = Hands.apply_diff(@first_hand, @first_hand_count, pieces)

    validate_cardinality(@board_piece_count + new_count + @second_hand_count)

    derive(@board, new_hand, @second_hand, @turn,
           @board_piece_count, new_count, @second_hand_count)
  end

  # Returns a new position with the second player's hand modified.
  #
  # Accepts keyword arguments where each key is a piece identifier
  # and each value is an integer delta: positive adds copies, negative
  # removes. A delta of zero is a no-op.
  #
  # @param pieces [Hash{Symbol => Integer}] piece to delta mapping.
  # @return [Qi] a new position with the updated hand.
  # @raise [ArgumentError] if a delta is not an Integer.
  # @raise [ArgumentError] if removing more pieces than present.
  # @raise [ArgumentError] if the resulting piece count exceeds the board size.
  #
  # @example Add a captured pawn
  #   pos2 = pos.second_player_hand_diff("c:p": 1)
  def second_player_hand_diff(**pieces)
    new_hand, new_count = Hands.apply_diff(@second_hand, @second_hand_count, pieces)

    validate_cardinality(@board_piece_count + @first_hand_count + new_count)

    derive(@board, @first_hand, new_hand, @turn,
           @board_piece_count, @first_hand_count, new_count)
  end

  # Returns a new position with the active player swapped.
  #
  # All other fields (board, hands, styles) are preserved unchanged.
  #
  # @return [Qi] a new position with the opposite turn.
  #
  # @example
  #   pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  #   pos.turn           #=> :first
  #   pos.toggle.turn    #=> :second
  def toggle
    derive(@board, @first_hand, @second_hand, other_turn,
           @board_piece_count, @first_hand_count, @second_hand_count)
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
  # guarantees these invariants. Only checks cardinality (done by caller).
  #
  # Unchanged fields are shared by reference — safe because transformation
  # methods never mutate existing state.
  def derive(board, first_hand, second_hand, turn,
             board_piece_count, first_hand_count, second_hand_count)
    instance = self.class.allocate
    instance.send(:init_derived, board, first_hand, second_hand, turn,
                  @shape, @square_count, board_piece_count,
                  first_hand_count, second_hand_count,
                  @first_player_style, @second_player_style)
    instance
  end

  # Assigns instance variables for a derived position.
  def init_derived(board, first_hand, second_hand, turn, shape,
                   square_count, board_piece_count,
                   first_hand_count, second_hand_count,
                   first_player_style, second_player_style)
    @board               = board
    @first_hand          = first_hand
    @second_hand         = second_hand
    @turn                = turn
    @shape               = shape
    @square_count        = square_count
    @board_piece_count   = board_piece_count
    @first_hand_count    = first_hand_count
    @second_hand_count   = second_hand_count
    @first_player_style  = first_player_style
    @second_player_style = second_player_style
  end

  def validate_cardinality(piece_count)
    return if piece_count <= @square_count

    raise ::ArgumentError, "too many pieces for board size (#{piece_count} pieces, #{@square_count} squares)"
  end
end
