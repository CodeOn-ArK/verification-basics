# 03 — Synchronous FIFO + Scoreboard

**Concepts:** reference queue · scoreboard checking every cycle · full/empty boundaries · write-while-full / read-while-empty · simultaneous read+write · random phase with a model keeping score

Run it on EDA Playground with Cadence Xcelium (see `../../docs/07_eda_playground.md`): DUT `sync_fifo.v` in Design, `tb_sync_fifo.v` in Testbench, Run — expect `PASS: 522 checks, 0 errors` in the log. Local fallback: `make` (Icarus).

The important design decision is in the TB, not the DUT: the model
applies the *same acceptance rule the spec states* (a write counts only
if the FIFO is not full at that edge). Spec rule first, RTL second —
if you copy the RTL's rule into the model without thinking, you have
verified nothing.

## Try this

1. Change the DUT so a write *is* accepted when full and a simultaneous
   read happens (a common "optimisation"). The scoreboard fails — is
   the DUT wrong, or the spec? This argument is real verification work.
2. Break the DUT's `count` update for simultaneous read+write. Which
   check fires first: data or count?
3. See `fifo_txn_sv.sv` for the same stimulus written as a SystemVerilog
   constrained-random class (for simulators with class support).
