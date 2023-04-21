# frozen_string_literal: true

module Qi
  # The Action abstraction.
  class Action
    CAPTURE_CHAR = "&"
    DROP_CHAR    = "*"

    # Action initializer.
    def initialize(*captures, **squares)
      @captures = captures
      @squares  = squares
    end

    # Commit an action to the position.
    #
    # @return [Array] An action to change the position.
    def call(**diffs)
      capture = diffs.delete(CAPTURE_CHAR)
      drop    = diffs.delete(DROP_CHAR)

      change(*@captures, capture:, drop:, **diffs)
    end

    private

    def change(*captures, capture: nil, drop: nil, **squares)
      captures.unshift(capture) unless capture.nil?
      captures.delete(drop) { |key| raise ::IndexError, "Capture #{key.inspect} not found!" } unless drop.nil?
      squares = @squares.merge(squares).compact

      [captures, squares]
    end
  end
end
