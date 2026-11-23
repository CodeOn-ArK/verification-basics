// adder_agent_env_test.sv - agent (driver+monitor+sequencer),
// env (agent+scoreboard), a random sequence, and the test.

class adder_agent extends uvm_agent;
    `uvm_component_utils(adder_agent)
    adder_driver    drv;
    adder_monitor   mon;
    uvm_sequencer #(adder_txn) sqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = adder_driver::type_id::create("drv", this);
        mon = adder_monitor::type_id::create("mon", this);
        sqr = uvm_sequencer#(adder_txn)::type_id::create("sqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass

class adder_env extends uvm_env;
    `uvm_component_utils(adder_env)
    adder_agent      agt;
    adder_scoreboard scb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = adder_agent::type_id::create("agt", this);
        scb = adder_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(scb.imp);
    endfunction
endclass

class random_seq extends uvm_sequence #(adder_txn);
    `uvm_object_utils(random_seq)
    function new(string name = "random_seq");
        super.new(name);
    endfunction

    task body();
        repeat (50) begin
            adder_txn txn = adder_txn::type_id::create("txn");
            start_item(txn);
            if (!txn.randomize())
                `uvm_fatal("RAND", "randomize failed")
            finish_item(txn);
        end
    endtask
endclass

class adder_test extends uvm_test;
    `uvm_component_utils(adder_test)
    adder_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = adder_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        random_seq seq = random_seq::type_id::create("seq");
        phase.raise_objection(this);
        seq.start(env.agt.sqr);
        #100;   // drain: let the last monitor/scoreboard pair finish
        phase.drop_objection(this);
    endtask
endclass
