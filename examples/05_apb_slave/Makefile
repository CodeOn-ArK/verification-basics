SIM ?= iverilog
all: run
build:
	$(SIM) -o sim.vvp apb_slave.v tb_apb_slave.v
run: build
	vvp sim.vvp
clean:
	rm -f sim.vvp dump.vcd
.PHONY: all run clean
