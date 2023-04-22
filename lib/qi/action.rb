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
      captures = @captures
      squares  = @squares

      diffs.each do |k, v|
        case String(k)
        when CAPTURE_CHAR
          captures = capture(v, *captures)
        when DROP_CHAR
          captures = drop(v, *captures)
        else
          squares = squares.merge(k => v)
        end
      end

      [captures, squares.compact]
    end

    private

    def capture(item, *items)
      [item] + items
    end

    def drop(item, *items)
      item_id = items.index(item) || raise(::IndexError, "Piece #{item.inspect} not found!")
      items.delete_at(item_id)
      items
    end
  end
end
