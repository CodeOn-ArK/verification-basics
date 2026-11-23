# 04 — Assertions (SVA)

**Concepts:** concurrent assertions · `|->` vs `|=>` · `$past` · `disable iff` · cover properties and vacuity

Needs a SystemVerilog simulator — Icarus Verilog does not support
concurrent SVA. Use Verilator, Questa, VCS, or Xcelium:

```bash
# example (Questa):
vlog -sv ../03_sync_fifo_scoreboard/sync_fifo.v fifo_assertions.sv your_tb.sv
```

Two files:

- `fifo_assertions.sv` — properties for the example-03 FIFO: invariants,
  count arithmetic after accepted reads/writes, reset behaviour, plus
  **cover properties** for write-while-full, read-while-empty, and
  simultaneous read+write.
- `apb_assertions.sv` — the APB protocol rules from example 05, in SVA:
  SETUP→ACCESS sequencing and signal stability. These are the checks
  that catch "right data, wrong protocol."

## The vacuity trap

An assertion with an antecedent that never becomes true **passes
forever and checks nothing**. That's why every assertion file here
ships cover properties for its antecedents. In a formal tool, ask for
a vacuity report; in simulation, check the covers were hit.

## Try this

1. Write the FIFO property "data read out equals data written in,
   in order" in SVA. Notice why you can't — order across many cycles
   needs a model, not a property. That's the scoreboard's job, and
   knowing which tool fits which check is the skill.
2. Break the FIFO so count increments by 2 on a write. Which
   properties fire? How many cycles after the bug?
