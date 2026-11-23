# Solution 01

**Bug:** `SUB` computes `b - a` instead of `a - b`.

**Smallest clear failure:** `a=10, b=3, op=SUB`
- Expected: `7`
- Actual: `3 - 10 = 249` (wraps)

**Why some tests miss it:** any case with `a == b` (result 0 either way),
and the zero-flag checks, pass on the buggy DUT. Symmetric inputs hide
asymmetric bugs — a general lesson: for non-commutative operations
(SUB, SHR, comparisons), always test with `a != b` in both orders.

The example-01 testbench catches this on its third directed check
(`0 - 1`: expected 255, buggy gives 1) and on random tests.
