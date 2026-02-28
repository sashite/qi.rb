# frozen_string_literal: true

class Qi
  # Pure functions for player hand operations.
  #
  # A hand is represented as a +Hash{String => Integer}+ mapping each
  # piece to its count. An empty hand is +{}+. Entries whose count
  # reaches zero are removed from the hash.
  #
  # This representation gives O(1) add, remove, and count queries per
  # piece type, compared to O(n) scans on a flat array.
  #
  # All functions are stateless and side-effect-free.
  #
  # @example Apply a diff
  #   hand = { "P" => 1 }
  #   new_hand, count = Qi::Hands.apply_diff(hand, 1, { "P" => 1, "B" => 1 })
  #   new_hand #=> { "P" => 2, "B" => 1 }
  #   count    #=> 3
  #
  # @example Remove pieces
  #   hand = { "P" => 2, "B" => 1 }
  #   new_hand, count = Qi::Hands.apply_diff(hand, 3, { "P" => -1, "B" => -1 })
  #   new_hand #=> { "P" => 1 }
  #   count    #=> 1
  module Hands
    # Applies delta changes to a hand, returning the new hash and its
    # piece count.
    #
    # Each change maps a piece (+String+) to an integer delta: positive
    # to add copies, negative to remove, zero is a no-op. Entries whose
    # count reaches zero are removed from the result.
    #
    # The piece count is computed incrementally during the diff — no
    # extra iteration over the result hash is needed.
    #
    # The original hand is not modified.
    #
    # @param hand [Hash{String => Integer}] the current hand.
    # @param hand_count [Integer] current total piece count of +hand+.
    # @param changes [Hash{String => Integer}] piece to delta mapping.
    #   Keys are normalized from Symbol to String (Ruby keyword argument
    #   convention).
    # @return [Array(Hash{String => Integer}, Integer)]
    #   +[new_hand, new_piece_count]+.
    # @raise [ArgumentError] if a delta is not an Integer.
    # @raise [ArgumentError] if removing more pieces than present.
    #
    # @example Add pieces
    #   Qi::Hands.apply_diff({}, 0, { "P" => 2, "B" => 1 })
    #   #=> [{ "P" => 2, "B" => 1 }, 3]
    #
    # @example Remove a piece
    #   Qi::Hands.apply_diff({ "P" => 2, "B" => 1 }, 3, { "P" => -1 })
    #   #=> [{ "P" => 1, "B" => 1 }, 2]
    #
    # @example Zero delta is a no-op
    #   Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => 0 })
    #   #=> [{ "P" => 1 }, 1]
    def self.apply_diff(hand, hand_count, changes)
      result = hand.dup
      count  = hand_count

      changes.each do |piece_key, delta|
        unless delta.is_a?(::Integer)
          raise ::ArgumentError, "delta must be an Integer, got #{delta.class} for piece #{piece_key.inspect}"
        end

        next if delta == 0

        piece = piece_key.is_a?(::Symbol) ? piece_key.name : piece_key

        current = result[piece] || 0
        new_count = current + delta

        if new_count < 0
          raise ::ArgumentError, "cannot remove #{piece.inspect}: not found in hand"
        end

        if new_count == 0
          result.delete(piece)
        else
          result[piece] = new_count
        end

        count += delta
      end

      [result, count]
    end
  end
end
