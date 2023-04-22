# frozen_string_literal: true

# The Qi abstraction.
#
# @example
#   Qi.call(
#     [43, 13, "+B"],
#     "in_hand": %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
#     "square": {
#        3 => "s",
#        4 => "k",
#        5 => "s",
#       22 => "+P",
#       43 => "+B"
#     }
#   )
#   # => {:in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"], :square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}}
module Qi
  # Apply a move to the position.
  #
  # @param move [Array] The move to play.
  # @param in_hand [Array] The list of pieces in hand.
  # @param square [Hash] The index of each piece on the board.
  #
  # @see https://developer.sashite.com/specs/portable-chess-notation
  # @see https://developer.sashite.com/specs/portable-move-notation
  #
  # @example A classic Shogi problem
  #   call(
  #     [43, 13, "+B"],
  #     *%w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
  #     **{
  #        3 => "s",
  #        4 => "k",
  #        5 => "s",
  #       22 => "+P",
  #       43 => "+B"
  #     }
  #   )
  #   # => {:in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"], :square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}}
  #
  # @return [Hash] The next position.
  def self.call(move, *in_hand, **square)
    actions = move.each_slice(4)

    actions.each do |action|
      src_square_id       = action.fetch(0)
      dst_square_id       = action.fetch(1)
      moved_piece_name    = action.fetch(2)
      captured_piece_name = action.fetch(3, nil)

      if src_square_id.nil?
        piece_in_hand_id = in_hand.index(moved_piece_name)
        in_hand.delete_at(piece_in_hand_id) unless piece_in_hand_id.nil?
      else
        square.delete(src_square_id)
      end

      square[dst_square_id] = moved_piece_name
      in_hand.push(captured_piece_name) unless captured_piece_name.nil?
    end

    {
      in_hand: in_hand,
      square: square
    }
  end
end
