module Qi
  # Main class.
  class Store
    # @example Instanciate a store with 88 cells.
    #   new(88)
    #
    # @param size                 [Fixnum]      The number of cell.
    # @param deleted_content      [Object, nil] Deleted content.
    # @param options              [Hash]        A content per cell.
    def initialize(size, deleted_content = nil, options = {})
      @cells            = Array.new(size)
      @deleted_content  = deleted_content

      options.each do |cell, piece|
        @cells[cell] = piece
      end
    end

    # @!attribute [r] cells
    #
    # @return [Array] The cells in the store.
    attr_reader :cells

    # @!attribute [r] deleted_content
    #
    # @return [Object, nil] Deleted content.
    attr_reader :deleted_content

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

      self.class.new(cells.length, deleted_content, h)
    end

    private

    # @return [Hash] The contents in the store.
    def contents
      Hash[[*cells.map.with_index]].invert
    end
  end
end
