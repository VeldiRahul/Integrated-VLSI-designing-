class config_full_test extends uvm_test;
  `uvm_component_utils(config_full_test)

  vending_env env;
  virtual vmc_if ctrl_vif;
	
  config_multi_item_setup_seq     multi_seq;
  config_max_items_seq            max_seq;
  config_max_items_readback_seq   readback_seq;

  function new(string name = "config_full_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("test3", "Virtual interface ctrl_vif not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    ctrl_vif.cfg_mode <= 1;
    `uvm_info("CFG_FULL_TEST", "CFG MODE = 1", UVM_LOW)
	#50
    `uvm_info("CFG_FULL_TEST", "Running config_multi_item_setup_seq", UVM_LOW)
    multi_seq = config_multi_item_setup_seq::type_id::create("multi_seq");
    multi_seq.start(env.cfg_ag.seqr);
    `uvm_info("CFG_FULL_TEST", "Completed config_multi_item_setup_seq", UVM_LOW)


    `uvm_info("CFG_FULL_TEST", "Running config_max_items_seq", UVM_LOW)
    max_seq = config_max_items_seq::type_id::create("max_seq");
    max_seq.start(env.cfg_ag.seqr);
    `uvm_info("CFG_FULL_TEST", "Completed config_max_items_seq", UVM_LOW)


    `uvm_info("CFG_FULL_TEST", "Running config_max_items_readback_seq", UVM_LOW)
    readback_seq = config_max_items_readback_seq::type_id::create("readback_seq");
    readback_seq.start(env.cfg_ag.seqr);
    `uvm_info("CFG_FULL_TEST", "Completed config_max_items_readback_seq", UVM_LOW)

    ctrl_vif.cfg_mode <= 0;

    phase.drop_objection(this);
  endtask

endclass
