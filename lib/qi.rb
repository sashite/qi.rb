# frozen_string_literal: true

# The Qi abstraction.
#
# @example
#   Qi.call(
#     [43, 13, "+B"],
#     "side_id": 0,
#     "board": {
#        3 => "s",
#        4 => "k",
#        5 => "s",
#       22 => "+P",
#       43 => "+B"
#     },
#     "hands": [
#       %w[S],
#       %w[r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
#     ]
#   )
#   # => {:side_id=>1, :board=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}, :hands=>[["S"], ["r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"]]}
module Qi
  # Apply a move to the position.
  #
  # @param move [Array] The move to play.
  # @param side_id [Integer] The identifier of the player who must play.
  # @param board [Hash] The indexes of each piece on the board.
  # @param hands [Array] The list of pieces in hand grouped by players.
  #
  # @see https://developer.sashite.com/specs/portable-chess-notation
  # @see https://developer.sashite.com/specs/portable-move-notation
  #
  # @example
  #   call(
  #     [43, 13, "+B"],
  #     "side_id": 0,
  #     "board": {
  #        3 => "s",
  #        4 => "k",
  #        5 => "s",
  #       22 => "+P",
  #       43 => "+B"
  #     },
  #     "hands": [
  #       %w[S],
  #       %w[r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
  #     ]
  #   )
  #   # => {:side_id=>1, :board=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}, :hands=>[["S"], ["r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"]]}
  #
  # @return [Hash] The next position.
  def self.call(move, side_id:, board:, hands:)
    updated_board = board.dup
    updated_in_hand_pieces = hands.fetch(side_id).dup

    actions = move.each_slice(4)

    actions.each do |action|
      src_square_id       = action.fetch(0)
      dst_square_id       = action.fetch(1)
      moved_piece_name    = action.fetch(2)
      captured_piece_name = action.fetch(3, nil)

      if src_square_id.nil?
        piece_in_hand_id = updated_in_hand_pieces.index(moved_piece_name)
        updated_in_hand_pieces.delete_at(piece_in_hand_id) unless piece_in_hand_id.nil?
      else
        updated_board.delete(src_square_id)
      end

      updated_board[dst_square_id] = moved_piece_name
      updated_in_hand_pieces.push(captured_piece_name) unless captured_piece_name.nil?
    end

    updated_hands = hands.dup
    updated_hands[side_id] = updated_in_hand_pieces

    {
      side_id: side_id.succ % hands.length,
      board: updated_board,
      hands: updated_hands
    }
  end
end
