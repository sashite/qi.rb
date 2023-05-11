# frozen_string_literal: true

class Qi
  # The Error module contains custom error classes for the Qi game.
  module Error
    # The Drop class is a custom error class that inherits from IndexError.
    # It is raised when a drop operation in the game of Qi is invalid.
    #
    # @see IndexError
    class Drop < ::IndexError
    end
  end
end
