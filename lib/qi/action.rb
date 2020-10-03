# frozen_string_literal: true

module Qi
  # The Action abstraction.
  class Action
    # Initialize an action instance.
    #
    # @param src_square_id [Integer, nil] The source square ID.
    # @param dst_square_id [Integer] The target square ID.
    # @param moved_piece_name [String] The moved piece name.
    # @param captured_piece_name [String, nil] The captured piece name.
    #
    # @example Initialize a promoted bishop action from 43 to 13
    #   new(43, 13, "+B", nil)
    #
    # @see https://developer.sashite.com/specs/portable-action-notation
    def initialize(src_square_id, dst_square_id, moved_piece_name, captured_piece_name = nil)
      @src_square_id = src_square_id
      @dst_square_id = dst_square_id
      @moved_piece_name = moved_piece_name
      @captured_piece_name = captured_piece_name
    end

    # Commit an action to the position.
    #
    # @param in_hand [Array] The list of pieces in hand.
    # @param square [Hash] The index of each piece on the board.
    #
    # @example Commit a Shogi action to the piece set of a position
    #   call(
    #     43, 13, "+B", nil,
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
    # @return [Hash] The next piece set.
    def call(in_hand:, square:)
      in_hand = in_hand.dup
      square = square.dup

      if @src_square_id.nil?
        piece_in_hand_id = in_hand.index(@moved_piece_name)
        in_hand.delete_at(piece_in_hand_id) unless piece_in_hand_id.nil?
      else
        square.delete(@src_square_id)
      end

      square[@dst_square_id] = @moved_piece_name
      in_hand.push(@captured_piece_name) unless @captured_piece_name.nil?

      { in_hand: in_hand, square: square }
    end
  end
end
