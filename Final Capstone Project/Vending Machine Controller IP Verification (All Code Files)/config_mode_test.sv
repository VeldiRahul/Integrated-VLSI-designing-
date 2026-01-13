class config_mode_test extends uvm_test;
  `uvm_component_utils(config_mode_test)

  virtual vmc_if ctrl_vif;
  virtual cfg_if cfg_vif;

  config_write_seq        cfg_wr_seq;
  config_read_seq         cfg_rd_seq;
  config_total_item_seq   cfg_total_seq;

  vending_env env;

  function new(string name="config_mode_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("CFG_TEST", "ctrl_vif not found");

    if (!uvm_config_db#(virtual cfg_if)::get(this, "", "cfg_vif", cfg_vif))
      `uvm_fatal("CFG_TEST", "cfg_vif not found");
  endfunction


  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    #20;
    ctrl_vif.cfg_mode = 1'b1;

    cfg_wr_seq = config_write_seq::type_id::create("cfg_wr_seq");
    cfg_wr_seq.start(env.cfg_ag.seqr);

    cfg_rd_seq = config_read_seq::type_id::create("cfg_rd_seq");
    cfg_rd_seq.start(env.cfg_ag.seqr);

    cfg_total_seq = config_total_item_seq::type_id::create("cfg_total_seq");
    cfg_total_seq.start(env.cfg_ag.seqr);

    ctrl_vif.cfg_mode = 1'b0;

    #20;
    phase.drop_objection(this);
  endtask

endclass


