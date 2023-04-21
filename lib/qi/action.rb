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
      captures = @captures + Array(diffs.delete(CAPTURE_CHAR))
      drop     = diffs.delete(DROP_CHAR)

      unless drop.nil?
        index = captures.rindex(drop)
        raise ::IndexError, "Piece #{drop.inspect} not captured!" if index.nil?

        captures.delete_at(index)
      end

      squares = @squares.merge(diffs).compact

      [captures.sort, squares]
    end
  end
end
