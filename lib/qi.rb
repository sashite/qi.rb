# frozen_string_literal: true

# A minimal, format-agnostic library for representing positions in
# two-player, turn-based board games.
#
# Qi models the four components of a position as defined by the
# Sashité Game Protocol:
#
# - *Board* — a multi-dimensional rectangular grid (1D, 2D, or 3D)
#   where each square is either empty (+nil+) or occupied by a piece
#   (any non-nil object).
# - *Hands* — collections of off-board pieces held by each player.
# - *Styles* — one style value per player side (format-free).
# - *Turn* — which player is active (+:first+ or +:second+).
#
# Piece and style representations are intentionally opaque: Qi validates
# structure, not semantics. This makes the library reusable across FEEN,
# PON, or any other encoding that shares the same positional model.
#
# @example A 3×3 board with two kings and a pawn in hand
#   board  = [[nil, nil, nil], [nil, "K^", nil], [nil, nil, "k^"]]
#   hands  = { first: ["+P"], second: [] }
#   pos    = Qi.new(board, hands, { first: "C", second: "c" }, :first)
#   pos.turn          #=> :first
#   pos.hands[:first] #=> ["+P"]
module Qi
  require_relative "qi/board"
  require_relative "qi/hands"
  require_relative "qi/styles"
  require_relative "qi/position"

  # Creates a new position after validating all structural constraints.
  #
  # @param board [Array] nested array representing the board (1D to 3D).
  # @param hands [Hash] +{ first: Array, second: Array }+ of off-board pieces.
  # @param styles [Hash] +{ first: Object, second: Object }+ of player styles.
  # @param turn [Symbol] +:first+ or +:second+.
  # @return [Qi::Position] an immutable, validated position.
  # @raise [ArgumentError] if any structural constraint is violated.
  #
  # @example A valid position
  #   Qi.new([[:a, nil], [nil, :b]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  #
  # @example An invalid position (too many pieces for the board)
  #   Qi.new([:k], { first: [:P], second: [] }, { first: "C", second: "c" }, :first)
  #   # => ArgumentError: too many pieces for board size (2 pieces, 1 squares)
  def self.new(board, hands, styles, turn)
    Position.new(board, hands, styles, turn)
  end
end
