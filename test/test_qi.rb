#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/qi"

puts
puts "=== QI Tests ==="
puts

# ============================================================================
# Qi.new RETURNS A Qi::Position
# ============================================================================

puts "Qi.new returns a Qi::Position:"

run_test("returns a Qi::Position instance") do
  pos = Qi.new([nil, :k], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "expected Qi::Position, got #{pos.class}" unless pos.is_a?(Qi::Position)
end

run_test("equivalent to Qi::Position.new") do
  args = [[nil, :k], { first: [], second: [] }, { first: "C", second: "c" }, :first]
  a = Qi.new(*args)
  b = Qi::Position.new(*args)
  raise "board mismatch" unless a.board == b.board
  raise "hands mismatch" unless a.hands == b.hands
  raise "styles mismatch" unless a.styles == b.styles
  raise "turn mismatch" unless a.turn == b.turn
end

# ============================================================================
# Qi.new WITH VALID INPUT
# ============================================================================

puts
puts "Qi.new with valid input:"

run_test("1D board") do
  pos = Qi.new([:a, nil, :b], { first: [], second: [] }, { first: "G", second: "g" }, :first)
  raise "wrong board" unless pos.board == [:a, nil, :b]
end

run_test("2D board") do
  pos = Qi.new([[:a, nil], [nil, :b]], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "wrong board" unless pos.board == [[:a, nil], [nil, :b]]
end

run_test("3D board") do
  board = [[[:a, :b], [:c, :d]], [[:A, :B], [:C, :D]]]
  pos = Qi.new(board, { first: [], second: [] }, { first: "R", second: "r" }, :first)
  raise "wrong board" unless pos.board == board
end

run_test("with pieces in hand") do
  pos = Qi.new([[nil, nil], [nil, nil]], { first: [:P], second: [:p] }, { first: "C", second: "c" }, :second)
  raise "wrong hands" unless pos.hands == { first: [:P], second: [:p] }
  raise "wrong turn" unless pos.turn == :second
end

# ============================================================================
# Qi.new WITH INVALID INPUT
# ============================================================================

puts
puts "Qi.new with invalid input:"

run_test("raises for invalid turn") do
  Qi.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :third)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "turn must be :first or :second"
end

run_test("raises for empty board") do
  Qi.new([], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board must not be empty"
end

run_test("raises for invalid hands") do
  Qi.new([nil], "not hands", { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "hands must be a Hash with keys :first and :second"
end

run_test("raises for invalid styles") do
  Qi.new([nil], { first: [], second: [] }, "not styles", :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "styles must be a Hash with keys :first and :second"
end

run_test("raises for cardinality violation") do
  Qi.new([:k], { first: [:P], second: [] }, { first: "C", second: "c" }, :first)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (2 pieces, 1 squares)"
end

# ============================================================================
# IMMUTABILITY VIA Qi.new
# ============================================================================

puts
puts "Immutability via Qi.new:"

run_test("returned position is frozen") do
  pos = Qi.new([nil], { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "should be frozen" unless pos.frozen?
end

run_test("does not mutate original board") do
  board = [[:a, nil], [nil, :b]]
  original = board.map(&:dup)
  Qi.new(board, { first: [], second: [] }, { first: "C", second: "c" }, :first)
  raise "original board was mutated" unless board == original
end

run_test("does not mutate original hands") do
  hands = { first: [:P], second: [] }
  Qi.new([nil, nil], hands, { first: "C", second: "c" }, :first)
  raise "original hands was mutated" unless hands == { first: [:P], second: [] }
end

puts
puts "All QI tests passed!"
puts
