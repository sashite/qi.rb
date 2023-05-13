# Qi.rb

[![Version](https://img.shields.io/github/v/tag/sashite/qi.rb?label=Version&logo=github)](https://github.com/sashite/qi.rb/releases)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/qi.rb/main)
[![CI](https://github.com/sashite/qi.rb/workflows/CI/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Aci+branch%3Amain)
[![RuboCop](https://github.com/sashite/qi.rb/workflows/RuboCop/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/sashite/qi.rb?label=License&logo=github)](https://github.com/sashite/qi.rb/raw/main/LICENSE.md)

Welcome to `Qi` (Chinese: 棋; pinyin: _qí_), a flexible and customizable library designed to represent and manipulate board game positions. `Qi` is ideal for a variety of board games, including chess, shogi, xiangqi, makruk, and more.

With `Qi`, you can easily track the game state, including which pieces are on the board and where, as well as any captured pieces. The library allows for the application of game moves, updating the state of the game and generating a new position, all while preserving the original state.

## Features:

- **Flexible representation of game states:** `Qi`'s design allows it to adapt to different games with varying rules and pieces.
- **Immutable positions:** Every move generates a new position, preserving the original one. This is particularly useful for scenarios like undoing moves or exploring potential future states in the game.
- **Compact serialization:** `Qi` provides a compact string serialization method for game states, which is useful for saving game progress or transmitting game states over the network.
- **Check state tracking:** In addition to the positions and captured pieces, `Qi` also allows tracking of specific game states such as check in chess.

While `Qi` does not generate game moves itself, it serves as a solid foundation upon which game engines can be built. Its design is focused on providing a robust and adaptable representation of game states, paving the way for the development of diverse board game applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "qi", ">= 10.0.0.beta12"
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install qi --pre
```

## Example

```ruby
require "qi"

north_captures  = %w[r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
south_captures  = %w[S]
captures        = north_captures + south_captures
squares         = { 3 => "s", 4 => "k", 5 => "s", 22 => "+P", 43 => "+B" }

qi0 = Qi.new(*captures, **squares)

qi0.captures      # => ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
qi0.squares       # => {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 43=>"+B"}
qi0.in_check?     # => false
qi0.not_in_check? # => true
qi0.north_turn?   # => false
qi0.south_turn?   # => true
qi0.serialize     # => "{ S;b;g;g;g;g;n;n;n;n;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;r;r;s s@3;k@4;s@5;+P@22;+B@43 ."
qi0.inspect       # => "<Qi { S;b;g;g;g;g;n;n;n;n;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;r;r;s s@3;k@4;s@5;+P@22;+B@43 .>"
qi0.to_a
# [false,
#  ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"],
#  {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 43=>"+B"},
#  false]

qi1 = qi0.commit(is_in_check: true, 43 => nil, 13 => "+B")

qi1.captures      # => ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
qi1.squares       # => {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}
qi1.in_check?     # => true
qi1.not_in_check? # => false
qi1.north_turn?   # => true
qi1.south_turn?   # => false
qi1.serialize     # => "} S;b;g;g;g;g;n;n;n;n;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;r;r;s s@3;k@4;s@5;+B@13;+P@22 +"
qi1.inspect       # => "<Qi } S;b;g;g;g;g;n;n;n;n;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;p;r;r;s s@3;k@4;s@5;+B@13;+P@22 +>"
qi1.to_a
# [true,
#  ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"],
#  {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"},
#  true]
```

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashité

This [gem](https://rubygems.org/gems/qi) is maintained by [Sashité](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!
