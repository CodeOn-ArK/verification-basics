// buggy_alu.v - same spec as examples/01. One operation is wrong.
// Spec: 0=ADD 1=SUB(a-b) 2=AND 3=OR 4=XOR 5=SHL 6=SHR 7=PASS_A
module buggy_alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,
    output reg  [7:0] y,
    output wire       zero
);
    always @* begin
        case (op)
            3'd0: y = a + b;
            3'd1: y = b - a;      // <-- is this the bug? prove it with a test.
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
