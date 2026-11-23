# 1 — The Verification Mindset

Design asks: *"How do I build this?"*
Verification asks: *"How could this be wrong?"*

That second question is most of the job. The Wilson Research Group study
(Siemens EDA, 2024) puts functional verification at roughly **60–70% of
total ASIC project effort**, debug at ~47% of a verification engineer's
time, and first-silicon success at only ~14% of projects. Chips do not
fail because nobody wrote the RTL. They fail because nobody proved the
RTL right.

## The four ideas everything else builds on

1. **A test that cannot fail proves nothing.**
   A testbench that prints "done" is not verification. Every test needs a
   checker with an opinion: an expected value, a property, a rule.

2. **Separate stimulus from checking.**
   The code that drives inputs and the code that judges outputs must be
   independent. If the same (possibly wrong) understanding generates both,
   they agree on the wrong answer and the bug sails through.

3. **The reference model is the spec, in code.**
   A golden model — often just a queue, an array, or a few lines of
   arithmetic — states what *should* happen. The scoreboard compares DUT
   vs. model on every transaction. When they disagree, one of them is
   wrong, and finding out which is the real work.

4. **Random finds what you didn't think of; coverage tells you what you missed.**
   Directed tests check what you already suspect. Constrained-random
   stimulus explores combinations you would never hand-write — and
   functional coverage measures which parts of the space you actually hit.

## Verification is not "running tests"

A verification plan answers, before any code:

- What are the features and corner cases? (overflow, back-to-back
  transactions, reset mid-transfer, empty/full boundaries…)
- How will each one be stimulated?
- How will each one be *checked* — scoreboard, assertion, or both?
- What coverage proves it was actually exercised?

See [`06_checklist.md`](06_checklist.md) for a copyable version.

## Where AI fits (honestly)

Modern AI tools are good at drafting boilerplate: testbench skeletons,
first-pass assertions, log triage. They are weak at exactly the parts
above — deciding intent, building a trustworthy checker, and judging
whether a failure matters. Independent benchmarks agree: in NVIDIA's
CVDP benchmark, a leading model scored ~25% on stimulus generation,
~19% on assertions, and ~6% on testbench checkers.

So learn the checker first. Then let tools draft the rest — and review
their output the way you'd review anyone else's: by trying to break it.
