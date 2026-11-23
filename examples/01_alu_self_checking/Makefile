SIM ?= iverilog
all: run
build:
	$(SIM) -o sim.vvp alu.v tb_alu.v
run: build
	vvp sim.vvp
wave: build
	vvp sim.vvp -vcd
clean:
	rm -f sim.vvp dump.vcd
.PHONY: all run wave clean
