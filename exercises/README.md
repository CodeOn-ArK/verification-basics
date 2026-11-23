# Exercises — Catch the Bug

Each exercise gives you a DUT with **one real bug** in it. The bug is
not labelled. Your job:

1. Write a self-checking testbench (use the patterns from `examples/`).
2. Find the smallest test case that fails.
3. Write up: expected vs actual, and the first cycle/input where they diverge.
4. *Then* open `solution/` and compare.

If your testbench passes the buggy DUT, your testbench is the bug.
That is the most common real-world failure mode, and the point of the exercise.

| # | Exercise | Bug family |
|---|----------|------------|
| 1 | [`01_buggy_alu`](01_buggy_alu/) | Wrong operation hidden among correct ones |
| 2 | [`02_buggy_fifo`](02_buggy_fifo/) | Boundary condition — off by one at full |
