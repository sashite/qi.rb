# qi.rb

[![Version](https://img.shields.io/gem/v/qi.svg)](https://rubygems.org/gems/qi)
[![Documentation](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/gems/qi)
[![CI](https://github.com/sashite/qi.rb/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/sashite/qi.rb/blob/main/LICENSE)

> A minimal, format-agnostic position model for two-player board games.

## Overview

`Qi` provides an immutable position object that represents the state of a two-player, turn-based board game as defined by the [Sashité Game Protocol](https://sashite.dev/game-protocol/).

A position encodes exactly four things:

| Component  | Accessors                                              | Description                           |
|------------|--------------------------------------------------------|---------------------------------------|
| Board      | `board`                                                | Board structure and occupancy         |
| Hands      | `first_player_hand`, `second_player_hand`              | Off-board pieces held by each player  |
| Styles     | `first_player_style`, `second_player_style`            | Player style for each side            |
| Turn       | `turn`                                                 | The active player's side              |

Piece and style representations are **intentionally opaque** — `Qi` validates structure, not semantics. This makes the library reusable across [FEEN](https://sashite.dev/specs/feen/1.0.0/), [PON](https://sashite.dev/specs/pon/1.0.0/), or any other encoding that shares the same positional model.

### Implementation Constraints

| Constraint         | Value    | Rationale                                 |
|--------------------|----------|-------------------------------------------|
| Max dimensions     | 3        | Covers 1D, 2D, 3D boards                 |
| Max dimension size | 255      | Fits in 8-bit integer; covers 255×255×255 |
| Board non-empty    | n ≥ 1    | A board must contain at least one square  |
| Piece cardinality  | p ≤ n    | Pieces cannot exceed the number of squares|

## Installation

```ruby
# In your Gemfile
gem "qi", "~> 12.0"
```

Or install manually:

```sh
gem install qi
```

## Dependencies

None. `Qi` is a zero-dependency library.

## Usage

### Creating a Position

A position is constructed from the board shape (dimension sizes) and player styles. The board starts empty, both hands start empty, and the turn defaults to `:first`:

```ruby
# 2D chess board (8×8)
pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")

# 1D board
pos = Qi.new(8, first_player_style: "G", second_player_style: "g")

# 3D board (5×5×5)
pos = Qi.new(5, 5, 5, first_player_style: "R", second_player_style: "r")
```

To set up a specific position, chain transformation methods:

```ruby
# Chess starting position
pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")
  .board_diff(
    0 => :r, 1 => :n, 2 => :b, 3 => :q, 4 => :k, 5 => :b, 6 => :n, 7 => :r,
    8 => :p, 9 => :p, 10 => :p, 11 => :p, 12 => :p, 13 => :p, 14 => :p, 15 => :p,
    48 => :P, 49 => :P, 50 => :P, 51 => :P, 52 => :P, 53 => :P, 54 => :P, 55 => :P,
    56 => :R, 57 => :N, 58 => :B, 59 => :Q, 60 => :K, 61 => :B, 62 => :N, 63 => :R
  )
```

### Accessors

All accessors return **independent copies** of the internal state. Mutating the returned value has no effect on the position.

```ruby
pos.board                #=> [[:r, :n, :b, ...], ...]
pos.first_player_hand    #=> []
pos.second_player_hand   #=> []
pos.turn                 #=> :first
pos.first_player_style   #=> "C"
pos.second_player_style  #=> "c"
pos.shape                #=> [8, 8]
```

### Transforming Positions

Positions are immutable. Transformation methods return a **new frozen `Qi` instance**, leaving the original unchanged. Methods can be chained.

#### Modifying the Board

`board_diff(**squares)` accepts flat indices (row-major order, 0-based) mapped to piece values (`nil` to empty a square):

```ruby
# Move a piece from index 12 to index 28
pos2 = pos.board_diff(12 => nil, 28 => "C:P")
```

See [Flat Indexing](#flat-indexing) for the formula used to compute flat indices from dimensional coordinates.

#### Modifying Hands

`first_player_hand_diff(**pieces)` and `second_player_hand_diff(**pieces)` accept piece identifiers mapped to integer deltas — positive to add, negative to remove. A delta of zero is a no-op for that piece.

Piece matching for removal uses **value equality** (Ruby's `==` operator). Two piece objects are considered the same piece type if they are equal by value, regardless of object identity. Reimplementations should use the equivalent structural/value equality in their language (e.g., `equals()` in Java, `==` in Python, `Eq` trait in Rust).

```ruby
# Add a pawn to first player's hand
pos2 = pos.first_player_hand_diff(P: 1)

# Remove a bishop and add a pawn
pos3 = pos.first_player_hand_diff(B: -1, P: 1)

# Add a captured pawn to second player's hand
pos4 = pos.second_player_hand_diff(p: 1)
```

#### Toggling the Active Player

`toggle` swaps the active player while preserving everything else:

```ruby
pos2 = pos.toggle
pos2.turn  #=> :second
```

#### Chaining

Transformations compose naturally:

```ruby
# A complete move: clear source, fill destination, capture to hand, toggle turn
pos2 = pos
  .board_diff(12 => nil, 28 => "C:P")
  .first_player_hand_diff("c:p": 1)
  .toggle
```

### Error Handling

`Qi.new` raises `ArgumentError` on invalid input:

```ruby
begin
  Qi.new(0, 8, first_player_style: "C", second_player_style: "c")
rescue ArgumentError => e
  e.message #=> "dimension size must be at least 1, got 0"
end
```

Transformation methods also raise `ArgumentError` for invalid operations:

```ruby
pos.board_diff(99 => :a)
# => ArgumentError: invalid flat index: 99 (board has 64 squares)

pos.first_player_hand_diff(P: -1)
# => ArgumentError: cannot remove :P: not found in hand
```

### Pieces as Arbitrary Objects

Pieces are not restricted to any specific type. You can use symbols, strings (EPIN tokens), arrays, or any non-nil Ruby object:

```ruby
# Symbols
pos = Qi.new(5, first_player_style: "C", second_player_style: "c")
  .board_diff(0 => :k, 1 => :p, 3 => :P, 4 => :K)

# EPIN strings
pos = Qi.new(2, 2, first_player_style: "C", second_player_style: "c")
  .board_diff(0 => "K^", 3 => "k^")

# Arrays as structured piece representations
pos = Qi.new(2, 2, first_player_style: :chess, second_player_style: :chess)
  .board_diff(0 => [:king, :first, true], 3 => [:king, :second, true])
```

## Board Structure

### Shape and Dimensionality

The board shape is defined by the dimension sizes passed to the constructor. The nesting depth of the array returned by `board` matches the number of dimensions:

| Dimensionality | Constructor           | `board` returns                         |
|----------------|-----------------------|-----------------------------------------|
| 1D             | `Qi.new(8, ...)`      | `[square, square, ...]`                 |
| 2D             | `Qi.new(8, 8, ...)`   | `[[square, ...], [square, ...], ...]`   |
| 3D             | `Qi.new(5, 5, 5, ...)` | `[[[square, ...], ...], ...]`          |

Each `square` is either `nil` (empty) or any non-nil object (a piece).

For a shape `[D1, D2, ..., DN]`, the total number of squares is `D1 × D2 × ... × DN`.

### Flat Indexing

The `board_diff(**squares)` method addresses squares by **flat index** — a single integer corresponding to the square's position in **row-major order** (also known as C order or lexicographic order).

The flat index is computed by traversing the nested structure depth-first, left-to-right, enumerating leaf elements from 0.

**1D board** with shape `[F]`:

```
flat_index = f
```

where `f` is the position (0-based).

**2D board** with shape `[R, F]` (R ranks, F files):

```
flat_index = r × F + f
```

where `r` is the rank index and `f` is the file index (both 0-based).

**3D board** with shape `[L, R, F]` (L layers, R ranks, F files):

```
flat_index = l × R × F + r × F + f
```

where `l` is the layer index, `r` is the rank index, and `f` is the file index (all 0-based).

**Example:** On a standard 8×8 chess board (shape `[8, 8]`), square `(rank=1, file=4)` has flat index `1 × 8 + 4 = 12`.

**Duplicate keys:** In Ruby, passing the same keyword argument twice keeps only the last value (`board_diff(0 => :a, 0 => :b)` is equivalent to `board_diff(0 => :b)`). Reimplementations should define their own policy: last-write-wins, first-write-wins, or rejection.

## Validation Errors

### Validation Order

Construction validates fields in a guaranteed order. When multiple errors exist, the **first** failing check determines the error message:

1. **Shape** — dimension count, types, and bounds
2. **Styles** — non-nil checks (first, then second)

This order is part of the public API contract. Reimplementations should preserve it to ensure consistent error reporting.

### Construction Errors

| Error message                                        | Cause                                     |
|------------------------------------------------------|-------------------------------------------|
| `"at least one dimension is required"`               | No dimension sizes provided               |
| `"board exceeds 3 dimensions (got N)"`               | More than 3 dimension sizes               |
| `"dimension size must be an Integer, got C"`         | Non-integer dimension size                |
| `"dimension size must be at least 1, got N"`         | Dimension size is zero or negative        |
| `"dimension size N exceeds maximum of 255"`          | Dimension size exceeds 255                |
| `"first player style must not be nil"`               | First style is `nil`                      |
| `"second player style must not be nil"`              | Second style is `nil`                     |

### Transformation Errors

| Error message                                                   | Cause                                          |
|-----------------------------------------------------------------|-------------------------------------------------|
| `"invalid flat index: I (board has N squares)"`                 | Board index out of range                        |
| `"delta must be an Integer, got C for piece P"`                 | Non-integer delta in hand change                |
| `"cannot remove P: not found in hand"`                          | Removing a piece not present in hand            |
| `"too many pieces for board size (P pieces, N squares)"`        | Transformation would exceed board capacity      |

### `inspect` Method

`inspect` returns a developer-friendly string representation. Its format is not stable and should not be parsed. It is intended for debugging only.

## Design Principles

- **Format-agnostic**: No dependency on EPIN, SIN, or any specific encoding.
- **Protocol-aligned**: Structurally compatible with the Game Protocol's Position model.
- **Immutable**: Positions are frozen at construction; no mutation is possible.
- **Diff-based transformations**: `board_diff`, `first_player_hand_diff`, `second_player_hand_diff`, and `toggle` return new positions from delta changes, avoiding unnecessary copies.
- **Zero dependencies**: Only the Ruby standard library.

## Notes for Reimplementors

This section provides guidance for porting `Qi` to other languages.

### API Naming

The Ruby API separates **accessors** (read) from **transformations** (diff) using a `_diff` suffix. In languages where this convention is unusual, alternatives include:

- `with_board(...)` / `with_first_hand(...)` for transformation methods
- `update_board(...)` / `update_hand(side, ...)` for a more imperative style

### Key Semantic Contracts

- **Piece equality is by value**, not by identity. Hand removal uses value-based matching (Ruby's `==`). Use the equivalent in your language (e.g., `Eq` in Rust, `__eq__` in Python, `equals()` in Java).
- **Validation order is guaranteed**: shape → styles. Tests assert which error is reported when multiple inputs are invalid simultaneously.
- **Positions are immutable**: all transformation methods return a new instance. The original is never modified.
- **Accessors always copy**: each call returns fresh, independent data structures that the caller owns.
- **The constructor creates an empty position**: board all `nil`, hands empty, turn `:first`. Pieces are added via `board_diff` and hand diff methods.

## Related Specifications

- [Game Protocol](https://sashite.dev/game-protocol/) — Conceptual foundation
- [PON Specification](https://sashite.dev/specs/pon/1.0.0/) — JSON-based position format
- [FEEN Specification](https://sashite.dev/specs/feen/1.0.0/) — Canonical string-based position format
- [EPIN Specification](https://sashite.dev/specs/epin/1.0.0/) — Piece token format
- [SIN Specification](https://sashite.dev/specs/sin/1.0.0/) — Style token format

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
