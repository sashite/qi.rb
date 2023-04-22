# Qi.rb

[![Version](https://img.shields.io/github/v/tag/sashite/qi.rb?label=Version&logo=github)](https://github.com/sashite/qi.rb/releases)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/qi.rb/main)
[![CI](https://github.com/sashite/qi.rb/workflows/CI/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Aci+branch%3Amain)
[![RuboCop](https://github.com/sashite/qi.rb/workflows/RuboCop/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/sashite/qi.rb?label=License&logo=github)](https://github.com/sashite/qi.rb/raw/main/LICENSE.md)

> `Qi` (棋) is an abstraction for updating positions of chess variants (including Chess, Janggi, Markruk, Shogi, Xiangqi), with a move.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "qi"
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install qi
```

## Example

```ruby
require "qi"

Qi.call(
  43, 13, "+B",
  in_hand: %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
  square: {
    3 => "s",
    4 => "k",
    5 => "s",
    22 => "+P",
    43 => "+B"
  }
)
# => {:in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"], :square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}}
```

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashite

This [gem](https://rubygems.org/gems/qi) is maintained by [Sashite](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!
