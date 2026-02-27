#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../helper"
require_relative "../../lib/qi/styles"

puts
puts "=== STYLES Tests ==="
puts

# ============================================================================
# VALID STYLES
# ============================================================================

puts "Valid styles:"

run_test("string styles") do
  result = Qi::Styles.validate({ first: "C", second: "c" })
  raise "expected nil, got #{result.inspect}" unless result.nil?
end

run_test("symbol styles") do
  result = Qi::Styles.validate({ first: :chess, second: :shogi })
  raise "expected nil" unless result.nil?
end

run_test("integer styles") do
  result = Qi::Styles.validate({ first: 1, second: 2 })
  raise "expected nil" unless result.nil?
end

run_test("mixed types") do
  result = Qi::Styles.validate({ first: "C", second: :shogi })
  raise "expected nil" unless result.nil?
end

run_test("false is a valid style (non-nil)") do
  result = Qi::Styles.validate({ first: false, second: false })
  raise "expected nil" unless result.nil?
end

run_test("zero is a valid style (non-nil)") do
  result = Qi::Styles.validate({ first: 0, second: 0 })
  raise "expected nil" unless result.nil?
end

run_test("empty string is a valid style (non-nil)") do
  result = Qi::Styles.validate({ first: "", second: "" })
  raise "expected nil" unless result.nil?
end

run_test("array styles") do
  result = Qi::Styles.validate({ first: [:chess, :western], second: [:shogi, :japanese] })
  raise "expected nil" unless result.nil?
end

run_test("hash styles") do
  result = Qi::Styles.validate({ first: { name: "C" }, second: { name: "c" } })
  raise "expected nil" unless result.nil?
end

# ============================================================================
# NOT A HASH
# ============================================================================

puts
puts "Not a Hash:"

run_test("raises for nil") do
  Qi::Styles.validate(nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

run_test("raises for string") do
  Qi::Styles.validate("not styles")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

run_test("raises for array") do
  Qi::Styles.validate(["C", "c"])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

run_test("raises for integer") do
  Qi::Styles.validate(42)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

run_test("raises for symbol") do
  Qi::Styles.validate(:styles)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

# ============================================================================
# WRONG KEYS
# ============================================================================

puts
puts "Wrong keys:"

run_test("raises for missing :second") do
  Qi::Styles.validate({ first: "C" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must have exactly keys :first and :second"
end

run_test("raises for missing :first") do
  Qi::Styles.validate({ second: "c" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must have exactly keys :first and :second"
end

run_test("raises for extra keys") do
  Qi::Styles.validate({ first: "C", second: "c", third: "x" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must have exactly keys :first and :second"
end

run_test("raises for wrong key names") do
  Qi::Styles.validate({ a: "C", b: "c" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must have exactly keys :first and :second"
end

run_test("raises for string keys") do
  Qi::Styles.validate({ "first" => "C", "second" => "c" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must have exactly keys :first and :second"
end

run_test("raises for empty hash") do
  Qi::Styles.validate({})
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must have exactly keys :first and :second"
end

# ============================================================================
# NIL VALUES
# ============================================================================

puts
puts "Nil values:"

run_test("raises for nil first style") do
  Qi::Styles.validate({ first: nil, second: "c" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

run_test("raises for nil second style") do
  Qi::Styles.validate({ first: "C", second: nil })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "second player style must not be nil"
end

run_test("raises for both nil (first detected first)") do
  Qi::Styles.validate({ first: nil, second: nil })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

puts
puts "All STYLES tests passed!"
puts
