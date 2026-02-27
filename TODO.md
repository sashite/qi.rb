# Qi Performance Optimizations

Optimization targets identified for `Qi::Position`, sorted by estimated impact.

## High

- [ ] **Merge `deep_freeze` into board validation**
  Currently `verify_and_count` traverses the entire structure, then `deep_freeze` traverses it again. Freezing elements directly during `verify_and_count` eliminates a full traversal (~64 calls on a standard chessboard, ~90 for xiangqi).

## Medium

- [ ] **Replace `shape[1..]` with a `depth` index**
  `verify_and_count_multi` allocates a new Array at each recursion level via `shape[1..]`. Passing an integer `depth` instead removes these allocations entirely.

- [ ] **Merge `compute_shape` and `verify_and_count`**
  `compute_shape` walks the first element at each level to infer the shape, then `verify_and_count` re-traverses everything. A single recursive pass can infer shape and verify structure simultaneously.

## Low

- [ ] **Direct turn check instead of `Array#include?`**
  Replace `VALID_TURNS.include?(turn)` with `turn == :first || turn == :second` to eliminate the method lookup dispatch.

## Negligible

- [ ] **`validate_dimension_sizes`: replace `find` with `each` + raise**
  Avoid allocating the intermediate `oversized` variable and only build the error message when necessary.
