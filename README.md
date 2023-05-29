# Qi.rb

[![Version](https://img.shields.io/github/v/tag/sashite/qi.rb?label=Version&logo=github)](https://github.com/sashite/qi.rb/releases)
[![Yard documentation](https://img.shields.io/badge/Yard-documentation-blue.svg?logo=github)](https://rubydoc.info/github/sashite/qi.rb/main)
[![CI](https://github.com/sashite/qi.rb/workflows/CI/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Aci+branch%3Amain)
[![RuboCop](https://github.com/sashite/qi.rb/workflows/RuboCop/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions?query=workflow%3Arubocop+branch%3Amain)
[![License](https://img.shields.io/github/license/sashite/qi.rb?label=License&logo=github)](https://github.com/sashite/qi.rb/raw/main/LICENSE.md)

**Qi** (Chinese: 棋; pinyin: _qí_) is a lightweight, flexible, and adaptable tool for representing board game positions, built in Ruby. It is designed to be game-agnostic and can be used with a variety of board games such as Chess, Four-Player Chess, Go, Makruk, Shogi, and Xiangqi.

Qi uses a unique approach where the state of a game is represented through capturing the pieces in play, the arrangement of pieces on the board, the sequence of turns, and other possible states that a game can have.

## Features

1. **Game Agnostic:** Qi can be used to represent board game positions for a wide variety of games. Whether you are playing Chess, Makruk, Shogi, or Xiangqi, Qi's flexible structure allows you to accurately capture the state of your game.
2. **Flexible Position Representation:** Qi captures the state of the game by recording the pieces in play, their arrangement on the board, the sequence of turns, and other additional states of the game. This enables a comprehensive view of the game at any given point.
3. **State Manipulation:** Qi allows for manipulation and update of game states through the `commit` method, allowing transitions between game states.
4. **Equality Checks:** With the `eql?` method, Qi allows for comparisons between different game states, which can be useful for tracking game progress, detecting repeats, or even in creating AI for your games.
5. **Turn Management:** Qi keeps track of the sequence of turns allowing users to identify whose turn it is currently.
6. **Access to Game Data:** Qi provides methods to access the current arrangement of pieces on the board (`squares_hash`) and the pieces captured by each player (`captures_hash`), helping users understand the current status of the game. It also allows access to a list of captured pieces (`captures_array`).
7. **Customizability:** Qi is flexible and allows for customization as per your needs. The keys and values of the `captures_hash` and `squares_hash` can be any kind of object, as well as the items from `turns` and values from `state`.

While `Qi` does not generate game moves itself, it serves as a solid foundation upon which game engines can be built. Its design is focused on providing a robust and adaptable representation of game states, paving the way for the development of diverse board game applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "qi"
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install qi
```

## Usage

The following usage example is derived from a classic _tsume shogi_ (詰将棋) problem, which translates to _mate shogi_ - a popular genre of shogi problems where the goal is to checkmate the opponent's king.
In the provided setup, the attacking side is in possession of a silver general (S), a promoted bishop (+B) positioned on square 43, and a promoted pawn (+P) on square 22.

On the defending side, there is a king (k) situated on square 4, surrounded by two silver generals (s) on squares 3 and 5 respectively.

In this scenario, `Qi` allows us to represent the state of the game and apply changes as moves are made. Please follow the given example to understand how to create such a representation and how to update it:

```ruby
require "qi"

# Initialize an array for each player's captured pieces
north_captures = %w[r r b g g g g s n n n n p p p p p p p p p p p p p p p p p]
south_captures = %w[S]

# Combine and count each player's captured pieces
captures = Hash.new(0)
(north_captures + south_captures).each { |piece| captures[piece] += 1 }

# Define the squares occupied by each piece on the board
squares = { 3 => "s", 4 => "k", 5 => "s", 22 => "+P", 43 => "+B" }

# Create a new game position
qi0 = Qi.new(captures, squares, [0, 1])

# Verify the properties of the game position
qi0.captures_array                          # => ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
qi0.captures_hash                           # => {"r"=>2, "b"=>1, "g"=>4, "s"=>1, "n"=>4, "p"=>17, "S"=>1}
qi0.squares_hash                            # => {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 43=>"+B"}
qi0.state                                   # => {}
qi0.turn                                    # => 0
qi0.turns                                   # => [0, 1]
qi0.eql?(Qi.new(captures, squares, [0, 1])) # => true
qi0.eql?(Qi.new(captures, squares, [1, 0])) # => false

# Move a piece on the board and check the game state
qi1 = qi0.commit([], [], { 43 => nil, 13 => "+B" }, in_check: true)

qi1.captures_array                          # => ["S", "b", "g", "g", "g", "g", "n", "n", "n", "n", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "r", "r", "s"]
qi1.captures_hash                           # => {"r"=>2, "b"=>1, "g"=>4, "s"=>1, "n"=>4, "p"=>17, "S"=>1}
qi1.squares_hash                            # => {3=>"s", 4=>"k", 5=>"s", 22=>"+P", 13=>"+B"}
qi1.state                                   # => {:in_check=>true}
qi1.turn                                    # => 1
qi1.turns                                   # => [1, 0]
qi1.eql?(Qi.new(captures, squares, [0, 1])) # => false
qi1.eql?(Qi.new(captures, squares, [1, 0])) # => false
```

In this example, we first create a `Qi` object to represent a game position with `Qi.new`. Then, we check various aspects of the game state using the methods provided by `Qi`. After that, we create a new game state `qi1` by committing changes to the existing state `qi0`. Finally, we again check various aspects of the new game state.

## License

The code is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## About Sashité

This [gem](https://rubygems.org/gems/qi) is proudly maintained and developed by [Sashité](https://sashite.com/). Our mission is to promote intercultural understanding and appreciation through the universal language of board games.

At Sashité, we believe in the power of games as a medium for sharing and appreciating the richness of different cultures. From Chinese to Japanese, and Western traditions, every culture has its unique representation in the world of board games, particularly in chess.

Our `Qi` gem is a testament to this belief - a flexible, efficient, and inclusive software that allows for the representation and interaction of diverse chess systems. This piece of software is not just a tool; it is a bridge connecting different cultures under the love of strategic play.

Join us in our journey as we continue to write [code](https://github.com/sashite/) to share the beauty of these cultures, one game at a time.
