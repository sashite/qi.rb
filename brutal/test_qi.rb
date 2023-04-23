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
  }
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
raise if actual.north_turn? != false
raise if actual.south_turn? != true
if actual.to_a != [false, [], [], { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L" }]
  raise
end
if actual.serialize != "SouthTurn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,56:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L"
  raise
end
if actual.inspect != "<Qi SouthTurn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,56:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }
  raise
end
raise if actual.north_turn? != true
raise if actual.south_turn? != false
if actual.to_a != [true, [], [], { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" }]
  raise
end
if actual.serialize != "NorthTurn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P"
  raise
end
if actual.inspect != "<Qi NorthTurn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }], [{ 3 => nil, 11 => "g" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != []
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if actual.north_turn? != false
raise if actual.south_turn? != true
if actual.to_a != [false, [], [], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }]
  raise
end
if actual.serialize != "SouthTurn======0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g"
  raise
end
if actual.inspect != "<Qi SouthTurn======0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }], [{ 3 => nil, 11 => "g" }], [{ 64 => nil, 24 => "+B" }, "P"]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }
  raise
end
raise if actual.north_turn? != true
raise if actual.south_turn? != false
if actual.to_a != [true, [], ["P"], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" }]
  raise
end
if actual.serialize != "NorthTurn===P===0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g"
  raise
end
if actual.inspect != "<Qi NorthTurn===P===0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }], [{ 3 => nil, 11 => "g" }], [{ 64 => nil, 24 => "+B" }, "P"], [{ 5 => nil, 14 => "g" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }
  raise
end
raise if actual.north_turn? != false
raise if actual.south_turn? != true
if actual.to_a != [false, [], ["P"], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" }]
  raise
end
if actual.serialize != "SouthTurn===P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:g"
  raise
end
if actual.inspect != "<Qi SouthTurn===P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:g>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }], [{ 3 => nil, 11 => "g" }], [{ 64 => nil, 24 => "+B" }, "P"], [{ 5 => nil, 14 => "g" }], [{ 24 => nil, 14 => "+B" }, "G"]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != %w[G P]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }
  raise
end
raise if actual.north_turn? != true
raise if actual.south_turn? != false
if actual.to_a != [true, [], %w[G P], { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" }]
  raise
end
if actual.serialize != "NorthTurn===G,P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B"
  raise
end
if actual.inspect != "<Qi NorthTurn===G,P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }], [{ 3 => nil, 11 => "g" }], [{ 64 => nil, 24 => "+B" }, "P"], [{ 5 => nil, 14 => "g" }], [{ 24 => nil, 14 => "+B" }, "G"], [{ 4 => nil, 3 => "k" }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != %w[G P]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k" }
  raise
end
raise if actual.north_turn? != false
raise if actual.south_turn? != true
if actual.to_a != [false, [], %w[G P], { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k" }]
  raise
end
if actual.serialize != "SouthTurn===G,P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k"
  raise
end
if actual.inspect != "<Qi SouthTurn===G,P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# Starting a test

actual = begin
  starting_position = Qi.new(*STARTING_POSITION_CONTEXT)

  [[{ 56 => nil, 47 => "P" }], [{ 3 => nil, 11 => "g" }], [{ 64 => nil, 24 => "+B" }, "P"], [{ 5 => nil, 14 => "g" }], [{ 24 => nil, 14 => "+B" }, "G"], [{ 4 => nil, 3 => "k" }], [{ 13=>"G" }, "G", { "is_drop"=>true }]].reduce(starting_position) do |position, args|
    position.commit(*args.first(2), **Hash(args[2]).transform_keys(&:to_sym))
  end
end

raise if actual.north_captures != []
raise if actual.south_captures != ["P"]
if actual.squares != { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G" }
  raise
end
raise if actual.north_turn? != true
raise if actual.south_turn? != false
if actual.to_a != [true, [], ["P"], { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G" }]
  raise
end
if actual.serialize != "NorthTurn===P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k,13:G"
  raise
end
if actual.inspect != "<Qi NorthTurn===P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k,13:G>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# End of the brutal test
