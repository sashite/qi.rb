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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != true
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != true
raise if actual.side_name != "south"
raise if actual.other_captures != []
raise if actual.owned_captures != []
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
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 56 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L" } }
  raise
end
raise if actual.hash != "c74651af75c7f434fe881971e5c5d4577075a8ebab4b62fcb51b78041796f577"
if actual.serialize != "south-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,56:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L"
  raise
end
if actual.inspect != "<Qi south-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,56:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "north"
raise if actual.other_captures != []
raise if actual.owned_captures != []
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
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 3 => "g", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P" } }
  raise
end
raise if actual.hash != "065b59a64d180f495aca30a73b0a6ee5fe6073a9e50a262ef27a9ae3c056c8a2"
if actual.serialize != "north-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P"
  raise
end
if actual.inspect != "<Qi north-turn======0:l,1:n,2:s,3:g,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "south"
raise if actual.other_captures != []
raise if actual.owned_captures != []
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
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: [], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 64 => "B", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" } }
  raise
end
raise if actual.hash != "7c018d30a6a26bf190fc39a1a1554664c35e40ed28ac729788a8a26996cbc84e"
if actual.serialize != "south-turn======0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g"
  raise
end
if actual.inspect != "<Qi south-turn======0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,64:B,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "north"
raise if actual.other_captures != ["P"]
raise if actual.owned_captures != []
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
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 5 => "g", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g" } }
  raise
end
raise if actual.hash != "c7d21538ffdbfad1e5cd933c0817330f5933dff6a772876c716ce7cd068e13f3"
if actual.serialize != "north-turn===P===0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g"
  raise
end
if actual.inspect != "<Qi north-turn===P===0:l,1:n,2:s,4:k,5:g,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "south"
raise if actual.other_captures != []
raise if actual.owned_captures != ["P"]
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
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 24 => "+B", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "g" } }
  raise
end
raise if actual.hash != "2cb381d450238f11947892bf47a60092ce9c866531da1afdbda0ae2a91911e27"
if actual.serialize != "south-turn===P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:g"
  raise
end
if actual.inspect != "<Qi south-turn===P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,24:+B,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:g>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "north"
raise if actual.other_captures != %w[G P]
raise if actual.owned_captures != []
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
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: %w[G P], squares: { 0 => "l", 1 => "n", 2 => "s", 4 => "k", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B" } }
  raise
end
raise if actual.hash != "a516c209e5e01f5200ee467653b6ea7425e77160e2db51cb1b407b59719b844f"
if actual.serialize != "north-turn===G,P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B"
  raise
end
if actual.inspect != "<Qi north-turn===G,P===0:l,1:n,2:s,4:k,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "south"
raise if actual.other_captures != []
raise if actual.owned_captures != %w[G P]
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
if actual.to_h != { is_north_turn: false, north_captures: [], south_captures: %w[G P], squares: { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k" } }
  raise
end
raise if actual.hash != "1f52ebafbcc19646da6e35944e321617d62d048735dde81e78ca6894cd63befc"
if actual.serialize != "south-turn===G,P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k"
  raise
end
if actual.inspect != "<Qi south-turn===G,P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k>"
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

raise if (actual == Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.eql?(Qi.new(*STARTING_POSITION_CONTEXT)) != false
raise if actual.side_name != "north"
raise if actual.other_captures != ["P"]
raise if actual.owned_captures != []
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
if actual.to_h != { is_north_turn: true, north_captures: [], south_captures: ["P"], squares: { 0 => "l", 1 => "n", 2 => "s", 6 => "s", 7 => "n", 8 => "l", 10 => "r", 16 => "b", 18 => "p", 19 => "p", 20 => "p", 21 => "p", 22 => "p", 23 => "p", 25 => "p", 26 => "p", 54 => "P", 55 => "P", 57 => "P", 58 => "P", 59 => "P", 60 => "P", 61 => "P", 62 => "P", 70 => "R", 72 => "L", 73 => "N", 74 => "S", 75 => "G", 76 => "K", 77 => "G", 78 => "S", 79 => "N", 80 => "L", 47 => "P", 11 => "g", 14 => "+B", 3 => "k", 13 => "G" } }
  raise
end
raise if actual.hash != "bfc68968d6d0e8f47a29031df29cc70e5e50be0c7a2fbc9dae6a136525522c18"
if actual.serialize != "north-turn===P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k,13:G"
  raise
end
if actual.inspect != "<Qi north-turn===P===0:l,1:n,2:s,6:s,7:n,8:l,10:r,16:b,18:p,19:p,20:p,21:p,22:p,23:p,25:p,26:p,54:P,55:P,57:P,58:P,59:P,60:P,61:P,62:P,70:R,72:L,73:N,74:S,75:G,76:K,77:G,78:S,79:N,80:L,47:P,11:g,14:+B,3:k,13:G>"
  raise
end

# Finishing a test

# ------------------------------------------------------------------------------

# End of the brutal test
