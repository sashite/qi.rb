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

run_test("both empty") do
  count = Qi::Hands.validate({ first: [], second: [] })
  raise "expected 0, got #{count}" unless count == 0
end

run_test("first has pieces, second empty") do
  count = Qi::Hands.validate({ first: ["P", "B"], second: [] })
  raise "expected 2, got #{count}" unless count == 2
end

run_test("first empty, second has pieces") do
  count = Qi::Hands.validate({ first: [], second: ["p"] })
  raise "expected 1, got #{count}" unless count == 1
end

run_test("both have pieces") do
  count = Qi::Hands.validate({ first: ["P", "B"], second: ["p"] })
  raise "expected 3, got #{count}" unless count == 3
end

run_test("promoted piece strings") do
  count = Qi::Hands.validate({ first: ["+P", "+P"], second: ["b"] })
  raise "expected 3, got #{count}" unless count == 3
end

run_test("EPIN string pieces") do
  count = Qi::Hands.validate({ first: ["K^", "R^"], second: ["k^"] })
  raise "expected 3, got #{count}" unless count == 3
end

run_test("namespaced string pieces") do
  count = Qi::Hands.validate({ first: ["C:P", "C:B"], second: ["S:p"] })
  raise "expected 3, got #{count}" unless count == 3
end

run_test("empty string is a valid piece") do
  count = Qi::Hands.validate({ first: [""], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

# ============================================================================
# NOT A HASH
# ============================================================================

puts
puts "Not a Hash:"

run_test("raises for nil") do
  Qi::Hands.validate(nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("raises for string") do
  Qi::Hands.validate("not hands")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("raises for array") do
  Qi::Hands.validate([[], []])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("raises for integer") do
  Qi::Hands.validate(42)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("raises for symbol") do
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

run_test("raises for missing :second") do
  Qi::Hands.validate({ first: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

run_test("raises for missing :first") do
  Qi::Hands.validate({ second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

run_test("raises for extra keys") do
  Qi::Hands.validate({ first: [], second: [], third: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

run_test("raises for wrong key names") do
  Qi::Hands.validate({ a: [], b: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

run_test("raises for string keys") do
  Qi::Hands.validate({ "first" => [], "second" => [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must have exactly keys :first and :second"
end

run_test("raises for empty hash") do
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

run_test("raises when first is not an Array") do
  Qi::Hands.validate({ first: "not an array", second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

run_test("raises when second is not an Array") do
  Qi::Hands.validate({ first: [], second: :pieces })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

run_test("raises when both are not Arrays") do
  Qi::Hands.validate({ first: nil, second: nil })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "each hand must be an Array"
end

run_test("raises when first is a Hash") do
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

run_test("raises for nil in first hand") do
  Qi::Hands.validate({ first: [nil], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

run_test("raises for nil in second hand") do
  Qi::Hands.validate({ first: [], second: [nil] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

run_test("raises for nil among valid pieces") do
  Qi::Hands.validate({ first: ["P", nil, "B"], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

run_test("raises for nil at start of hand") do
  Qi::Hands.validate({ first: [nil, "P", "B"], second: [] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

run_test("raises for multiple nils") do
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

run_test("symbol pieces") do
  count = Qi::Hands.validate({ first: [:P], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

run_test("integer pieces") do
  count = Qi::Hands.validate({ first: [1, 2, 3], second: [4] })
  raise "expected 4, got #{count}" unless count == 4
end

run_test("false is a valid piece (non-nil)") do
  count = Qi::Hands.validate({ first: [false], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

run_test("zero is a valid piece (non-nil)") do
  count = Qi::Hands.validate({ first: [0], second: [] })
  raise "expected 1, got #{count}" unless count == 1
end

run_test("mixed types") do
  count = Qi::Hands.validate({ first: [:P, "B", 1], second: [false] })
  raise "expected 4, got #{count}" unless count == 4
end

puts
puts "All HANDS tests passed!"
puts
