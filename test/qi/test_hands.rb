#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../helper"
require_relative "../../lib/qi/hands"

puts
puts "=== HANDS Tests ==="
puts

# ============================================================================
# APPLY_DIFF — ADDING PIECES
# ============================================================================

puts "apply_diff — adding pieces:"

Test("add one piece to empty hand") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "P" => 1 })
  raise "wrong hand: #{hand.inspect}" unless hand == { "P" => 1 }
  raise "wrong count: #{count}" unless count == 1
end

Test("add multiple copies of one piece") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "P" => 3 })
  raise "wrong hand" unless hand == { "P" => 3 }
  raise "wrong count" unless count == 3
end

Test("add different pieces") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "P" => 1, "B" => 2 })
  raise "wrong hand" unless hand == { "P" => 1, "B" => 2 }
  raise "wrong count" unless count == 3
end

Test("add to existing piece") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => 2 })
  raise "wrong hand" unless hand == { "P" => 3 }
  raise "wrong count" unless count == 3
end

Test("add new piece to hand with existing pieces") do
  hand, count = Qi::Hands.apply_diff({ "P" => 2 }, 2, { "B" => 1 })
  raise "wrong hand" unless hand == { "P" => 2, "B" => 1 }
  raise "wrong count" unless count == 3
end

# ============================================================================
# APPLY_DIFF — REMOVING PIECES
# ============================================================================

puts
puts "apply_diff — removing pieces:"

Test("remove one copy (piece remains)") do
  hand, count = Qi::Hands.apply_diff({ "P" => 2, "B" => 1 }, 3, { "P" => -1 })
  raise "wrong hand" unless hand == { "P" => 1, "B" => 1 }
  raise "wrong count" unless count == 2
end

Test("remove all copies (entry disappears)") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1, "B" => 1 }, 2, { "P" => -1 })
  raise "wrong hand" unless hand == { "B" => 1 }
  raise "wrong count" unless count == 1
end

Test("remove multiple copies") do
  hand, count = Qi::Hands.apply_diff({ "P" => 3 }, 3, { "P" => -2 })
  raise "wrong hand" unless hand == { "P" => 1 }
  raise "wrong count" unless count == 1
end

Test("remove all copies from single-entry hand") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => -1 })
  raise "wrong hand" unless hand == {}
  raise "wrong count" unless count == 0
end

Test("remove different pieces") do
  hand, count = Qi::Hands.apply_diff({ "P" => 2, "B" => 1, "R" => 1 }, 4, { "P" => -1, "R" => -1 })
  raise "wrong hand" unless hand == { "P" => 1, "B" => 1 }
  raise "wrong count" unless count == 2
end

# ============================================================================
# APPLY_DIFF — MIXED ADD AND REMOVE
# ============================================================================

puts
puts "apply_diff — mixed add and remove:"

Test("add and remove in same call") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => -1, "B" => 1 })
  raise "wrong hand" unless hand == { "B" => 1 }
  raise "wrong count" unless count == 1
end

Test("add new piece while removing existing") do
  hand, count = Qi::Hands.apply_diff({ "P" => 2, "B" => 1 }, 3, { "P" => -2, "B" => -1, "R" => 3 })
  raise "wrong hand" unless hand == { "R" => 3 }
  raise "wrong count" unless count == 3
end

# ============================================================================
# APPLY_DIFF — ZERO DELTA
# ============================================================================

puts
puts "apply_diff — zero delta:"

Test("zero delta is a no-op") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => 0 })
  raise "wrong hand" unless hand == { "P" => 1 }
  raise "wrong count" unless count == 1
end

Test("zero delta on missing piece is a no-op") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "P" => 0 })
  raise "wrong hand" unless hand == {}
  raise "wrong count" unless count == 0
end

Test("mixed zero and non-zero deltas") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => 0, "B" => 1 })
  raise "wrong hand" unless hand == { "P" => 1, "B" => 1 }
  raise "wrong count" unless count == 2
end

# ============================================================================
# APPLY_DIFF — EMPTY CHANGES
# ============================================================================

puts
puts "apply_diff — empty changes:"

Test("empty changes on empty hand") do
  hand, count = Qi::Hands.apply_diff({}, 0, {})
  raise "wrong hand" unless hand == {}
  raise "wrong count" unless count == 0
end

Test("empty changes on non-empty hand") do
  hand, count = Qi::Hands.apply_diff({ "P" => 2 }, 2, {})
  raise "wrong hand" unless hand == { "P" => 2 }
  raise "wrong count" unless count == 2
end

# ============================================================================
# APPLY_DIFF — SYMBOL KEYS (RUBY KEYWORD CONVENTION)
# ============================================================================

puts
puts "apply_diff — symbol keys:"

Test("symbol keys are normalized to strings") do
  hand, count = Qi::Hands.apply_diff({}, 0, { P: 1, B: 2 })
  raise "wrong hand" unless hand == { "P" => 1, "B" => 2 }
  raise "wrong count" unless count == 3
end

Test("remove with symbol key") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1 }, 1, { P: -1 })
  raise "wrong hand" unless hand == {}
  raise "wrong count" unless count == 0
end

Test("namespaced symbol keys") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "S:P": 1, "C:B": 2 })
  raise "wrong hand" unless hand == { "S:P" => 1, "C:B" => 2 }
  raise "wrong count" unless count == 3
end

# ============================================================================
# APPLY_DIFF — PIECE STRING TYPES
# ============================================================================

puts
puts "apply_diff — piece string types:"

Test("EPIN string pieces") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "K^" => 1, "R^" => 2 })
  raise "wrong" unless hand == { "K^" => 1, "R^" => 2 }
  raise "wrong count" unless count == 3
end

Test("promoted piece strings") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "+P" => 2, "+R" => 1 })
  raise "wrong" unless hand == { "+P" => 2, "+R" => 1 }
  raise "wrong count" unless count == 3
end

Test("namespaced string pieces") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "C:P" => 1, "S:p" => 1 })
  raise "wrong" unless hand == { "C:P" => 1, "S:p" => 1 }
  raise "wrong count" unless count == 2
end

Test("empty string is a valid piece") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "" => 1 })
  raise "wrong" unless hand == { "" => 1 }
  raise "wrong count" unless count == 1
end

# ============================================================================
# APPLY_DIFF — IMMUTABILITY
# ============================================================================

puts
puts "apply_diff — immutability:"

Test("original hand is not mutated") do
  original = { "P" => 2 }
  Qi::Hands.apply_diff(original, 2, { "P" => -1 })
  raise "original was mutated" unless original == { "P" => 2 }
end

Test("returned hand is a different object") do
  original = { "P" => 1 }
  hand, _ = Qi::Hands.apply_diff(original, 1, { "B" => 1 })
  raise "same object" if original.equal?(hand)
end

Test("adding does not mutate original") do
  original = {}
  Qi::Hands.apply_diff(original, 0, { "P" => 1 })
  raise "original was mutated" unless original == {}
end

# ============================================================================
# APPLY_DIFF — DELTA TYPE ERRORS
# ============================================================================

puts
puts "apply_diff — delta type errors:"

Test("rejects string delta") do
  Qi::Hands.apply_diff({}, 0, { "P" => "one" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message.include?("delta must be an Integer")
end

Test("rejects float delta") do
  Qi::Hands.apply_diff({}, 0, { "P" => 1.5 })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message.include?("delta must be an Integer")
end

Test("rejects nil delta") do
  Qi::Hands.apply_diff({}, 0, { "P" => nil })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message.include?("delta must be an Integer")
end

Test("rejects symbol delta") do
  Qi::Hands.apply_diff({}, 0, { "P" => :one })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message.include?("delta must be an Integer")
end

# ============================================================================
# APPLY_DIFF — REMOVAL ERRORS
# ============================================================================

puts
puts "apply_diff — removal errors:"

Test("raises when removing from empty hand") do
  Qi::Hands.apply_diff({}, 0, { "P" => -1 })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "cannot remove \"P\": not found in hand"
end

Test("raises when removing more than present") do
  Qi::Hands.apply_diff({ "P" => 1 }, 1, { "P" => -2 })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "cannot remove \"P\": not found in hand"
end

Test("raises when removing piece not in hand") do
  Qi::Hands.apply_diff({ "B" => 1 }, 1, { "P" => -1 })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "cannot remove \"P\": not found in hand"
end

# ============================================================================
# APPLY_DIFF — COUNT CONSISTENCY
# ============================================================================

puts
puts "apply_diff — count consistency:"

Test("count matches hand contents after multiple additions") do
  hand, count = Qi::Hands.apply_diff({}, 0, { "P" => 3, "B" => 2 })
  raise "wrong count" unless count == 5
  raise "count mismatch" unless count == hand.each_value.sum
end

Test("count is zero after removing everything") do
  hand, count = Qi::Hands.apply_diff({ "P" => 1, "B" => 1 }, 2, { "P" => -1, "B" => -1 })
  raise "wrong count" unless count == 0
  raise "hand not empty" unless hand == {}
end

Test("count correct after mixed add/remove") do
  hand, count = Qi::Hands.apply_diff({ "P" => 3 }, 3, { "P" => -2, "B" => 4 })
  raise "wrong count: #{count}" unless count == 5
  raise "count mismatch" unless count == hand.each_value.sum
end

puts
puts "All HANDS tests passed!"
puts
