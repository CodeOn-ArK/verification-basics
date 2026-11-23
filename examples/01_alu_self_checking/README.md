# 01 — ALU, Self-Checking

**Concepts:** golden reference model · check task · directed edge cases + random volume · explicit PASS/FAIL

Run it:

Run it on EDA Playground with Cadence Xcelium (see `../../docs/07_eda_playground.md`): DUT `alu.v` in Design, `tb_alu.v` in Testbench, Run — expect `PASS: 207 checks, 0 errors` in the log. Local fallback: `make` (Icarus).

## Try this

1. In `alu.v`, change the SUB case to `a + b`. Re-run. Which directed
   test catches it first — and would the random tests have caught it too?
2. Delete the overflow directed test (`255 + 1`). Is the bug in (1)
   still caught? What does that tell you about directed vs random?
3. Add a `SLT` (set-less-than) operation to both the DUT *and* the model.
   Then add it to only the DUT. Notice which failure mode is scarier —
   and why the model must be written from the spec, not from the RTL.
