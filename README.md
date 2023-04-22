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
gem "qi", ">= 10.0.0.beta2"
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

captures  = %w[S r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
squares   = { "3": "s", "4": "k", "5": "s", "22": "+P", "43": "+B" }

captures, squares = Qi(*captures, **squares).call("43": nil, "13": "+B")

captures  # => ["S", "r", "r", "b", "g", "g", "g", "g", "s", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"]
squares   # => {:"3"=>"s", :"4"=>"k", :"5"=>"s", :"22"=>"+P", :"13"=>"+B"}
```

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashité

This [gem](https://rubygems.org/gems/qi) is maintained by [Sashité](https://sashite.com/).

With some [lines of code](https://github.com/sashite/), let's share the beauty of Chinese, Japanese and Western cultures through the game of chess!
