// adder_scoreboard.sv - hears only the monitor. Compares each result
// against the transaction's model(). Independent of driver + sequence:
// that separation is what makes the check mean something.
class adder_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(adder_scoreboard)
    uvm_analysis_imp #(adder_txn, adder_scoreboard) imp;
    int checks = 0, errors = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction

    function void write(adder_txn txn);
        checks++;
        if (txn.y !== txn.model()) begin
            errors++;
            `uvm_error("SCB", $sformatf("a=%0d b=%0d -> y=%0d, expected %0d",
                                        txn.a, txn.b, txn.y, txn.model()))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SCB", $sformatf("SCOREBOARD: %0d checks, %0d errors", checks, errors),
                  UVM_NONE)
    endfunction
endclass
