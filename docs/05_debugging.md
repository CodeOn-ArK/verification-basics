# 5 — Debugging: When a Test Fails

Debug is ~half the job. A workflow beats staring:

## 1. Shrink the failure

- Re-run with the logged **seed**. Confirm it still fails.
- Cut the test down: fewer transactions, smaller data, until the failure
  is the shortest sequence that still breaks. A 6-transaction failure is
  debuggable; a 10,000-transaction one is not.

## 2. Decide whose bug it is

Three suspects, in the order to check them:

1. **Testbench / checker** — the most common. Did the monitor sample on
   the right edge? Is the reference model handling reset correctly?
2. **Stimulus** — was the transaction actually legal? Back-to-back,
   boundary, and protocol timing first.
3. **DUT** — only after 1 and 2 are clean. Now it's a real find: protect it.

## 3. Localise in time, then in logic

- Find the **first** mismatch. Everything after the first divergence is
  usually fallout, not separate bugs.
- Walk backwards from the bad output: which input, which state, which
  cycle first went wrong? Waveforms are for this step, not step 1.
- Check the boring things first: reset release, clock-domain edges,
  off-by-one in counts, signed/unsigned, blocking vs non-blocking.

## 4. Write it up so it stays fixed

- The reduced test goes into regression, permanently.
- The bug report says: seed, reduced sequence, expected vs actual,
  first-bad cycle. "Test fails sometimes" is not a report.
- Add the assertion that would have caught it immediately. Every real
  bug should make the safety net stronger.

## A note on AI debug help

Log triage and failure clustering are the most mature AI uses in
verification — tools can bucket 500 regression failures into the 4 that
are actually distinct. Use them for that. But root-cause is a
context problem (spec intent, vendor IP internals, the change made last
Tuesday), and that context is exactly what the tool usually cannot see.
Verify any AI-suggested root cause against the waveform before acting
on it — a confident wrong theory costs more time than no theory.
