module Qi
  class Store
    attr_reader :size, :captured, :position

    def initialize(size, captured = nil, position = {})
      @size     = Integer(size)
      @captured = captured
      @position = Hash(position.compact)

      freeze
    end

    def call(position_id, capture_position_id, content)
      self.class.new(
        size,
        position[capture_position_id],
        position.merge(
          Integer(position_id)          => nil,
          Integer(capture_position_id)  => content
        )
      )
    end

    def to_a
      (0...size).map { |i| position[i] }
    end
  end
end
