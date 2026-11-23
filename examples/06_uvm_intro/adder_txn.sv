// adder_txn.sv - the transaction: one add request + its expected result.
class adder_txn extends uvm_sequence_item;
    rand bit [7:0] a;
    rand bit [7:0] b;
         bit [7:0] y;   // filled in by the monitor

    // Bias toward edge values - the docs/03 habit, in constraint form.
    constraint c_edges {
        a dist {8'h00 := 5, 8'hFF := 5, [8'h01:8'hFE] := 90};
        b dist {8'h00 := 5, 8'hFF := 5, [8'h01:8'hFE] := 90};
    }

    `uvm_object_utils_begin(adder_txn)
        `uvm_field_int(a, UVM_ALL_ON)
        `uvm_field_int(b, UVM_ALL_ON)
        `uvm_field_int(y, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "adder_txn");
        super.new(name);
    endfunction

    // The reference model lives with the transaction.
    function bit [7:0] model();
        return a + b;
    endfunction
endclass
