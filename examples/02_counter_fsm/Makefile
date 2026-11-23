SIM ?= iverilog
all: run
build:
	$(SIM) -o sim.vvp counter_fsm.v tb_counter_fsm.v
run: build
	vvp sim.vvp
clean:
	rm -f sim.vvp dump.vcd
.PHONY: all run clean
