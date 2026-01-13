class config_negative_test extends uvm_test;
  `uvm_component_utils(config_negative_test)

  vending_env env;
  virtual vmc_if ctrl_vif;

  config_invalid_address_seq	 wrong_addr_seq;
  config_while_mode_select_seq 		wrong_time_seq;

  function new(string name = "config_negative_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("test2", "ctrl_vif not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Enter CONFIG MODE
    ctrl_vif.cfg_mode = 1;
    `uvm_info("CFG_NEG_TEST", "Entering CONFIG MODE", UVM_LOW)

    wrong_addr_seq = config_invalid_address_seq::type_id::create("wrong_addr_seq");
    wrong_addr_seq.start(env.cfg_ag.seqr);
    `uvm_info("CFG_NEG_TEST", "Wrong address test completed", UVM_LOW)

    `uvm_info("CFG_NEG_TEST", "Switched to USER MODE", UVM_LOW)

    #50;
    wrong_time_seq = config_while_mode_select_seq::type_id::create("wrong_time_seq");
    wrong_time_seq.start(env.cfg_ag.seqr);
    `uvm_info("CFG_NEG_TEST", "Wrong timing config test completed", UVM_LOW)
	
    ctrl_vif.cfg_mode = 0;
    
    phase.drop_objection(this);
  endtask

endclass
