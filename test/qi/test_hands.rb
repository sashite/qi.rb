#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../helper"
require_relative "../../lib/qi/hands"

puts
puts "=== HANDS Tests ==="
puts

# ============================================================================
# VALID HANDS
# ============================================================================

puts "Valid hands:"

Test("both empty") do
  count = Qi::Hands.validate({ first: [], second: [] })
  raise "expected 0, got #{count}" unless count == 0
end

Test("first has pieces, second empty") do
  count = Qi::Hands.validate({ first: ["P", "B"], second: [] })
  raise "expected 2, got #{count}" unless count == 2
end

Test("first empty, second has pieces") do
  count = Qi::Hands.validate({ first: [], second: ["p"] })
  raise "expected 1, got #{count}" unless count == 1
end

Test("both have pieces") do
  count = Qi::Hands.validate({ first: ["P", "B"], second: ["p"] })
  raise "expected 3, got #{count}" unless count == 3
end

Test("promoted piece strings") do
  count = Qi::Hands.validate({ first: ["+P", "+P"], second: ["b"] })
  raise "expected 3, got #{count}" unless count == 3
end

Test("EPIN string pieces") do
  count = Qi::Hands.validate({ first: ["K^", "R^"], second: ["k^"] })
  raise "expected 3, got #{count}" unless count == 3
end

Test("namespaced string pieces") do
  count = Qi::Hands.validate({ first: ["C:P", "C:B"], second: ["S:p"] })
  raise "expected 3, got #{count}" unless count == 3
end

Test("empty string is a valid piece") do
  count = Qi::Hands.validate({ first: [""], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

# ============================================================================
# NOT A HASH
# ============================================================================

puts
puts "Not a Hash:"

Test("raises for nil") do
  Qi::Hands.validate(nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

Test("raises for string") do
  Qi::Hands.validate("not hands")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

Test("raises for array") do
  Qi::Hands.validate([[], []])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

Test("raises for integer") do
  Qi::Hands.validate(42)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

Test("raises for symbol") do
  Qi::Hands.validate(:hands)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

# ============================================================================
# WRONG KEYS
# ============================================================================

puts
puts "Wrong keys:"

Test("raises for missing :second") do
  Qi::Hands.validate({ first: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

Test("raises for missing :first") do
  Qi::Hands.validate({ second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

Test("raises for extra keys") do
  Qi::Hands.validate({ first: [], second: [], third: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

Test("raises for wrong key names") do
  Qi::Hands.validate({ a: [], b: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

Test("raises for string keys") do
  Qi::Hands.validate({ "first" => [], "second" => [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

Test("raises for empty hash") do
  Qi::Hands.validate({})
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

# ============================================================================
# VALUES NOT ARRAYS
# ============================================================================

puts
puts "Values not Arrays:"

Test("raises when first is not an Array") do
  Qi::Hands.validate({ first: "not an array", second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

Test("raises when second is not an Array") do
  Qi::Hands.validate({ first: [], second: :pieces })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

Test("raises when both are not Arrays") do
  Qi::Hands.validate({ first: nil, second: nil })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

Test("raises when first is a Hash") do
  Qi::Hands.validate({ first: { a: 1 }, second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

# ============================================================================
# NIL PIECES
# ============================================================================

puts
puts "Nil pieces:"

Test("raises for nil in first hand") do
  Qi::Hands.validate({ first: [nil], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

Test("raises for nil in second hand") do
  Qi::Hands.validate({ first: [], second: [nil] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

Test("raises for nil among valid pieces") do
  Qi::Hands.validate({ first: ["P", nil, "B"], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

Test("raises for nil at start of hand") do
  Qi::Hands.validate({ first: [nil, "P", "B"], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

Test("raises for multiple nils") do
  Qi::Hands.validate({ first: [nil, nil], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

# ============================================================================
# NON-STRING PIECE TYPES (ACCEPTED)
# ============================================================================

puts
puts "Non-string piece types (accepted — normalization is Qi's responsibility):"

Test("symbol pieces") do
  count = Qi::Hands.validate({ first: [:P], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

Test("integer pieces") do
  count = Qi::Hands.validate({ first: [1, 2, 3], second: [4] })
  raise "expected 4, got #{count}" unless count == 4
end

Test("false is a valid piece (non-nil)") do
  count = Qi::Hands.validate({ first: [false], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

Test("zero is a valid piece (non-nil)") do
  count = Qi::Hands.validate({ first: [0], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

Test("mixed types") do
  count = Qi::Hands.validate({ first: [:P, "B", 1], second: [false] })
  raise "expected 4, got #{count}" unless count == 4
end

puts
puts "All HANDS tests passed!"
puts
