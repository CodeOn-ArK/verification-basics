# 3 — Constrained Random & Coverage

## Why random at all?

A FIFO with 8-bit data has 256 possible write values. Add read/write
timing, full/empty states, and back-to-back bursts and the interesting
combinations number in the millions. You will hand-write maybe twenty
directed tests. Random stimulus covers the rest — *if* it is aimed.

## Constrained, not chaotic

Pure random inputs are mostly illegal or useless (invalid opcodes,
addresses that don't exist). **Constrained-random** generation says:
"pick anything — inside these rules."

```systemverilog
class fifo_txn;
  rand bit        wr_en;
  rand bit [7:0]  data;
  rand int        gap;              // idle cycles before this txn

  constraint c_mostly_writes { wr_en dist {1 := 70, 0 := 30}; }
  constraint c_small_gaps    { gap inside {[0:3]}; }
  constraint c_edge_data     { data dist {8'h00 := 5, 8'hFF := 5, [8'h01:8'hFE] := 90}; }
endclass
```

Three habits that matter:

1. **Bias toward edges.** Boundaries (0, max, full, empty, one-before-full)
   are where bugs live. Weight them.
2. **Keep constraints legal-by-construction.** If the generator can emit
   an illegal transaction, every failure needs triage: DUT bug or bad
   stimulus? Usually the latter, and it wastes days.
3. **Seed is part of the test.** Log the seed, make failures reproducible
   with that seed, and sweep seeds in regression.

## Coverage: knowing when you're done

Random without coverage is just hoping. Functional coverage defines the
space you care about and measures what you hit:

```systemverilog
covergroup fifo_cg @(posedge clk);
  cp_state : coverpoint {full, empty} {
    bins is_full  = {2'b10};
    bins is_empty = {2'b01};
  }
  cp_op : coverpoint op {
    bins write = {WRITE};
    bins read  = {READ};
    bins both  = {BOTH};
  }
  x_state_op : cross cp_state, cp_op;   // e.g. "write while full" must be hit
endgroup
```

- **Code coverage** (line/toggle/FSM) says the RTL *ran*.
- **Functional coverage** says the *scenarios* happened.
- You need both. 100% line coverage with no "write-while-full" bin hit
  means the most dangerous case was never tested.

## Coverage closure is a judgement call

The last few percent of coverage is the expensive part, and it is where
verification engineers earn their pay: is this bin unreachable (prove it,
waive it), under-constrained (fix the generator), or a real design gap
(write the directed test)? Tools — including AI coverage-closure tools —
can rank and suggest. The decision, and the waiver, are yours.
