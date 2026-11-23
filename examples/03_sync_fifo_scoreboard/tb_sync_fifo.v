// tb_sync_fifo.v - scoreboard testbench.
// Lesson: the reference model is a simple queue in the testbench.
// Every accepted read is compared against the oldest queued write.
// Full/empty/count are checked EVERY cycle, not just at the end.
`timescale 1ns/1ps
module tb_sync_fifo;
    reg clk = 0, rst_n = 0, wr_en = 0, rd_en = 0;
    reg  [7:0] wr_data = 0;
    wire [7:0] rd_data;
    wire full, empty;
    wire [3:0] count;

    integer checks = 0, errors = 0;
    always #5 clk = ~clk;

    sync_fifo dut (.clk(clk), .rst_n(rst_n), .wr_en(wr_en), .wr_data(wr_data),
                   .rd_en(rd_en), .rd_data(rd_data), .full(full),
                   .empty(empty), .count(count));

    // Reference queue (circular buffer in the TB)
    reg [7:0] q [0:63];
    integer q_head = 0, q_tail = 0, q_cnt = 0;

    // One cycle: inputs must already be driven; evaluate after the edge.
    task cycle;
        reg do_wr, do_rd;
        reg [7:0] exp_rd;
        begin
            do_wr = wr_en && (q_cnt < 8);
            do_rd = rd_en && (q_cnt > 0);
            exp_rd = q[q_head % 64];
            @(posedge clk); #1;
            if (do_wr) begin q[q_tail % 64] = wr_data; q_tail = q_tail + 1; end
            if (do_rd) begin q_head = q_head + 1; end
            q_cnt = q_cnt + (do_wr ? 1 : 0) - (do_rd ? 1 : 0);

            checks = checks + 1;
            if (do_rd && rd_data !== exp_rd) begin
                errors = errors + 1;
                $display("ERROR @%0t: rd_data=%0d exp %0d", $time, rd_data, exp_rd);
            end
            if (count !== q_cnt[3:0] || full !== (q_cnt == 8) || empty !== (q_cnt == 0)) begin
                errors = errors + 1;
                $display("ERROR @%0t: count=%0d (exp %0d) full=%b empty=%b",
                         $time, count, q_cnt, full, empty);
            end
            @(negedge clk);
            wr_en = 0; rd_en = 0; wr_data = 0;
        end
    endtask

    task write1; input [7:0] d; begin wr_en = 1; wr_data = d; cycle; end endtask
    task read1; begin rd_en = 1; cycle; end endtask
    task both1; input [7:0] d; begin wr_en = 1; wr_data = d; rd_en = 1; cycle; end endtask

    integer i;
    reg [7:0] rand_data;
    initial begin
        repeat (2) @(posedge clk); #1;
        checks = checks + 1;
        if (!empty || count !== 0) begin errors = errors + 1; $display("ERROR: not empty after reset"); end
        @(negedge clk); rst_n = 1;

        // Fill to full, then try to write while full (must be ignored).
        for (i = 0; i < 8; i = i + 1) write1(i * 8'd11);
        write1(8'hEE); write1(8'hDD);

        // Simultaneous read+write while full: read frees a slot, write
        // is only accepted if the DUT allows it when not full at the edge.
        // Our DUT gates writes with !full, so this write is dropped and
        // the model (same rule) stays in lock-step.
        both1(8'h99);

        // Drain to empty, then read while empty (must be ignored).
        for (i = 0; i < 8; i = i + 1) read1;
        read1; read1;

        // Random phase: biased mix, model keeps score.
        for (i = 0; i < 500; i = i + 1) begin
            rand_data = $random;
            case ($random % 4)
                0: read1;
                1: both1(rand_data);
                default: write1(rand_data);
            endcase
        end

        if (errors == 0) $display("PASS: %0d checks, 0 errors", checks);
        else             $display("FAIL: %0d checks, %0d errors", checks, errors);
        $finish;
    end
endmodule
