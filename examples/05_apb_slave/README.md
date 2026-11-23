# 05 — APB Slave: Protocol Checking

**Concepts:** bus protocol phases (SETUP → ACCESS) · protocol tasks · register mirror model · data checks vs protocol checks

```bash
make
# PASS: 8 checks, 0 errors
```

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
