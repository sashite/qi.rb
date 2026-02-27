#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../helper"
require_relative "../../lib/qi/position"

puts
puts "=== POSITION Tests ==="
puts

# ============================================================================
# VALID POSITIONS
# ============================================================================

puts "Valid positions:"

run_test("1D board, turn :first") do
  pos = Qi::Position.new([nil, :k], { first: [], second: [] }, { first: :chess, second: :chess }, :first)
  raise "wrong turn" unless pos.turn == :first
end

run_test("1D board, turn :second") do
  pos = Qi::Position.new([nil, :k], { first: [], second: [] }, { first: :chess, second: :chess }, :second)
  raise "wrong turn" unless pos.turn == :second
end

run_test("2D board with EPIN strings") do
  pos = Qi::Position.new([["K^", nil], [nil, "k^"]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "wrong board" unless pos.board == [["K^", nil], [nil, "k^"]]
end

run_test("3D board") do
  board = [
    [[:a, :b], [:c, :d]],
    [[:A, :B], [:C, :D]]
  ]
  pos = Qi::Position.new(board, { first: [], second: [] }, { first: "R", second: "r" }, :first)
  raise "wrong board" unless pos.board == board
end

run_test("chess starting position") do
  board = [
    [:r, :n, :b, :q, :k, :b, :n, :r],
    [:p, :p, :p, :p, :p, :p, :p, :p],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [nil, nil, nil, nil, nil, nil, nil, nil],
    [:P, :P, :P, :P, :P, :P, :P, :P],
    [:R, :N, :B, :Q, :K, :B, :N, :R]
  ]
  pos = Qi::Position.new(board, { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "wrong turn" unless pos.turn == :first
end

run_test("shogi-like position with pieces in hand") do
  board = [[nil, nil, nil], [nil, "K^", nil], [nil, nil, nil]]
  hands = { first: ["P", "P", "B"], second: ["p"] }
  pos = Qi::Position.new(board, hands, { first: "S", second: "s" }, :first)
  raise "wrong hands" unless pos.hands == { first: ["P", "P", "B"], second: ["p"] }
end

# ============================================================================
# FIELD ACCESSORS
# ============================================================================

puts
puts "Field accessors:"

run_test("board accessor") do
  board = [[:a, nil], [nil, :b]]
  pos = Qi::Position.new(board, { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "wrong board" unless pos.board == [[:a, nil], [nil, :b]]
end

run_test("hands accessor") do
  hands = { first: [:P], second: [:p, :b] }
  pos = Qi::Position.new([[nil, nil, nil], [nil, nil, nil]], hands, { first: "C", second: "c" }, :first)
  raise "wrong hands" unless pos.hands == { first: [:P], second: [:p, :b] }
end

run_test("styles accessor") do
  styles = { first: "S", second: "s" }
  pos = Qi::Position.new([nil], { first: [], second: [] }, styles, :first)
  raise "wrong styles" unless pos.styles == { first: "S", second: "s" }
end

run_test("turn accessor") do
  pos = Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :second)
  raise "wrong turn" unless pos.turn == :second
end

# ============================================================================
# TURN VALIDATION
# ============================================================================

puts
puts "Turn validation:"

run_test("raises for :third") do
  Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :third)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

run_test("raises for nil") do
  Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

run_test("raises for string \"first\"") do
  Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, "first")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

run_test("raises for integer 1") do
  Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, 1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

run_test("raises for boolean true") do
  Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, true)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

# ============================================================================
# BOARD VALIDATION (delegated)
# ============================================================================

puts
puts "Board validation (delegated):"

run_test("raises for empty board") do
  Qi::Position.new([], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

run_test("raises for non-array board") do
  Qi::Position.new("board", { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must be an Array"
end

run_test("raises for non-rectangular board") do
  Qi::Position.new([[:a, :b], [:c]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "non-rectangular board: expected 2 elements, got 1"
end

# ============================================================================
# HANDS VALIDATION (delegated)
# ============================================================================

puts
puts "Hands validation (delegated):"

run_test("raises for non-hash hands") do
  Qi::Position.new([nil], "hands", { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("raises for nil piece in hand") do
  Qi::Position.new([nil, nil], { first: [nil], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hand pieces must not be nil"
end

# ============================================================================
# STYLES VALIDATION (delegated)
# ============================================================================

puts
puts "Styles validation (delegated):"

run_test("raises for non-hash styles") do
  Qi::Position.new([nil], { first: [], second: [] }, "styles", :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

run_test("raises for nil first style") do
  Qi::Position.new([nil], { first: [], second: [] }, { first: nil, second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

# ============================================================================
# CARDINALITY VALIDATION
# ============================================================================

puts
puts "Cardinality validation:"

run_test("raises when board pieces exceed squares") do
  Qi::Position.new([:a, :b], { first: [:c], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (3 pieces, 2 squares)"
end

run_test("raises when hand pieces alone exceed squares") do
  Qi::Position.new([:k], { first: [:P], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (2 pieces, 1 squares)"
end

run_test("raises when combined pieces exceed squares") do
  Qi::Position.new([nil, :k], { first: [:P, :B], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (3 pieces, 2 squares)"
end

run_test("accepts pieces equal to squares") do
  pos = Qi::Position.new([:a, :b], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have succeeded" unless pos.board == [:a, :b]
end

run_test("accepts pieces equal to squares with hands") do
  pos = Qi::Position.new([:a, nil, nil], { first: [:P], second: [:p] }, { first: "C", second: "c" }, :first)
  raise "should have succeeded" unless pos.turn == :first
end

# ============================================================================
# IMMUTABILITY
# ============================================================================

puts
puts "Immutability:"

run_test("position is frozen") do
  pos = Qi::Position.new([nil, :k], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should be frozen" unless pos.frozen?
end

run_test("board is frozen") do
  pos = Qi::Position.new([[:a, nil], [nil, :b]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "board should be frozen" unless pos.board.frozen?
end

run_test("board inner arrays are frozen") do
  pos = Qi::Position.new([[:a, nil], [nil, :b]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "inner array should be frozen" unless pos.board[0].frozen?
end

run_test("hands hash is frozen") do
  pos = Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "hands should be frozen" unless pos.hands.frozen?
end

run_test("hands arrays are frozen") do
  pos = Qi::Position.new([nil, nil], { first: [:P], second: [] }, { first: "C", second: "c" }, :first)
  raise "first hand should be frozen" unless pos.hands[:first].frozen?
  raise "second hand should be frozen" unless pos.hands[:second].frozen?
end

run_test("styles hash is frozen") do
  pos = Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "styles should be frozen" unless pos.styles.frozen?
end

run_test("cannot modify board") do
  pos = Qi::Position.new([[:a, nil], [nil, :b]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  pos.board << [:x, :y]
  raise "should have raised"
rescue FrozenError
  # expected
end

run_test("cannot modify board inner array") do
  pos = Qi::Position.new([[:a, nil], [nil, :b]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  pos.board[0][0] = :z
  raise "should have raised"
rescue FrozenError
  # expected
end

run_test("cannot modify hands") do
  pos = Qi::Position.new([nil, nil], { first: [:P], second: [] }, { first: "C", second: "c" }, :first)
  pos.hands[:first] << :B
  raise "should have raised"
rescue FrozenError
  # expected
end

run_test("cannot modify styles") do
  pos = Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  pos.styles[:first] = "X"
  raise "should have raised"
rescue FrozenError
  # expected
end

run_test("no writer methods") do
  pos = Qi::Position.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  pos.board = []
  raise "should have raised"
rescue NoMethodError
  # expected
end

# ============================================================================
# INSPECT
# ============================================================================

puts
puts "Inspect:"

run_test("inspect returns a readable string") do
  pos = Qi::Position.new([nil, :k], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  str = pos.inspect
  raise "should start with #<Qi::Position" unless str.start_with?("#<Qi::Position")
  raise "should contain board=" unless str.include?("board=")
  raise "should contain hands=" unless str.include?("hands=")
  raise "should contain styles=" unless str.include?("styles=")
  raise "should contain turn=" unless str.include?("turn=")
end

# ============================================================================
# VALIDATION ORDER
# ============================================================================

puts
puts "Validation order (turn checked first):"

run_test("turn error takes precedence over board error") do
  Qi::Position.new([], { first: [], second: [] }, { first: "C", second: "c" }, :third)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

run_test("board error takes precedence over hands error") do
  Qi::Position.new([], "not hands", { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

run_test("hands error takes precedence over styles error") do
  Qi::Position.new([nil], "not hands", "not styles", :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("styles error takes precedence over cardinality error") do
  Qi::Position.new([:a], { first: [:P], second: [] }, "not styles", :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

puts
puts "All POSITION tests passed!"
puts
