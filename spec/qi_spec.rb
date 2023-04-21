# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Qi do
  let(:action) { Qi("a", "b", "b", x: 1, y: 2, z: 3) }

  describe "#call" do
    it "returns an array of captures and squares" do
      expect(action.call).to eq([%w[a b b], { x: 1, y: 2, z: 3 }])
    end

    it "adds a capture to the captures array" do
      expect(action.call("&" => "d")).to eq([%w[a b b d], { x: 1, y: 2, z: 3 }])
    end

    it "removes a drop from the captures array" do
      expect(action.call("*" => "b")).to eq([%w[a b], { x: 1, y: 2, z: 3 }])
    end

    it "raises an error if the drop is not in the captures array" do
      expect { action.call("*" => "d") }.to raise_exception(IndexError)
    end

    it "updates the squares hash with new values" do
      expect(action.call(x: 4, w: 5)).to eq([%w[a b b], { x: 4, y: 2, z: 3, w: 5 }])
    end

    it "removes the squares with nil values" do
      expect(action.call(y: nil)).to eq([%w[a b b], { x: 1, z: 3 }])
    end
  end
end
