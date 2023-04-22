# Qi.rb

[![Build Status](https://travis-ci.org/sashite/qi.rb.svg?branch=master)](https://travis-ci.org/sashite/qi.rb)
[![Gem Version](https://badge.fury.io/rb/qi.svg)][gem]
[![Inline docs](https://inch-ci.org/github/sashite/qi.rb.svg?branch=master)][inchpages]
[![Documentation](https://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

> `Qi` (棋) is an abstraction for initializing and updating positions of chess variants (including Chess, Janggi, Markruk, Shogi, Xiangqi).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "qi"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qi

## Examples

Let's replay [The Shortest Possible Game](https://userpages.monmouth.com/~colonel/shortshogi.html) of [Shogi](https://en.wikipedia.org/wiki/Shogi):

```ruby
require "qi"

starting_position = Qi::Position.new(
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

starting_position.in_hand_pieces
# => []

starting_position.squares
# => ["l", "n", "s", "g", "k", "g", "s", "n", "l",
#     nil, "r", nil, nil, nil, nil, nil, "b", nil,
#     "p", "p", "p", "p", "p", "p", "p", "p", "p",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     "P", "P", "P", "P", "P", "P", "P", "P", "P",
#     nil, "B", nil, nil, nil, nil, nil, "R", nil,
#     "L", "N", "S", "G", "K", "G", "S", "N", "L"]

starting_position.pieces_in_hand_grouped_by_sides
# => [[], []]

starting_position.active_side_id
# => 0

# List of moves (see https://github.com/sashite/pmn.rb)
moves = [
  [ 56, 47, "P" ],
  [ 3, 11, "g" ],
  [ 64, 24, "+B", "P" ],
  [ 5, 14, "g" ],
  [ 24, 14, "+B", "G" ],
  [ 4, 3, "k" ],
  [ nil, 13, "G" ]
]

last_position = moves.reduce(starting_position) do |position, move|
  position.call(move)
end

last_position.in_hand_pieces
# => []

last_position.squares
# => ["l", "n", "s", "k", nil, nil, "s", "n", "l",
#     nil, "r", "g", nil, "G", "+B", nil, "b", nil,
#     "p", "p", "p", "p", "p", "p", nil, "p", "p",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, "P", nil, nil, nil, nil, nil, nil,
#     "P", "P", nil, "P", "P", "P", "P", "P", "P",
#     nil, nil, nil, nil, nil, nil, nil, "R", nil,
#     "L", "N", "S", "G", "K", "G", "S", "N", "L"]

last_position.pieces_in_hand_grouped_by_sides
# => [["P"], []]

last_position.active_side_id
# => 1
```

A classic [Tsume Shogi](https://en.wikipedia.org/wiki/Tsume_shogi) problem:

```ruby
require "qi"

starting_position = Qi::Position.new(
  nil, nil, nil, "s", "k", "s", nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, "+P", nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, "+B", nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  pieces_in_hand_grouped_by_sides: [
    ["S"],
    ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
  ]
)

starting_position.in_hand_pieces
# => ["S"]

starting_position.squares
# => [nil, nil, nil, "s", "k", "s", nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, "+P", nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, "+B", nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil]

starting_position.pieces_in_hand_grouped_by_sides
# => [["S"], ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]]

starting_position.active_side_id
# => 0

# List of moves (see https://github.com/sashite/pmn.rb)
moves = [
  [  43, 13, "+B" ],  [ 5, 13, "s", "b" ],
  [ nil, 14,  "S" ]
]

last_position = moves.reduce(starting_position) do |position, move|
  position.call(move)
end

last_position.in_hand_pieces
# => ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s", "b"]

last_position.squares
# => [nil, nil, nil, "s", "k", nil, nil, nil, nil,
#     nil, nil, nil, nil, "s", "S", nil, nil, nil,
#     nil, nil, nil, nil, "+P", nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil]

last_position.pieces_in_hand_grouped_by_sides
# => [[], ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s", "b"]]

last_position.active_side_id
# => 1
```

Another example with [Xiangqi](https://en.wikipedia.org/wiki/Xiangqi)'s Short Double Cannons Checkmate:

```ruby
require "qi"

starting_position = Qi::Position.new(
  "車", "馬", "象", "士", "將", "士", "象", "馬", "車",
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, "砲", nil, nil, nil, nil, nil, "砲", nil,
  "卒", nil, "卒", nil, "卒", nil, "卒", nil, "卒",
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  "兵", nil, "兵", nil, "兵", nil, "兵", nil, "兵",
  nil, "炮", nil, nil, nil, nil, nil, "炮", nil,
  nil, nil, nil, nil, nil, nil, nil, nil, nil,
  "俥", "傌", "相", "仕", "帥", "仕", "相", "傌", "俥"
)

starting_position.in_hand_pieces
# => []

starting_position.squares
# => ["車", "馬", "象", "士", "將", "士", "象", "馬", "車",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, "砲", nil, nil, nil, nil, nil, "砲", nil,
#     "卒", nil, "卒", nil, "卒", nil, "卒", nil, "卒",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     "兵", nil, "兵", nil, "兵", nil, "兵", nil, "兵",
#     nil, "炮", nil, nil, nil, nil, nil, "炮", nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     "俥", "傌", "相", "仕", "帥", "仕", "相", "傌", "俥"]

starting_position.pieces_in_hand_grouped_by_sides
# => [[], []]

starting_position.active_side_id
# => 0

# List of moves (see https://github.com/sashite/pmn.rb)
moves = [
  [ 64, 67, "炮" ],
  [ 25, 22, "砲" ],
  [ 70, 52, "炮" ],
  [ 19, 55, "砲" ],
  [ 67, 31, "炮" ],
  [ 22, 58, "砲" ],
  [ 52, 49, "炮" ]
]

last_position = moves.reduce(starting_position) do |position, move|
  position.call(move)
end

last_position.in_hand_pieces
# => []

last_position.squares
# => ["車", "馬", "象", "士", "將", "士", "象", "馬", "車",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     "卒", nil, "卒", nil, "炮", nil, "卒", nil, "卒",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, "炮", nil, nil, nil, nil,
#     "兵", "砲", "兵", nil, "砲", nil, "兵", nil, "兵",
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     nil, nil, nil, nil, nil, nil, nil, nil, nil,
#     "俥", "傌", "相", "仕", "帥", "仕", "相", "傌", "俥"]

last_position.pieces_in_hand_grouped_by_sides
# => [[], []]

last_position.active_side_id
# => 1
```

Let's do some moves on a [Four-player chess](https://en.wikipedia.org/wiki/Four-player_chess) board:

```ruby
require "qi"

starting_position = Qi::Position.new(
  nil , nil , nil , "yR", "yN", "yB", "yK", "yQ", "yB", "yN", "yR", nil , nil , nil ,
  nil , nil , nil , "yP", "yP", "yP", "yP", "yP", "yP", "yP", "yP", nil , nil , nil ,
  nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil ,
  "bR", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gR",
  "bN", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gN",
  "bB", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gB",
  "bK", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gQ",
  "bQ", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gK",
  "bB", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gB",
  "bN", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gN",
  "bR", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gR",
  nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil ,
  nil , nil , nil , "rP", "rP", "rP", "rP", "rP", "rP", "rP", "rP", nil , nil , nil ,
  nil , nil , nil , "rR", "rN", "rB", "rQ", "rK", "rB", "rN", "rR", nil , nil , nil ,
  pieces_in_hand_grouped_by_sides: [
    [],
    [],
    [],
    []
  ]
)

starting_position.in_hand_pieces
# => []

starting_position.squares
# => [nil , nil , nil , "yR", "yN", "yB", "yK", "yQ", "yB", "yN", "yR", nil , nil , nil ,
#     nil , nil , nil , "yP", "yP", "yP", "yP", "yP", "yP", "yP", "yP", nil , nil , nil ,
#     nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil ,
#     "bR", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gR",
#     "bN", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gN",
#     "bB", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gB",
#     "bK", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gQ",
#     "bQ", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gK",
#     "bB", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gB",
#     "bN", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gN",
#     "bR", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gR",
#     nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil ,
#     nil , nil , nil , "rP", "rP", "rP", "rP", "rP", "rP", "rP", "rP", nil , nil , nil ,
#     nil , nil , nil , "rR", "rN", "rB", "rQ", "rK", "rB", "rN", "rR", nil , nil , nil]

starting_position.pieces_in_hand_grouped_by_sides
# => [[], [], [], []]

starting_position.active_side_id
# => 0

# List of moves (see https://github.com/sashite/pmn.rb)
moves = [
  [ 175, 147, "rP" ],
  [ 85, 87, "bP" ],
  [ 20, 48, "yP" ],
  [ 110, 108, "gP" ],
  [ 191, 162, "rN" ]
]

last_position = moves.reduce(starting_position) do |position, move|
  position.call(move)
end

last_position.in_hand_pieces
# => []

last_position.squares
# => [nil , nil , nil , "yR", "yN", "yB", "yK", "yQ", "yB", "yN", "yR", nil , nil , nil ,
#     nil , nil , nil , "yP", "yP", "yP", nil , "yP", "yP", "yP", "yP", nil , nil , nil ,
#     nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , nil ,
#     "bR", "bP", nil , nil , nil , nil , "yP", nil , nil , nil , nil , nil , "gP", "gR",
#     "bN", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gN",
#     "bB", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gB",
#     "bK", nil , nil , "bP", nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gQ",
#     "bQ", "bP", nil , nil , nil , nil , nil , nil , nil , nil , "gP", nil , nil , "gK",
#     "bB", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gB",
#     "bN", "bP", nil , nil , nil , nil , nil , nil , nil , nil , nil , nil , "gP", "gN",
#     "bR", "bP", nil , nil , nil , nil , nil , "rP", nil , nil , nil , nil , "gP", "gR",
#     nil , nil , nil , nil , nil , nil , nil , nil , "rN", nil , nil , nil , nil , nil ,
#     nil , nil , nil , "rP", "rP", "rP", "rP", nil , "rP", "rP", "rP", nil , nil , nil ,
#     nil , nil , nil , "rR", "rN", "rB", "rQ", "rK", "rB", nil , "rR", nil , nil , nil]

last_position.pieces_in_hand_grouped_by_sides
# => [[], [], [], []]

last_position.active_side_id
# => 1
```

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashite

This [gem](https://rubygems.org/gems/qi) is maintained by [Sashite](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!

[gem]: https://rubygems.org/gems/qi
[inchpages]: https://inch-ci.org/github/sashite/qi.rb
[rubydoc]: https://rubydoc.info/gems/qi/frames
