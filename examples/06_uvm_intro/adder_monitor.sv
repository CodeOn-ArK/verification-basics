// adder_monitor.sv - pins -> transactions. Passive: never drives.
// It pairs each request (valid) with the result on the done cycle and
// broadcasts the completed transaction to whoever subscribes.
class adder_monitor extends uvm_monitor;
    `uvm_component_utils(adder_monitor)
    virtual adder_if vif;
    uvm_analysis_port #(adder_txn) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "monitor: no virtual interface")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            adder_txn txn;
            @(vif.mon_cb);
            if (vif.mon_cb.valid) begin
                txn = adder_txn::type_id::create("txn");
                txn.a = vif.mon_cb.a;
                txn.b = vif.mon_cb.b;
                // Result lands on the done cycle, one clock later.
                @(vif.mon_cb);
                if (!vif.mon_cb.done)
                    `uvm_error("MON", "done did not follow valid")
                txn.y = vif.mon_cb.y;
                ap.write(txn);
            end
        end
    endtask
endclass
