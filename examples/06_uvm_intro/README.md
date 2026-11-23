# 06 — UVM Intro: The Same Architecture, Standardised

UVM is not a different way of thinking. It is example 02's architecture
with standard class names, a factory, and a phase system:

| Testbench block (docs/02) | UVM class |
|---------------------------|-----------|
| Generator | `uvm_sequence` + `uvm_sequencer` |
| Driver | `uvm_driver` |
| Monitor | `uvm_monitor` |
| Scoreboard | `uvm_scoreboard` |
| (glue + config) | `uvm_agent`, `uvm_env`, `uvm_test` |

Files, in reading order:

1. `adder_if.sv` — the interface: pins + clocking, in one place
2. `adder_txn.sv` — the transaction (`uvm_sequence_item`)
3. `adder_driver.sv` — transaction → pins
4. `adder_monitor.sv` — pins → transaction, broadcasts on an analysis port
5. `adder_scoreboard.sv` — subscribes, compares against the model
6. `adder_agent_env_test.sv` — agent, env, sequence, and test

The DUT is the example-01 ALU restricted to ADD — deliberately boring.
The point is the structure; the checking idea (compare against an
independent model) is exactly the one from example 01.

## Running it

Primary: EDA Playground with Cadence Xcelium and the UVM 1.2 library
selected (see `../../docs/07_eda_playground.md` for the per-file setup).

It also runs on any UVM-capable simulator (Questa, VCS, Xcelium;
Verilator does not ship UVM):

```bash
# Questa example:
vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv \
     adder_if.sv adder_pkg.sv tb_top.sv
vsim -c tb_top -do "run -all; quit"
# Expected: UVM_INFO ... SCOREBOARD: 50 checks, 0 errors
#           UVM Report Summary: UVM_ERROR : 0
```

## What to notice

- The scoreboard never talks to the driver. It only hears the monitor.
  That separation is the whole game (docs/02).
- The sequence decides *what* happens; the driver decides *how it
  wiggles pins*. Swap the sequence, keep everything else: directed test
  → random test with zero driver changes.
- Configuration (`uvm_config_db`) is how the virtual interface reaches
  the driver/monitor from the top. It's clunky. It's also how every
  real environment does it.
