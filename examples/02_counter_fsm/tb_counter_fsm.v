// tb_counter_fsm.v - sequential checking: reset, state, terminal, pause.
// Lesson: sample AFTER the edge, model expected count in the testbench,
// and check invariants every cycle (count only moves in RUN, done only
// in DONE).
`timescale 1ns/1ps
module tb_counter_fsm;
    reg clk = 0, rst_n = 0, start = 0, pause = 0, up = 1;
    reg [3:0] terminal = 4'd5;
    wire [3:0] count;
    wire done;

    integer checks = 0, errors = 0;
    always #5 clk = ~clk;

    counter_fsm dut (.clk(clk), .rst_n(rst_n), .start(start), .pause(pause),
                     .up(up), .terminal(terminal), .count(count), .done(done));

    task check_state;
        input [3:0] exp_count;
        input       exp_done;
        begin
            checks = checks + 1;
            if (count !== exp_count || done !== exp_done) begin
                errors = errors + 1;
                $display("ERROR @%0t: count=%0d (exp %0d) done=%b (exp %b)",
                         $time, count, exp_count, done, exp_done);
            end
        end
    endtask

    task step;  // advance one clock, then check
        input [3:0] exp_count;
        input       exp_done;
        begin @(posedge clk); #1; check_state(exp_count, exp_done); end
    endtask

    initial begin
        // Reset behaviour: outputs known, count 0.
        repeat (2) @(posedge clk); #1;
        check_state(4'd0, 1'b0);
        rst_n = 1;

        // IDLE holds at 0 until start.
        step(4'd0, 1'b0);

        // RUN up to terminal=5: count visible after each edge.
        start = 1; step(4'd0, 1'b0);   // IDLE->RUN, count still 0
        start = 0;
        step(4'd1, 1'b0); step(4'd2, 1'b0);

        // PAUSE freezes the count.
        pause = 1; step(4'd2, 1'b0); step(4'd2, 1'b0);
        pause = 0; step(4'd2, 1'b0);   // PAUSE->RUN, no count yet

        step(4'd3, 1'b0); step(4'd4, 1'b0); step(4'd5, 1'b0);
        step(4'd5, 1'b1);              // count==terminal -> DONE, done=1

        // Mid-run reset: the case directed tests forget.
        start = 1; step(4'd0, 1'b0); start = 0;
        step(4'd1, 1'b0);
        rst_n = 0; #1; check_state(4'd0, 1'b0);
        rst_n = 1; step(4'd0, 1'b0);

        if (errors == 0) $display("PASS: %0d checks, 0 errors", checks);
        else             $display("FAIL: %0d checks, %0d errors", checks, errors);
        $finish;
    end
endmodule
