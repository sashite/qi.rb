# Qi.rb

[![Version](https://img.shields.io/github/v/tag/sashite/qi.rb?label=Version&logo=github)](https://github.com/sashite/qi.rb/releases)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/qi.rb/main)
[![CI](https://github.com/sashite/qi.rb/workflows/CI/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Aci+branch%3Amain)
[![RuboCop](https://github.com/sashite/qi.rb/workflows/RuboCop/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/sashite/qi.rb?label=License&logo=github)](https://github.com/sashite/qi.rb/raw/main/LICENSE.md)

> `Qi` (Chinese: 棋; pinyin: _qí_) is an abstraction that could help to update positions for games like Shogi.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "qi", ">= 10.0.0.beta11"
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

is_north_turn   = false
north_captures  = %w[r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
south_captures  = %w[S]
squares         = { 3 => "s", 4 => "k", 5 => "s", 22 => "+P", 43 => "+B" }

qi0 = Qi.new(is_north_turn, north_captures, south_captures, squares)

qi0.north_captures  # => ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
qi0.south_captures  # => ["S"]
qi0.squares         # => {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 43=>"+B"}
qi0.north_turn?     # => false
qi0.south_turn?     # => true
qi0.serialize       # => "South-turn===b,g,g,g,g,n,n,n,n,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,r,r,s,S===3:s,4:k,5:s,22:+P,43:+B"
qi0.inspect         # => "<Qi South-turn===b,g,g,g,g,n,n,n,n,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,r,r,s,S===3:s,4:k,5:s,22:+P,43:+B>"
qi0.to_a
# [false,
#  ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"],
#  ["S"],
#  {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 43=>"+B"},
#  {}]

qi1 = qi0.commit(43, 13, "+B", nil)

qi1.north_captures  # => ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
qi1.south_captures  # => ["S"]
qi1.squares         # => {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}
qi1.north_turn?     # => true
qi1.south_turn?     # => false
qi1.serialize       # => "North-turn===b,g,g,g,g,n,n,n,n,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,r,r,s,S===3:s,4:k,5:s,13:+B,22:+P"
qi1.inspect         # => "<Qi North-turn===b,g,g,g,g,n,n,n,n,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,r,r,s,S===3:s,4:k,5:s,13:+B,22:+P>"
qi1.to_a
# [true,
#  ["b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"],
#  ["S"],
#  {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"},
#  {}]
```

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashité

This [gem](https://rubygems.org/gems/qi) is maintained by [Sashité](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!
