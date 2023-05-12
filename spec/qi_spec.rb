# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Qi do
  let(:north_captures) { %w[p] }
  let(:south_captures) { %w[G] }
  let(:squares) { { 1 => "P", 2 => "g", 3 => nil } }
  let(:options) { {} }
  let(:is_north_turn) { false }
  let(:qi) { described_class.new(is_north_turn, north_captures, south_captures, squares, **options) }
  let(:commit) { qi.commit(src_square, dst_square, piece_name, in_hand) }

  context "when moving a piece" do
    let(:src_square) { 1 }
    let(:dst_square) { 3 }
    let(:piece_name) { squares.fetch(1) }
    let(:in_hand) { nil }

    it "moves the piece from the source to the destination" do
      result = commit
      expect(result.squares[src_square]).to be_nil
      expect(result.squares[dst_square]).to eq(piece_name)
    end
  end

  context "when dropping a piece" do
    let(:src_square) { nil }
    let(:dst_square) { 3 }
    let(:piece_name) { south_captures.fetch(0) }
    let(:in_hand) { piece_name }

    it "drops the piece to the destination square" do
      result = commit
      expect(result.squares[dst_square]).to eq(piece_name)
      expect(result.south_captures).not_to be_include(in_hand)
    end
  end

  context "when capturing a piece" do
    let(:src_square) { 1 }
    let(:dst_square) { 2 }
    let(:piece_name) { squares.fetch(1) }
    let(:in_hand) { squares.fetch(2) }

    it "captures the opponent piece" do
      result = commit
      expect(result.squares[src_square]).to be_nil
      expect(result.squares[dst_square]).to eq(piece_name)
      expect(result.south_captures).to be_include(in_hand)
    end
  end
end
