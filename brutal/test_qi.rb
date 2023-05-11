# frozen_string_literal: true

require "simplecov"

::SimpleCov.command_name "Brutal test suite"
::SimpleCov.start

begin
  require_relative "../lib/qi"
rescue ::LoadError
  require "../lib/qi"
end

STARTING_POSITION_CONTEXT = [
  false,
  [],
  [],
  {
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
  },
  false
].freeze

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != true
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != true
raise if actual.current_captures != []
raise if actual.opponent_captures != []
raise if actual.current_turn != "South"
raise if actual.next_turn != "North"
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [false, [], [], { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L" }, is_in_check: false }
  raise
end
raise if actual.hash != "fcf1484387b948c360781e566b261ed8adc43d89a8809a84fbb9952f8ebdeda5"
if actual.board_pieces != [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 54, 55, 56, 57, 58, 59, 60, 61, 62, 64, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "South-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,56:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi South-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,56:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != []
raise if actual.opponent_captures != []
raise if actual.current_turn != "North"
raise if actual.next_turn != "South"
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [true, [], [], { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }, is_in_check: false }
  raise
end
raise if actual.hash != "d1dd131dbf32da5d2a19ec730ff2ff4f37cda6cdd1aa0036d45d3f63b3661a13"
if actual.board_pieces != [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 64, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "North-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi North-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 3 => nil, 11 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != []
raise if actual.opponent_captures != []
raise if actual.current_turn != "South"
raise if actual.next_turn != "North"
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [false, [], [], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, is_in_check: false }
  raise
end
raise if actual.hash != "8a9eede9e87c82ce18134b40b5f34df5f605202fb3e3ef6cb04aa96d57ef6ae9"
if actual.board_pieces != [0, 1, 2, 4, 5, 6, 7, 8, 10, 11, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 64, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "South-turn======0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,11:g,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi South-turn======0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,11:g,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 3 => nil, 11 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 64 => nil, 24 => "+B" }, "P", { "is_drop" => false, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != []
raise if actual.opponent_captures != ["P"]
raise if actual.current_turn != "North"
raise if actual.next_turn != "South"
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [true, [], ["P"], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }, is_in_check: false }
  raise
end
raise if actual.hash != "43aef7d6037d1ba540c2f7796c52d39a5b25e550cb2fcfcb2c55d70a6b45801d"
if actual.board_pieces != [0, 1, 2, 4, 5, 6, 7, 8, 10, 11, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "North-turn===P===0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,11:g,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi North-turn===P===0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,11:g,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 3 => nil, 11 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 64 => nil, 24 => "+B" }, "P", { "is_drop" => false, "is_in_check" => false }], [{ 5 => nil, 14 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != ["P"]
raise if actual.opponent_captures != []
raise if actual.current_turn != "South"
raise if actual.next_turn != "North"
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [false, [], ["P"], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }, is_in_check: false }
  raise
end
raise if actual.hash != "f2126b92ae95477092b7b8998781643b7f26bdfa9a3632dec3d562f6f1e7ea7e"
if actual.board_pieces != [0, 1, 2, 4, 6, 7, 8, 10, 11, 14, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "South-turn===P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,11:g,14:g,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi South-turn===P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,11:g,14:g,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 3 => nil, 11 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 64 => nil, 24 => "+B" }, "P", { "is_drop" => false, "is_in_check" => false }], [{ 5 => nil, 14 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 24 => nil, 14 => "+B" }, "G", { "is_drop" => false, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != %w[G P]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != []
raise if actual.opponent_captures != %w[G P]
raise if actual.current_turn != "North"
raise if actual.next_turn != "South"
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [true, [], %w[G P], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: %w[G P], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }, is_in_check: false }
  raise
end
raise if actual.hash != "f6c15ff6267cdc5c63fc4a73f4975910c1567a2d5024c81f50e0e015961921fc"
if actual.board_pieces != [0, 1, 2, 4, 6, 7, 8, 10, 11, 14, 16, 18, 19, 20, 21, 22, 23, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "North-turn===G,P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,11:g,14:+B,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi North-turn===G,P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,11:g,14:+B,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 3 => nil, 11 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 64 => nil, 24 => "+B" }, "P", { "is_drop" => false, "is_in_check" => false }], [{ 5 => nil, 14 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 24 => nil, 14 => "+B" }, "G", { "is_drop" => false, "is_in_check" => false }], [{ 4 => nil, 3 => "k" }, nil, { "is_drop" => nil, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != %w[G P]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != %w[G P]
raise if actual.opponent_captures != []
raise if actual.current_turn != "South"
raise if actual.next_turn != "North"
raise if actual.north_turn? != false
raise if actual.south_turn? != true
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [false, [], %w[G P], { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k" }, false]
  raise
end
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: %w[G P], squares: { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k" }, is_in_check: false }
  raise
end
raise if actual.hash != "64d39228bb327e65d3b81eb65d5cfb1453c7732c70f68dde7f277a26f7f79fbe"
if actual.board_pieces != [0, 1, 2, 3, 6, 7, 8, 10, 11, 14, 16, 18, 19, 20, 21, 22, 23, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "South-turn===G,P===0:l,1:n,2:s,3:k,6:s,7:n,8:l,10:r,11:g,14:+B,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi South-turn===G,P===0:l,1:n,2:s,3:k,6:s,7:n,8:l,10:r,11:g,14:+B,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 3 => nil, 11 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 64 => nil, 24 => "+B" }, "P", { "is_drop" => false, "is_in_check" => false }], [{ 5 => nil, 14 => "g" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 24 => nil, 14 => "+B" }, "G", { "is_drop" => false, "is_in_check" => false }], [{ 4 => nil, 3 => "k" }, nil, { "is_drop" => nil, "is_in_check" => false }], [{ 13=>"G" }, "G", { "is_drop" => true, "is_in_check" => false }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G" }
  raise
end
raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.current_captures != []
raise if actual.opponent_captures != ["P"]
raise if actual.current_turn != "North"
raise if actual.next_turn != "South"
raise if actual.north_turn? != true
raise if actual.south_turn? != false
raise if actual.in_check? != false
raise if actual.not_in_check? != true
if actual.to_a != [true, [], ["P"], { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G" }, false]
  raise
end
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G" }, is_in_check: false }
  raise
end
raise if actual.hash != "6331d04cdb1b5e4002b00ef6269e927edf926444783d743807d57c837ed44c21"
if actual.board_pieces != [0, 1, 2, 3, 6, 7, 8, 10, 11, 13, 14, 16, 18, 19, 20, 21, 22, 23, 25, 26, 47, 54, 55, 57, 58, 59, 60, 61, 62, 70, 72, 73, 74, 75, 76, 77, 78, 79, 80]
  raise
end
if actual.serialize != "North-turn===P===0:l,1:n,2:s,3:k,6:s,7:n,8:l,10:r,11:g,13:G,14:+B,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check"
  raise
end
if actual.inspect != "<Qi North-turn===P===0:l,1:n,2:s,3:k,6:s,7:n,8:l,10:r,11:g,13:G,14:+B,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,47:P,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L===not-in-check>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# End of the brutal test
