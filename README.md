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

# Place pieces, capture to hand, switch turn — all in one chain
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
| Styles | `first_player_style`, `second_player_style` | One style value per player side |
| Turn | `turn` | The active player (`:first` or `:second`) |

**Pieces are Strings.** Every piece — whether on the board or in a hand — must be a `String`. This aligns naturally with the notation formats in the Sashité ecosystem (FEEN, EPIN, PON), which all produce string representations. Empty squares are represented by `nil`.

Style representations are **intentionally opaque**: any non-nil Ruby object is a valid style value. `Qi` validates piece types and structural integrity, not game semantics. This makes the library reusable across [FEEN](https://sashite.dev/specs/feen/1.0.0/), [PON](https://sashite.dev/specs/pon/1.0.0/), or any encoding that shares the same positional model.

```ruby
# All of these are valid pieces:
pos.board_diff(0 => "K")                # Short name
pos.board_diff(0 => "K^")               # EPIN string
pos.board_diff(0 => "C:K")              # Namespaced
pos.board_diff(0 => "+P")               # Promoted
```

### Implementation Constraints

| Constraint | Value | Rationale |
|------------|-------|-----------|
| Max dimensions | 3 | Covers 1D, 2D, 3D boards |
| Max dimension size | 255 | Fits in 8-bit integer; covers 255×255×255 |
| Board non-empty | n ≥ 1 | A board must contain at least one square |
| Piece cardinality | p ≤ n | Pieces cannot exceed the number of squares |
| Piece type | `String` | Consistent with notation formats |

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
    0 => "r", 1 => "n", 2 => "b", 3 => "q", 4 => "k", 5 => "b", 6 => "n", 7 => "r",
    8 => "p", 9 => "p", 10 => "p", 11 => "p", 12 => "p", 13 => "p", 14 => "p", 15 => "p",
    48 => "P", 49 => "P", 50 => "P", 51 => "P", 52 => "P", 53 => "P", 54 => "P", 55 => "P",
    56 => "R", 57 => "N", 58 => "B", 59 => "Q", 60 => "K", 61 => "B", 62 => "N", 63 => "R"
  )
```

### Accessors

Accessors for mutable structures (`board`, `first_player_hand`, `second_player_hand`, `shape`) return **independent copies**. Mutating the returned value has no effect on the position. Styles are returned **frozen** (no allocation on access). `turn` returns an immutable Symbol.

```ruby
pos.board                #=> [["r", "n", "b", ...], ...]
pos.first_player_hand    #=> []
pos.second_player_hand   #=> []
pos.turn                 #=> :first
pos.first_player_style   #=> "C" (frozen)
pos.second_player_style  #=> "c" (frozen)
pos.shape                #=> [8, 8]
```

### Transforming Positions

Positions are immutable. Transformation methods return a **new frozen `Qi` instance**, leaving the original unchanged.

#### Modifying the Board

`board_diff(**squares)` accepts flat indices (0-based, row-major order) mapped to piece values (`nil` to empty a square):

```ruby
# Move a piece from index 12 to index 28
pos2 = pos.board_diff(12 => nil, 28 => "P")
```

See [Flat Indexing](#flat-indexing) for computing flat indices from dimensional coordinates.

#### Modifying Hands

`first_player_hand_diff(**pieces)` and `second_player_hand_diff(**pieces)` accept piece identifiers mapped to integer deltas — positive to add, negative to remove. A delta of zero is a no-op for that piece.

Piece matching for removal uses **value equality** (Ruby's `==` operator).

```ruby
# Add a pawn to first player's hand
pos2 = pos.first_player_hand_diff("P": 1)

# Remove a bishop and add a pawn
pos3 = pos.first_player_hand_diff("B": -1, "P": 1)

# Add a captured pawn to second player's hand
pos4 = pos.second_player_hand_diff("p": 1)
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
  .board_diff(12 => nil, 28 => "P")
  .first_player_hand_diff("p": 1)
  .toggle
```

### Error Handling

`Qi.new` raises `ArgumentError` on invalid input:

```ruby
Qi.new(0, 8, first_player_style: "C", second_player_style: "c")
# => ArgumentError: dimension size must be at least 1, got 0
```

Transformation methods also raise `ArgumentError` for invalid operations:

```ruby
pos.board_diff(99 => "a")
# => ArgumentError: invalid flat index: 99 (board has 64 squares)

pos.board_diff(0 => :symbol)
# => ArgumentError: piece must be a String, got Symbol

pos.first_player_hand_diff("P": -1)
# => ArgumentError: cannot remove "P": not found in hand
```

## Board Structure

### Shape and Dimensionality

The board shape is defined by the dimension sizes passed to the constructor. The nesting depth of the array returned by `board` matches the number of dimensions:

| Dimensionality | Constructor | `board` returns |
|----------------|-------------|-----------------|
| 1D | `Qi.new(8, ...)` | `[square, square, ...]` |
| 2D | `Qi.new(8, 8, ...)` | `[[square, ...], [square, ...], ...]` |
| 3D | `Qi.new(5, 5, 5, ...)` | `[[[square, ...], ...], ...]` |

Each `square` is either `nil` (empty) or a `String` (a piece).

For a shape `[D1, D2, ..., DN]`, the total number of squares is `D1 × D2 × ... × DN`.

### Flat Indexing

The `board_diff` method addresses squares by **flat index** — a single integer in **row-major order** (C order). The flat index is computed by traversing the nested structure depth-first, left-to-right, enumerating leaf elements from 0.

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

## Validation Errors

### Validation Order

Construction validates fields in a guaranteed order. When multiple errors exist, the **first** failing check determines the error message:

1. **Shape** — dimension count, types, and bounds
2. **Styles** — non-nil checks (first, then second)

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

| Error message | Cause |
|---------------|-------|
| `"invalid flat index: I (board has N squares)"` | Board index out of range |
| `"piece must be a String, got C"` | Non-string, non-nil value in board_diff |
| `"hand piece must be a String, got C"` | Non-string piece in hand diff |
| `"delta must be an Integer, got C for piece P"` | Non-integer delta in hand change |
| `"cannot remove P: not found in hand"` | Removing a piece not present in hand |
| `"too many pieces for board size (P pieces, N squares)"` | Transformation would exceed board capacity |

### `inspect`

Returns a developer-friendly string for debugging. The format is not stable and should not be parsed.

## Design Principles

**Immutable by construction.** Every `Qi` instance is frozen at creation. Transformation methods return new instances rather than mutating state. This eliminates an entire class of bugs around shared mutable state and makes positions safe to use as hash keys, cache entries, or history snapshots.

**Diff-based transformations.** Rather than rebuilding a full position from scratch, `board_diff` and hand diff methods express changes as deltas against the current state. This keeps the API surface small (four transformation methods cover all possible state transitions) while making the intent of each operation explicit.

**String pieces, opaque styles.** Pieces are constrained to `String` values, aligning with the notation formats in the Sashité ecosystem (FEEN, EPIN, PON) which all produce string representations. This eliminates unnecessary type conversions between layers. Styles remain opaque (any non-nil value) since they are not exchanged as frequently between components.

**Zero dependencies.** `Qi` relies only on the Ruby standard library. No transitive dependency tree to audit, no version conflicts to resolve.

## Thread Safety

`Qi` instances are frozen at construction and all accessors return independent copies. This makes positions inherently thread-safe: they can be shared freely across threads without synchronization.

## Ecosystem

`Qi` is the positional core of the [Sashité](https://sashite.dev/) ecosystem. It models *what a position is* (board, hands, styles, turn) without prescribing *how positions are serialized* or *what moves are legal*.

Other libraries in the ecosystem build on `Qi` to provide those capabilities: [FEEN](https://sashite.dev/specs/feen/1.0.0/) defines a canonical string encoding for positions, [PON](https://sashite.dev/specs/pon/1.0.0/) provides a JSON-based position format, [EPIN](https://sashite.dev/specs/epin/1.0.0/) specifies piece token syntax, and [SIN](https://sashite.dev/specs/sin/1.0.0/) specifies style token syntax. The [Game Protocol](https://sashite.dev/game-protocol/) describes the conceptual foundation that all these specifications share.

## Notes for Reimplementors

This section provides guidance for porting `Qi` to other languages.

### API Naming

The Ruby API separates **accessors** (read) from **transformations** (diff) using a `_diff` suffix. In languages where this convention is unusual, alternatives include `with_board(...)` / `with_first_hand(...)` for a fluent style, or `update_board(...)` / `update_hand(side, ...)` for a more imperative style.

### Key Semantic Contracts

**Pieces are strings.** Both board squares and hand contents must be `String` values (or `nil` / the language equivalent for empty squares). The string format is not constrained — any non-empty or empty string is valid. Reimplementations should enforce this type constraint at the boundary (construction and transformation methods).

**Piece equality is by value**, not by identity. Hand removal uses value-based matching (Ruby's `==`). Use the equivalent in your language (`Eq` in Rust, `__eq__` in Python, `equals()` in Java).

**Validation order is guaranteed**: shape → styles. Tests assert which error is reported when multiple inputs are invalid simultaneously.

**Positions are immutable**: all transformation methods return a new instance. The original is never modified.

**Accessors copy or freeze**: mutable collections (`board`, hands, `shape`) return fresh copies. Styles are frozen at construction and returned directly (zero-cost access). `turn` returns an immutable Symbol.

**The constructor creates an empty position**: board all `nil`, hands empty, turn `:first`. Pieces are added via `board_diff` and hand diff methods.

### Duplicate Key Policy

In Ruby, passing the same keyword argument twice keeps only the last value (`board_diff(0 => "a", 0 => "b")` is equivalent to `board_diff(0 => "b")`). Reimplementations should define their own policy: last-write-wins, first-write-wins, or rejection.

## License

Available as open source under the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).
