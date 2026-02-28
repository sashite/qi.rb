# frozen_string_literal: true

class Qi
  # Pure validation function for player styles.
  #
  # A style is a +String+ label denoting a movement tradition or game
  # family (e.g., +"C"+, +"S"+, +"X"+). Semantic validation (e.g., SIN
  # compliance) is the responsibility of the encoding layer (FEEN, PON,
  # etc.).
  #
  # @example Validate a style
  #   Qi::Styles.validate(:first, "C") #=> "C"
  module Styles
    # Validates a single player style and returns it.
    #
    # The style must not be +nil+ and must be a +String+. The validated
    # value is returned as-is (no coercion, no allocation).
    #
    # @param side [Symbol] +:first+ or +:second+, used in error messages.
    # @param style [Object] the style value to validate.
    # @return [String] the validated style.
    # @raise [ArgumentError] if the style is nil or not a String.
    #
    # @example Valid style
    #   Qi::Styles.validate(:first, "C") #=> "C"
    #
    # @example Nil style
    #   Qi::Styles.validate(:first, nil)
    #   # => ArgumentError: first player style must not be nil
    #
    # @example Non-string style
    #   Qi::Styles.validate(:second, :chess)
    #   # => ArgumentError: second player style must be a String
    def self.validate(side, style)
      if style.nil?
        raise ::ArgumentError, "#{side} player style must not be nil"
      end

      unless style.is_a?(::String)
        raise ::ArgumentError, "#{side} player style must be a String"
      end

      style
    end
  end
end
