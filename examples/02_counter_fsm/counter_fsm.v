// counter_fsm.v - up/down counter with a small control FSM.
// States: IDLE -> RUN -> (PAUSE <-> RUN) -> DONE when count hits terminal.
module counter_fsm (
    input  wire       clk,
    input  wire       rst_n,     // async assert, sync release style (active low)
    input  wire       start,
    input  wire       pause,
    input  wire       up,        // 1 = count up, 0 = count down
    input  wire [3:0] terminal,  // target count in RUN
    output reg  [3:0] count,
    output reg        done
);
    localparam IDLE = 2'd0, RUN = 2'd1, PAUSE = 2'd2, DONE = 2'd3;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; count <= 4'd0; done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0; count <= 4'd0;
                    if (start) state <= RUN;
                end
                RUN: begin
                    if (pause) begin
                        state <= PAUSE;
                    end else if (count == terminal) begin
                        state <= DONE; done <= 1'b1;   // hold at terminal
                    end else begin
                        count <= up ? count + 4'd1 : count - 4'd1;
                    end
                end
                PAUSE: begin
                    if (!pause) state <= RUN;
                end
                DONE: begin
                    if (start) begin state <= RUN; count <= 4'd0; done <= 1'b0; end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
