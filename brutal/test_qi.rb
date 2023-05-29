# frozen_string_literal: true

require "simplecov"

::SimpleCov.command_name "Brutal test suite"
::SimpleCov.start

begin
  require_relative "../lib/qi"
rescue ::LoadError
  require "../lib/qi"
end

STARTING_POSITION_CONTEXT = {
  0  => "l",
  1  => "n",
  2  => "s",
  3  => "g",
  4  => "k",
  5  => "g",
  6  => "s",
  7  => "n",
  8  => "l",
  10 => "r",
  16 => "b",
  18 => "p",
  19 => "p",
  20 => "p",
  21 => "p",
  22 => "p",
  23 => "p",
  24 => "p",
  25 => "p",
  26 => "p",
  54 => "P",
  55 => "P",
  56 => "P",
  57 => "P",
  58 => "P",
  59 => "P",
  60 => "P",
  61 => "P",
  62 => "P",
  64 => "B",
  70 => "R",
  72 => "L",
  73 => "N",
  74 => "S",
  75 => "G",
  76 => "K",
  77 => "G",
  78 => "S",
  79 => "N",
  80 => "L"
}.freeze

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != []
raise if actual.captures_hash != {}
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }
  raise
end
raise if actual.state != {}
raise if actual.turn != 1
raise if actual.turns != [1, 0]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }], [[], [], { 3 => "nil", 11 => "g" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != []
raise if actual.captures_hash != {}
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if actual.state != {}
raise if actual.turn != 0
raise if actual.turns != [0, 1]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }], [[], [], { 3 => "nil", 11 => "g" }], [["P"], [], { 64 => "nil", 24 => "+B" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != ["P"]
raise if actual.captures_hash != { "P"=>1 }
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if actual.state != {}
raise if actual.turn != 1
raise if actual.turns != [1, 0]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }], [[], [], { 3 => "nil", 11 => "g" }], [["P"], [], { 64 => "nil", 24 => "+B" }], [[], [], { 5 => "nil", 14 => "g" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != ["P"]
raise if actual.captures_hash != { "P"=>1 }
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }
  raise
end
raise if actual.state != {}
raise if actual.turn != 0
raise if actual.turns != [0, 1]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }], [[], [], { 3 => "nil", 11 => "g" }], [["P"], [], { 64 => "nil", 24 => "+B" }], [[], [], { 5 => "nil", 14 => "g" }], [["G"], [], { 24 => "nil", 14 => "+B" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != %w[G P]
raise if actual.captures_hash != { "P" => 1, "G" => 1 }
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "nil", 4 => "k", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }
  raise
end
raise if actual.state != {}
raise if actual.turn != 1
raise if actual.turns != [1, 0]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }], [[], [], { 3 => "nil", 11 => "g" }], [["P"], [], { 64 => "nil", 24 => "+B" }], [[], [], { 5 => "nil", 14 => "g" }], [["G"], [], { 24 => "nil", 14 => "+B" }], [[], [], { 4 => "nil", 3 => "k" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != %w[G P]
raise if actual.captures_hash != { "P" => 1, "G" => 1 }
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }
  raise
end
raise if actual.state != {}
raise if actual.turn != 0
raise if actual.turns != [0, 1]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])

  [[[], [], { 56 => "nil", 47 => "P" }], [[], [], { 3 => "nil", 11 => "g" }], [["P"], [], { 64 => "nil", 24 => "+B" }], [[], [], { 5 => "nil", 14 => "g" }], [["G"], [], { 24 => "nil", 14 => "+B" }], [[], [], { 4 => "nil", 3 => "k" }], [[], ["G"], { 13=>"G" }, { "note"=>"this is a drop" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(3), **args.fetch(3) { {} })
  end
end

raise if actual.captures_array != ["P"]
raise if actual.captures_hash != { "P"=>1 }
if actual.squares_hash != { 0 => "l", 1 => "n", 2 => "s", 3 => "k", 4 => "nil", 5 => "nil", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "nil", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "nil", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "nil", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 13 => "G" }
  raise
end
raise if actual.state != { note: "this is a drop" }
raise if actual.turn != 1
raise if actual.turns != [1, 0]
raise if (actual == Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false
raise if actual.eql?(Qi.new({}, STARTING_POSITION_CONTEXT, [0, 1])) != false

# Finishing a test

# ------------------------------------------------------------------------------

# End of the brutal test
