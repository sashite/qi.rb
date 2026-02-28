# frozen_string_literal: true

class Qi
  # Pure validation functions for player hands.
  #
  # Hands are represented as a Hash with exactly two keys:
  #
  # - +:first+ — array of pieces held by the first player.
  # - +:second+ — array of pieces held by the second player.
  #
  # Each piece in a hand must be a +String+. The ordering of pieces
  # within a hand carries no semantic meaning.
  #
  # @example Validate hands with pieces
  #   Qi::Hands.validate({ first: ["+P", "+P"], second: ["b"] }) #=> 3
  #
  # @example Validate empty hands
  #   Qi::Hands.validate({ first: [], second: [] }) #=> 0
  module Hands
    # Validates hands structure and returns the total piece count.
    #
    # Validation checks shape (exactly two keys), type (both values are arrays),
    # and requires every element to be a +String+.
    #
    # @param hands [Object] the hands structure to validate.
    # @return [Integer] the total number of pieces across both hands.
    # @raise [ArgumentError] if the hands structure is invalid.
    #
    # @example Valid hands
    #   Qi::Hands.validate({ first: ["P", "B"], second: ["p"] }) #=> 3
    #
    # @example Non-string piece rejected
    #   Qi::Hands.validate({ first: [:P], second: [] })
    #   # => ArgumentError: hand piece must be a String, got Symbol
    #
    # @example Nil piece rejected
    #   Qi::Hands.validate({ first: [nil], second: [] })
    #   # => ArgumentError: hand piece must be a String, got NilClass
    #
    # @example Missing key
    #   Qi::Hands.validate({ first: [] })
    #   # => ArgumentError: hands must have exactly keys :first and :second
    def self.validate(hands)
      validate_shape(hands)
      validate_arrays(hands)
      validate_hand(hands[:first])
      validate_hand(hands[:second])
      hands[:first].size + hands[:second].size
    end

    # --- Shape validation -----------------------------------------------------

    def self.validate_shape(hands)
      unless hands.is_a?(::Hash)
        raise ::ArgumentError, "hands must be a Hash with keys :first and :second"
      end

      return if hands.size == 2 && hands.key?(:first) && hands.key?(:second)

      raise ::ArgumentError, "hands must have exactly keys :first and :second"
    end

    def self.validate_arrays(hands)
      return if hands[:first].is_a?(::Array) && hands[:second].is_a?(::Array)

      raise ::ArgumentError, "each hand must be an Array"
    end

    # --- Piece validation -----------------------------------------------------

    def self.validate_hand(pieces)
      pieces.each do |piece|
        unless piece.is_a?(::String)
          raise ::ArgumentError, "hand piece must be a String, got #{piece.class}"
        end
      end
    end

    private_class_method :validate_shape,
                         :validate_arrays,
                         :validate_hand
  end
end
