# frozen_string_literal: true

require_relative "board"
require_relative "hands"
require_relative "styles"

module Qi
  # An immutable, validated position for a two-player board game.
  #
  # A +Qi::Position+ is the in-memory representation of a game position
  # as defined by the Sashité Game Protocol. It guarantees that all
  # structural invariants hold at construction time.
  #
  # == Fields
  #
  # - +board+ — multi-dimensional Array representing board structure and occupancy.
  # - +hands+ — +{ first: Array, second: Array }+ of off-board pieces.
  # - +styles+ — +{ first: Object, second: Object }+ of player styles.
  # - +turn+ — +:first+ or +:second+, the active player's side.
  #
  # == Construction
  #
  # Use +Qi.new+ to build positions. Direct instantiation via +Qi::Position.new+
  # is also supported; both perform identical validation.
  #
  # @example
  #   pos = Qi.new([["K^", nil], [nil, "k^"]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  #   pos.board  #=> [["K^", nil], [nil, "k^"]]
  #   pos.turn   #=> :first
  class Position
    VALID_TURNS = %i[first second].freeze

    # @return [Array] the board structure.
    attr_reader :board

    # @return [Hash] off-board pieces for each player.
    attr_reader :hands

    # @return [Hash] style for each player.
    attr_reader :styles

    # @return [Symbol] the active player's side (+:first+ or +:second+).
    attr_reader :turn

    # Creates a validated, immutable position.
    #
    # Validation is performed in order of increasing cost: turn (symbol check),
    # board (structural traversal), hands, styles, then cardinality.
    #
    # == Validated invariants
    #
    # - Turn is +:first+ or +:second+.
    # - Board is a non-empty, rectangular, nested Array (1D to 3D).
    # - Each dimension size is at most 255.
    # - Hands is a Hash with +:first+ and +:second+ Arrays of non-nil pieces.
    # - Styles is a Hash with +:first+ and +:second+ non-nil values.
    # - Total piece count does not exceed total square count.
    #
    # @param board [Array] nested array representing the board (1D to 3D).
    # @param hands [Hash] +{ first: Array, second: Array }+ of off-board pieces.
    # @param styles [Hash] +{ first: Object, second: Object }+ of player styles.
    # @param turn [Symbol] +:first+ or +:second+.
    # @return [Qi::Position] a frozen, immutable position.
    # @raise [ArgumentError] if any structural constraint is violated.
    #
    # @example A valid position
    #   Qi::Position.new([nil, :k], { first: [], second: [] }, { first: :chess, second: :chess }, :second)
    #
    # @example Invalid turn
    #   Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :third)
    #   # => ArgumentError: turn must be :first or :second
    def initialize(board, hands, styles, turn)
      validate_turn(turn)
      square_count, board_piece_count = Board.validate(board)
      hand_piece_count = Hands.validate(hands)
      Styles.validate(styles)
      validate_cardinality(square_count, board_piece_count + hand_piece_count)

      @board  = deep_freeze(board)
      @hands  = deep_freeze(hands)
      @styles = deep_freeze(styles)
      @turn   = turn

      freeze
    end

    # Returns a developer-friendly string representation.
    #
    # @return [String]
    def inspect
      "#<#{self.class} board=#{@board.inspect} hands=#{@hands.inspect} styles=#{@styles.inspect} turn=#{@turn.inspect}>"
    end

    private

    def validate_turn(turn)
      return if VALID_TURNS.include?(turn)

      raise ::ArgumentError, "turn must be :first or :second"
    end

    def validate_cardinality(square_count, piece_count)
      return if piece_count <= square_count

      raise ::ArgumentError, "too many pieces for board size (#{piece_count} pieces, #{square_count} squares)"
    end

    # Recursively freezes an object and all its nested contents.
    def deep_freeze(obj)
      case obj
      when ::Hash
        obj.each_value { |v| deep_freeze(v) }
        obj.freeze
      when ::Array
        obj.each { |e| deep_freeze(e) }
        obj.freeze
      else
        obj.freeze
      end
    end
  end
end
