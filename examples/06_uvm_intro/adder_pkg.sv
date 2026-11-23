// adder_pkg.sv - pull the UVM library and all classes into one package.
package adder_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "adder_txn.sv"
    `include "adder_driver.sv"
    `include "adder_monitor.sv"
    `include "adder_scoreboard.sv"
    `include "adder_agent_env_test.sv"
endpackage
