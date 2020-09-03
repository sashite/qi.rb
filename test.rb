# frozen_string_literal: true

require "simplecov"

::SimpleCov.command_name "Brutal test suite"
::SimpleCov.start

require "./lib/qi"

STARTING_POSITION = Qi::Position.new(
  "l", "n", "s", "g", "k", "g", "s", "n", "l",
  nil, "r", nil, nil, nil, nil, nil, "b", nil,
  "p", "p", "p", "p", "p", "p", "p", "p", "p",
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  "P", "P", "P", "P", "P", "P", "P", "P", "P",
  nil, "B", nil, nil, nil, nil, nil, "R", nil,
  "L", "N", "S", "G", "K", "G", "S", "N", "L"
)

# ------------------------------------------------------------------------------

actual = begin
  [].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "g", "k", "g", "s", "n", "l", nil, "r", nil, nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", "P", "P", "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [[], []]
raise if actual.active_side_id != 0

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "g", "k", "g", "s", "n", "l", nil, "r", nil, nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [[], []]
raise if actual.active_side_id != 1

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", "g", "s", "n", "l", nil, "r", "g", nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [[], []]
raise if actual.active_side_id != 0

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", "g", "s", "n", "l", nil, "r", "g", nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "+B", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [["P"], []]
raise if actual.active_side_id != 1

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != ["P"]
raise if actual.squares != ["l", "n", "s", nil, "k", nil, "s", "n", "l", nil, "r", "g", nil, nil, "g", nil, "b", nil, "p", "p", "p", "p", "p", "p", "+B", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [["P"], []]
raise if actual.active_side_id != 0

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", nil, "s", "n", "l", nil, "r", "g", nil, nil, "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [["P", "G"], []]
raise if actual.active_side_id != 1

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != ["P", "G"]
raise if actual.squares != ["l", "n", "s", "k", nil, nil, "s", "n", "l", nil, "r", "g", nil, nil, "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [["P", "G"], []]
raise if actual.active_side_id != 0

# ------------------------------------------------------------------------------

actual = begin
  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"], [nil, 13, "G"]].reduce(STARTING_POSITION) { |position, move| position.call(move) }
end

raise if actual.in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "k", nil, nil, "s", "n", "l", nil, "r", "g", nil, "G", "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.pieces_in_hand_grouped_by_sides != [["P"], []]
raise if actual.active_side_id != 1
