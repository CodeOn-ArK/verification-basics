# Exercise 02 — Buggy FIFO

Same spec as example 03: depth 8, writes ignored when full.

Deliverable: a scoreboard testbench (adapt example 03's) that fails on
this DUT, plus the shortest failing sequence you can find.

Think about what "full" protects: the 8th slot. A test that only writes
a few items will never see this bug — boundary bugs need boundary
stimulus. That is why docs/03 says *bias toward edges*.

Solution: [`solution/SOLUTION.md`](solution/SOLUTION.md)
