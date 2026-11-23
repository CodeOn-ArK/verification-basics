// apb_slave.v - minimal APB slave: 4 x 32-bit registers, no wait states.
// APB phases: SETUP (PSEL=1, PENABLE=0) -> ACCESS (PSEL=1, PENABLE=1).
// With PREADY tied high, a transfer completes at the end of ACCESS.
module apb_slave (
    input  wire        pclk,
    input  wire        presetn,
    input  wire        psel,
    input  wire        penable,
    input  wire        pwrite,
    input  wire [3:0]  paddr,     // word index 0..3
    input  wire [31:0] pwdata,
    output reg  [31:0] prdata,
    output wire        pready,
    output wire        pslverr
);
    reg [31:0] regs [0:3];

    assign pready  = 1'b1;
    assign pslverr = 1'b0;

    wire access_phase = psel && penable && pready;

    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            regs[0] <= 0; regs[1] <= 0; regs[2] <= 0; regs[3] <= 0;
            prdata <= 0;
        end else if (access_phase) begin
            if (pwrite) regs[paddr] <= pwdata;
            else        prdata <= regs[paddr];
        end
    end
endmodule
