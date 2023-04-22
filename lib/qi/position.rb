# frozen_string_literal: true

module Qi
  # The position class.
  #
  # @see https://developer.sashite.com/specs/portable-chess-notation
  class Position
    attr_reader :squares, :bottomside_in_hand_pieces, :topside_in_hand_pieces

    # Initialize a position.
    #
    # @param is_turn_to_topside [Boolean] The player who must play.
    # @param bottomside_in_hand_pieces [Array] The list of bottom-side's pieces in hand.
    # @param topside_in_hand_pieces [Array] The list of top-side's pieces in hand.
    #
    # @example The Shogi's starting position
    #   Position.new(
    #     'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    #     nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    #     'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    #     nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    #     'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
    #   )
    def initialize(*squares, is_turn_to_topside: false, bottomside_in_hand_pieces: [], topside_in_hand_pieces: [])
      @squares                    = squares
      @is_turn_to_topside         = is_turn_to_topside
      @bottomside_in_hand_pieces  = bottomside_in_hand_pieces
      @topside_in_hand_pieces     = topside_in_hand_pieces

      freeze
    end

    # Apply a move in PMN (Portable Move Notation) format.
    #
    # @see https://developer.sashite.com/specs/portable-move-notation
    # @return [Position] The new position.
    def call(move)
      updated_squares = squares.dup
      updated_bottomside_in_hand_pieces = bottomside_in_hand_pieces.dup
      updated_topside_in_hand_pieces = topside_in_hand_pieces.dup

      actions = move.each_slice(4)

      actions.each do |action|
        src_square_id       = action.fetch(0)
        dst_square_id       = action.fetch(1)
        moved_piece_name    = action.fetch(2)
        captured_piece_name = action.fetch(3, nil)

        if src_square_id.nil?
          if turn_to_topside?
            piece_in_hand_id = updated_topside_in_hand_pieces.index(moved_piece_name)
            updated_topside_in_hand_pieces.delete_at(piece_in_hand_id)
          else
            piece_in_hand_id = updated_bottomside_in_hand_pieces.index(moved_piece_name)
            updated_bottomside_in_hand_pieces.delete_at(piece_in_hand_id)
          end
        else
          updated_squares[src_square_id] = nil
        end

        updated_squares[dst_square_id] = moved_piece_name

        unless captured_piece_name.nil?
          if turn_to_topside?
            updated_topside_in_hand_pieces.push(captured_piece_name)
          else
            updated_bottomside_in_hand_pieces.push(captured_piece_name)
          end
        end
      end

      self.class.new(*updated_squares, is_turn_to_topside: !turn_to_topside?,
                                       bottomside_in_hand_pieces: updated_bottomside_in_hand_pieces,
                                       topside_in_hand_pieces: updated_topside_in_hand_pieces)
    end

    # The player who must play.
    #
    # @return [Boolean] True if it is turn to topside, false otherwise.
    def turn_to_topside?
      @is_turn_to_topside
    end
  end
end