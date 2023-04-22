# frozen_string_literal: true

require_relative File.join("qi", "action")

# The Qi abstraction.
#
# @example Apply a move to a classic Shogi problem
#   Qi.call(
#     43, 13, "+B",
#     in_hand: %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
#     square: {
#        3 => "s",
#        4 => "k",
#        5 => "s",
#       22 => "+P",
#       43 => "+B"
#     }
#   )
#   # => {:in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"], :square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}}
module Qi
  # Apply an action to the position.
  #
  # @param src_square_id [Integer] A source square index.
  # @param dst_square_id [Integer] A target square index.
  # @param moved_piece_name [String] A piece name.
  # @param captured_piece_name [String] A captured piece name.
  # @param in_hand [Array] The list of pieces in hand.
  # @param square [Hash] The index of each piece on the board.
  #
  # @see https://developer.sashite.com/specs/portable-chess-notation
  # @see https://developer.sashite.com/specs/portable-move-notation
  #
  # @example Apply a move to a classic Shogi problem
  #   call(
  #     43,
  #     13,
  #     "+B",
  #     in_hand: %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
  #     square: {
  #        3 => "s",
  #        4 => "k",
  #        5 => "s",
  #       22 => "+P",
  #       43 => "+B"
  #     }
  #   )
  #   # => {:in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"], :square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}}
  #
  # @return [Hash] The piece set of the next position.
  def self.call(src_square_id, dst_square_id, moved_piece_name, captured_piece_name = nil, in_hand:, square:)
    Action.new(src_square_id, dst_square_id, moved_piece_name, captured_piece_name).call(in_hand: in_hand, square: square)
  end
end
