class latency_output_test extends uvm_test;
  `uvm_component_utils(latency_output_test)

  vending_env                           env;
  virtual vmc_if                        ctrl_vif;
  cfg_sequence                          cfg_seq;

  currency_latency_check_seq            cseq;
  item_latency_check_seq                iseq;

  item_single_output_seq                i_single_output;
  currency_single_output_seq            c_single_output;

  item_one_dispense_within_latency_seq  i_within_latency;
  currency_one_dispense_within_latency_seq  c_within_latency;

  function new(string name = "latency_output_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("LAT_TEST", "Virtual ctrl_if not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("LATENCY_TEST",
              "Starting latency/output property tests...",
              UVM_LOW)
    
    ctrl_vif.cfg_mode = 1'b1;

    cfg_seq = cfg_sequence::type_id::create("cfg_seq");
    cfg_seq.start(env.cfg_ag.seqr);

    `uvm_info("LATENCY_TEST", "Configuration sequence completed.", UVM_LOW)

    #100;
    ctrl_vif.cfg_mode = 1'b0; 

    iseq = item_latency_check_seq::type_id::create("iseq");
    iseq.start(env.item_ag.seqr);
    #10;

    cseq = currency_latency_check_seq::type_id::create("cseq");
    cseq.start(env.currency_ag.seqr);

    `uvm_info("LATENCY_TEST", "Latency check transaction sequence completed.", UVM_LOW)

    #50;

    i_single_output = item_single_output_seq::type_id::create("i_single_output");
    i_single_output.start(env.item_ag.seqr);
    #10;

    c_single_output = currency_single_output_seq::type_id::create("c_single_output");
    c_single_output.start(env.currency_ag.seqr);

    `uvm_info("LATENCY_TEST", "Single-output per transaction sequence completed.",UVM_LOW)

    #50;

    i_within_latency = item_one_dispense_within_latency_seq::type_id::create("i_within_latency");
    i_within_latency.start(env.item_ag.seqr);
    #10;

    c_within_latency = currency_one_dispense_within_latency_seq::type_id::create("c_within_latency");
    c_within_latency.start(env.currency_ag.seqr);

    `uvm_info("ONE_DISPENSE_LATENCY_TEST","Both item & currency sequences done.", UVM_MEDIUM)

    #50;

    phase.drop_objection(this);
  endtask
endclass
