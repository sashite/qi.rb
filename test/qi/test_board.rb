#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../helper"
require_relative "../../lib/qi/board"

puts
puts "=== BOARD Tests ==="
puts

# ============================================================================
# VALID 1D BOARDS
# ============================================================================

puts "Valid 1D boards:"

run_test("single empty square") do
  sq, pc = Qi::Board.validate([nil])
  raise "expected [1, 0], got [#{sq}, #{pc}]" unless sq == 1 && pc == 0
end

run_test("single occupied square") do
  sq, pc = Qi::Board.validate(["k"])
  raise "expected [1, 1], got [#{sq}, #{pc}]" unless sq == 1 && pc == 1
end

run_test("mixed squares") do
  sq, pc = Qi::Board.validate(["k", nil, nil, "K"])
  raise "expected [4, 2], got [#{sq}, #{pc}]" unless sq == 4 && pc == 2
end

run_test("all occupied") do
  sq, pc = Qi::Board.validate(["a", "b", "c"])
  raise "expected [3, 3], got [#{sq}, #{pc}]" unless sq == 3 && pc == 3
end

run_test("all empty") do
  sq, pc = Qi::Board.validate([nil, nil, nil])
  raise "expected [3, 0], got [#{sq}, #{pc}]" unless sq == 3 && pc == 0
end

run_test("EPIN string pieces") do
  sq, pc = Qi::Board.validate(["K^", nil, "k^"])
  raise "expected [3, 2], got [#{sq}, #{pc}]" unless sq == 3 && pc == 2
end

run_test("promoted piece strings") do
  sq, pc = Qi::Board.validate(["+P", nil, "+R"])
  raise "expected [3, 2], got [#{sq}, #{pc}]" unless sq == 3 && pc == 2
end

run_test("empty string is a valid piece") do
  sq, pc = Qi::Board.validate(["", nil])
  raise "expected [2, 1], got [#{sq}, #{pc}]" unless sq == 2 && pc == 1
end

# ============================================================================
# VALID 2D BOARDS
# ============================================================================

puts
puts "Valid 2D boards:"

run_test("2x2 with pieces") do
  sq, pc = Qi::Board.validate([["a", nil], [nil, "b"]])
  raise "expected [4, 2], got [#{sq}, #{pc}]" unless sq == 4 && pc == 2
end

run_test("2x3 all empty") do
  sq, pc = Qi::Board.validate([[nil, nil, nil], [nil, nil, nil]])
  raise "expected [6, 0], got [#{sq}, #{pc}]" unless sq == 6 && pc == 0
end

run_test("3x3 all empty") do
  sq, pc = Qi::Board.validate([[nil, nil, nil], [nil, nil, nil], [nil, nil, nil]])
  raise "expected [9, 0], got [#{sq}, #{pc}]" unless sq == 9 && pc == 0
end

run_test("2x3 with pieces") do
  sq, pc = Qi::Board.validate([["r", nil, nil], [nil, nil, "R"]])
  raise "expected [6, 2], got [#{sq}, #{pc}]" unless sq == 6 && pc == 2
end

run_test("chess starting position (8x8)") do
  board = [
    ["r", "n", "b", "q", "k", "b", "n", "r"],
    ["p", "p", "p", "p", "p", "p", "p", "p"],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    ["P", "P", "P", "P", "P", "P", "P", "P"],
    ["R", "N", "B", "Q", "K", "B", "N", "R"]
  ]
  sq, pc = Qi::Board.validate(board)
  raise "expected [64, 32], got [#{sq}, #{pc}]" unless sq == 64 && pc == 32
end

run_test("EPIN string pieces on 2D board") do
  sq, pc = Qi::Board.validate([["K^", nil], [nil, "k^"]])
  raise "expected [4, 2], got [#{sq}, #{pc}]" unless sq == 4 && pc == 2
end

# ============================================================================
# VALID 3D BOARDS
# ============================================================================

puts
puts "Valid 3D boards:"

run_test("2x2x2 with pieces") do
  board = [
    [["a", nil], [nil, "b"]],
    [[nil, "c"], ["d", nil]]
  ]
  sq, pc = Qi::Board.validate(board)
  raise "expected [8, 4], got [#{sq}, #{pc}]" unless sq == 8 && pc == 4
end

run_test("2x2x2 all occupied") do
  board = [
    [["a", "b"], ["c", "d"]],
    [["A", "B"], ["C", "D"]]
  ]
  sq, pc = Qi::Board.validate(board)
  raise "expected [8, 8], got [#{sq}, #{pc}]" unless sq == 8 && pc == 8
end

run_test("2x2x2 all empty") do
  board = [
    [[nil, nil], [nil, nil]],
    [[nil, nil], [nil, nil]]
  ]
  sq, pc = Qi::Board.validate(board)
  raise "expected [8, 0], got [#{sq}, #{pc}]" unless sq == 8 && pc == 0
end

run_test("2x3x4 with some pieces") do
  board = [
    [["a", nil, nil, nil], [nil, nil, nil, nil], [nil, nil, nil, "b"]],
    [[nil, nil, nil, nil], [nil, "c", nil, nil], [nil, nil, nil, nil]]
  ]
  sq, pc = Qi::Board.validate(board)
  raise "expected [24, 3], got [#{sq}, #{pc}]" unless sq == 24 && pc == 3
end

# ============================================================================
# TYPE ERRORS
# ============================================================================

puts
puts "Type errors:"

run_test("raises for nil") do
  Qi::Board.validate(nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must be an Array"
end

run_test("raises for string") do
  Qi::Board.validate("not a board")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must be an Array"
end

run_test("raises for integer") do
  Qi::Board.validate(42)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must be an Array"
end

run_test("raises for hash") do
  Qi::Board.validate({ a: 1 })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must be an Array"
end

run_test("raises for symbol") do
  Qi::Board.validate(:board)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must be an Array"
end

# ============================================================================
# EMPTY BOARD
# ============================================================================

puts
puts "Empty board:"

run_test("raises for empty array") do
  Qi::Board.validate([])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

run_test("raises for empty inner array (2D)") do
  Qi::Board.validate([[]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

run_test("raises for multiple empty inner arrays (2D)") do
  Qi::Board.validate([[], []])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

run_test("raises for empty inner arrays (3D)") do
  Qi::Board.validate([[[], []]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

# ============================================================================
# NON-RECTANGULAR BOARDS
# ============================================================================

puts
puts "Non-rectangular boards:"

run_test("2D ragged rows") do
  Qi::Board.validate([["a", "b"], ["c"]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "non-rectangular board: expected 2 elements, got 1"
end

run_test("2D first row longer") do
  Qi::Board.validate([["a", "b", "c"], ["d", "e"]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "non-rectangular board: expected 3 elements, got 2"
end

run_test("3D ragged inner ranks") do
  Qi::Board.validate([[["a", "b"], ["c"]], [["d", "e"], ["f", "g"]]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "non-rectangular board: expected 2 elements, got 1"
end

run_test("3D ragged layers") do
  Qi::Board.validate([[["a", "b"], ["c", "d"]], [["e", "f"]]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "non-rectangular board: expected 2 elements, got 1"
end

# ============================================================================
# INCONSISTENT STRUCTURE
# ============================================================================

puts
puts "Inconsistent structure:"

run_test("mixed arrays and non-arrays at same level") do
  Qi::Board.validate([["a", "b"], "c"])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "inconsistent board structure: mixed arrays and non-arrays at same level"
end

run_test("array found where flat square expected") do
  Qi::Board.validate(["a", ["b", "c"]])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "inconsistent board structure: expected flat squares at this level"
end

# ============================================================================
# DIMENSION LIMITS
# ============================================================================

puts
puts "Dimension limits:"

run_test("rejects 4D board") do
  board = [[[[nil]]]]
  Qi::Board.validate(board)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board exceeds 3 dimensions"
end

run_test("rejects 5D board") do
  board = [[[[[nil]]]]]
  Qi::Board.validate(board)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board exceeds 3 dimensions"
end

# ============================================================================
# DIMENSION SIZE LIMITS
# ============================================================================

puts
puts "Dimension size limits:"

run_test("accepts 255-element 1D board") do
  board = Array.new(255) { nil }
  sq, pc = Qi::Board.validate(board)
  raise "expected [255, 0]" unless sq == 255 && pc == 0
end

run_test("rejects 256-element 1D board") do
  board = Array.new(256) { nil }
  Qi::Board.validate(board)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size 256 exceeds maximum of 255"
end

run_test("rejects oversized inner dimension") do
  board = [Array.new(256) { nil }]
  Qi::Board.validate(board)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size 256 exceeds maximum of 255"
end

run_test("accepts 255x255 board") do
  board = Array.new(255) { Array.new(255) { nil } }
  sq, pc = Qi::Board.validate(board)
  expected = 255 * 255
  raise "expected [#{expected}, 0]" unless sq == expected && pc == 0
end

run_test("rejects oversized outer dimension (2D board with 256 rows)") do
  board = Array.new(256) { [nil] }
  Qi::Board.validate(board)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size 256 exceeds maximum of 255"
end

# ============================================================================
# PIECE TYPE VALIDATION
# ============================================================================

puts
puts "Valid piece types:"

run_test("string pieces") do
  sq, pc = Qi::Board.validate(["K^", nil, "+P"])
  raise "expected [3, 2]" unless sq == 3 && pc == 2
end

run_test("namespaced string pieces") do
  sq, pc = Qi::Board.validate(["C:K", nil, "S:P"])
  raise "expected [3, 2]" unless sq == 3 && pc == 2
end

run_test("empty string is a valid piece") do
  sq, pc = Qi::Board.validate(["", nil])
  raise "expected [2, 1]" unless sq == 2 && pc == 1
end

puts
puts "Non-string piece types (accepted — normalization is Qi's responsibility):"

run_test("symbol pieces") do
  sq, pc = Qi::Board.validate([:king, nil, :pawn])
  raise "expected [3, 2]" unless sq == 3 && pc == 2
end

run_test("integer pieces") do
  sq, pc = Qi::Board.validate([1, nil, 2])
  raise "expected [3, 2]" unless sq == 3 && pc == 2
end

run_test("false is a valid piece (non-nil)") do
  sq, pc = Qi::Board.validate([false, nil])
  raise "expected [2, 1]" unless sq == 2 && pc == 1
end

run_test("zero is a valid piece (non-nil)") do
  sq, pc = Qi::Board.validate([0, nil])
  raise "expected [2, 1]" unless sq == 2 && pc == 1
end

run_test("hash piece") do
  sq, pc = Qi::Board.validate([{ name: "king" }, nil])
  raise "expected [2, 1]" unless sq == 2 && pc == 1
end

run_test("mixed types on 2D board") do
  sq, pc = Qi::Board.validate([[:a, nil], [nil, "b"]])
  raise "expected [4, 2]" unless sq == 4 && pc == 2
end

run_test("mixed types on 3D board") do
  sq, pc = Qi::Board.validate([[["a", nil], [nil, :b]]])
  raise "expected [4, 2]" unless sq == 4 && pc == 2
end

puts
puts "All BOARD tests passed!"
puts
