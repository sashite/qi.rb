# frozen_string_literal: true

require_relative "action"

module Qi
  # The Move abstraction.
  class Move
    # Initialize a move instance.
    #
    # @param move [Array] The move to apply.
    #
    # @example Initialize a promoted bishop move from 43 to 13
    #   new([43, 13, "+B"])
    #
    # @see https://developer.sashite.com/specs/portable-move-notation
    def initialize(move)
      @actions = move.each_slice(4)
    end

    # Apply a move to the piece set of a position.
    #
    # @param in_hand [Array] The list of pieces in hand.
    # @param square [Hash] The index of each piece on the board.
    #
    # @example Apply a move to a classic Shogi problem
    #   call(
    #     [43, 13, "+B"],
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
    def call(in_hand:, square:)
      @actions.inject(in_hand: in_hand, square: square) do |piece_set, attrs|
        Action.new(*attrs).call(**piece_set)
      end
    end
  end
end
