# frozen_string_literal: true

require "digest"
require "kernel/boolean"

# The Qi class represents a state of games such as Shogi.
class Qi
  # @return [Array] the pieces captured by the current player.
  attr_reader :captures

  # @return [Hash] the current state of the board.
  attr_reader :squares

  # Initializes a new game state.
  #
  # @param capture [String, nil] the piece to be captured.
  # @param captures [Array] the pieces already captured.
  # @param drop [String, nil] the piece to be dropped.
  # @param is_in_check [Boolean] whether the current player is in check.
  # @param is_north_turn [Boolean] whether it's North's turn.
  # @param squares [Hash] the current state of the board.
  def initialize(capture = nil, *captures, drop: nil, is_in_check: false, is_north_turn: false, **squares)
    captures << capture                       unless capture.nil?
    captures.delete_at(captures.rindex(drop)) unless drop.nil?

    @captures       = captures.sort
    @is_in_check    = Boolean(is_in_check)
    @is_north_turn  = Boolean(is_north_turn)
    @squares        = squares.compact
  end

  # Commits a move and returns a new game state.
  #
  # @param capture [String, nil] the piece to be captured.
  # @param drop [String, nil] the piece to be dropped.
  # @param is_in_check [Boolean] whether the current player is in check.
  # @param diffs [Hash] the differences in the state of the board.
  # @return [Qi] the new game state.
  def commit(capture: nil, drop: nil, is_in_check: false, **diffs)
    self.class.new(capture, *captures, drop:, is_in_check:, is_north_turn: south_turn?, **squares.merge(diffs))
  end

  # @return [Boolean] whether the current player is in check.
  def in_check?
    @is_in_check
  end

  # @return [Boolean] whether the current player is not in check.
  def not_in_check?
    !in_check?
  end

  # @return [Boolean] whether it's North's turn.
  def north_turn?
    @is_north_turn
  end

  # @return [Boolean] whether it's South's turn.
  def south_turn?
    !north_turn?
  end

  # @return [Boolean] whether the other game state is equal to this one.
  def eql?(other)
    return false unless other.respond_to?(:serialize)

    other.serialize == serialize
  end
  alias == eql?

  # @return [Array] the array representation of the game state.
  def to_a
    [
      north_turn?,
      captures,
      squares,
      in_check?
    ]
  end

  # @return [Hash] the hash representation of the game state.
  def to_h
    {
      is_north_turn: north_turn?,
      captures:,
      squares:,
      is_in_check:   in_check?
    }
  end

  # @return [String] the SHA-256 hash of the serialized game state.
  def hash
    ::Digest::SHA256.hexdigest(serialize)
  end

  # @return [String] the string representation of the game state.
  def serialize
    [
      serialized_turn,
      serialized_captures,
      serialized_squares,
      serialized_in_check
    ].join(" ")
  end

  # @return [String] the string representation of the object.
  def inspect
    "<#{self.class} #{serialize}>"
  end

  private

  # @return [String] the serialized turn.
  def serialized_turn
    north_turn? ? "}" : "{"
  end

  # @return [String] the serialized captures.
  def serialized_captures
    captures.join(";")
  end

  # @return [String] the serialized board state.
  def serialized_squares
    squares.keys.sort.map { |i| "#{squares.fetch(i)}@#{i}" }.join(";")
  end

  # @return [String] the serialized check state.
  def serialized_in_check
    in_check? ? "+" : "."
  end
end
