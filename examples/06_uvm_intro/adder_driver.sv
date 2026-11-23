// adder_driver.sv - transaction -> pins. The ONLY block that drives.
class adder_driver extends uvm_driver #(adder_txn);
    `uvm_component_utils(adder_driver)
    virtual adder_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "driver: no virtual interface")
    endfunction

    task run_phase(uvm_phase phase);
        vif.drv_cb.valid <= 0;
        forever begin
            adder_txn txn;
            seq_item_port.get_next_item(txn);
            @(vif.drv_cb);
            vif.drv_cb.a     <= txn.a;
            vif.drv_cb.b     <= txn.b;
            vif.drv_cb.valid <= 1;
            @(vif.drv_cb);
            vif.drv_cb.valid <= 0;
            seq_item_port.item_done();
        end
    endtask
endclass
