// apb_assertions.sv - the APB protocol rules from example 05, as SVA.
// These catch the bugs a data scoreboard cannot: right data, wrong protocol.

module apb_assertions (
    input logic        pclk,
    input logic        presetn,
    input logic        psel,
    input logic        penable,
    input logic        pwrite,
    input logic [3:0]  paddr,
    input logic        pready
);
    // 1. ACCESS follows SETUP: if PSEL rises with PENABLE low, then
    //    next cycle PENABLE must be high (no hanging in SETUP).
    a_setup_then_access : assert property (@(posedge pclk) disable iff (!presetn)
        (psel && !penable) |=> penable)
        else $error("APB: SETUP not followed by ACCESS");

    // 2. Address, direction and select stay stable from SETUP to ACCESS.
    a_stable_setup_to_access : assert property (@(posedge pclk) disable iff (!presetn)
        (psel && !penable) |=> (paddr == $past(paddr) && pwrite == $past(pwrite) && psel))
        else $error("APB: PADDR/PWRITE/PSEL changed between SETUP and ACCESS");

    // 3. PENABLE is never high without PSEL.
    a_penable_needs_psel : assert property (@(posedge pclk)
        penable |-> psel)
        else $error("APB: PENABLE high without PSEL");

    // 4. A completed transfer (ACCESS + PREADY) is followed by either
    //    a new SETUP (PENABLE low) or idle (PSEL low).
    a_access_completes : assert property (@(posedge pclk) disable iff (!presetn)
        (psel && penable && pready) |=> (!penable || !psel))
        else $error("APB: PENABLE held high after completed transfer");
endmodule
