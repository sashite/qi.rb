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

puts "validate — valid styles:"

Test("single-character style") do
  result = Qi::Styles.validate(:first, "C")
  raise "expected 'C', got #{result.inspect}" unless result == "C"
end

Test("lowercase style") do
  result = Qi::Styles.validate(:second, "c")
  raise "expected 'c', got #{result.inspect}" unless result == "c"
end

Test("word style") do
  result = Qi::Styles.validate(:first, "chess")
  raise "expected 'chess'" unless result == "chess"
end

Test("empty string is valid") do
  result = Qi::Styles.validate(:first, "")
  raise "expected ''" unless result == ""
end

Test("namespaced style") do
  result = Qi::Styles.validate(:first, "C:western")
  raise "wrong" unless result == "C:western"
end

# ============================================================================
# RETURN VALUE IDENTITY
# ============================================================================

puts
puts "validate — return value identity:"

Test("returns the same object (no allocation)") do
  s = "C"
  result = Qi::Styles.validate(:first, s)
  raise "different object" unless result.equal?(s)
end

Test("works with both sides") do
  result_first = Qi::Styles.validate(:first, "S")
  result_second = Qi::Styles.validate(:second, "s")
  raise "wrong first" unless result_first == "S"
  raise "wrong second" unless result_second == "s"
end

# ============================================================================
# NIL ERRORS
# ============================================================================

puts
puts "validate — nil errors:"

Test("raises for nil first style") do
  Qi::Styles.validate(:first, nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "first player style must not be nil"
end

Test("raises for nil second style") do
  Qi::Styles.validate(:second, nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "second player style must not be nil"
end

# ============================================================================
# TYPE ERRORS — NON-STRING VALUES REJECTED
# ============================================================================

puts
puts "validate — type errors (non-string values rejected):"

Test("rejects symbol") do
  Qi::Styles.validate(:first, :chess)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "first player style must be a String"
end

Test("rejects integer") do
  Qi::Styles.validate(:second, 42)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "second player style must be a String"
end

Test("rejects false") do
  Qi::Styles.validate(:first, false)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "first player style must be a String"
end

Test("rejects zero") do
  Qi::Styles.validate(:first, 0)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "first player style must be a String"
end

Test("rejects array") do
  Qi::Styles.validate(:second, ["chess"])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "second player style must be a String"
end

Test("rejects hash") do
  Qi::Styles.validate(:first, { name: "C" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "first player style must be a String"
end

# ============================================================================
# VALIDATION ORDER — NIL BEFORE TYPE
# ============================================================================

puts
puts "validate — validation order:"

Test("nil is checked before type (nil is not a String, but message says nil)") do
  Qi::Styles.validate(:first, nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong: #{e.message}" unless e.message == "first player style must not be nil"
end

# ============================================================================
# SIDE PARAMETER IN ERROR MESSAGES
# ============================================================================

puts
puts "validate — side parameter in error messages:"

Test("first side in nil error") do
  Qi::Styles.validate(:first, nil)
rescue ArgumentError => e
  raise "wrong" unless e.message.start_with?("first ")
end

Test("second side in nil error") do
  Qi::Styles.validate(:second, nil)
rescue ArgumentError => e
  raise "wrong" unless e.message.start_with?("second ")
end

Test("first side in type error") do
  Qi::Styles.validate(:first, :chess)
rescue ArgumentError => e
  raise "wrong" unless e.message.start_with?("first ")
end

Test("second side in type error") do
  Qi::Styles.validate(:second, :shogi)
rescue ArgumentError => e
  raise "wrong" unless e.message.start_with?("second ")
end

puts
puts "All STYLES tests passed!"
puts
