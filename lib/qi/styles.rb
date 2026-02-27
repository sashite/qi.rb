# frozen_string_literal: true

class Qi
  # Pure validation functions for player styles.
  #
  # Styles are represented as a Hash with exactly two keys:
  #
  # - +:first+ — the style associated with the first player side.
  # - +:second+ — the style associated with the second player side.
  #
  # Style values are format-free: any non-nil object is accepted.
  # Semantic validation (e.g., SIN compliance) is the responsibility
  # of the encoding layer (FEEN, PON, etc.), not of Qi.
  #
  # @example Validate string styles
  #   Qi::Styles.validate({ first: "C", second: "c" }) #=> nil
  #
  # @example Validate symbol styles
  #   Qi::Styles.validate({ first: :chess, second: :shogi }) #=> nil
  module Styles
    # Validates the styles structure.
    #
    # Returns +nil+ if the Hash has exactly keys +:first+ and +:second+ with
    # non-nil values, or raises +ArgumentError+ otherwise.
    #
    # @param styles [Object] the styles structure to validate.
    # @return [nil]
    # @raise [ArgumentError] if the styles structure is invalid.
    #
    # @example Valid styles
    #   Qi::Styles.validate({ first: "S", second: "s" }) #=> nil
    #
    # @example Nil first style
    #   Qi::Styles.validate({ first: nil, second: "c" })
    #   # => ArgumentError: first player style must not be nil
    #
    # @example Nil second style
    #   Qi::Styles.validate({ first: "C", second: nil })
    #   # => ArgumentError: second player style must not be nil
    #
    # @example Missing key
    #   Qi::Styles.validate({ first: "C" })
    #   # => ArgumentError: styles must have exactly keys :first and :second
    #
    # @example Not a Hash
    #   Qi::Styles.validate("not a hash")
    #   # => ArgumentError: styles must be a Hash with keys :first and :second
    def self.validate(styles)
      validate_shape(styles)
      validate_non_nil(styles)
    end

    def self.validate_shape(styles)
      unless styles.is_a?(::Hash)
        raise ::ArgumentError, "styles must be a Hash with keys :first and :second"
      end

      return if styles.size == 2 && styles.key?(:first) && styles.key?(:second)

      raise ::ArgumentError, "styles must have exactly keys :first and :second"
    end

    def self.validate_non_nil(styles)
      raise ::ArgumentError, "first player style must not be nil" if styles[:first].nil?
      raise ::ArgumentError, "second player style must not be nil" if styles[:second].nil?
    end

    private_class_method :validate_shape,
                         :validate_non_nil
  end
end
