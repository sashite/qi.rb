#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../helper"
require_relative "../../lib/qi/board"

puts
puts "=== BOARD Tests ==="
puts

# ============================================================================
# VALIDATE_SHAPE — VALID SHAPES
# ============================================================================

puts "validate_shape — valid shapes:"

Test("1D single square") do
  result = Qi::Board.validate_shape([1])
  raise "expected 1, got #{result}" unless result == 1
end

Test("1D linear (8)") do
  result = Qi::Board.validate_shape([8])
  raise "expected 8, got #{result}" unless result == 8
end

Test("2D square (8x8)") do
  result = Qi::Board.validate_shape([8, 8])
  raise "expected 64, got #{result}" unless result == 64
end

Test("2D rectangular (9x10)") do
  result = Qi::Board.validate_shape([9, 10])
  raise "expected 90, got #{result}" unless result == 90
end

Test("2D shogi (9x9)") do
  result = Qi::Board.validate_shape([9, 9])
  raise "expected 81, got #{result}" unless result == 81
end

Test("3D cube (5x5x5)") do
  result = Qi::Board.validate_shape([5, 5, 5])
  raise "expected 125, got #{result}" unless result == 125
end

Test("3D rectangular (2x3x4)") do
  result = Qi::Board.validate_shape([2, 3, 4])
  raise "expected 24, got #{result}" unless result == 24
end

Test("max dimension size (255)") do
  result = Qi::Board.validate_shape([255])
  raise "expected 255, got #{result}" unless result == 255
end

Test("max 2D (255x255)") do
  result = Qi::Board.validate_shape([255, 255])
  raise "expected #{255 * 255}, got #{result}" unless result == 255 * 255
end

Test("minimal dimensions (1x1x1)") do
  result = Qi::Board.validate_shape([1, 1, 1])
  raise "expected 1, got #{result}" unless result == 1
end

# ============================================================================
# VALIDATE_SHAPE — EMPTY SHAPE
# ============================================================================

puts
puts "validate_shape — empty shape:"

Test("raises for empty array") do
  Qi::Board.validate_shape([])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "at least one dimension is required"
end

# ============================================================================
# VALIDATE_SHAPE — DIMENSION COUNT
# ============================================================================

puts
puts "validate_shape — dimension count:"

Test("raises for 4 dimensions") do
  Qi::Board.validate_shape([2, 2, 2, 2])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board exceeds 3 dimensions (got 4)"
end

Test("raises for 5 dimensions") do
  Qi::Board.validate_shape([1, 1, 1, 1, 1])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board exceeds 3 dimensions (got 5)"
end

# ============================================================================
# VALIDATE_SHAPE — DIMENSION TYPES
# ============================================================================

puts
puts "validate_shape — dimension types:"

Test("raises for string dimension") do
  Qi::Board.validate_shape(["8", 8])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be an Integer, got String"
end

Test("raises for float dimension") do
  Qi::Board.validate_shape([8.0])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be an Integer, got Float"
end

Test("raises for nil dimension") do
  Qi::Board.validate_shape([nil])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be an Integer, got NilClass"
end

Test("raises for symbol dimension") do
  Qi::Board.validate_shape([:eight])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be an Integer, got Symbol"
end

# ============================================================================
# VALIDATE_SHAPE — DIMENSION BOUNDS
# ============================================================================

puts
puts "validate_shape — dimension bounds:"

Test("raises for zero dimension") do
  Qi::Board.validate_shape([0, 8])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be at least 1, got 0"
end

Test("raises for negative dimension") do
  Qi::Board.validate_shape([-1])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be at least 1, got -1"
end

Test("raises for dimension exceeding 255") do
  Qi::Board.validate_shape([256])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size 256 exceeds maximum of 255"
end

Test("raises for second dimension exceeding 255") do
  Qi::Board.validate_shape([8, 256])
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size 256 exceeds maximum of 255"
end

# ============================================================================
# APPLY_DIFF — PLACING PIECES
# ============================================================================

puts
puts "apply_diff — placing pieces:"

Test("place one piece on empty board") do
  board = Array.new(4)
  new_board, count = Qi::Board.apply_diff(board, 4, 0, { 0 => "K" })
  raise "wrong board: #{new_board.inspect}" unless new_board == ["K", nil, nil, nil]
  raise "wrong count: #{count}" unless count == 1
end

Test("place multiple pieces") do
  board = Array.new(4)
  new_board, count = Qi::Board.apply_diff(board, 4, 0, { 0 => "K", 3 => "k" })
  raise "wrong board" unless new_board == ["K", nil, nil, "k"]
  raise "wrong count" unless count == 2
end

Test("place piece at last index") do
  board = Array.new(8)
  new_board, count = Qi::Board.apply_diff(board, 8, 0, { 7 => "R" })
  raise "wrong board" unless new_board[7] == "R"
  raise "wrong count" unless count == 1
end

Test("place piece at index 0") do
  board = Array.new(8)
  new_board, count = Qi::Board.apply_diff(board, 8, 0, { 0 => "R" })
  raise "wrong board" unless new_board[0] == "R"
  raise "wrong count" unless count == 1
end

# ============================================================================
# APPLY_DIFF — EMPTYING SQUARES
# ============================================================================

puts
puts "apply_diff — emptying squares:"

Test("empty a square") do
  board = ["K", nil, nil, nil]
  new_board, count = Qi::Board.apply_diff(board, 4, 1, { 0 => nil })
  raise "wrong board" unless new_board == [nil, nil, nil, nil]
  raise "wrong count" unless count == 0
end

Test("empty already-empty square (no-op)") do
  board = [nil, nil]
  new_board, count = Qi::Board.apply_diff(board, 2, 0, { 0 => nil })
  raise "wrong board" unless new_board == [nil, nil]
  raise "wrong count" unless count == 0
end

# ============================================================================
# APPLY_DIFF — REPLACING PIECES
# ============================================================================

puts
puts "apply_diff — replacing pieces:"

Test("replace piece with another") do
  board = ["K", nil, nil, "k"]
  new_board, count = Qi::Board.apply_diff(board, 4, 2, { 0 => "Q" })
  raise "wrong board" unless new_board == ["Q", nil, nil, "k"]
  raise "wrong count" unless count == 2
end

Test("overwrite multiple squares") do
  board = ["a", "b", "c"]
  new_board, count = Qi::Board.apply_diff(board, 3, 3, { 0 => "x", 2 => "z" })
  raise "wrong board" unless new_board == ["x", "b", "z"]
  raise "wrong count" unless count == 3
end

# ============================================================================
# APPLY_DIFF — MOVING PIECES
# ============================================================================

puts
puts "apply_diff — moving pieces:"

Test("move a piece (empty source, fill destination)") do
  board = ["K", nil, nil, nil]
  new_board, count = Qi::Board.apply_diff(board, 4, 1, { 0 => nil, 2 => "K" })
  raise "wrong board" unless new_board == [nil, nil, "K", nil]
  raise "wrong count" unless count == 1
end

Test("capture-like: replace destination, empty source") do
  board = ["K", nil, "k", nil]
  new_board, count = Qi::Board.apply_diff(board, 4, 2, { 0 => nil, 2 => "K" })
  raise "wrong board" unless new_board == [nil, nil, "K", nil]
  raise "wrong count" unless count == 1
end

# ============================================================================
# APPLY_DIFF — PIECE TYPES
# ============================================================================

puts
puts "apply_diff — valid piece types:"

Test("EPIN string pieces") do
  board = Array.new(3)
  new_board, count = Qi::Board.apply_diff(board, 3, 0, { 0 => "K^", 2 => "k^" })
  raise "wrong board" unless new_board == ["K^", nil, "k^"]
  raise "wrong count" unless count == 2
end

Test("promoted piece strings") do
  board = Array.new(3)
  new_board, count = Qi::Board.apply_diff(board, 3, 0, { 0 => "+P", 2 => "+R" })
  raise "wrong board" unless new_board == ["+P", nil, "+R"]
  raise "wrong count" unless count == 2
end

Test("namespaced string pieces") do
  board = Array.new(3)
  new_board, count = Qi::Board.apply_diff(board, 3, 0, { 0 => "C:K", 2 => "S:P" })
  raise "wrong board" unless new_board == ["C:K", nil, "S:P"]
  raise "wrong count" unless count == 2
end

Test("empty string is a valid piece") do
  board = Array.new(2)
  new_board, count = Qi::Board.apply_diff(board, 2, 0, { 0 => "" })
  raise "wrong board" unless new_board == ["", nil]
  raise "wrong count" unless count == 1
end

# ============================================================================
# APPLY_DIFF — NON-STRING PIECES REJECTED
# ============================================================================

puts
puts "apply_diff — non-string pieces rejected:"

Test("rejects symbol piece") do
  Qi::Board.apply_diff(Array.new(2), 2, 0, { 0 => :king })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "piece must be a String, got Symbol"
end

Test("rejects integer piece") do
  Qi::Board.apply_diff(Array.new(2), 2, 0, { 0 => 42 })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "piece must be a String, got Integer"
end

Test("rejects false") do
  Qi::Board.apply_diff(Array.new(2), 2, 0, { 0 => false })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "piece must be a String, got FalseClass"
end

Test("rejects array piece") do
  Qi::Board.apply_diff(Array.new(2), 2, 0, { 0 => ["K"] })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "piece must be a String, got Array"
end

Test("rejects hash piece") do
  Qi::Board.apply_diff(Array.new(2), 2, 0, { 0 => { name: "K" } })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "piece must be a String, got Hash"
end

# ============================================================================
# APPLY_DIFF — INDEX ERRORS
# ============================================================================

puts
puts "apply_diff — index errors:"

Test("rejects negative index") do
  Qi::Board.apply_diff(Array.new(4), 4, 0, { -1 => "K" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: -1 (board has 4 squares)"
end

Test("rejects index equal to square count") do
  Qi::Board.apply_diff(Array.new(4), 4, 0, { 4 => "K" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: 4 (board has 4 squares)"
end

Test("rejects index far out of range") do
  Qi::Board.apply_diff(Array.new(2), 2, 0, { 99 => "K" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: 99 (board has 2 squares)"
end

Test("rejects non-integer index (string)") do
  Qi::Board.apply_diff(Array.new(4), 4, 0, { "a1" => "K" })
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message.include?("invalid flat index")
end

# ============================================================================
# APPLY_DIFF — IMMUTABILITY
# ============================================================================

puts
puts "apply_diff — immutability:"

Test("original board is not mutated") do
  board = ["K", nil, nil, nil]
  Qi::Board.apply_diff(board, 4, 1, { 0 => nil, 2 => "K" })
  raise "original was mutated" unless board == ["K", nil, nil, nil]
end

Test("returned board is a different object") do
  board = Array.new(4)
  new_board, _ = Qi::Board.apply_diff(board, 4, 0, { 0 => "K" })
  raise "same object" if board.equal?(new_board)
end

# ============================================================================
# APPLY_DIFF — EMPTY CHANGES
# ============================================================================

puts
puts "apply_diff — empty changes:"

Test("empty changes returns unchanged copy") do
  board = ["K", nil, "k"]
  new_board, count = Qi::Board.apply_diff(board, 3, 2, {})
  raise "wrong board" unless new_board == ["K", nil, "k"]
  raise "wrong count" unless count == 2
  raise "should be different object" if board.equal?(new_board)
end

# ============================================================================
# TO_NESTED — 1D
# ============================================================================

puts
puts "to_nested — 1D:"

Test("1D all empty") do
  result = Qi::Board.to_nested([nil, nil, nil], [3])
  raise "wrong: #{result.inspect}" unless result == [nil, nil, nil]
end

Test("1D with pieces") do
  result = Qi::Board.to_nested(["k", nil, nil, "K"], [4])
  raise "wrong: #{result.inspect}" unless result == ["k", nil, nil, "K"]
end

Test("1D single square") do
  result = Qi::Board.to_nested(["K"], [1])
  raise "wrong" unless result == ["K"]
end

# ============================================================================
# TO_NESTED — 2D
# ============================================================================

puts
puts "to_nested — 2D:"

Test("2x2 with pieces") do
  result = Qi::Board.to_nested(["a", nil, nil, "b"], [2, 2])
  raise "wrong" unless result == [["a", nil], [nil, "b"]]
end

Test("2x3 all empty") do
  result = Qi::Board.to_nested([nil] * 6, [2, 3])
  raise "wrong" unless result == [[nil, nil, nil], [nil, nil, nil]]
end

Test("3x3 with pieces") do
  result = Qi::Board.to_nested(["r", "n", "b", nil, "k", nil, nil, nil, "R"], [3, 3])
  raise "wrong" unless result == [["r", "n", "b"], [nil, "k", nil], [nil, nil, "R"]]
end

Test("8x8 chess starting position") do
  flat = [
    "r", "n", "b", "q", "k", "b", "n", "r",
    "p", "p", "p", "p", "p", "p", "p", "p",
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil,
    "P", "P", "P", "P", "P", "P", "P", "P",
    "R", "N", "B", "Q", "K", "B", "N", "R"
  ]
  nested = Qi::Board.to_nested(flat, [8, 8])
  raise "wrong rank 0" unless nested[0] == ["r", "n", "b", "q", "k", "b", "n", "r"]
  raise "wrong rank 2" unless nested[2] == [nil] * 8
  raise "wrong rank 7" unless nested[7] == ["R", "N", "B", "Q", "K", "B", "N", "R"]
  raise "wrong rank count" unless nested.size == 8
end

# ============================================================================
# TO_NESTED — 3D
# ============================================================================

puts
puts "to_nested — 3D:"

Test("2x2x2 with pieces") do
  flat = ["a", nil, nil, "b", nil, "c", "d", nil]
  result = Qi::Board.to_nested(flat, [2, 2, 2])
  raise "wrong" unless result == [[["a", nil], [nil, "b"]], [[nil, "c"], ["d", nil]]]
end

Test("2x2x2 all empty") do
  result = Qi::Board.to_nested([nil] * 8, [2, 2, 2])
  raise "wrong" unless result == [[[nil, nil], [nil, nil]], [[nil, nil], [nil, nil]]]
end

Test("2x3x4 with some pieces") do
  flat = Array.new(24)
  flat[0] = "a"
  flat[11] = "b"
  flat[17] = "c"
  result = Qi::Board.to_nested(flat, [2, 3, 4])
  raise "wrong [0][0][0]" unless result[0][0][0] == "a"
  raise "wrong [0][2][3]" unless result[0][2][3] == "b"
  raise "wrong [1][1][1]" unless result[1][1][1] == "c"
end

# ============================================================================
# TO_NESTED — IMMUTABILITY
# ============================================================================

puts
puts "to_nested — immutability:"

Test("1D: returned array is independent copy") do
  original = ["a", nil, "b"]
  nested = Qi::Board.to_nested(original, [3])
  nested[0] = "z"
  raise "original mutated" unless original[0] == "a"
end

Test("2D: returned structure is independent") do
  original = ["a", nil, nil, "b"]
  nested = Qi::Board.to_nested(original, [2, 2])
  nested[0][0] = "z"
  raise "original mutated" unless original[0] == "a"
end

# ============================================================================
# CONSTANTS
# ============================================================================

puts
puts "Constants:"

Test("MAX_DIMENSIONS is 3") do
  raise "wrong" unless Qi::Board::MAX_DIMENSIONS == 3
end

Test("MAX_DIMENSION_SIZE is 255") do
  raise "wrong" unless Qi::Board::MAX_DIMENSION_SIZE == 255
end

puts
puts "All BOARD tests passed!"
puts
