# frozen_string_literal: true

# A class that represents the state of a game.
class Qi
  # @!attribute [r] north_captures
  #   @return [Array] an array of pieces captured by the north player
  # @!attribute [r] south_captures
  #   @return [Array] an array of pieces captured by the south player
  # @!attribute [r] squares
  #   @return [Hash] a hash of pieces on the board
  attr_reader :north_captures, :south_captures, :squares

  # Initializes a new Qi object with the given parameters.
  # @param is_north_turn [Boolean] a boolean value indicating whose turn it is
  # @param north_captures [Array] an array of pieces captured by the north player
  # @param south_captures [Array] an array of pieces captured by the south player
  # @param squares [Hash] a hash of pieces on the board
  def initialize(is_north_turn, north_captures, south_captures, squares)
    # Assign the parameters to instance variables.
    @is_north_turn  = is_north_turn
    @north_captures = north_captures.sort
    @south_captures = south_captures.sort
    @squares        = squares.compact
  end

  # Returns a new Qi object that represents the state after applying the given changes.
  # @param diffs [Hash] a hash of changes to apply to the squares hash
  # @param in_hand [Object, nil] the piece that is in hand or nil if none
  # @param is_drop [Boolean] a boolean value indicating whether the in hand piece is dropped or not
  # @return [Qi] a new Qi object with modified attributes
  def commit(diffs = {}, in_hand = nil, is_drop = false)
    modified_squares = squares.merge(diffs)

    if in_hand.nil?
      self.class.new(south_turn?, north_captures, south_captures, modified_squares)
    elsif north_turn?
      modified_captures = if is_drop
                            remove_from_captures(in_hand, *north_captures)
                          else
                            north_captures + [in_hand]
                          end

      self.class.new(false, modified_captures, south_captures, modified_squares)
    else
      modified_captures = if is_drop
                            remove_from_captures(in_hand, *south_captures)
                          else
                            south_captures + [in_hand]
                          end

      self.class.new(true, north_captures, modified_captures, modified_squares)
    end
  end

  # Checks if it is the north turn or not.
  # @return [Boolean] true if it is the north turn and false otherwise
  def north_turn?
    @is_north_turn
  end

  # Checks if it is not the north turn or not.
  # @return [Boolean] true if it is not the north turn and false otherwise
  def south_turn?
    !north_turn?
  end

  # Returns an array representation of the Qi object's attributes.
  # @return [Array] an array containing four elements:
  #   - a boolean value indicating whose turn it is
  #   - an array of pieces captured by the north player
  #   - an array of pieces captured by the south player
  #   - a hash of squares on the board
  def to_a
    [
      north_turn?,
      north_captures,
      south_captures,
      squares
    ]
  end

  # Returns an array representation of the Qi object's attributes for display purposes.
  # @param size [Integer] the number of squares on the board
  # @param cols [Integer] the number of columns on the board
  # @return [Array] an array containing four elements:
  #   - an array of pieces captured by the north player
  #   - a nested array of strings representing the squares on the board
  #   - an array of pieces captured by the south player
  #   - a string indicating whose turn it is
  def display(size, cols)
    square_size = squares.values.max_by(&:length).length
    board = (0...size).to_a.map { |i| squares.fetch(i, ".") }.map { |square| square.center(square_size) }.each_slice(cols).to_a
    turn = (north_turn? ? "Turn to north" : "Turn to south")

    [
      north_captures,
      board,
      south_captures,
      turn
    ]
  end

  # Returns a string representation of the Qi object's attributes.
  # @return [String] a string containing the turn, the captures and the squares in a formatted way.
  def inspect
    serialized_turn     = (north_turn? ? "north-turn" : "south-turn")
    serialized_captures = captures.join(",")
    serialized_squares  = squares.keys.map { |i| "#{i}:#{squares.fetch(i)}" }.join(",")

    "<Qi #{serialized_turn} #{serialized_captures} #{serialized_squares}>"
  end

  private

  def captures
    south_captures + north_captures
  end

  def remove_from_captures(captured_piece, *captured_pieces)
    capture_id = captured_pieces.rindex(captured_piece)
    raise ::IndexError, "#{captured_piece} not found!" if capture_id.nil?

    captured_pieces.delete_at(capture_id)
    captured_pieces
  end
end
