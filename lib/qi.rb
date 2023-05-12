# frozen_string_literal: true

require "digest"
require_relative "qi/error/drop"

# Qi is a class for representing a state of games like Shogi. It includes
# information about the current turn, captures, game board, and other game options.
class Qi
  # Constants for representing the North and South players.
  North = :North
  South = :South

  # @return [Array] the pieces captured by the north player
  attr_reader :north_captures

  # @return [Array] the pieces captured by the south player
  attr_reader :south_captures

  # @return [Hash] the current state of the game board
  attr_reader :squares

  # @return [Hash] additional game options
  attr_reader :options

  # Initialize a new Qi object.
  #
  # @example Creating a new Qi object
  #   qi = Qi.new(true, ['P', 'G'], ['B', '+B'], {56 => 'P', 3 => 'g', 64 => '+B'}, fullmove_number: 42, is_in_check: false)
  #
  # @param [Boolean] is_north_turn true if it's the north player's turn, false otherwise
  # @param [Array] north_captures the pieces captured by the north player
  # @param [Array] south_captures the pieces captured by the south player
  # @param [Hash] squares the current state of the game board
  # @param [Hash] options additional game options
  def initialize(is_north_turn, north_captures, south_captures, squares, **options)
    @is_north_turn  = is_north_turn
    @north_captures = north_captures.sort
    @south_captures = south_captures.sort
    @squares        = squares.compact
    @options        = options
  end

  # Apply a move or a drop on the board.
  #
  # The method creates a new instance of Qi representing the state of the game after the move.
  # This includes updating the captures and the positions of the pieces on the board.
  #
  # @param src_square [Object, nil] the source square, or nil if dropping a piece from hand
  # @param dst_square [Object] the destination square
  # @param piece_name [String] the name of the piece to move
  # @param in_hand [String, nil] the piece in hand, or nil if moving a piece from a square
  # @param options [Hash] options to pass to the new instance
  #
  # @example Applying a move
  #   qi = Qi.new(true, ['P', 'B'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.commit(56, 47, 'P', nil) #=> <Qi South-turn===B,P,+B,G===47:P,64:+B>
  #
  # @example Applying a capture
  #   qi = Qi.new(true, ['P', 'B'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.commit(56, 47, 'P', 'G') #=> <Qi South-turn===B,G,P,+B,G===47:P,64:+B>
  #
  # @example Applying a drop
  #   qi = Qi.new(true, ['P', 'B', 'G'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.commit(nil, 47, 'G', 'G') #=> <Qi South-turn===B,P,+B,G===47:G,56:P,64:+B>
  #
  # @return [Qi] the new game state after the move
  def commit(src_square, dst_square, piece_name, in_hand, **options)
    raise ::ArgumentError, "Both src_square and in_hand cannot be nil" if src_square.nil? && in_hand.nil?

    modified_captures = update_captures(src_square, in_hand)
    modified_squares = squares.merge({ src_square => nil, dst_square => piece_name })
    self.class.new(south_turn?, *modified_captures, modified_squares, **options)
  end

  # Compare this Qi object with another for equality.
  #
  # @example Comparing two Qi objects
  #   qi1 = Qi.new(...)
  #   qi2 = Qi.new(...)
  #   qi1.eql?(qi2) #=> true or false
  #
  # @param [Qi] other the other Qi object to compare with
  # @return [Boolean] true if the two objects represent the same game state, false otherwise
  def eql?(other)
    return false unless other.respond_to?(:serialize)

    other.serialize == serialize
  end
  alias == eql?

  # Get the captures of the current player.
  #
  # The method returns the north player's captures when it's their turn,
  # and the south player's captures when it's their turn.
  #
  # @example When it's the north player's turn
  #   qi = Qi.new(true, ['P', 'B'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.current_captures #=> ['B', 'P']
  #
  # @example When it's the south player's turn
  #   qi = Qi.new(false, ['P', 'B'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.current_captures #=> ['+B', 'G']
  #
  # @return [Array] the captures of the current player
  def current_captures
    north_turn? ? north_captures : south_captures
  end

  # Get the captures of the opponent player.
  #
  # @return [Array] the captures of the opponent player
  def opponent_captures
    north_turn? ? south_captures : north_captures
  end

  # Get the current turn.
  #
  # @return [Symbol] :North if it's the north player's turn, :South otherwise
  def current_turn
    north_turn? ? North : South
  end

  # Get the next turn.
  #
  # @return [Symbol] :South if it's the north player's turn, :North otherwise
  def next_turn
    north_turn? ? South : North
  end

  # Check if it's the north player's turn.
  #
  # @return [Boolean] true if it's the north player's turn, false otherwise
  def north_turn?
    @is_north_turn
  end

  # Check if it's the south player's turn.
  #
  # @return [Boolean] true if it's the south player's turn, false otherwise
  def south_turn?
    !north_turn?
  end

  # Convert the state to an array.
  #
  # @example Converting the state to an array
  #   qi.to_a #=> [true, ['P', 'G'], ['B', '+B'], {56 => 'P', 3 => 'g', 64 => '+B'}, {}]
  #
  # @return [Array] an array representing the game state
  def to_a
    [
      north_turn?,
      north_captures,
      south_captures,
      squares,
      options
    ]
  end

  # Convert the state to a hash.
  #
  # @example Converting the state to a hash
  #   qi.to_h #=> {is_north_turn: true, north_captures: ['P', 'G'], south_captures: ['B', '+B'], squares: {56 => 'P', 3 => 'g', 64 => '+B'}, options: {}}
  #
  # @return [Hash] a hash representing the game state
  def to_h
    {
      is_north_turn:  north_turn?,
      north_captures:,
      south_captures:,
      squares:,
      options:
    }
  end

  # Generate a hash value for the game state.
  #
  # @example Generating a hash value
  #   qi.hash #=> "10dfb778f6559dd368c510a27e3b00bdb5b4ad88d4d67f38864d7e36de7c2f9c"
  #
  # @return [String] a SHA256 hash of the serialized game state
  def hash
    ::Digest::SHA256.hexdigest(serialize)
  end

  # Serialize the game state.
  #
  # @example Serializing the game state
  #   qi.serialize #=> "North-turn===P,G,B,+B===3:g,56:P,64:+B"
  #
  # @return [String] a string representation of the game state
  def serialize
    serialized_turn     = "#{current_turn}-turn"
    serialized_captures = (north_captures + south_captures).join(",")
    serialized_squares  = squares.keys.sort.map { |i| "#{i}:#{squares.fetch(i)}" }.join(",")

    "#{serialized_turn}===#{serialized_captures}===#{serialized_squares}"
  end

  # Provide a string representation of the game state for debugging.
  #
  # @example Getting a string representation of the game state
  #   qi.inspect #=> "<Qi North-turn===P,G,B,+B===3:g,56:P,64:+B>"
  #
  # @return [String] a string representation of the game state
  def inspect
    "<#{self.class} #{serialize}>"
  end

  private

  # Update captures based on the source square and the piece in hand.
  #
  # If the source square is not nil and in_hand is nil (i.e., we're moving a piece on the board),
  # the captures remain the same. If the source square is not nil and in_hand is not nil
  # (i.e., we're capturing a piece that will remain in hand), the piece is added to the
  # current player's captures. If the source square is nil (i.e., we're dropping a piece from hand),
  # the piece is removed from the current player's captures.
  #
  # @param src_square [Object, nil] the source square, or nil if dropping a piece from hand
  # @param in_hand [String, nil] the piece in hand, or nil if moving a piece from a square
  #
  # @example When moving a piece on the board
  #   qi = Qi.new(true, ['P', 'B'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.send(:update_captures, 56, nil) #=> [['B', 'P'], ['G', '+B']]
  #
  # @example When capturing a piece that will remain in hand
  #   qi = Qi.new(true, ['P', 'B'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.send(:update_captures, 56, 'G') #=> [['B', 'P', 'G'], ['G', '+B']]
  #
  # @example When dropping a piece from hand
  #   qi = Qi.new(true, ['P', 'B', 'G'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.send(:update_captures, nil, 'G') #=> [['B', 'P'], ['G', '+B']]
  #
  # @return [Array] a two-element array with the updated north and south captures
  def update_captures(src_square, in_hand)
    return [north_captures, south_captures] if in_hand.nil?

    captures = if src_square.nil?
                 remove_from_captures(in_hand, *current_captures)
               else
                 current_captures + [in_hand]
               end

    north_turn? ? [captures, opponent_captures] : [opponent_captures, captures]
  end

  # Removes a piece from the captures.
  #
  # If the piece is not found in the captures, an Error::Drop exception is raised.
  #
  # @param piece [String] the piece to remove from the captures
  # @param captures [Array] the captures to update
  #
  # @example
  #   qi = Qi.new(true, ['P', 'B', 'G'], ['G', '+B'], {56 => 'P', 64 => '+B'})
  #   qi.send(:remove_from_captures, 'G', *qi.current_captures) #=> ['P', 'B']
  #
  # @raise [Error::Drop] if the piece is not found in the captures
  #
  # @return [Array] the captures after removing the piece
  def remove_from_captures(piece, *captures)
    index = captures.rindex(piece)
    raise Error::Drop, "There are no #{piece} in hand" if index.nil?

    captures.delete_at(index)
    captures
  end
end
