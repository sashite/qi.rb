# qi.rb

[![Version](https://img.shields.io/gem/v/qi.svg)](https://rubygems.org/gems/qi)
[![Documentation](https://img.shields.io/badge/yard-docs-blue.svg)](https://rubydoc.info/gems/qi)
[![CI](https://github.com/sashite/qi.rb/actions/workflows/ruby.yml/badge.svg?branch=main)](https://github.com/sashite/qi.rb/actions)
[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](https://github.com/sashite/qi.rb/blob/main/LICENSE)

> An immutable, format-agnostic position model for two-player board games.

## Quick Start

```ruby
gem "qi", "~> 12.0"
```

```ruby
require "qi"

# Create an empty 8×8 board with player styles
pos = Qi.new(8, 8, first_player_style: "C", second_player_style: "c")

# Place pieces and switch turn
pos2 = pos
  .board_diff(0 => "r", 1 => "n", 2 => "b", 3 => "q", 4 => "k")
  .board_diff(60 => "K", 59 => "Q", 58 => "B", 57 => "N", 56 => "R")
  .toggle

pos2.turn  #=> :second
```

Every transformation returns a **new frozen instance**. The original is never modified.

## Overview

`Qi` models a board game position as defined by the [Sashité Game Protocol](https://sashite.dev/game-protocol/). A position encodes exactly four things:

| Component | Accessors | Description |
|-----------|-----------|-------------|
| Board | `board` | Multi-dimensional grid (1D, 2D, or 3D) of squares |
| Hands | `first_player_hand`, `second_player_hand` | Off-board pieces held by each player |
| Styles | `first_player_style`, `second_player_style` | One style String per player side |
| Turn | `turn` | The active player (`:first` or `:second`) |

**Pieces and styles are Strings.** Every piece — whether on the board or in a hand — and every style value is stored as a `String`. This aligns naturally with the notation formats in the Sashité ecosystem ([FEEN](https://sashite.dev/specs/feen/1.0.0/), [EPIN](https://sashite.dev/specs/epin/1.0.0/), [PON](https://sashite.dev/specs/pon/1.0.0/), [SIN](https://sashite.dev/specs/sin/1.0.0/)), which all produce string representations. Empty squares are represented by `nil`.

**String normalization.** All inputs (pieces and styles) are normalized to `String` via interpolation (`"#{value}"`). This guarantees internal consistency without relying on type checks, and accepts any value that responds to `to_s`.

```ruby
pos.board_diff(0 => "K")               # String — stored as "K"
pos.board_diff(0 => :K)                # Symbol — normalized to "K"
pos.board_diff(0 => "C:K")             # Namespaced — stored as "C:K"
pos.board_diff(0 => "+P")              # Promoted — stored as "+P"
```

## Installation

```ruby
# In your Gemfile
gem "qi", "~> 12.0"
```

Or install manually:

```sh
gem install qi
```

### Requirements

`Qi` requires **Ruby 3.2+** (tested against 3.2, 3.3, 3.4, and 4.0) and has **zero runtime dependencies**.

## API Reference

### Construction

#### `Qi.new(*shape, first_player_style:, second_player_style:)` → `Qi`

Creates an immutable position with an empty board.

**Parameters:**

- `*shape` — one to three `Integer` dimension sizes (each 1–255).
- `first_player_style:` — style for the first player (any non-nil value, normalized to `String`).
- `second_player_style:` — style for the second player (any non-nil value, normalized to `String`).

The board starts with all squares empty (`nil`), both hands start empty, and the turn defaults to `:first`. Styles are normalized to `String` and frozen at construction.

```ruby
Qi.new(8, 8, first_player_style: "C", second_player_style: "c")   # 2D (8×8)
Qi.new(8, first_player_style: "G", second_player_style: "g")      # 1D
Qi.new(5, 5, 5, first_player_style: "R", second_player_style: "r") # 3D
```

**Raises** `ArgumentError` if shape constraints are violated or if a style is `nil` (see [Validation Errors](#validation-errors)).

### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `Qi::MAX_DIMENSIONS` | `3` | Maximum number of board dimensions |
| `Qi::MAX_DIMENSION_SIZE` | `255` | Maximum size of any single dimension |

### Accessors

All accessors are safe to call from any thread. Collections return independent copies; styles and turn return immutable values.

| Method | Returns | Copy behavior |
|--------|---------|---------------|
| `board` | `Array` | Nested array (independent copy). Each leaf is `nil` or `String`. |
| `first_player_hand` | `Array<String>` | Independent copy. |
| `second_player_hand` | `Array<String>` | Independent copy. |
| `turn` | `Symbol` | `:first` or `:second` (immutable). |
| `first_player_style` | `String` | Frozen value (returned directly, no allocation). |
| `second_player_style` | `String` | Frozen value (returned directly, no allocation). |
| `shape` | `Array<Integer>` | Independent copy (e.g., `[8, 8]`). |
| `inspect` | `String` | Developer-friendly, unstable format. Do not parse. |

```ruby
pos.board                #=> [["r", "n", "b", ...], ...]
pos.first_player_hand    #=> []
pos.second_player_hand   #=> []
pos.turn                 #=> :first
pos.first_player_style   #=> "C"
pos.second_player_style  #=> "c"
pos.shape                #=> [8, 8]
pos.inspect              #=> "#<Qi shape=[8, 8] turn=:first>"
```

**Note:** Styles are frozen Strings. Attempting to mutate a returned style raises `FrozenError`. If you need a mutable copy, call `.dup` on the returned value.

### Transformations

All transformation methods return a **new frozen `Qi` instance**. The original is never modified.

#### `board_diff(**squares)` → `Qi`

Returns a new position with modified squares.

Keys are flat indices (`Integer`, 0-based, row-major order). Values are pieces (normalized to `String`) or `nil` (empty square).

```ruby
pos2 = pos.board_diff(12 => nil, 28 => "P")
```

**Raises** `ArgumentError` if an index is out of range or if the resulting total piece count exceeds the board size.

See [Flat Indexing](#flat-indexing) for computing flat indices from coordinates.

#### `first_player_hand_diff(**pieces)` → `Qi`
#### `second_player_hand_diff(**pieces)` → `Qi`

Returns a new position with a modified hand.

Keys are piece identifiers (normalized to `String`); values are integer deltas (positive to add, negative to remove, zero is a no-op). Removal uses **value equality** (`==`).

```ruby
pos2 = pos.first_player_hand_diff("P": 1)           # Add one "P"
pos3 = pos.first_player_hand_diff("B": -1, "P": 1)  # Remove one "B", add one "P"
pos4 = pos.second_player_hand_diff("p": 1)           # Add one "p" to second hand
```

**String normalization:** Ruby keyword arguments produce Symbol keys. The hand diff methods normalize these to Strings internally (`"P": 1` becomes key `:P`, stored as `"P"`). This is transparent in normal usage — the example above stores `"P"`, `"B"`, and `"p"` as Strings in the hand.

**Raises** `ArgumentError` if a delta is not an `Integer`, if removing a piece not present, or if the resulting total piece count exceeds the board size.

#### `toggle` → `Qi`

Returns a new position with the active player swapped. All other fields are preserved.

```ruby
pos.turn           #=> :first
pos.toggle.turn    #=> :second
```

#### Chaining

Transformations compose naturally. A typical move involves modifying the board, optionally updating a hand, and toggling the turn:

```ruby
# Simple move: slide a piece from index 12 to index 28
pos2 = pos
  .board_diff(12 => nil, 28 => "P")
  .toggle

# Capture: overwrite defender, add captured piece to hand, toggle
pos3 = pos
  .board_diff(12 => nil, 28 => "P")        # Attacker replaces defender
  .first_player_hand_diff("p": 1)          # Captured piece goes to hand
  .toggle
```

The Protocol does not prescribe how captures are modeled. In the example above, `board_diff(12 => nil, 28 => "P")` simultaneously vacates the source and overwrites the destination. The captured piece must be added to the hand separately — `board_diff` does not track what was previously on a square.

## Board Structure

### Shape and Dimensionality

The nesting depth of the array returned by `board` matches the number of dimensions:

| Dimensionality | Constructor | `board` returns |
|----------------|-------------|-----------------|
| 1D | `Qi.new(8, ...)` | `[square, square, ...]` |
| 2D | `Qi.new(8, 8, ...)` | `[[square, ...], [square, ...], ...]` |
| 3D | `Qi.new(5, 5, 5, ...)` | `[[[square, ...], ...], ...]` |

Each `square` is either `nil` (empty) or a `String` (a piece).

For a shape `[D1, D2, ..., DN]`, the total number of squares is `D1 × D2 × ... × DN`.

### Flat Indexing

`board_diff` addresses squares by **flat index** — a single integer in **row-major order** (C order).

**1D board** with shape `[F]`:

```
flat_index = f
```

**2D board** with shape `[R, F]` (R ranks, F files):

```
flat_index = r × F + f
```

For example, on a 3×3 board (shape `[3, 3]`):

```
             file
           0   1   2
        ┌────┬────┬────┐
rank 0  │  0 │  1 │  2 │
        ├────┼────┼────┤
rank 1  │  3 │  4 │  5 │
        ├────┼────┼────┤
rank 2  │  6 │  7 │  8 │
        └────┴────┴────┘
```

Square `(rank=1, file=2)` → flat index `1 × 3 + 2 = 5`.

**3D board** with shape `[L, R, F]` (L layers, R ranks, F files):

```
flat_index = l × R × F + r × F + f
```

### Piece Cardinality

The total number of pieces across all locations (board squares + both hands) must never exceed the number of squares on the board. This invariant is enforced on every transformation.

For a board with *n* squares and *p* total pieces: **0 ≤ p ≤ n**.

```ruby
pos = Qi.new(2, first_player_style: "C", second_player_style: "c")
  .board_diff(0 => "a", 1 => "b")   # 2 pieces on 2 squares: OK

pos.first_player_hand_diff("c": 1)
# => ArgumentError: too many pieces for board size (3 pieces, 2 squares)
```

## Validation Errors

### Validation Order

Construction validates fields in a guaranteed order. When multiple errors exist, the **first** failing check determines the error message:

1. **Shape** — dimension count, types, and bounds
2. **Styles** — nil checks (first, then second)

This order is part of the public API contract.

### Construction Errors

| Error message | Cause |
|---------------|-------|
| `"at least one dimension is required"` | No dimension sizes provided |
| `"board exceeds 3 dimensions (got N)"` | More than 3 dimension sizes |
| `"dimension size must be an Integer, got C"` | Non-integer dimension size |
| `"dimension size must be at least 1, got N"` | Dimension size is zero or negative |
| `"dimension size N exceeds maximum of 255"` | Dimension size exceeds 255 |
| `"first player style must not be nil"` | First style is `nil` |
| `"second player style must not be nil"` | Second style is `nil` |

### Transformation Errors

| Error message | Method | Cause |
|---------------|--------|-------|
| `"invalid flat index: I (board has N squares)"` | `board_diff` | Index out of range or non-integer key |
| `"delta must be an Integer, got C for piece P"` | hand diffs | Non-integer delta |
| `"cannot remove P: not found in hand"` | hand diffs | Removing more pieces than present |
| `"too many pieces for board size (P pieces, N squares)"` | all | Total pieces would exceed board capacity |

## Design Principles

**Immutable by construction.** Every `Qi` instance is frozen at creation. Transformation methods return new instances rather than mutating state. This eliminates an entire class of bugs around shared mutable state and makes positions safe to use as hash keys, cache entries, or history snapshots.

**Diff-based transformations.** Rather than rebuilding a full position from scratch, `board_diff` and hand diff methods express changes as deltas against the current state. This keeps the API surface small (four transformation methods cover all possible state transitions) while making the intent of each operation explicit.

**String normalization.** Pieces and styles are normalized to `String` via interpolation (`"#{value}"`). This aligns with the notation formats in the Sashité ecosystem (FEEN, EPIN, PON, SIN) which all produce string representations, and eliminates type conversions between layers. Rather than rejecting non-string inputs, the library coerces them — guaranteeing internal consistency by construction rather than by validation.

**Zero dependencies.** `Qi` relies only on the Ruby standard library. No transitive dependency tree to audit, no version conflicts to resolve.

## Thread Safety

`Qi` instances are frozen at construction. Accessors that return collections (`board`, hands, `shape`) produce independent copies on each call. Styles are frozen Strings returned directly. This makes positions inherently thread-safe: they can be shared freely across threads without synchronization.

## Ecosystem

`Qi` is the positional core of the [Sashité](https://sashite.dev/) ecosystem. It models *what a position is* (board, hands, styles, turn) without prescribing *how positions are serialized* or *what moves are legal*.

Other libraries in the ecosystem build on `Qi` to provide those capabilities: [FEEN](https://sashite.dev/specs/feen/1.0.0/) defines a canonical string encoding for positions, [PON](https://sashite.dev/specs/pon/1.0.0/) provides a JSON-based position format, [EPIN](https://sashite.dev/specs/epin/1.0.0/) specifies piece token syntax, and [SIN](https://sashite.dev/specs/sin/1.0.0/) specifies style token syntax. The [Game Protocol](https://sashite.dev/game-protocol/) describes the conceptual foundation that all these specifications share.

## Notes for Reimplementors

This section provides guidance for porting `Qi` to other languages.

### API Surface

The complete public API consists of:

- **1 constructor** — `Qi.new(*shape, first_player_style:, second_player_style:)`
- **7 accessors** — `board`, `first_player_hand`, `second_player_hand`, `turn`, `first_player_style`, `second_player_style`, `shape`
- **4 transformations** — `board_diff`, `first_player_hand_diff`, `second_player_hand_diff`, `toggle`
- **1 debug** — `inspect`
- **2 constants** — `MAX_DIMENSIONS`, `MAX_DIMENSION_SIZE`

### API Naming

The Ruby API separates **accessors** (read) from **transformations** (diff) using a `_diff` suffix. In languages where this convention is unusual, alternatives include `with_board(...)` / `with_first_hand(...)` for a fluent style, or `update_board(...)` / `update_hand(side, ...)` for a more imperative style.

### Key Semantic Contracts

**Pieces and styles are strings.** Board squares, hand contents, and style values are all stored as strings. The Ruby implementation normalizes inputs via interpolation (`"#{value}"`), accepting any value that responds to `to_s`. Statically typed languages should accept string parameters directly.

**Piece equality is by value**, not by identity. Hand removal uses value-based matching (Ruby's `==`). Use the equivalent in your language (`Eq` in Rust, `__eq__` in Python, `equals()` in Java).

**Piece cardinality is global.** The constraint `p ≤ n` counts pieces across all locations: board squares plus both hands. A transformation that adds a piece to a hand can exceed the limit even if the board has empty squares.

**Nil means empty.** On the board, `nil` (or the language equivalent) represents an empty square. It is never coerced to a string. Styles must not be nil — this is the only nil-related error at construction.

**Validation order is guaranteed**: shape → styles. Tests assert which error is reported when multiple inputs are invalid simultaneously.

**Positions are immutable**: all transformation methods return a new instance. The original is never modified.

**Accessors protect internal state**: mutable collections (`board`, hands, `shape`) return fresh copies. Styles are frozen Strings returned directly (zero-cost access). `turn` returns an immutable value.

**The constructor creates an empty position**: board all null, hands empty, turn is first player. Pieces are added via `board_diff` and hand diff methods.

### Hand Diff and String Normalization

In Ruby, keyword arguments produce Symbol keys, so `first_player_hand_diff("P": 1)` passes `{P: 1}` with key `:P` (a Symbol). The implementation normalizes this to the String `"P"` before storing.

This is a Ruby-specific concern. In other languages, hand diff methods should accept string keys directly. The important contract is that the hand always contains strings, matching the board's piece type.

### Duplicate Key Policy

In Ruby, passing the same keyword argument twice keeps only the last value (`board_diff(0 => "a", 0 => "b")` is equivalent to `board_diff(0 => "b")`). Reimplementations should define their own policy: last-write-wins, first-write-wins, or rejection.

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
