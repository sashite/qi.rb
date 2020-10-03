# Qi.rb

[![Build Status](https://travis-ci.org/sashite/qi.rb.svg?branch=master)](https://travis-ci.org/sashite/qi.rb)
[![Gem Version](https://badge.fury.io/rb/qi.svg)][gem]
[![Inline docs](https://inch-ci.org/github/sashite/qi.rb.svg?branch=master)][inchpages]
[![Documentation](https://img.shields.io/:yard-docs-38c800.svg)][rubydoc]

> `Qi` (棋) is an abstraction for updating positions of chess variants (including Chess, Janggi, Markruk, Shogi, Xiangqi), with a move.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "qi", ">= 9.0.0.beta1"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qi --pre

## Examples

```ruby
require "qi"

Qi.call(
  [43, 13, "+B"],
  in_hand: %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p],
  square: {
     3 => "s",
     4 => "k",
     5 => "s",
    22 => "+P",
    43 => "+B"
  }
)
# => {:square=>{3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}, :in_hand=>["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"]}
```

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashite

This [gem](https://rubygems.org/gems/qi) is maintained by [Sashite](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!

[gem]: https://rubygems.org/gems/qi
[inchpages]: https://inch-ci.org/github/sashite/qi.rb
[rubydoc]: https://rubydoc.info/gems/qi/frames
