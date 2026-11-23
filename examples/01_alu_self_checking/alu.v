// alu.v - simple 8-bit ALU. The DUT under test in example 01.
module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,      // 0=ADD 1=SUB 2=AND 3=OR 4=XOR 5=SHL 6=SHR 7=PASS_A
    output reg  [7:0] y,
    output wire       zero
);
    always @* begin
        case (op)
            3'd0: y = a + b;
            3'd1: y = a - b;
            3'd2: y = a & b;
            3'd3: y = a | b;
            3'd4: y = a ^ b;
            3'd5: y = a << 1;
            3'd6: y = a >> 1;
            default: y = a;
        endcase
    end
    assign zero = (y == 8'd0);
endmodule
