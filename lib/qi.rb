# frozen_string_literal: true

require_relative "qi/error/drop"

# A class that represents the state of a game.
class Qi
  # @!attribute [r] north_captures
  #   @return [Array] an array of pieces captured by the north player
  # @!attribute [r] south_captures
  #   @return [Array] an array of pieces captured by the south player
  # @!attribute [r] squares
  #   @return [Hash] a hash of pieces on the board
  attr_reader :north_captures, :south_captures, :squares

  # Initializes a new Qi object with the given attributes.
  #
  # @param is_north_turn [Boolean] a boolean value indicating whose turn it is
  # @param north_captures [Array<Object>] an array of pieces captured by the north player
  # @param south_captures [Array<Object>] an array of pieces captured by the south player
  # @param squares [Hash<Object, Object>] a hash of squares on the board
  def initialize(is_north_turn, north_captures, south_captures, squares)
    # Assign the parameters to instance variables.
    @is_north_turn  = is_north_turn
    @north_captures = north_captures.sort
    @south_captures = south_captures.sort
    @squares        = squares.compact
  end

  # Returns a new Qi object that represents the state after applying the given changes.
  #
  # @param diffs [Hash<Object, Object>] a hash of changes to apply to the squares hash
  # @param in_hand [Object, nil] the piece that is in hand or nil if none
  # @param is_drop [Boolean] a boolean value indicating whether the in hand piece is dropped or not
  # @return [Qi] a new Qi object with modified attributes, where:
  #   - the turn is switched
  #   - the captures are updated according to the in hand piece and the drop flag
  #   - the squares are merged with the diffs hash
  def commit(diffs = {}, in_hand = nil, is_drop: false)
    modified_squares = squares.merge(diffs)
    modified_captures = update_captures(in_hand, is_drop:)
    self.class.new(!north_turn?, *modified_captures, modified_squares)
  end

  def side_name
    if north_turn?
      "north"
    else
      "south"
    end
  end

  def other_captures
    if north_turn?
      south_captures
    else
      north_captures
    end
  end

  def owned_captures
    if north_turn?
      north_captures
    else
      south_captures
    end
  end

  # Checks if it is the north turn or not.
  #
  # @return [Boolean] true if it is the north turn and false otherwise
  def north_turn?
    @is_north_turn
  end

  # Checks if it is not the north turn or not.
  #
  # @return [Boolean] true if it is not the north turn and false otherwise
  def south_turn?
    !north_turn?
  end

  # Returns an array representation of the Qi object's attributes.
  #
  # @return [Array(Boolean, Array<Object>, Array<Object>, Hash<Object, Object>)] an array containing four elements:
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

  # Returns a hash representation of the Qi object's attributes.
  #
  # @return [Hash{Symbol => Object}] a hash containing four key-value pairs:
  #   - is_north_turn: a boolean value indicating whose turn it is
  #   - north_captures: an array of pieces captured by the north player
  #   - south_captures: an array of pieces captured by the south player
  #   - squares: a hash of squares on the board
  def to_h
    {
      is_north_turn:  north_turn?,
      north_captures:,
      south_captures:,
      squares:
    }
  end

  # Returns a string representation of the Qi object's attributes.
  #
  # @return [String] a string containing three parts separated by "===":
  #   - the current turn, either "NorthTurn" or "SouthTurn"
  #   - the captures, sorted and joined by ","
  #   - the squares, mapped to "coordinate:piece" pairs and joined by ","
  def serialize
    serialized_turn     = "#{side_name}-turn"
    serialized_captures = (north_captures + south_captures).sort.join(",")
    serialized_squares  = squares.keys.map { |i| "#{i}:#{squares.fetch(i)}" }.join(",")

    "#{serialized_turn}===#{serialized_captures}===#{serialized_squares}"
  end

  # Returns a human-readable representation of the Qi object.
  #
  # @return [String] a string containing the class name and the serialized attributes
  def inspect
    "<#{self.class} #{serialize}>"
  end

  private

  # Updates the captures arrays based on the piece in hand and whether it is dropped or not.
  #
  # @param in_hand [Object, nil] the piece that is in hand or nil if none
  # @param is_drop [Boolean] a boolean value indicating whether the in hand piece is dropped or not
  # @return [Array] an array containing the updated north and south captures arrays
  def update_captures(in_hand, is_drop:)
    return [north_captures, south_captures] if in_hand.nil?

    captures = if is_drop
                 remove_from_captures(in_hand, *owned_captures)
               else
                 owned_captures + [in_hand]
               end

    north_turn? ? [captures, other_captures] : [other_captures, captures]
  end

  # Removes the last occurrence of a piece from an array of captures and returns the modified array.
  #
  # @param piece [Object] the piece to be removed
  # @param captures [Array<Object>] the array of captures
  # @return [Array<Object>] the modified array of captures
  # @raise [Qi::Error::Drop] if the piece is not found in the array
  def remove_from_captures(piece, *captures)
    index = captures.rindex(piece)
    raise Error::Drop, "There are no #{piece} in hand." if index.nil?

    captures.delete_at(index)
    captures
  end
end
