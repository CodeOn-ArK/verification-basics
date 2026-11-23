# 7 — Running Everything on EDA Playground (Cadence Xcelium)

This repo is written for [EDA Playground](https://www.edaplayground.com)
with **Cadence Xcelium** as the simulator. Nothing to install, and the
same flow runs every example — including the SVA and UVM ones, which
open-source simulators can't run.

## One clarification first

Cadence **Virtuoso** is a schematic/layout tool — it is not a logic
simulator and it is not on EDA Playground. The Cadence *simulator* on
EDA Playground is **Xcelium**. When this repo says "Cadence", it means
Xcelium on EDA Playground (the same engine you use in a real Cadence
flow). If you later run these files in Virtuoso-adjacent flows, the
simulation part still goes through Xcelium.

## Setup (once)

1. Open [edaplayground.com](https://www.edaplayground.com) and sign in
   (a free registered account unlocks the commercial simulators,
   including Xcelium).
2. Language: **Verilog / SystemVerilog**
3. Tools: **Cadence Xcelium** — pick the newest version listed
   (the examples were written against Xcelium 20.09-era behaviour).
4. Options: tick **EPWave** if you want to look at waveforms after
   a failure (off by default is fine for a PASS/FAIL run).

## Running an example (same steps every time)

1. Open the example folder. The DUT file(s) go in the **Design** window
   (right), the testbench file(s) in the **Testbench** window (left).
   Multi-file examples: add every file from the folder to the
   playground and keep the testbench top module as the run target —
   see the per-example table below.
2. Hit **Run**.
3. Read the log. Every example prints one verdict line:

```
PASS: 207 checks, 0 errors
```

If it prints `FAIL`, the first `ERROR:` line in the log is the case to
investigate — see [docs/05_debugging.md](05_debugging.md).

## Per-example setup

| Example | Design window | Testbench window | Extra setting |
|---------|---------------|------------------|---------------|
| 01 ALU | `alu.v` | `tb_alu.v` | — |
| 02 Counter/FSM | `counter_fsm.v` | `tb_counter_fsm.v` | — |
| 03 FIFO scoreboard | `sync_fifo.v` | `tb_sync_fifo.v` | — (`fifo_txn_sv.sv` is reference-only SV class code, don't paste it) |
| 04 SVA | `../03_sync_fifo_scoreboard/sync_fifo.v` (or the APB DUT from 05) | `fifo_assertions.sv` / `apb_assertions.sv` + a testbench that instantiates the DUT | Assertions run in-simulation; also try the `cover` properties to check for vacuity |
| 05 APB slave | `apb_slave.v` | `tb_apb_slave.v` | — |
| 06 UVM intro | `adder_dut.sv`, `adder_if.sv`, `adder_pkg.sv` and the `adder_*.sv` classes | `tb_top.sv` | **UVM library: UVM 1.2** (or IEEE 1800.2-2017) — without it, `uvm_pkg` won't resolve |

## Things that bite on EDA Playground

- **Top module:** the testbench module (`tb_*`, or `tb_top` for UVM)
  must be the top. If Xcelium elaborates the DUT as top, you get a
  run with no stimulus and no verdict.
- **`$finish`:** all testbenches here call `$finish`, so the run ends
  cleanly instead of hanging on a free-running clock.
- **Random seeds:** `$random` without a seed uses the simulator's
  default. On Xcelium, use the run options / `+ntb_random_seed` if you
  want a different seed per run; note the seed in any bug report.
- **Waves:** EPWave shows only what the testbench dumps. If a signal is
  missing from the wave viewer, it's a dump problem, not a DUT problem.
- **UVM verbosity:** the UVM run prints a lot of `UVM_INFO`. The line
  that matters is the scoreboard's `SCOREBOARD: 50 checks, 0 errors`
  and the report summary (`UVM_ERROR : 0`).

## Local fallback

Examples 01, 02, 03 and 05 also run under Icarus Verilog
(`make` in each folder). Examples 04 and 06 do not — they need full
SystemVerilog, so use Xcelium for those.
