# 05 — APB Slave: Protocol Checking

**Concepts:** bus protocol phases (SETUP → ACCESS) · protocol tasks · register mirror model · data checks vs protocol checks

Run it on EDA Playground with Cadence Xcelium (see `../../docs/07_eda_playground.md`): DUT `apb_slave.v` in Design, `tb_apb_slave.v` in Testbench, Run — expect `PASS: 8 checks, 0 errors` in the log. Local fallback: `make` (Icarus).

Data checking alone is not protocol verification. A slave can return the
right data while violating the protocol (sampling in SETUP, changing
`PRDATA` late, ignoring `PENABLE`) — and a different master will then
fail in integration. That's why real environments add protocol
assertions next to the scoreboard; see
[`../04_assertions_sva`](../04_assertions_sva/) for the APB rules in SVA.

## Try this

1. Make the DUT register writes in the SETUP phase instead of ACCESS.
   All data checks still pass. Write down what *would* catch it.
2. Add a wait state: `PREADY` low for one cycle on reads. Fix the TB
   tasks to wait for `PREADY` — notice the tasks, not the checks, change.
