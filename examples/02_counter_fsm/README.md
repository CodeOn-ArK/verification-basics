# 02 — Counter + FSM

**Concepts:** clocked checking · reset (including mid-run) · state-dependent behaviour · pause/freeze

Run it on EDA Playground with Cadence Xcelium (see `../../docs/07_eda_playground.md`): DUT `counter_fsm.v` in Design, `tb_counter_fsm.v` in Testbench, Run — expect `PASS: 16 checks, 0 errors` in the log. Local fallback: `make` (Icarus).

## Try this

1. The testbench checks `count` *after* each edge with a `#1` delay.
   Move the check to before the edge. What breaks, and why does sampling
   discipline matter more than the check itself?
2. Add a down-counting test (`up = 0`) ending at terminal. Careful:
   what is "terminal" when counting down, and does the DUT's compare
   still work? Write the test from the *spec you intend*, then argue
   with what the RTL does.
3. Assert reset in the middle of PAUSE. Add the check.
