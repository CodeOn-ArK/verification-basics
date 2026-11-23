// sync_fifo.v - synchronous FIFO, depth 8, 8-bit data.
// Writes are ignored when full; reads are ignored when empty.
module sync_fifo (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       wr_en,
    input  wire [7:0] wr_data,
    input  wire       rd_en,
    output reg  [7:0] rd_data,
    output wire       full,
    output wire       empty,
    output wire [3:0] count
);
    reg [7:0] mem [0:7];
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] cnt;

    assign full  = (cnt == 4'd8);
    assign empty = (cnt == 4'd0);
    assign count = cnt;

    wire do_wr = wr_en && !full;
    wire do_rd = rd_en && !empty;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0; rd_ptr <= 0; cnt <= 0; rd_data <= 0;
        end else begin
            if (do_wr) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1;
            end
            if (do_rd) begin
                rd_data <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end
            case ({do_wr, do_rd})
                2'b10: cnt <= cnt + 1;
                2'b01: cnt <= cnt - 1;
                default: cnt <= cnt;
            endcase
        end
    end
endmodule
