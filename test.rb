# frozen_string_literal: false

require 'simplecov'

::SimpleCov.command_name 'Brutal test suite'
::SimpleCov.start

require './lib/qi'

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "g", "k", "g", "s", "n", "l", nil, "r", nil, nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", "P", "P", "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != []
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != false

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "g", "k", "g", "s", "n", "l", nil, "r", nil, nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != []
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"], [3, 11, "g"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", "g", "s", "n", "l", nil, "r", "g", nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "p", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, "B", nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != []
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != false

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", "g", "s", "n", "l", nil, "r", "g", nil, nil, nil, nil, "b", nil, "p", "p", "p", "p", "p", "p", "+B", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P"]
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", nil, "s", "n", "l", nil, "r", "g", nil, nil, "g", nil, "b", nil, "p", "p", "p", "p", "p", "p", "+B", "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P"]
raise if actual.in_hand_pieces != ["P"]
raise if actual.turn_to_topside? != false

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", nil, "k", nil, "s", "n", "l", nil, "r", "g", nil, nil, "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P", "G"]
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "k", nil, nil, "s", "n", "l", nil, "r", "g", nil, nil, "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P", "G"]
raise if actual.in_hand_pieces != ["P", "G"]
raise if actual.turn_to_topside? != false

# ------------------------------------------------------------------------------

actual = begin
  starting_position = Qi::Position.new(
    'l', 'n', 's', 'g', 'k', 'g', 's', 'n', 'l',
    nil, 'r', nil, nil, nil, nil, nil, 'b', nil,
    'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p',
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P',
    nil, 'B', nil, nil, nil, nil, nil, 'R', nil,
    'L', 'N', 'S', 'G', 'K', 'G', 'S', 'N', 'L'
  )

  [[56, 47, "P"], [3, 11, "g"], [64, 24, "+B", "P"], [5, 14, "g"], [24, 14, "+B", "G"], [4, 3, "k"], [nil, 13, "G"]].reduce(starting_position) { |position, move| position.call(move) }
end

raise if actual.topside_in_hand_pieces != []
raise if actual.squares != ["l", "n", "s", "k", nil, nil, "s", "n", "l", nil, "r", "g", nil, "G", "+B", nil, "b", nil, "p", "p", "p", "p", "p", "p", nil, "p", "p", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "P", nil, nil, nil, nil, nil, nil, "P", "P", nil, "P", "P", "P", "P", "P", "P", nil, nil, nil, nil, nil, nil, nil, "R", nil, "L", "N", "S", "G", "K", "G", "S", "N", "L"]
raise if actual.bottomside_in_hand_pieces != ["P"]
raise if actual.in_hand_pieces != []
raise if actual.turn_to_topside? != true
