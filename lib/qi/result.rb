module Qi
  # Result class.
  class Result
    # @param store           [Store]       Collection of data.
    # @param deleted_content [Object, nil] Last deleted content.
    def initialize(store, deleted_content)
      @store           = store
      @deleted_content = deleted_content
    end

    # @!attribute [r] store
    #
    # @return [Store] Collection of data.
    attr_reader :store

    # @!attribute [r] deleted_content
    #
    # @return [Symbol, nil] Last deleted content.
    attr_reader :deleted_content
  end
end
