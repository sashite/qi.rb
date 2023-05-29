# frozen_string_literal: true

# The Qi class provides a consistent representation of a game state
# and supports changes in the game state through the commit method.
# It is designed to be used in board games such as chess, makruk, shogi, xiangqi.
class Qi
  # @!attribute [r] captures_hash
  #   @return [Hash<Object, Integer>] a hash of captured pieces
  #   @example
  #     {"r"=>2, "b"=>1, "g"=>4, "s"=>1, "n"=>4, "p"=>17, "S"=>1}

  # @!attribute [r] squares_hash
  #   @return [Hash<Object, Object>] A hash where the keys represent square
  #     identifiers and the values represent the piece that will occupy each square.
  #     Both the keys and values can be any type of Ruby object, such as integers, strings, symbols, etc.
  #   @example
  #     {A3: "s", E4: "k", B5: "s", C22: "+P", D43: "+B"}

  # @!attribute [r] state
  #   @return [Hash<Symbol, Object>] a hash of game states
  #   @example
  #     {:in_check=>true}

  # @!attribute [r] turns
  #   @return [Array<Object>] a rotation of turns
  #   @example
  #     ["Sente", "Gote"]

  attr_reader :captures_hash, :squares_hash, :state, :turns

  # @param captures_hash [Hash<Object, Integer>] a hash of captured pieces
  # @param squares_hash [Hash<Object, Object>] A hash where the keys represent square
  #   identifiers and the values represent the piece that will occupy each square.
  #   Both the keys and values can be any type of Ruby object, such as integers, strings, symbols, etc.
  # @param turns [Array<Object>] a rotation of turns
  # @param state [Hash<Symbol, Object>] a hash of game states
  #
  # @example
  #   captures = Hash.new(0)
  #   north_captures = %w[r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
  #   south_captures = %w[S]
  #   (north_captures + south_captures).each { |piece| captures[piece] += 1 }
  #   squares = { 3 => "s", 4 => "k", 5 => "s", 22 => "+P", 43 => "+B" }
  #   Qi.new(captures, squares, [0, 1])
  def initialize(captures_hash, squares_hash, turns, **state)
    @captures_hash = ::Hash.new(0).merge(captures_hash.select { |_, v| v > 0 })
    @squares_hash = squares_hash.compact
    @turns = turns
    @state = state.transform_keys(&:to_sym)

    freeze
  end

  # Return an array of captures containing piece names.
  #
  # @return [Array<Object>] an array of captures
  # @example
  #   ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
  def captures_array
    captures_hash.flat_map { |piece, count| ::Array.new(count, piece) }.sort
  end

  # Commit a change to the game state and return a new Qi object.
  #
  # @param add_captures_array [Array<Object>] an array of pieces to be added to captures
  # @param del_captures_array [Array<Object>] an array of pieces to be deleted from captures
  # @param edit_squares_hash [Hash<Object, Object>] A hash where the keys represent square
  #   identifiers and the values represent the piece that will occupy each square.
  #   Both the keys and values can be any type of Ruby object, such as integers, strings, symbols, etc.
  # @param state [Hash<Symbol, Object>] a hash of new game states
  # @return [Qi] a new Qi object representing the updated game state
  # @example
  #   qi0.commit([], [], { D43: nil, B13: "+B" }, in_check: true)
  def commit(add_captures_array, del_captures_array, edit_squares_hash, **state)
    self.class.new(
      edit_captures_hash(add_captures_array.compact, del_captures_array.compact, **captures_hash),
      squares_hash.merge(edit_squares_hash),
      turns.rotate,
      **state
    )
  end

  # Check if the current Qi object is equal to another Qi object.
  #
  # @param other [Qi] another Qi object
  # @return [Boolean] returns true if the captures_hash, squares_hash, turn, and state of both Qi objects are equal, false otherwise
  def eql?(other)
    return false unless other.captures_hash == captures_hash
    return false unless other.squares_hash == squares_hash
    return false unless other.turn == turn
    return false unless other.state == state

    true
  end
  alias == eql?

  # Get the current turn.
  #
  # @return [Object] the current turn
  def turn
    turns.fetch(0)
  end

  private

  # Edits the captures hash and returns it.
  #
  # @param add_captures_array [Array<Object>] an array of pieces to be added to captures
  # @param del_captures_array [Array<Object>] an array of pieces to be deleted from captures
  # @param hash [Hash<Object, Integer>] the current captures hash
  # @return [Hash<Object, Integer>] the updated captures hash
  def edit_captures_hash(add_captures_array, del_captures_array, **hash)
    add_captures_array.each { |piece_name| hash[piece_name] += 1 }
    del_captures_array.each { |piece_name| hash[piece_name] -= 1 }

    hash
  end
end
