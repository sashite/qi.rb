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
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  raise "expected Qi, got #{pos.class}" unless pos.is_a?(Qi)
end

Test("1D board") do
  pos = Qi.new(8, first_player_style: "G", second_player_style: "g")
  raise "wrong shape" unless pos.shape == [8]
end

Test("2D board") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  raise "wrong shape" unless pos.shape == [8, 8]
end

Test("3D board") do
  pos = Qi.new(5, 5, 5, first_player_style: "R", second_player_style: "r")
  raise "wrong shape" unless pos.shape == [5, 5, 5]
end

Test("minimal board (1 square)") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
  raise "wrong board" unless pos.board == [nil]
end

Test("max dimension size (255)") do
  pos = Qi.new(255, first_player_style: "C", second_player_style: "c")
  raise "wrong shape" unless pos.shape == [255]
end

Test("turn defaults to :first") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  raise "wrong turn" unless pos.turn == :first
end

Test("board starts empty") do
  pos = Qi.new(2, 3, first_player_style: "C", second_player_style: "c")
  raise "wrong board" unless pos.board == [[nil, nil, nil], [nil, nil, nil]]
end

Test("hands start empty") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  raise "wrong first hand" unless pos.first_player_hand == []
  raise "wrong second hand" unless pos.second_player_hand == []
end

Test("symbol styles are normalized to strings") do
  pos = Qi.new(8, 8, first_player_style: :chess, second_player_style: :shogi)
  raise "wrong first style" unless pos.first_player_style == "chess"
  raise "wrong second style" unless pos.second_player_style == "shogi"
end

Test("string styles") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  raise "wrong first style" unless pos.first_player_style == "C"
  raise "wrong second style" unless pos.second_player_style == "c"
end

Test("false style is normalized to string") do
  pos = Qi.new(1, first_player_style: false, second_player_style: false)
  raise "wrong style" unless pos.first_player_style == "false"
end

Test("zero style is normalized to string") do
  pos = Qi.new(1, first_player_style: 0, second_player_style: 0)
  raise "wrong style" unless pos.first_player_style == "0"
end

Test("position is frozen") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  raise "should be frozen" unless pos.frozen?
end

# ============================================================================
# CONSTRUCTION ERRORS — SHAPE
# ============================================================================

puts
puts "Construction errors (shape):"

Test("raises for no dimensions") do
  Qi.new(first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "at least one dimension is required"
end

Test("raises for 4 dimensions") do
  Qi.new(2, 2, 2, 2, first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "board exceeds 3 dimensions (got 4)"
end

Test("raises for non-integer dimension") do
  Qi.new("8", 8, first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be an Integer, got String"
end

Test("raises for zero dimension") do
  Qi.new(0, 8, first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be at least 1, got 0"
end

Test("raises for negative dimension") do
  Qi.new(-1, first_player_style: "C", second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "dimension size must be at least 1, got -1"
end

Test("raises for dimension exceeding 255") do
  Qi.new(256, first_player_style: "C", second_player_style: "c")
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
  Qi.new(8, 8, first_player_style: nil, second_player_style: "c")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

Test("raises for nil second style") do
  Qi.new(8, 8, first_player_style: "C", second_player_style: nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "second player style must not be nil"
end

# ============================================================================
# ACCESSORS — BOARD
# ============================================================================

puts
puts "Board accessor:"

Test("1D board with pieces") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "k", 3 => "K")
  raise "wrong board" unless pos.board == ["k", nil, nil, "K"]
end

Test("2D board with pieces") do
  pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 3 => "b")
  raise "wrong board" unless pos.board == [["a", nil], [nil, "b"]]
end

Test("3D board with pieces") do
  pos = Qi.new(2, 2, 2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 7 => "b")
  board = pos.board
  raise "wrong [0][0][0]" unless board[0][0][0] == "a"
  raise "wrong [1][1][1]" unless board[1][1][1] == "b"
end

Test("EPIN string pieces") do
  pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "K^", 3 => "k^")
  raise "wrong board" unless pos.board == [["K^", nil], [nil, "k^"]]
end

# ============================================================================
# ACCESSORS — IMMUTABILITY
# ============================================================================

puts
puts "Accessor immutability:"

Test("board returns a copy") do
  pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  b1 = pos.board
  b2 = pos.board
  raise "should be different objects" if b1.equal?(b2)
end

Test("mutating board copy does not affect position") do
  pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  copy = pos.board
  copy[0][0] = "z"
  raise "position was affected" unless pos.board == [["a", nil], [nil, nil]]
end

Test("first_player_hand returns a copy") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  h1 = pos.first_player_hand
  h2 = pos.first_player_hand
  raise "should be different objects" if h1.equal?(h2)
end

Test("mutating hand copy does not affect position") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  copy = pos.first_player_hand
  copy << "B"
  raise "position was affected" unless pos.first_player_hand == ["P"]
end

Test("second_player_hand returns a copy") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1)
  h1 = pos.second_player_hand
  h2 = pos.second_player_hand
  raise "should be different objects" if h1.equal?(h2)
end

Test("first_player_style is frozen") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
  raise "should be frozen" unless pos.first_player_style.frozen?
end

Test("second_player_style is frozen") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
  raise "should be frozen" unless pos.second_player_style.frozen?
end

Test("shape returns a copy") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  s1 = pos.shape
  s2 = pos.shape
  raise "should be different objects" if s1.equal?(s2)
end

Test("constructor does not retain reference to style") do
  style = +"C"
  pos = Qi.new(1, first_player_style: style, second_player_style: "c")
  style << "X"
  raise "position was affected" unless pos.first_player_style == "C"
end

# ============================================================================
# BOARD DIFF
# ============================================================================

puts
puts "Board diff:"

Test("set a single square") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(1 => "a")
  raise "wrong board" unless pos2.board == [nil, "a", nil, nil]
end

Test("empty a square") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos2 = pos.board_diff(0 => nil)
  raise "wrong board" unless pos2.board == [nil, nil, nil]
end

Test("multiple changes at once") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => "a", 1 => "b", 3 => "c")
  raise "wrong board" unless pos2.board == ["a", "b", nil, "c"]
end

Test("replace piece with another") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 1 => "b")
  pos2 = pos.board_diff(0 => "x")
  raise "wrong board" unless pos2.board == ["x", "b"]
end

Test("move a piece (empty source, fill destination)") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .board_diff(1 => "C:P")
  pos2 = pos.board_diff(1 => nil, 3 => "C:P")
  raise "wrong board" unless pos2.board == [nil, nil, nil, "C:P"]
end

Test("2D board: set square (flat index 2)") do
  pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(2 => "z")
  raise "wrong board" unless pos2.board == [[nil, nil], ["z", nil]]
end

Test("preserves hands") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.board_diff(0 => "a")
  raise "hands changed" unless pos2.first_player_hand == ["P"]
end

Test("preserves styles") do
  pos = Qi.new(2, first_player_style: "S", second_player_style: "s")
  pos2 = pos.board_diff(0 => "a")
  raise "first style changed" unless pos2.first_player_style == "S"
  raise "second style changed" unless pos2.second_player_style == "s"
end

Test("preserves turn") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c").toggle
  pos2 = pos.board_diff(0 => "a")
  raise "turn changed" unless pos2.turn == :second
end

Test("returns a new frozen position") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => "a")
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be frozen" unless pos2.frozen?
end

Test("original position is unchanged") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos.board_diff(0 => nil)
  raise "original was affected" unless pos.board == ["a", nil, nil]
end

# --- Board diff errors ---

puts
puts "Board diff errors:"

Test("raises for negative flat index") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.board_diff(-1 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: -1 (board has 2 squares)"
end

Test("raises for flat index equal to square count") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.board_diff(2 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: 2 (board has 2 squares)"
end

Test("raises for flat index exceeding square count") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.board_diff(99 => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "invalid flat index: 99 (board has 2 squares)"
end

Test("raises for non-integer key") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.board_diff("a1" => "a")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("invalid flat index")
end

Test("symbol piece is normalized to string") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => :a)
  raise "wrong board" unless pos2.board == ["a", nil]
end

Test("integer piece is normalized to string") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => 42)
  raise "wrong board" unless pos2.board == ["42", nil]
end

Test("array piece is normalized to string") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => [:king])
  raise "wrong board" unless pos2.board == ["[:king]", nil]
end

Test("false piece is normalized to string") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => false)
  raise "wrong board" unless pos2.board == ["false", nil]
end

Test("raises when adding pieces beyond board capacity") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
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
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "wrong hand" unless pos2.first_player_hand == ["P"]
end

Test("add multiple copies") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 3)
  raise "wrong hand" unless pos2.first_player_hand == ["P", "P", "P"]
end

Test("add different pieces") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 1, B: 1)
  raise "wrong hand" unless pos2.first_player_hand == ["P", "B"]
end

Test("remove a piece") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1, B: 1)
  pos2 = pos.first_player_hand_diff(P: -1)
  raise "wrong hand" unless pos2.first_player_hand == ["B"]
end

Test("remove multiple copies") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 2, B: 1)
  pos2 = pos.first_player_hand_diff(P: -2)
  raise "wrong hand" unless pos2.first_player_hand == ["B"]
end

Test("add and remove in same call") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.first_player_hand_diff(P: -1, B: 1)
  raise "wrong hand" unless pos2.first_player_hand == ["B"]
end

Test("zero delta is a no-op") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.first_player_hand_diff(P: 0)
  raise "wrong hand" unless pos2.first_player_hand == ["P"]
end

Test("string-key pieces are stored as strings") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff("S:P": 1)
  raise "wrong hand" unless pos2.first_player_hand == ["S:P"]
end

Test("preserves board") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "board changed" unless pos2.board == ["a", nil, nil]
end

Test("preserves second player hand") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1)
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "second hand changed" unless pos2.second_player_hand == ["p"]
end

Test("preserves styles") do
  pos = Qi.new(2, first_player_style: "S", second_player_style: "s")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "styles changed" unless pos2.first_player_style == "S"
end

Test("preserves turn") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c").toggle
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "turn changed" unless pos2.turn == :second
end

Test("returns a new frozen position") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.first_player_hand_diff(P: 1)
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be frozen" unless pos2.frozen?
end

Test("original position is unchanged") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos.first_player_hand_diff(P: -1)
  raise "original was affected" unless pos.first_player_hand == ["P"]
end

# --- First player hand diff errors ---

puts
puts "First player hand diff errors:"

Test("raises for non-integer delta") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.first_player_hand_diff(P: "one")
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("delta must be an Integer")
end

Test("raises when removing piece not in hand") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.first_player_hand_diff(P: -1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("cannot remove")
end

Test("raises when removing more pieces than present") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos.first_player_hand_diff(P: -2)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("cannot remove")
end

Test("raises for cardinality violation") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
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
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
  pos2 = pos.second_player_hand_diff(p: 1)
  raise "wrong hand" unless pos2.second_player_hand == ["p"]
end

Test("remove a piece") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1, b: 1)
  pos2 = pos.second_player_hand_diff(p: -1)
  raise "wrong hand" unless pos2.second_player_hand == ["b"]
end

Test("add and remove in same call") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .second_player_hand_diff(p: 1)
  pos2 = pos.second_player_hand_diff(p: -1, b: 1)
  raise "wrong hand" unless pos2.second_player_hand == ["b"]
end

Test("preserves first player hand") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
  pos2 = pos.second_player_hand_diff(p: 1)
  raise "first hand changed" unless pos2.first_player_hand == ["P"]
end

Test("returns a new frozen position") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.second_player_hand_diff(p: 1)
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be frozen" unless pos2.frozen?
end

# --- Second player hand diff errors ---

puts
puts "Second player hand diff errors:"

Test("raises when removing piece not in hand") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.second_player_hand_diff(p: -1)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message.include?("cannot remove")
end

Test("raises for cardinality violation") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
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
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos2 = pos.toggle
  raise "expected :second" unless pos2.turn == :second
end

Test("toggle from :second to :first") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c").toggle
  pos2 = pos.toggle
  raise "expected :first" unless pos2.turn == :first
end

Test("toggle preserves board") do
  pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 3 => "b")
  pos2 = pos.toggle
  raise "board changed" unless pos2.board == pos.board
end

Test("toggle preserves hands") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .first_player_hand_diff(P: 1)
    .second_player_hand_diff(p: 1)
  pos2 = pos.toggle
  raise "first hand changed" unless pos2.first_player_hand == ["P"]
  raise "second hand changed" unless pos2.second_player_hand == ["p"]
end

Test("toggle preserves styles") do
  pos = Qi.new(1, first_player_style: "S", second_player_style: "s")
  pos2 = pos.toggle
  raise "first style changed" unless pos2.first_player_style == "S"
  raise "second style changed" unless pos2.second_player_style == "s"
end

Test("toggle returns a new frozen position") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
  pos2 = pos.toggle
  raise "should be a different object" if pos.equal?(pos2)
  raise "should be frozen" unless pos2.frozen?
end

Test("original position is unchanged after toggle") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  pos.toggle
  raise "original turn changed" unless pos.turn == :first
end

Test("double toggle returns to original turn") do
  pos = Qi.new(1, first_player_style: "C", second_player_style: "c")
  pos2 = pos.toggle.toggle
  raise "expected :first" unless pos2.turn == :first
end

# ============================================================================
# CHAINING
# ============================================================================

puts
puts "Chaining:"

Test("board_diff + toggle") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
  pos2 = pos.board_diff(0 => "a").toggle
  raise "wrong board" unless pos2.board == ["a", nil, nil, nil]
  raise "wrong turn" unless pos2.turn == :second
end

Test("board_diff + first_player_hand_diff + toggle") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
  pos2 = pos
    .board_diff(0 => "a")
    .first_player_hand_diff(P: 1)
    .toggle
  raise "wrong board" unless pos2.board == ["a", nil, nil, nil]
  raise "wrong hand" unless pos2.first_player_hand == ["P"]
  raise "wrong turn" unless pos2.turn == :second
end

Test("board_diff + second_player_hand_diff + toggle") do
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
  pos2 = pos
    .board_diff(0 => "a")
    .second_player_hand_diff(p: 1)
    .toggle
  raise "wrong board" unless pos2.board == ["a", nil, nil, nil]
  raise "wrong hand" unless pos2.second_player_hand == ["p"]
  raise "wrong turn" unless pos2.turn == :second
end

Test("complete capture scenario") do
  # Set up: piece at index 1, capture it to hand, place attacker, toggle
  pos = Qi.new(4, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "attacker", 1 => "defender")
  pos2 = pos
    .board_diff(1 => "attacker", 0 => nil)
    .first_player_hand_diff(defender: 1)
    .toggle
  raise "wrong board" unless pos2.board == [nil, "attacker", nil, nil]
  raise "wrong hand" unless pos2.first_player_hand == ["defender"]
  raise "wrong turn" unless pos2.turn == :second
end

# ============================================================================
# CARDINALITY
# ============================================================================

puts
puts "Cardinality:"

Test("accepts pieces equal to squares") do
  pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a", 1 => "b")
  raise "should have succeeded" unless pos.board == ["a", "b"]
end

Test("accepts pieces equal to squares with hands") do
  pos = Qi.new(3, first_player_style: "C", second_player_style: "c")
    .board_diff(0 => "a")
    .first_player_hand_diff(P: 1)
    .second_player_hand_diff(p: 1)
  raise "should have 1 board piece" unless pos.board.count { |s| !s.nil? } == 1
  raise "should have 1 in first hand" unless pos.first_player_hand.size == 1
  raise "should have 1 in second hand" unless pos.second_player_hand.size == 1
end

# ============================================================================
# INSPECT
# ============================================================================

puts
puts "Inspect:"

Test("inspect returns a readable string") do
  pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
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
  Qi.new(first_player_style: nil, second_player_style: nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "at least one dimension is required"
end

Test("first style error takes precedence over second style error") do
  Qi.new(8, first_player_style: nil, second_player_style: nil)
  raise "should have raised"
rescue ArgumentError => e
  raise "wrong message: #{e.message}" unless e.message == "first player style must not be nil"
end

puts
puts "All QI tests passed!"
puts
