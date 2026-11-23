# Exercise 01 — Buggy ALU

The comment in the DUT points at a suspect. Don't trust it — *prove* it,
and check whether it's the only bug.

Deliverable (to yourself): a testbench where a directed test fails on
this DUT and passes on `examples/01_alu_self_checking/alu.v`.

Hint: a random-only testbench catches this too, but notice which
directed pair makes the failure obvious at a glance: pick `a` and `b`
so that `a - b` and `b - a` differ *and* neither is zero.

Solution: [`solution/SOLUTION.md`](solution/SOLUTION.md)
