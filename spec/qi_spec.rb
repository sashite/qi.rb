# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Qi do
  let(:captures_hash) { { "r" => 2, "b" => 1, "g" => 4, "s" => 1, "n" => 4, "p" => 17, "S" => 1 } }
  let(:squares_hash) { { 3 => "s", 4 => "k", 5 => "s", 22 => "+P", 43 => "+B" } }
  let(:turns) { [0, 1] }
  let(:state) { {} }
  let(:qi) { described_class.new(captures_hash, squares_hash, turns, **state) }

  describe "#initialize" do
    it "initializes with correct attributes" do
      expect(qi.captures_hash).to eq(captures_hash)
      expect(qi.squares_hash).to eq(squares_hash)
      expect(qi.turn).to eq(0)
      expect(qi.state).to eq(state)
    end
  end

  describe "#captures_array" do
    it "returns an array of captured pieces" do
      expected_array = %w[S b g g g g n n n n p p p p p p p p p p p p p p p p p r r s]
      expect(qi.captures_array).to eq(expected_array)
    end
  end

  describe "#commit" do
    let(:add_captures_array) { %w[r p] }
    let(:del_captures_array) { %w[g n] }
    let(:edit_squares_hash) { { 43 => nil, 13 => "+B" } }
    let(:state) { { in_check: true } }
    let(:new_qi) { qi.commit(add_captures_array, del_captures_array, edit_squares_hash, **state) }

    it "returns a new Qi object with updated captures hash" do
      expect(new_qi.captures_hash["r"]).to eq(3)
      expect(new_qi.captures_hash["p"]).to eq(18)
      expect(new_qi.captures_hash["g"]).to eq(3)
      expect(new_qi.captures_hash["n"]).to eq(3)
    end

    it "returns a new Qi object with updated squares hash" do
      expect(new_qi.squares_hash).to eq({ 3 => "s", 4 => "k", 5 => "s", 22 => "+P", 13 => "+B" })
    end

    it "returns a new Qi object with updated turn" do
      expect(new_qi.turn).to eq(1)
    end

    it "returns a new Qi object with updated state" do
      expect(new_qi.state).to eq({ in_check: true })
    end
  end

  describe "#eql?" do
    it "returns true if two Qi objects are the same" do
      expect(qi.eql?(described_class.new(captures_hash, squares_hash, turns, **state))).to be(true)
    end

    it "returns false if two Qi objects are different" do
      expect(qi.eql?(described_class.new(captures_hash, squares_hash, [1, 0], **state))).to be(false)
    end
  end
end
