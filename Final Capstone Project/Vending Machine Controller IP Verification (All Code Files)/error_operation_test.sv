class error_operation_test extends uvm_test;
  `uvm_component_utils(error_operation_test)


  vending_env env;
  virtual vmc_if ctrl_vif;
  cfg_sequence cfg_seq;

  currency_before_item_seq       out_curr_seq;
  item_after_currency_seq        late_item_seq;
  unsupported_currency_seq       bad_curr_seq;
  invalid_item_select_seq        inv_item_seq;

  function new(string name = "error_operation_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = vending_env::type_id::create("env", this);
    
    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("test6", "Virtual interface not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(), "Starting error operation test", UVM_MEDIUM)

    ctrl_vif.cfg_mode = 1;
    cfg_seq = cfg_sequence::type_id::create("cfg_seq");
    cfg_seq.start(env.cfg_ag.seqr);
    `uvm_info("ERROR_TEST", "Configuration completed before running error sequences", UVM_LOW);
    ctrl_vif.cfg_mode = 0;
    
    #30;

    out_curr_seq = currency_before_item_seq::type_id::create("out_curr_seq");
    out_curr_seq.start(env.currency_ag.seqr);
    #10;
    `uvm_info("ERROR_TEST", "All currency_before_item_seq error operation sequences completed", UVM_LOW);

    late_item_seq = item_after_currency_seq::type_id::create("late_item_seq");
    late_item_seq.start(env.item_ag.seqr);
        #50;
    `uvm_info("ERROR_TEST", "All currency_after_item error operation sequences completed", UVM_LOW);

    
    bad_curr_seq = unsupported_currency_seq::type_id::create("bad_curr_seq");
    bad_curr_seq.start(env.currency_ag.seqr);
    `uvm_info("ERROR_TEST", "All unsupported  error operation sequences completed", UVM_LOW);
    
    inv_item_seq = invalid_item_select_seq::type_id::create("inv_item_seq");
    inv_item_seq.start(env.item_ag.seqr);
    #50;

    `uvm_info("ERROR_TEST", "All error operation sequences completed", UVM_LOW);
    phase.drop_objection(this);
  endtask

endclass
