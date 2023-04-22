# frozen_string_literal: true
# shareable_constant_value: none

# warn_indent: true

require_relative File.join("qi", "action")

# The Kernel module.
module Kernel
  # Abstraction to build positions.
  #
  # @return [Array] An action to change the position.
  #
  # @api public
  def Qi(*captures, **squares)
    ::Qi::Action.new(*captures, **squares)
  end
end
