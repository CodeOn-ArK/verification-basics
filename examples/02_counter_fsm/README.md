# 02 — Counter + FSM

**Concepts:** clocked checking · reset (including mid-run) · state-dependent behaviour · pause/freeze

```bash
make
# PASS: 16 checks, 0 errors
```

## Try this

1. The testbench checks `count` *after* each edge with a `#1` delay.
   Move the check to before the edge. What breaks, and why does sampling
   discipline matter more than the check itself?
2. Add a down-counting test (`up = 0`) ending at terminal. Careful:
   what is "terminal" when counting down, and does the DUT's compare
   still work? Write the test from the *spec you intend*, then argue
   with what the RTL does.
3. Assert reset in the middle of PAUSE. Add the check.
