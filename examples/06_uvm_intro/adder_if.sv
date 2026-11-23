// adder_if.sv - all DUT pins in one interface.
interface adder_if (input logic clk);
    logic [7:0] a;
    logic [7:0] b;
    logic [7:0] y;
    logic       valid;   // high for one cycle: a/b are a new request
    logic       done;    // high the cycle y is the result

    clocking drv_cb @(posedge clk);
        output a, b, valid;
        input  y, done;
    endclocking

    clocking mon_cb @(posedge clk);
        input a, b, valid, y, done;
    endclocking
endinterface
