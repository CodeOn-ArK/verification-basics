// fifo_txn_sv.sv - the random phase of tb_sync_fifo, written the
// SystemVerilog class way. Reference only: needs a simulator with
// class / constraint support (Verilator, Questa, VCS, Xcelium).
class fifo_txn;
    typedef enum {WRITE, READ, BOTH, IDLE} op_e;

    rand op_e      op;
    rand bit [7:0] data;
    rand int       gap;   // idle cycles before this transaction

    // Bias toward writes (fill it up) and toward edge data values.
    constraint c_op  { op dist {WRITE := 45, READ := 30, BOTH := 20, IDLE := 5}; }
    constraint c_dat { data dist {8'h00 := 5, 8'hFF := 5, [8'h01:8'hFE] := 90}; }
    constraint c_gap { gap inside {[0:3]}; }

    function string sprint();
        return $sformatf("op=%s data=0x%0h gap=%0d", op.name(), data, gap);
    endfunction
endclass
