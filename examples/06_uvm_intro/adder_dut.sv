// adder_dut.sv - registered adder. Result appears the cycle after valid.
module adder_dut (adder_if vif);
    always @(posedge vif.clk) begin
        vif.done <= vif.valid;
        if (vif.valid) vif.y <= vif.a + vif.b;
    end
endmodule
