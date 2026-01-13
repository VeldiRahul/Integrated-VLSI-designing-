class config_edge_test extends uvm_test;
  `uvm_component_utils(config_edge_test)

  vending_env env;
  virtual vmc_if ctrl_vif;
  
  cfg_sequence base_cfg_seq;
  config_check_default_reset_seq reset_check_seq;
  config_clear_dispense_count_seq clear_disp_seq;
  config_randomized_item_setup_seq random_cfg_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = vending_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("test4", "Virtual interface not found")
  endfunction


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ctrl_vif.cfg_mode = 1;

   // `uvm_info("CONFIG_EDGE_TEST", "Starting base configuration sequence...", UVM_LOW)
   // base_cfg_seq = cfg_sequence::type_id::create("base_cfg_seq");
   // base_cfg_seq.start(env.cfg_ag.seqr);

    `uvm_info("CONFIG_EDGE_TEST", "Checking default reset values", UVM_LOW)
    reset_check_seq = config_check_default_reset_seq::type_id::create("reset_check_seq");
    reset_check_seq.start(env.cfg_ag.seqr);

    `uvm_info("CONFIG_EDGE_TEST", "Clearing dispense counter", UVM_LOW)
    clear_disp_seq = config_clear_dispense_count_seq::type_id::create("clear_disp_seq");
    clear_disp_seq.start(env.cfg_ag.seqr);

    `uvm_info("CONFIG_EDGE_TEST", "Running randomized item setup", UVM_LOW)
    random_cfg_seq = config_randomized_item_setup_seq::type_id::create("random_cfg_seq");
    random_cfg_seq.start(env.cfg_ag.seqr);
    
	ctrl_vif.cfg_mode = 0;
    phase.drop_objection(this);
  endtask
endclass