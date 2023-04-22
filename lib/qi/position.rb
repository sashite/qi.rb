# frozen_string_literal: true

module Qi
  # The position class.
  #
  # @see https://developer.sashite.com/specs/portable-chess-notation
  class Position
    # Players are identified by a number according to the order in which they
    #   traditionally play from the starting position.
    #
    # @!attribute [r] active_side_id
    #   @return [Integer] The identifier of the player who must play.
    attr_reader :active_side_id

    # The list of pieces in hand owned by players.
    #
    # @!attribute [r] pieces_in_hand_grouped_by_sides
    #   @return [Array] The list of pieces in hand grouper by sides.
    attr_reader :pieces_in_hand_grouped_by_sides

    # The list of squares of on the board.
    #
    # @!attribute [r] squares
    #   @return [Array] The list of squares.
    attr_reader :squares

    # Initialize a position.
    #
    # @param squares [Array] The list of squares of on the board.
    # @param active_side_id [Integer] The identifier of the player who must play.
    # @param pieces_in_hand_grouped_by_sides [Array] The list of pieces in hand
    #   grouped by players.
    #
    # @example Chess's starting position
    #   Position.new(
    #     "♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜",
    #     "♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟",
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     "♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙",
    #     "♖", "♘", "♗", "♕", "♔", "♗", "♘", "♖"
    #   )
    #
    # @example Makruk's starting position
    #   Position.new(
    #     "♜", "♞", "♝", "♛", "♚", "♝", "♞", "♜",
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     "♟", "♟", "♟", "♟", "♟", "♟", "♟", "♟",
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     "♙", "♙", "♙", "♙", "♙", "♙", "♙", "♙",
    #     nil, nil, nil, nil, nil, nil, nil, nil,
    #     "♖", "♘", "♗", "♔", "♕", "♗", "♘", "♖"
    #   )
    #
    # @example Shogi's starting position
    #   Position.new(
    #     "l", "n", "s", "g", "k", "g", "s", "n", "l",
    #     nil, "r", nil, nil, nil, nil, nil, "b", nil,
    #     "p", "p", "p", "p", "p", "p", "p", "p", "p",
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     "P", "P", "P", "P", "P", "P", "P", "P", "P",
    #     nil, "B", nil, nil, nil, nil, nil, "R", nil,
    #     "L", "N", "S", "G", "K", "G", "S", "N", "L"
    #   )
    #
    # @example Xiangqi's starting position
    #   Position.new(
    #     "車", "馬", "象", "士", "將", "士", "象", "馬", "車",
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, "砲", nil, nil, nil, nil, nil, "砲", nil,
    #     "卒", nil, "卒", nil, "卒", nil, "卒", nil, "卒",
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     "兵", nil, "兵", nil, "兵", nil, "兵", nil, "兵",
    #     nil, "炮", nil, nil, nil, nil, nil, "炮", nil,
    #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
    #     "俥", "傌", "相", "仕", "帥", "仕", "相", "傌", "俥"
    #   )
    def initialize(*squares, active_side_id: 0, pieces_in_hand_grouped_by_sides: [[], []])
      @squares = squares
      @active_side_id = active_side_id % pieces_in_hand_grouped_by_sides.length
      @pieces_in_hand_grouped_by_sides = pieces_in_hand_grouped_by_sides

      freeze
    end

    # Apply a move in PMN (Portable Move Notation) format.
    #
    # @param move [Array] The move to play.
    # @see https://developer.sashite.com/specs/portable-move-notation
    # @return [Position] The new position.
    def call(move)
      updated_squares = squares.dup
      updated_in_hand_pieces = in_hand_pieces.dup

      actions = move.each_slice(4)

      actions.each do |action|
        src_square_id       = action.fetch(0)
        dst_square_id       = action.fetch(1)
        moved_piece_name    = action.fetch(2)
        captured_piece_name = action.fetch(3, nil)

        if src_square_id.nil?
          piece_in_hand_id = updated_in_hand_pieces.index(moved_piece_name)
          updated_in_hand_pieces.delete_at(piece_in_hand_id)
        else
          updated_squares[src_square_id] = nil
        end

        updated_squares[dst_square_id] = moved_piece_name

        unless captured_piece_name.nil?
          updated_in_hand_pieces.push(captured_piece_name)
        end
      end

      updated_pieces_in_hand_grouped_by_sides = pieces_in_hand_grouped_by_sides.dup
      updated_pieces_in_hand_grouped_by_sides[active_side_id] = updated_in_hand_pieces

      self.class.new(*updated_squares,
        active_side_id: active_side_id.next,
        pieces_in_hand_grouped_by_sides: updated_pieces_in_hand_grouped_by_sides
      )
    end

    # The list of pieces in hand owned by the current player.
    #
    # @return [Array] Topside's pieces in hand if turn to topside, bottomside's
    #   ones otherwise.
    def in_hand_pieces
      pieces_in_hand_grouped_by_sides.fetch(active_side_id)
    end

    # Forsyth–Edwards Expanded Notation.
    #
    # @see https://developer.sashite.com/specs/forsyth-edwards-expanded-notation
    #
    # @param indexes [Array] The shape of the board.
    #
    # @example Generate the FEEN string of a Xiangqi position
    #   feen(10, 9)
    #
    # @return [String] The FEEN representation of the position.
    def feen(*indexes)
      ::FEEN.dump(
        active_side_id: active_side_id,
        board: squares.each_with_index.inject({}) { |h, (v, i)| v.nil? ? h : h.merge(i.to_s.to_sym => v) },
        indexes: indexes,
        pieces_in_hand_grouped_by_sides: pieces_in_hand_grouped_by_sides
      )
    end
  end
end

require "feen"
