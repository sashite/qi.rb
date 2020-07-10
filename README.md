# Qi.rb

[![Build Status](https://travis-ci.org/sashite/qi.rb.svg?branch=master)](https://travis-ci.org/sashite/qi.rb)
[![Gem Version](https://badge.fury.io/rb/qi.svg)][gem]
[![Inline docs](https://inch-ci.org/github/sashite/qi.rb.svg?branch=master)][inchpages]
[![Documentation](https://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

> Instantiate [Portable Chess Notation](https://developer.sashite.com/specs/portable-chess-notation)'s positions and apply [Portable Move Notation](https://developer.sashite.com/specs/portable-move-notation)'s moves.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qi

## Example

Let's replay [The Shortest Possible Game of Shogi](https://userpages.monmouth.com/~colonel/shortshogi.html):

```ruby
require 'qi'

shogi_starting_position = Qi::Position.new(
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

moves = [
  [ 56, 47, 'P' ],
  [ 3, 11, 'g' ],
  [ 64, 24, '+B', 'P' ],
  [ 5, 14, 'g' ],
  [ 24, 14, '+B', 'G' ],
  [ 4, 3, 'k' ],
  [ nil, 13, 'G' ]
]

last_position = moves.reduce(shogi_starting_position) do |position, move|
  position.call(move)
end

last_position.topside_in_hand_pieces # => []

last_position.squares # => ["l", "n", "s", "k", nil, nil, "s", "n", "l",
                      #     nil, "r", "g", nil, "G", "+B", nil, "b", nil,
                      #     "p", "p", "p", "p", "p", "p", nil, "p", "p",
                      #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
                      #     nil, nil, nil, nil, nil, nil, nil, nil, nil,
                      #     nil, nil, "P", nil, nil, nil, nil, nil, nil,
                      #     "P", "P", nil, "P", "P", "P", "P", "P", "P",
                      #     nil, nil, nil, nil, nil, nil, nil, "R", nil,
                      #     "L", "N", "S", "G", "K", "G", "S", "N", "L"]

last_position.bottomside_in_hand_pieces # => ["P"]
last_position.turn_to_topside? # => true
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashite

The `qi` gem is maintained by [Sashite](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!

[gem]: https://rubygems.org/gems/qi
[inchpages]: https://inch-ci.org/github/sashite/qi.rb
[rubydoc]: https://rubydoc.info/gems/qi/frames
