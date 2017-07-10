module Qi
  class Store
    attr_reader :size, :captured, :position

    def initialize(size, captured = nil, position = {})
      @size     = Integer(size)
      @captured = captured
      @position = Hash(position).compact
    end

    def call(position_id, capture_position_id, content)
      position_id         = Integer(position_id)
      capture_position_id = Integer(capture_position_id)

      [position_id, capture_position_id].each do |id|
        next if range.include?(id)

        raise ArgumentError, "#{id} out of range"
      end

      self.class.new(
        size,
        position[capture_position_id],
        position.merge(
          position_id         => nil,
          capture_position_id => content
        )
      )
    end

    def to_a
      range.map { |i| position[i] }
    end

    protected

    def range
      0...size
    end
  end
end
