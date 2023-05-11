# frozen_string_literal: true

require_relative "spec_helper"

RSpec.describe Qi do
  let(:qi) do
    described_class.new(is_north_turn, %i[rook bishop], %i[rook pawn knight], { a1: :king, b2: :queen }, false)
  end

  describe "#==" do
    subject do
      qi == another_qi
    end

    let(:is_north_turn) { true }

    context "with the same position" do
      let(:is_north_turn) { true }

      let(:another_qi) do
        described_class.new(is_north_turn, %i[rook bishop], %i[rook pawn knight], { a1: :king, b2: :queen }, false)
      end

      it { is_expected.to be true }
    end

    context "with another position" do
      let(:another_qi) do
        described_class.new(!is_north_turn, %i[rook bishop], %i[rook pawn knight], { a1: :king, b2: :queen }, false)
      end

      it { is_expected.to be false }
    end
  end

  describe "#commit" do
    let(:is_in_check) { false }

    context "when a piece is in hand" do
      let(:in_hand) { :rook }

      context "when it is a drop" do
        let(:is_drop) { true }

        context "when it is north turn" do
          let(:is_north_turn) { true }

          it "returns a new qi with the piece removed from north captures and added to squares" do
            new_qi = qi.commit({ c3: in_hand }, in_hand, is_drop:, is_in_check:)
            expect(new_qi.north_turn?).to be false
            expect(new_qi.north_captures).to eq [:bishop]
            expect(new_qi.south_captures).to eq qi.south_captures
            expect(new_qi.squares).to eq({ a1: :king, b2: :queen, c3: :rook })
          end

          it "raises an error if the piece is not in north captures" do
            expect { qi.commit({ c3: in_hand }, :knight, is_drop:, is_in_check:) }.to raise_exception(Qi::Error::Drop)
          end
        end

        context "when it is south turn" do
          let(:is_north_turn) { false }

          it "returns a new qi with the piece removed from south captures and added to squares" do
            new_qi = qi.commit({ c3: in_hand }, in_hand, is_drop:, is_in_check:)
            expect(new_qi.north_turn?).to be true
            expect(new_qi.north_captures).to eq qi.north_captures
            expect(new_qi.south_captures).to eq %i[knight pawn]
            expect(new_qi.squares).to eq({ a1: :king, b2: :queen, c3: :rook })
          end

          it "raises an error if the piece is not in south captures" do
            expect { qi.commit({ c3: in_hand }, :bishop, is_drop:, is_in_check:) }.to raise_exception(Qi::Error::Drop)
          end
        end
      end

      context "when it is a capture" do
        let(:is_drop) { false }

        context "when it is north turn" do
          let(:is_north_turn) { true }

          it "returns a new qi with the piece added to north captures and removed from squares" do
            new_qi = qi.commit({ b2: nil }, in_hand, is_drop:, is_in_check:)
            expect(new_qi.north_turn?).to be false
            expect(new_qi.north_captures).to eq %i[bishop rook rook]
            expect(new_qi.south_captures).to eq qi.south_captures
            expect(new_qi.squares).to eq({ a1: :king })
          end
        end

        context "when it is south turn" do
          let(:is_north_turn) { false }

          it "returns a new qi with the piece added to south captures and removed from squares" do
            new_qi = qi.commit({ a1: nil }, in_hand, is_drop:, is_in_check:)
            expect(new_qi.north_turn?).to be true
            expect(new_qi.north_captures).to eq qi.north_captures
            expect(new_qi.south_captures).to eq %i[knight pawn rook rook]
            expect(new_qi.squares).to eq({ b2: :queen })
          end
        end
      end
    end

    context "when no piece is in hand" do
      let(:in_hand) { nil }

      context "when it is a drop" do
        let(:is_drop) { true }

        context "when it is north turn" do
          let(:is_north_turn) { true }

          it "raises an argument error" do
            expect { qi.commit({ c3: :rook }, in_hand, is_drop:, is_in_check:) }.to raise_exception(ArgumentError)
          end
        end

        context "when it is south turn" do
          let(:is_north_turn) { false }

          it "raises an argument error" do
            expect { qi.commit({ c3: :rook }, in_hand, is_drop:, is_in_check:) }.to raise_exception(ArgumentError)
          end
        end
      end

      context "when it is a capture" do
        let(:is_drop) { false }

        context "when it is north turn" do
          let(:is_north_turn) { true }

          it "raises an argument error" do
            expect { qi.commit({ c3: nil }, in_hand, is_drop:, is_in_check:) }.to raise_exception(ArgumentError)
          end
        end

        context "when it is south turn" do
          let(:is_north_turn) { false }

          it "raises an argument error" do
            expect { qi.commit({ a1: nil }, in_hand, is_drop:, is_in_check:) }.to raise_exception(ArgumentError)
          end
        end
      end
    end
  end
end
