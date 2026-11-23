// tb_top.sv - clock, interface, DUT, and the UVM test kick-off.
module tb_top;
    import uvm_pkg::*;
    import adder_pkg::*;

    logic clk = 0;
    always #5 clk = ~clk;

    adder_if vif (clk);
    adder_dut dut (vif);

    initial begin
        vif.valid = 0; vif.a = 0; vif.b = 0;
        uvm_config_db#(virtual adder_if)::set(null, "*", "vif", vif);
        run_test("adder_test");
    end
endmodule
