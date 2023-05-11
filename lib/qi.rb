# frozen_string_literal: true

require "digest"
require_relative "qi/error/drop"

# The Qi class represents the current state of a game, tracking both the positions of pieces on the board and the pieces captured by each player.
# It provides methods for manipulating the game state, including moving pieces around the board, capturing opponent's pieces, and dropping pieces from hand onto the board.
# Additionally, it maintains information about the current game turn (which player's turn it is) and whether a player is in check.
class Qi
  # Constant representing the North player.
  North = "North"

  # Constant representing the South player.
  South = "South"

  # @!attribute [r] north_captures
  # @return [Array] The list of pieces captured by the North player.
  attr_reader :north_captures

  # @!attribute [r] south_captures
  # @return [Array] The list of pieces captured by the South player.
  attr_reader :south_captures

  # @!attribute [r] squares
  # @return [Hash] The current state of the board, represented as a hash where each key is a position and each value is the state of that position.
  attr_reader :squares

  # Initializes a new instance of the game state.
  #
  # @param is_north_turn [Boolean] True if it's North's turn, false otherwise.
  # @param north_captures [Array] An array representing the pieces captured by North.
  # @param south_captures [Array] An array representing the pieces captured by South.
  # @param squares [Hash] A hash representing the state of the squares on the board.
  # @param is_in_check [Boolean] True if the current player is in check, false otherwise.
  def initialize(is_north_turn, north_captures, south_captures, squares, is_in_check)
    @is_north_turn  = is_north_turn
    @north_captures = north_captures.sort
    @south_captures = south_captures.sort
    @squares        = squares.compact
    @is_in_check    = is_in_check
  end

  # Creates a new game state by applying a set of diffs to the squares and the captures.
  # Raises an error if in_hand is provided but is_drop is not, or vice versa.
  #
  # @param diffs [Hash] A hash representing the changes to the squares. Each key is a position, and each value is the new state of that position.
  # @param in_hand [String, nil] A string representing the piece that the current player has in hand, or nil if no piece is in hand.
  # @param is_drop [Boolean, nil] True if the current player is dropping a piece, false if they are not, or nil if there is no piece in hand.
  # @param is_in_check [Boolean] True if the current player is in check after the move, false otherwise.
  # @return [Qi] The new game state after applying the diffs.
  # @raise [ArgumentError] If in_hand is provided but is_drop is not, or vice versa.
  def commit(diffs, in_hand, is_drop:, is_in_check:)
    if !in_hand.nil? && is_drop.nil?
      raise ::ArgumentError, "A piece is in hand, but is_drop is not provided"
    elsif in_hand.nil? && !is_drop.nil?
      raise ::ArgumentError, "No piece is in hand, but is_drop is provided"
    end

    modified_squares = squares.merge(diffs)
    modified_captures = update_captures(in_hand, is_drop:)
    self.class.new(south_turn?, *modified_captures, modified_squares, is_in_check)
  end

  # Checks if this game state is equal to another.
  # Two game states are considered equal if they can be serialized to the same string.
  #
  # @param other [Object] The object to compare with this game state.
  # @return [Boolean] True if the other object can be serialized and its serialized form is equal to this game state's serialized form, false otherwise.
  def eql?(other)
    return false unless other.respond_to?(:serialize)

    other.serialize == serialize
  end
  alias == eql?

  # Returns the captures of the current player.
  #
  # @return [Array] An array or other iterable representing the pieces captured by the current player.
  def current_captures
    if north_turn?
      north_captures
    else
      south_captures
    end
  end

  # Returns the list of pieces that the current player's opponent has captured.
  #
  # @return [Array] An array of pieces that the opponent has captured.
  def opponent_captures
    if north_turn?
      south_captures
    else
      north_captures
    end
  end

  # Returns the name of the current side.
  #
  # @return [String] "North" if it's North's turn, "South" otherwise.
  def current_turn
    if north_turn?
      North
    else
      South
    end
  end

  # Returns the name of the next side.
  # If it's currently the North player's turn, this method will return "South", and vice versa.
  #
  # @return [String] "South" if it's North's turn, "North" otherwise.
  def next_turn
    if north_turn?
      South
    else
      North
    end
  end

  # Checks if it's North's turn.
  #
  # @return [Boolean] True if it's North's turn, false otherwise.
  def north_turn?
    @is_north_turn
  end

  # Checks if it's South's turn.
  #
  # @return [Boolean] True if it's South's turn, false otherwise.
  def south_turn?
    !north_turn?
  end

  # Checks if the current player is in check.
  #
  # @return [Boolean] True if the current player is in check, false otherwise.
  def in_check?
    @is_in_check
  end

  # Checks if the current player is not in check.
  #
  # @return [Boolean] True if the current player is not in check, false otherwise.
  def not_in_check?
    !in_check?
  end

  # Converts the current game state to an array. The resulting array includes:
  # whether it's North's turn, the pieces captured by North, the pieces captured by South,
  # the state of the squares, and whether the current player is in check.
  # This array can be used for various purposes, such as saving the game state,
  # transmitting the game state over a network, or analyzing the game state.
  #
  # @return [Array] The game state, represented as an array. The elements of the array are:
  #   - A boolean indicating whether it's North's turn,
  #   - An array or other iterable representing the pieces captured by North,
  #   - An array or other iterable representing the pieces captured by South,
  #   - A data structure representing the state of the squares on the board,
  #   - A boolean indicating whether the current player is in check.
  def to_a
    [
      north_turn?,
      north_captures,
      south_captures,
      squares,
      in_check?
    ]
  end

  # Converts the current game state to a hash. The resulting hash includes:
  # whether it's North's turn, the pieces captured by North, the pieces captured by South,
  # the state of the squares, and whether the current player is in check.
  # This hash can be used for various purposes, such as saving the game state,
  # transmitting the game state over a network, or analyzing the game state.
  #
  # @return [Hash] The game state, represented as a hash. The keys of the hash are:
  #   - :is_north_turn, a boolean indicating whether it's North's turn,
  #   - :north_captures, an array or other iterable representing the pieces captured by North,
  #   - :south_captures, an array or other iterable representing the pieces captured by South,
  #   - :squares, a data structure representing the state of the squares on the board,
  #   - :is_in_check, a boolean indicating whether the current player is in check.
  def to_h
    {
      is_north_turn:  north_turn?,
      north_captures:,
      south_captures:,
      squares:,
      is_in_check:    in_check?
    }
  end

  # Returns the hash-code for the position.
  def hash
    ::Digest::SHA256.hexdigest(serialize)
  end

  # Returns a sorted list of all pieces currently on the board.
  #
  # @return [Array] An array of all pieces currently on the board.
  def board_pieces
    squares.keys.sort
  end

  # Serialize the current game state to a string. The serialized state includes:
  # the current turn, the captured pieces, the state of the squares, and whether
  # the current player is in check. The serialized state can be used to save
  # the game, or to transmit the game state over a network.
  #
  # @return [String] The serialized game state.
  def serialize
    serialized_turn     = "#{current_turn}-turn"
    serialized_captures = (north_captures + south_captures).sort.join(",")
    serialized_squares  = board_pieces.map { |i| "#{i}:#{squares.fetch(i)}" }.join(",")
    serialized_check    = (in_check? ? "in-check" : "not-in-check")

    "#{serialized_turn}===#{serialized_captures}===#{serialized_squares}===#{serialized_check}"
  end

  # Provides a string representation of the game state, including the class name and the serialized game state.
  #
  # @return [String] A string representation of the game state.
  def inspect
    "<#{self.class} #{serialize}>"
  end

  private

  # Updates the list of captures based on the piece in hand and whether the move is a drop.
  # If the in_hand parameter is nil, the method returns the current captures without modification.
  # Otherwise, the method either adds the piece in hand to the current player's captures (if is_drop is false),
  # or removes the piece in hand from the current player's captures (if is_drop is true).
  #
  # @param in_hand [String, nil] The piece in hand, or nil if no piece is in hand.
  # @param is_drop [Boolean] True if the current move is a drop, false otherwise.
  # @return [Array] The updated list of captures for North and South.
  def update_captures(in_hand, is_drop:)
    return [north_captures, south_captures] if in_hand.nil?

    captures = if is_drop
                 remove_from_captures(in_hand, *current_captures)
               else
                 current_captures + [in_hand]
               end

    north_turn? ? [captures, opponent_captures] : [opponent_captures, captures]
  end

  # Removes a piece from the captures.
  # The method raises an error if the piece is not found in the captures.
  #
  # @param piece [String] The piece to remove from the captures.
  # @param captures [Array] The list of captures.
  # @return [Array] The updated list of captures.
  # @raise [Error::Drop] If the piece is not found in the captures.
  def remove_from_captures(piece, *captures)
    index = captures.rindex(piece)
    raise Error::Drop, "There are no #{piece} in hand" if index.nil?

    captures.delete_at(index)
    captures
  end
end
