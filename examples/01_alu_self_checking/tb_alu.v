// tb_alu.v - self-checking testbench.
// Lesson: a golden reference model + a check task. Every stimulus is
// judged. Directed edge cases first, then $random for volume.
`timescale 1ns/1ps
module tb_alu;
    reg  [7:0] a, b;
    reg  [2:0] op;
    wire [7:0] y;
    wire       zero;

    integer checks = 0;
    integer errors = 0;

    alu dut (.a(a), .b(b), .op(op), .y(y), .zero(zero));

    // Golden model: the spec, restated independently of the RTL.
    function [7:0] model;
        input [7:0] ma, mb;
        input [2:0] mop;
        begin
            case (mop)
                3'd0: model = ma + mb;
                3'd1: model = ma - mb;
                3'd2: model = ma & mb;
                3'd3: model = ma | mb;
                3'd4: model = ma ^ mb;
                3'd5: model = ma << 1;
                3'd6: model = ma >> 1;
                default: model = ma;
            endcase
        end
    endfunction

    task check;
        input [7:0] ta, tb_in;
        input [2:0] top;
        reg [7:0] exp;
        begin
            a = ta; b = tb_in; op = top;
            #1;  // combinational settle
            exp = model(ta, tb_in, top);
            checks = checks + 1;
            if (y !== exp || zero !== (exp == 8'd0)) begin
                errors = errors + 1;
                $display("ERROR: a=%0d b=%0d op=%0d -> y=%0d (exp %0d) zero=%b",
                         ta, tb_in, top, y, exp, zero);
            end
        end
    endtask

    integer i;
    initial begin
        // Directed edge cases: where bugs actually live.
        check(8'd0,   8'd0,   3'd0);   // 0+0, zero flag
        check(8'd255, 8'd1,   3'd0);   // overflow wraps to 0
        check(8'd0,   8'd1,   3'd1);   // underflow wraps to 255
        check(8'd128, 8'd0,   3'd5);   // shift out the MSB
        check(8'd1,   8'd0,   3'd6);   // shift to zero
        check(8'hAA,  8'h55,  3'd4);   // XOR pattern
        check(8'hFF,  8'hFF,  3'd2);   // AND all-ones

        // Random volume: every op, random operands.
        for (i = 0; i < 200; i = i + 1)
            check($random, $random, $random);

        if (errors == 0) $display("PASS: %0d checks, 0 errors", checks);
        else             $display("FAIL: %0d checks, %0d errors", checks, errors);
        $finish;
    end
endmodule
