// fifo_assertions.sv - concurrent assertions for the example-03 FIFO.
// Needs a SystemVerilog simulator (Verilator / Questa / VCS / Xcelium).
// Bind into the DUT with the bind file below, or `include it in a TB.
//
// Read each property as a sentence. If you can't say it in English,
// you don't understand it well enough to trust it.

module fifo_assertions (
    input logic       clk,
    input logic       rst_n,
    input logic       wr_en,
    input logic       rd_en,
    input logic       full,
    input logic       empty,
    input logic [3:0] count
);
    // 1. Never full and empty at the same time.
    a_not_full_and_empty : assert property (@(posedge clk)
        !(full && empty))
        else $error("FIFO is full and empty at once");

    // 2. Count stays in range.
    a_count_range : assert property (@(posedge clk)
        count <= 4'd8)
        else $error("FIFO count out of range: %0d", count);

    // 3. Full means count == depth; empty means count == 0.
    a_full_means_8 : assert property (@(posedge clk)
        full |-> count == 4'd8);
    a_empty_means_0 : assert property (@(posedge clk)
        empty |-> count == 4'd0);

    // 4. An accepted write (not full, no simultaneous read) increments
    //    the count on the NEXT cycle.
    a_wr_increments : assert property (@(posedge clk) disable iff (!rst_n)
        (wr_en && !full && !rd_en) |=> count == $past(count) + 4'd1)
        else $error("count did not increment after accepted write");

    // 5. An accepted read (not empty, no simultaneous write) decrements.
    a_rd_decrements : assert property (@(posedge clk) disable iff (!rst_n)
        (rd_en && !empty && !wr_en) |=> count == $past(count) - 4'd1)
        else $error("count did not decrement after accepted read");

    // 6. Simultaneous accepted read+write holds the count steady.
    a_both_steady : assert property (@(posedge clk) disable iff (!rst_n)
        (wr_en && rd_en && !full && !empty) |=> count == $past(count));

    // 7. After reset, the FIFO is empty.
    a_reset_empty : assert property (@(posedge clk)
        $rose(rst_n) |-> empty);

    // Cover: prove the interesting scenarios were actually exercised.
    // (A property that never triggers can never fail - check vacuity.)
    c_write_while_full  : cover property (@(posedge clk) wr_en && full);
    c_read_while_empty  : cover property (@(posedge clk) rd_en && empty);
    c_simultaneous_rw   : cover property (@(posedge clk) wr_en && rd_en && !full && !empty);
endmodule

// Bind it to every sync_fifo instance:
// bind sync_fifo fifo_assertions u_fa (.*);
