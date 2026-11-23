# 2 — Testbench Architecture

Almost every testbench, from a 50-line class exercise to a full UVM
environment, has the same five parts:

```
                 ┌────────────┐   transactions   ┌─────────┐
                 │ Generator  │ ───────────────▶ │ Driver  │ ──▶ DUT pins
                 └────────────┘                  └─────────┘
                                                       │
   DUT pins ──▶ ┌──────────┐   transactions   ┌────────────┐
                │ Monitor  │ ───────────────▶ │ Scoreboard │ ──▶ PASS / FAIL
                └──────────┘                  └────────────┘
                      │
                      └──────────────▶ Coverage
```

| Block | Job | Golden rule |
|-------|-----|-------------|
| **Generator** | Create transactions (directed or constrained-random) | Knows the *plan*, not the pins |
| **Driver** | Turn a transaction into pin wiggles, cycle by cycle | The only block allowed to drive inputs |
| **Monitor** | Watch pins, rebuild transactions from what actually happened | Passive — never drives |
| **Scoreboard** | Compare DUT behaviour against a reference model | Independent of the driver/generator logic |
| **Coverage** | Record which scenarios were exercised | Collected from the monitor, not the generator |

## Why the split matters

- **Monitor + scoreboard see reality.** If the driver has a bug and sends
  the wrong transaction, the monitor reports what was *actually* sent,
  so the scoreboard still checks the right thing.
- **Reuse.** The same monitor/scoreboard works for directed tests,
  random tests, and (later) emulation — only the generator changes.
- **UVM is just this, standardised.** Example 06 maps each block above
  to its UVM class (`uvm_driver`, `uvm_monitor`, `uvm_scoreboard`, …).
  Learn the architecture here and UVM becomes vocabulary, not magic.

## Transactions, not cycles

Work at the transaction level ("write 0xA5 to the FIFO", "read a packet")
everywhere except inside the driver and monitor. Cycle-level code
scattered through a testbench is the #1 reason testbenches become
unmaintainable.

## The self-checking rule

Every example in this repo ends with an explicit verdict:

```
PASS: 128 checks, 0 errors
FAIL: 128 checks, 3 errors   <- and the first failing case printed in full
```

If your testbench can't print that line, it isn't finished.
