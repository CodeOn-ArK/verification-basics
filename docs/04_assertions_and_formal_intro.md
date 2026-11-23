# 4 — Assertions & a Formal Intro

An assertion is a check that lives next to the design and fires the
moment a rule is broken — not at the end of a test, not if someone
remembered to call it.

## Immediate vs concurrent

```systemverilog
// Immediate: procedural, like an if with teeth
always_comb begin
  a_onehot : assert ($onehot(state)) else $error("state not one-hot: %b", state);
end

// Concurrent: temporal, checked on a clock — "this implies that, next cycle"
a_no_overflow : assert property (@(posedge clk)
  (wr_en && !full) |=> (count == $past(count) + 1))
  else $error("count did not increment on accepted write");
```

## The three temporal ideas you need

| Operator | Meaning |
|----------|---------|
| `a \|-> b` | Same cycle: if `a`, then `b` must hold now |
| `a \|=> b` | Next cycle: if `a`, then `b` must hold one cycle later |
| `a ##n b` | Sequence: `b` occurs `n` cycles after `a` |

And the past: `$past(sig)` is the value last cycle, `$rose`/`$fell` catch
edges. With those, 90% of useful properties are a few lines.

## What assertions are good at

- **Interfaces:** a grant only follows a request; `valid` stays up until `ready`.
- **Invariants:** a FIFO is never both full and empty; a one-hot stays one-hot.
- **Never-events:** no write while full, no read while empty, no X on outputs after reset.
- **Cause → effect:** an accepted write increments the count next cycle.

## Where formal fits

Simulation checks the scenarios you stimulated. **Formal verification**
proves a property for *all* inputs, by mathematics — or hands you a
counterexample waveform showing exactly how it breaks.

- Assertions are the currency of both: the same SVA runs in simulation
  and in a formal tool (Jasper, VC Formal, Questa Formal, SymbiYosys).
- Formal shines on bounded, rule-like logic: arbiters, FIFOs, protocol
  bridges, control FSMs. It struggles on huge datapaths without help
  (abstraction, decomposition, assume-guarantee).
- Formal does not replace intent. A property that doesn't capture the
  real requirement proves the wrong thing, perfectly.

Practical start: take the assertions from
[`examples/04_assertions_sva`](../examples/04_assertions_sva/), run them
in simulation first, then point a formal tool at the FIFO and ask it to
prove `never full && empty at once`.

## AI and assertions

LLMs draft plausible assertions — benchmarks put functionally-correct
assertion generation at roughly half of attempts. Treat every generated
property as a draft: ask "could this pass while the design is wrong?"
(vacuity), and "could this fail while the design is right?" (over-strict).
A vacuous assertion is worse than none — it looks like coverage.
