#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "helper"
require_relative "../lib/qi"

puts
puts "=== QI Tests ==="
puts

# ============================================================================
# CONSTRUCTION
# ============================================================================

puts "Construction:"

Test("returns a Qi instance") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  raise "expected Qi, got #{pos.class}" unless pos.is_a?(Qi)
end

Test("1D board") do
  pos = Qi.new([8], first_player_style: "G", second_player_style: "g")
  raise "wrong shape" unless pos.shape == [8]
end

Test("2D board") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  raise "wrong shape" unless pos.shape == [8, 8]
end

Test("3D board") do
  pos = Qi.new([5, 5, 5], first_player_style: "R", second_player_style: "r")
  raise "wrong shape" unless pos.shape == [5, 5, 5]
end

Test("minimal board (1 square)") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
  raise "wrong board" unless pos.board == [nil]
end

Test("max dimension size (255)") do
  pos = Qi.new([255], first_player_style: "C", second_player_style: "c")
  raise "wrong shape" unless pos.shape == [255]
end

Test("turn defaults to :first") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  raise "wrong turn" unless pos.turn == :first
end

Test("board starts empty (flat array of nils)") do
  pos = Qi.new([2, 3], first_player_style: "C", second_player_style: "c")
  raise "wrong board" unless pos.board == [nil, nil, nil, nil, nil, nil]
end

Test("hands start empty (empty hashes)") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  raise "wrong first hand" unless pos.first_player_hand == {}
  raise "wrong second hand" unless pos.second_player_hand == {}
end

Test("string styles") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  raise "wrong first style" unless pos.first_player_style == "C"
  raise "wrong second style" unless pos.second_player_style == "c"
end

Test("empty string styles") do
  pos = Qi.new([1], first_player_style: "", second_player_style: "")
  raise "wrong first style" unless pos.first_player_style == ""
  raise "wrong second style" unless pos.second_player_style == ""
end

# ============================================================================
# CONSTRUCTION ERRORS — SHAPE
# ============================================================================

puts
puts "Construction errors (shape):"

Test("raises for no dimensions") do
  Qi.new([], first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "at least one dimension is required"
end

Test("raises for 4 dimensions") do
  Qi.new([2, 2, 2, 2], first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board exceeds 3 dimensions (got 4)"
end

Test("raises for non-integer dimension") do
  Qi.new(["8", 8], first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be an Integer, got String"
end

Test("raises for zero dimension") do
  Qi.new([0, 8], first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be at least 1, got 0"
end

Test("raises for negative dimension") do
  Qi.new([-1], first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be at least 1, got -1"
end

Test("raises for dimension exceeding 255") do
  Qi.new([256], first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size 256 exceeds maximum of 255"
end

# ============================================================================
# CONSTRUCTION ERRORS — STYLES
# ============================================================================

puts
puts "Construction errors (styles):"

Test("raises for nil first style") do
  Qi.new([8, 8], first_player_style: nil, second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

Test("raises for nil second style") do
  Qi.new([8, 8], first_player_style: "C", second_player_style: nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "second player style must not be nil"
end

Test("raises for symbol first style") do
  Qi.new([8, 8], first_player_style: :chess, second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must be a String"
end

Test("raises for symbol second style") do
  Qi.new([8, 8], first_player_style: "C", second_player_style: :shogi)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "second player style must be a String"
end

Test("raises for integer style") do
  Qi.new([8, 8], first_player_style: 0, second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must be a String"
end

Test("raises for false style") do
  Qi.new([1], first_player_style: false, second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must be a String"
end

# ============================================================================
# ACCESSORS — BOARD (FLAT)
# ============================================================================

puts
puts "Board accessor (flat):"

Test("1D board with pieces") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "k", 3 => "K")
  raise "wrong board" unless pos.board == ["k", nil, nil, "K"]
end

Test("2D board with pieces (flat)") do
  pos = Qi.new([2, 2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 3 => "b")
  raise "wrong board" unless pos.board == ["a", nil, nil, "b"]
end

Test("3D board with pieces (flat)") do
  pos = Qi.new([2, 2, 2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 7 => "b")
  raise "wrong [0]" unless pos.board[0] == "a"
  raise "wrong [7]" unless pos.board[7] == "b"
end

Test("EPIN string pieces") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "K^", 2 => "k^")
  raise "wrong board" unless pos.board == ["K^", nil, "k^"]
end

Test("board returns internal array (same object)") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  b1 = pos.board
  b2 = pos.board
  raise "should be same object" unless b1.equal?(b2)
end

# ============================================================================
# ACCESSORS — TO_NESTED
# ============================================================================

puts
puts "to_nested:"

Test("1D to_nested") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "k", 3 => "K")
  raise "wrong" unless pos.to_nested == ["k", nil, nil, "K"]
end

Test("2D to_nested") do
  pos = Qi.new([2, 2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 3 => "b")
  raise "wrong" unless pos.to_nested == [["a", nil], [nil, "b"]]
end

Test("3D to_nested") do
  pos = Qi.new([2, 2, 2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 7 => "b")
  nested = pos.to_nested
  raise "wrong [0][0][0]" unless nested[0][0][0] == "a"
  raise "wrong [1][1][1]" unless nested[1][1][1] == "b"
end

Test("to_nested returns independent copy") do
  pos = Qi.new([2, 2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  nested = pos.to_nested
  nested[0][0] = "z"
  raise "board was affected" unless pos.board[0] == "a"
end

# ============================================================================
# ACCESSORS — HANDS (HASH)
# ============================================================================

puts
puts "Hand accessors (hash):"

Test("first_player_hand returns hash") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 2, B: 1)
  raise "wrong" unless pos.first_player_hand == { "P" => 2, "B" => 1 }
end

Test("second_player_hand returns hash") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1)
  raise "wrong" unless pos.second_player_hand == { "p" => 1 }
end

Test("hand returns internal hash (same object)") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  h1 = pos.first_player_hand
  h2 = pos.first_player_hand
  raise "should be same object" unless h1.equal?(h2)
end

# ============================================================================
# ACCESSORS — STYLES & SHAPE
# ============================================================================

puts
puts "Style and shape accessors:"

Test("styles return internal strings (same object)") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
  s1 = pos.first_player_style
  s2 = pos.first_player_style
  raise "should be same object" unless s1.equal?(s2)
end

Test("shape returns internal array (same object)") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  s1 = pos.shape
  s2 = pos.shape
  raise "should be same object" unless s1.equal?(s2)
end

# ============================================================================
# BOARD DIFF
# ============================================================================

puts
puts "Board diff:"

Test("set a single square") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(1 => "a")
  raise "wrong board" unless pos2.board == [nil, "a", nil, nil]
end

Test("empty a square") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos2 = pos.board_diff(0 => nil)
  raise "wrong board" unless pos2.board == [nil, nil, nil]
end

Test("multiple changes at once") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => "a", 1 => "b", 3 => "c")
  raise "wrong board" unless pos2.board == ["a", "b", nil, "c"]
end

Test("replace piece with another") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 1 => "b")
  pos2 = pos.board_diff(0 => "x")
  raise "wrong board" unless pos2.board == ["x", "b"]
end

Test("move a piece (empty source, fill destination)") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .board_diff(1 => "C:P")
  pos2 = pos.board_diff(1 => nil, 3 => "C:P")
  raise "wrong board" unless pos2.board == [nil, nil, nil, "C:P"]
end

Test("preserves hands") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.board_diff(0 => "a")
  raise "hands changed" unless pos2.first_player_hand == { "P" => 1 }
end

Test("preserves styles") do
  pos = Qi.new([2], first_player_style: "S", second_player_style: "s")
  pos2 = pos.board_diff(0 => "a")
  raise "first style changed" unless pos2.first_player_style == "S"
  raise "second style changed" unless pos2.second_player_style == "s"
end

Test("preserves turn") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c").toggle
  pos2 = pos.board_diff(0 => "a")
  raise "turn changed" unless pos2.turn == :second
end

Test("returns a new Qi instance") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => "a")
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be a Qi" unless pos2.is_a?(Qi)
end

Test("original position is unchanged") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos.board_diff(0 => nil)
  raise "original was affected" unless pos.board == ["a", nil, nil]
end

# --- Board diff errors ---

puts
puts "Board diff errors:"

Test("raises for negative flat index") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.board_diff(-1 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: -1 (board has 2 squares)"
end

Test("raises for flat index equal to square count") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.board_diff(2 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: 2 (board has 2 squares)"
end

Test("raises for flat index exceeding square count") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.board_diff(99 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: 99 (board has 2 squares)"
end

Test("raises for non-integer key") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.board_diff("a1" => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message.include?("invalid flat index")
end

Test("raises for non-string piece") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.board_diff(0 => :king)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "piece must be a String, got Symbol"
end

Test("raises when adding pieces beyond board capacity") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos.board_diff(0 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (2 pieces, 1 squares)"
end

# ============================================================================
# FIRST PLAYER HAND DIFF
# ============================================================================

puts
puts "First player hand diff:"

Test("add a piece") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "wrong hand" unless pos2.first_player_hand == { "P" => 1 }
end

Test("add multiple copies") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 3)
  raise "wrong hand" unless pos2.first_player_hand == { "P" => 3 }
end

Test("add different pieces") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 1, B: 1)
  raise "wrong hand" unless pos2.first_player_hand == { "P" => 1, "B" => 1 }
end

Test("remove a piece") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1, B: 1)
  pos2 = pos.first_player_hand_diff(P: -1)
  raise "wrong hand" unless pos2.first_player_hand == { "B" => 1 }
end

Test("remove all copies (entry disappears)") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 2, B: 1)
  pos2 = pos.first_player_hand_diff(P: -2)
  raise "wrong hand" unless pos2.first_player_hand == { "B" => 1 }
end

Test("add and remove in same call") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.first_player_hand_diff(P: -1, B: 1)
  raise "wrong hand" unless pos2.first_player_hand == { "B" => 1 }
end

Test("zero delta is a no-op") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.first_player_hand_diff(P: 0)
  raise "wrong hand" unless pos2.first_player_hand == { "P" => 1 }
end

Test("namespaced piece keys") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff("S:P": 1)
  raise "wrong hand" unless pos2.first_player_hand == { "S:P" => 1 }
end

Test("preserves board") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "board changed" unless pos2.board == ["a", nil, nil]
end

Test("preserves second player hand") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1)
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "second hand changed" unless pos2.second_player_hand == { "p" => 1 }
end

Test("preserves styles") do
  pos = Qi.new([2], first_player_style: "S", second_player_style: "s")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "styles changed" unless pos2.first_player_style == "S"
end

Test("preserves turn") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c").toggle
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "turn changed" unless pos2.turn == :second
end

Test("returns a new Qi instance") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be a Qi" unless pos2.is_a?(Qi)
end

Test("original position is unchanged") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos.first_player_hand_diff(P: -1)
  raise "original was affected" unless pos.first_player_hand == { "P" => 1 }
end

# --- First player hand diff errors ---

puts
puts "First player hand diff errors:"

Test("raises for non-integer delta") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.first_player_hand_diff(P: "one")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("delta must be an Integer")
end

Test("raises when removing piece not in hand") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.first_player_hand_diff(P: -1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("cannot remove")
end

Test("raises when removing more pieces than present") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos.first_player_hand_diff(P: -2)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("cannot remove")
end

Test("raises for cardinality violation") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos.first_player_hand_diff(P: 1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (2 pieces, 1 squares)"
end

# ============================================================================
# SECOND PLAYER HAND DIFF
# ============================================================================

puts
puts "Second player hand diff:"

Test("add a piece") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
  pos2 = pos.second_player_hand_diff(p: 1)
  raise "wrong hand" unless pos2.second_player_hand == { "p" => 1 }
end

Test("remove a piece") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1, b: 1)
  pos2 = pos.second_player_hand_diff(p: -1)
  raise "wrong hand" unless pos2.second_player_hand == { "b" => 1 }
end

Test("add and remove in same call") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1)
  pos2 = pos.second_player_hand_diff(p: -1, b: 1)
  raise "wrong hand" unless pos2.second_player_hand == { "b" => 1 }
end

Test("preserves first player hand") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.second_player_hand_diff(p: 1)
  raise "first hand changed" unless pos2.first_player_hand == { "P" => 1 }
end

Test("returns a new Qi instance") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos2 = pos.second_player_hand_diff(p: 1)
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be a Qi" unless pos2.is_a?(Qi)
end

# --- Second player hand diff errors ---

puts
puts "Second player hand diff errors:"

Test("raises when removing piece not in hand") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.second_player_hand_diff(p: -1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("cannot remove")
end

Test("raises for cardinality violation") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos.second_player_hand_diff(p: 1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "too many pieces for board size (2 pieces, 1 squares)"
end

# ============================================================================
# TOGGLE
# ============================================================================

puts
puts "Toggle:"

Test("toggle from :first to :second") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos2 = pos.toggle
  raise "expected :second" unless pos2.turn == :second
end

Test("toggle from :second to :first") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c").toggle
  pos2 = pos.toggle
  raise "expected :first" unless pos2.turn == :first
end

Test("toggle preserves board") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 3 => "b")
  pos2 = pos.toggle
  raise "board changed" unless pos2.board == pos.board
end

Test("toggle preserves hands") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
    .second_player_hand_diff(p: 1)
  pos2 = pos.toggle
  raise "first hand changed" unless pos2.first_player_hand == { "P" => 1 }
  raise "second hand changed" unless pos2.second_player_hand == { "p" => 1 }
end

Test("toggle preserves styles") do
  pos = Qi.new([1], first_player_style: "S", second_player_style: "s")
  pos2 = pos.toggle
  raise "first style changed" unless pos2.first_player_style == "S"
  raise "second style changed" unless pos2.second_player_style == "s"
end

Test("toggle returns a new Qi instance") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
  pos2 = pos.toggle
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be a Qi" unless pos2.is_a?(Qi)
end

Test("original position is unchanged after toggle") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
  pos.toggle
  raise "original turn changed" unless pos.turn == :first
end

Test("double toggle returns to original turn") do
  pos = Qi.new([1], first_player_style: "C", second_player_style: "c")
  pos2 = pos.toggle.toggle
  raise "expected :first" unless pos2.turn == :first
end

# ============================================================================
# CHAINING
# ============================================================================

puts
puts "Chaining:"

Test("board_diff + toggle") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => "a").toggle
  raise "wrong board" unless pos2.board == ["a", nil, nil, nil]
  raise "wrong turn" unless pos2.turn == :second
end

Test("board_diff + first_player_hand_diff + toggle") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  pos2 = pos
    .board_diff(0 => "a")
    .first_player_hand_diff(P: 1)
    .toggle
  raise "wrong board" unless pos2.board == ["a", nil, nil, nil]
  raise "wrong hand" unless pos2.first_player_hand == { "P" => 1 }
  raise "wrong turn" unless pos2.turn == :second
end

Test("board_diff + second_player_hand_diff + toggle") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
  pos2 = pos
    .board_diff(0 => "a")
    .second_player_hand_diff(p: 1)
    .toggle
  raise "wrong board" unless pos2.board == ["a", nil, nil, nil]
  raise "wrong hand" unless pos2.second_player_hand == { "p" => 1 }
  raise "wrong turn" unless pos2.turn == :second
end

Test("complete capture scenario") do
  pos = Qi.new([4], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "attacker", 1 => "defender")
  pos2 = pos
    .board_diff(1 => "attacker", 0 => nil)
    .first_player_hand_diff(defender: 1)
    .toggle
  raise "wrong board" unless pos2.board == [nil, "attacker", nil, nil]
  raise "wrong hand" unless pos2.first_player_hand == { "defender" => 1 }
  raise "wrong turn" unless pos2.turn == :second
end

Test("shogi-style drop from hand to board") do
  pos = Qi.new([4], first_player_style: "S", second_player_style: "s")
    .first_player_hand_diff(P: 1)
  pos2 = pos
    .board_diff(2 => "P")
    .first_player_hand_diff(P: -1)
    .toggle
  raise "wrong board" unless pos2.board == [nil, nil, "P", nil]
  raise "wrong hand" unless pos2.first_player_hand == {}
  raise "wrong turn" unless pos2.turn == :second
end

# ============================================================================
# CARDINALITY
# ============================================================================

puts
puts "Cardinality:"

Test("accepts pieces equal to squares") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 1 => "b")
  raise "should have succeeded" unless pos.board == ["a", "b"]
end

Test("accepts pieces equal to squares with hands") do
  pos = Qi.new([3], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
    .first_player_hand_diff(P: 1)
    .second_player_hand_diff(p: 1)
  raise "should have 1 board piece" unless pos.board.count { |s| !s.nil? } == 1
  raise "should have 1 in first hand" unless pos.first_player_hand == { "P" => 1 }
  raise "should have 1 in second hand" unless pos.second_player_hand == { "p" => 1 }
end

Test("cardinality counts across all locations") do
  pos = Qi.new([2], first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
    .first_player_hand_diff(P: 1)
  # 2 pieces total = 2 squares: OK
  # Adding one more should fail
  pos.second_player_hand_diff(p: 1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message" unless e.message == "too many pieces for board size (3 pieces, 2 squares)"
end

# ============================================================================
# INSPECT
# ============================================================================

puts
puts "Inspect:"

Test("inspect returns a readable string") do
  pos = Qi.new([8, 8], first_player_style: "C", second_player_style: "c")
  str = pos.inspect
  raise "should start with #<Qi" unless str.start_with?("#<Qi")
  raise "should contain shape=" unless str.include?("shape=")
  raise "should contain turn=" unless str.include?("turn=")
end

# ============================================================================
# VALIDATION ORDER
# ============================================================================

puts
puts "Validation order:"

Test("shape error takes precedence over style error") do
  Qi.new([], first_player_style: nil, second_player_style: nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "at least one dimension is required"
end

Test("first style error takes precedence over second style error") do
  Qi.new([8], first_player_style: nil, second_player_style: nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

# ============================================================================
# CONSTANTS
# ============================================================================

puts
puts "Constants:"

Test("MAX_DIMENSIONS is 3") do
  raise "wrong" unless Qi::MAX_DIMENSIONS == 3
end

Test("MAX_DIMENSION_SIZE is 255") do
  raise "wrong" unless Qi::MAX_DIMENSION_SIZE == 255
end

puts
puts "All QI tests passed!"
puts
