# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Qi do
  let(:qi) { described_class.new("P", is_in_check: false, is_north_turn: true, 56 => "P", 47 => "+G") }

  describe "#initialize" do
    it "initializes with correct state" do
      expect(qi.captures).to eq(["P"])
      expect(qi.squares).to eq({ 56 => "P", 47 => "+G" })
      expect(qi.in_check?).to be false
      expect(qi.north_turn?).to be true
    end
  end

  describe "#commit" do
    context "when capturing a piece" do
      let(:new_qi) { qi.commit(capture: "G", 47 => nil) }

      it "updates the game state correctly" do
        expect(new_qi.captures).to be_include("G")
        expect(new_qi.squares[47]).to be_nil
        expect(new_qi.south_turn?).to be true
      end
    end

    context "when dropping a piece" do
      let(:new_qi) { qi.commit(drop: "P", 47 => "P") }

      it "updates the game state correctly" do
        expect(new_qi.captures).not_to be_include("P")
        expect(new_qi.squares[47]).to eq("P")
        expect(new_qi.south_turn?).to be true
      end
    end

    context "when moving a piece" do
      let(:new_qi) { qi.commit(56 => nil, 47 => "P") }

      it "updates the game state correctly" do
        expect(new_qi.squares[56]).to be_nil
        expect(new_qi.squares[47]).to eq("P")
        expect(new_qi.south_turn?).to be true
      end
    end
  end

  describe "#in_check?" do
    context "when in check" do
      let(:qi) { described_class.new(is_in_check: true) }

      it "returns true" do
        expect(qi.in_check?).to be true
      end
    end

    context "when not in check" do
      it "returns false" do
        expect(qi.in_check?).to be false
      end
    end
  end

  describe "#north_turn?" do
    context "when it is north turn" do
      it "returns true" do
        expect(qi.north_turn?).to be true
      end
    end

    context "when it is not north turn" do
      let(:qi) { described_class.new(is_north_turn: false) }

      it "returns false" do
        expect(qi.north_turn?).to be false
      end
    end
  end
end
