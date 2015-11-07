module Qi
  # Main class.
  class Store
    # @param size    [Fixnum] The number of cell.
    # @param options [Hash]   A content per cell.
    def initialize(size, options = {})
      @cells = Array.new(size)

      options.each do |cell, piece|
        @cells[cell] = piece
      end
    end

    # @!attribute [r] cells
    #
    # @return [Array] The cells in the store.
    attr_reader :cells

    # @param src_cell [Fixnum] Source cell.
    # @param dst_cell [Fixnum] Destination cell.
    # @param content  [Object] Content.
    #
    # @return [Store] The new store.
    def call(src_cell, dst_cell, content)
      h = contents
      h.delete(src_cell)
      deleted_content = h.delete(dst_cell)
      h[dst_cell] = content

      new_store = self.class.new(cells.length, h)

      Result.new(new_store, deleted_content)
    end

    private

    # @return [Hash] The contents in the store.
    def contents
      Hash[[*cells.map.with_index]].invert
    end
  end
end

require_relative 'result'
