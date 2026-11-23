# Verification Basics

A hands-on introduction to functional verification of digital hardware —
from a first self-checking testbench to scoreboards, constrained-random
stimulus, assertions, functional coverage, and a minimal UVM environment.

Everything here is written to be **read, run, and broken on purpose**.
Verification is learned by catching bugs, not by reading about them.

> Rule of the repo: *the model suggests, the checker decides.*
> Never trust a test that cannot fail.

## Start here

| Step | Folder | What you learn |
|------|--------|----------------|
| 1 | [`01_alu_self_checking`](examples/01_alu_self_checking/) | Directed tests, a golden reference model, self-checking |
| 2 | [`02_counter_fsm`](examples/02_counter_fsm/) | Sequential logic, reset behaviour, FSM state checks |
| 3 | [`03_sync_fifo_scoreboard`](examples/03_sync_fifo_scoreboard/) | Scoreboard + queue reference model, constrained-random stimulus, error injection |
| 4 | [`04_assertions_sva`](examples/04_assertions_sva/) | SystemVerilog Assertions: properties, sequences, immediate vs concurrent |
| 5 | [`05_apb_slave`](examples/05_apb_slave/) | Protocol checking on a real bus (APB), tasks, protocol assertions |
| 6 | [`06_uvm_intro`](examples/06_uvm_intro/) | The same ideas, organised as UVM: agent, driver, monitor, scoreboard, env |

## Concepts (short, no fluff)

- [`docs/01_verification_mindset.md`](docs/01_verification_mindset.md) — why verification is ~60–70% of a chip project
- [`docs/02_testbench_architecture.md`](docs/02_testbench_architecture.md) — generator, driver, monitor, scoreboard, coverage
- [`docs/03_constrained_random_and_coverage.md`](docs/03_constrained_random_and_coverage.md) — random with intent, and knowing when you're done
- [`docs/04_assertions_and_formal_intro.md`](docs/04_assertions_and_formal_intro.md) — SVA and where formal fits
- [`docs/05_debugging.md`](docs/05_debugging.md) — a workflow for when a test fails
- [`docs/06_checklist.md`](docs/06_checklist.md) — verification plan + sign-off checklist you can copy

## Exercises

[`exercises/`](exercises/) — each one ships a buggy DUT. Your job is to
write the checker that catches the bug, *then* look at the solution.

## Running the examples

Most examples run with the open-source [Icarus Verilog](https://steveicarus.github.io/iverilog/):

```bash
cd examples/01_alu_self_checking
make        # compiles, runs, prints PASS/FAIL
make wave   # optional: dump waves (open with GTKWave / Surfer)
```

Examples 04 and 06 use fuller SystemVerilog (SVA / UVM) and need a
SystemVerilog simulator (Verilator, Questa, VCS, or Xcelium). Each folder's
README says exactly what it needs and what output to expect.

## Layout

```
docs/        concepts, in reading order
examples/    runnable, self-checking examples, in learning order
exercises/   buggy DUTs — catch the bug yourself first
```

## Who this is for

Students and early-career engineers moving into design verification (DV).
It assumes you can read basic Verilog/SystemVerilog and know what a clock,
a reset, and a register are. It does not assume UVM.

---

By Saheb Panda · MIT License
