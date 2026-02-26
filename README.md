# Qi

[![Version](https://img.shields.io/gem/v/qi.svg)](https://rubygems.org/gems/qi)
[![Documentation](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/gems/qi)
[![CI](https://github.com/sashite/qi.rb/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions)
[![License](https://img.shields.io/gem/l/qi.svg)](https://github.com/sashite/qi.rb/blob/main/LICENSE)

> A minimal, format-agnostic position model for two-player board games.

## Overview

`Qi` provides an immutable `Qi::Position` object that represents the state of a two-player, turn-based board game as defined by the [Sashité Game Protocol](https://sashite.dev/game-protocol/).

A position encodes exactly four things:

| Field    | Type                                        | Description                           |
|----------|---------------------------------------------|---------------------------------------|
| `board`  | nested `Array` (1D to 3D)                   | Board structure and occupancy         |
| `hands`  | `Hash` with `:first` and `:second` keys     | Off-board pieces held by each player  |
| `styles` | `Hash` with `:first` and `:second` keys     | Player style for each side            |
| `turn`   | `:first` or `:second`                       | The active player's side              |

Piece and style representations are **intentionally opaque** — `Qi` validates structure, not semantics. This makes the library reusable across [FEEN](https://sashite.dev/specs/feen/1.0.0/), [PON](https://sashite.dev/specs/pon/1.0.0/), or any other encoding that shares the same positional model.

### Implementation Constraints

| Constraint         | Value | Rationale                                 |
|--------------------|-------|-------------------------------------------|
| Max dimensions     | 3     | Covers 1D, 2D, 3D boards                 |
| Max dimension size | 255   | Fits in 8-bit integer; covers 255×255×255 |
| Board non-empty    | n ≥ 1 | A board must contain at least one square  |
| Piece cardinality  | p ≤ n | Pieces cannot exceed the number of squares|

## Installation

```ruby
# In your Gemfile
gem "qi", "~> 11.0"
```

Or install manually:

```sh
gem install qi
```

## Dependencies

None. `Qi` is a zero-dependency library.

## Usage

### Creating a Position

```ruby
# Chess starting position
board = [
  [:r, :n, :b, :q, :k, :b, :n, :r],
  [:p, :p, :p, :p, :p, :p, :p, :p],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [:P, :P, :P, :P, :P, :P, :P, :P],
  [:R, :N, :B, :Q, :K, :B, :N, :R]
]

position = Qi.new(
  board,
  { first: [], second: [] },
  { first: "C", second: "c" },
  :first
)
```

### Accessing Fields

```ruby
position.board   #=> [[:r, :n, :b, ...], ...]
position.hands   #=> { first: [], second: [] }
position.styles  #=> { first: "C", second: "c" }
position.turn    #=> :first
```

All accessors return **frozen** objects. A `Qi::Position` is immutable once created.

### Error Handling

`Qi.new` raises `ArgumentError` on invalid input:

```ruby
begin
  Qi.new([], { first: [], second: [] }, { first: "C", second: "c" }, :first)
rescue ArgumentError => e
  e.message #=> "board must not be empty"
end
```

### Pieces as Arbitrary Objects

Pieces are not restricted to any specific type. You can use symbols, strings (EPIN tokens), arrays, or any non-nil Ruby object:

```ruby
# Symbols
Qi.new([:k, :p, nil, :P, :K], { first: [], second: [] }, { first: "C", second: "c" }, :first)

# EPIN strings
Qi.new([["K^", nil], [nil, "k^"]], { first: [], second: [] }, { first: "C", second: "c" }, :first)

# Arrays as structured piece representations
Qi.new(
  [[[:king, :first, true], nil], [nil, [:king, :second, true]]],
  { first: [], second: [] },
  { first: :chess, second: :chess },
  :first
)
```

### Multi-dimensional Boards

```ruby
# 1D board
Qi.new([:a, nil, :b], { first: [], second: [] }, { first: "G", second: "g" }, :first)

# 2D board (standard)
Qi.new([[nil, nil], [nil, nil]], { first: [], second: [] }, { first: "C", second: "c" }, :first)

# 3D board (2 layers × 2 ranks × 2 files)
board_3d = [
  [[:a, :b], [:c, :d]],
  [[:A, :B], [:C, :D]]
]
Qi.new(board_3d, { first: [], second: [] }, { first: "R", second: "r" }, :first)
```

### Hands with Captured Pieces

```ruby
# Shogi-like position with pieces in hand
Qi.new(
  [[nil, nil, nil], [nil, "K^", nil], [nil, nil, nil]],
  { first: ["P", "P", "B"], second: ["p"] },
  { first: "S", second: "s" },
  :first
)
```

## Validation Errors

| Error message                                                        | Cause                                          |
|----------------------------------------------------------------------|-------------------------------------------------|
| `"board must be an Array"`                                           | Board is not an Array                           |
| `"board must not be empty"`                                          | Board is `[]`                                   |
| `"board exceeds 3 dimensions (got N)"`                               | More than 3 nesting levels                      |
| `"dimension size N exceeds maximum of 255"`                          | A dimension has more than 255 elements          |
| `"non-rectangular board: expected N elements, got M"`                | Sub-arrays at the same level differ in length   |
| `"inconsistent board structure: mixed arrays and non-arrays at same level"` | Mixed arrays and non-arrays at the same nesting level |
| `"inconsistent board structure: expected flat squares at this level"` | An array found where a leaf square was expected |
| `"hands must be a Hash with keys :first and :second"`               | Hands is not a Hash                             |
| `"hands must have exactly keys :first and :second"`                  | Hash has missing or extra keys                  |
| `"each hand must be an Array"`                                       | Hand value is not an Array                      |
| `"hand pieces must not be nil"`                                      | `nil` found in a hand Array                     |
| `"styles must be a Hash with keys :first and :second"`              | Styles is not a Hash                            |
| `"styles must have exactly keys :first and :second"`                 | Hash has missing or extra keys                  |
| `"first player style must not be nil"`                               | First style value is `nil`                      |
| `"second player style must not be nil"`                              | Second style value is `nil`                     |
| `"turn must be :first or :second"`                                   | Invalid turn value                              |
| `"too many pieces for board size (P pieces, N squares)"`             | Piece cardinality violation                     |

## Design Principles

- **Format-agnostic**: No dependency on EPIN, SIN, or any specific encoding.
- **Protocol-aligned**: Structurally compatible with the Game Protocol's Position model.
- **Immutable**: Positions are frozen at construction; no mutation is possible.
- **Validated at construction**: All invariants are enforced when building a position.
- **Zero dependencies**: Only the Ruby standard library.

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [PON Specification](https://sashite.dev/specs/pon/1.0.0/) — JSON-based position format
- [FEEN Specification](https://sashite.dev/specs/feen/1.0.0/) — Canonical string-based position format
- [EPIN Specification](https://sashite.dev/specs/epin/1.0.0/) — Piece token format
- [SIN Specification](https://sashite.dev/specs/sin/1.0.0/) — Style token format

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
