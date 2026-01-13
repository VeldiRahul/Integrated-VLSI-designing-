class reset_mode_test extends uvm_test;
  `uvm_component_utils(reset_mode_test)

 
  reset_check_seq       reg_chk_seq;
  vending_env           env;
  virtual vmc_if        ctrl_vif;
  virtual cfg_if        cfg_vif;

  function new(string name="reset_mode_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("RESET_TEST1", "ctrl_vif NOT FOUND")

    if (!uvm_config_db#(virtual cfg_if)::get(this, "", "cfg_vif", cfg_vif))
      `uvm_fatal("RESET_TEST1", "cfg_vif NOT FOUND")
  endfunction


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("RESET_TEST", "===== STARTING RESET MODE TEST =====", UVM_LOW)

    `uvm_info("RESET_TEST", "Running reset_check_seq (readback)...", UVM_LOW)

    reg_chk_seq = reset_check_seq::type_id::create("reg_chk_seq");
    reg_chk_seq.start(env.cfg_ag.seqr);  


    `uvm_info("RESET_TEST", "===== RESET MODE TEST: COMPLETED SUCCESSFULLY =====", UVM_LOW)

    phase.drop_objection(this);
  endtask

endclass
