SIM ?= iverilog
all: run
build:
	$(SIM) -o sim.vvp sync_fifo.v tb_sync_fifo.v
run: build
	vvp sim.vvp
clean:
	rm -f sim.vvp dump.vcd
.PHONY: all run clean
