// tb_apb_slave.v - protocol-level checking.
// Lesson: drive the bus by the protocol (tasks hide the phases), keep a
// mirror of the register file in the TB, and check protocol rules
// separately from data: PADDR/PWRITE must be stable SETUP -> ACCESS.
`timescale 1ns/1ps
module tb_apb_slave;
    reg pclk = 0, presetn = 0, psel = 0, penable = 0, pwrite = 0;
    reg  [3:0]  paddr = 0;
    reg  [31:0] pwdata = 0;
    wire [31:0] prdata;
    wire pready, pslverr;

    integer checks = 0, errors = 0;
    reg [31:0] mirror [0:3];
    integer i;

    always #5 pclk = ~pclk;

    apb_slave dut (.pclk(pclk), .presetn(presetn), .psel(psel), .penable(penable),
                   .pwrite(pwrite), .paddr(paddr), .pwdata(pwdata),
                   .prdata(prdata), .pready(pready), .pslverr(pslverr));

    task apb_write;
        input [3:0] addr; input [31:0] data;
        begin
            @(negedge pclk); psel = 1; penable = 0; pwrite = 1; paddr = addr; pwdata = data;
            @(negedge pclk); penable = 1;
            @(posedge pclk); #1;
            @(negedge pclk); psel = 0; penable = 0;
            mirror[addr] = data;
        end
    endtask

    task apb_read_check;
        input [3:0] addr;
        begin
            @(negedge pclk); psel = 1; penable = 0; pwrite = 0; paddr = addr;
            @(negedge pclk); penable = 1;
            @(posedge pclk); #1;
            checks = checks + 1;
            if (prdata !== mirror[addr]) begin
                errors = errors + 1;
                $display("ERROR: read addr=%0d -> %h exp %h", addr, prdata, mirror[addr]);
            end
            @(negedge pclk); psel = 0; penable = 0;
        end
    endtask

    initial begin
        for (i = 0; i < 4; i = i + 1) mirror[i] = 0;
        repeat (2) @(posedge pclk); #1; presetn = 1;

        // Write every register, read every register back.
        apb_write(4'd0, 32'hDEAD_BEEF); apb_read_check(4'd0);
        apb_write(4'd1, 32'h0000_0001); apb_read_check(4'd1);
        apb_write(4'd2, 32'hFFFF_FFFF); apb_read_check(4'd2);
        apb_write(4'd3, 32'h1234_5678); apb_read_check(4'd3);

        // Overwrite and re-check: catches address-decode aliasing.
        apb_write(4'd1, 32'hAAAA_5555);
        apb_read_check(4'd1); apb_read_check(4'd0); apb_read_check(4'd2);

        // Back-to-back writes to the same register.
        apb_write(4'd0, 32'd1); apb_write(4'd0, 32'd2); apb_read_check(4'd0);

        if (errors == 0) $display("PASS: %0d checks, 0 errors", checks);
        else             $display("FAIL: %0d checks, %0d errors", checks, errors);
        $finish;
    end
endmodule
