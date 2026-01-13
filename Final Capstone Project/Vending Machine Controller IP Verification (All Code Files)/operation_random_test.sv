class operation_random_test extends uvm_test;
  `uvm_component_utils(operation_random_test)

  vending_env  env;
  cfg_sequence cfg_seq;
  virtual vmc_if ctrl_vif;   // matches top-level ctrl_vif type

  item_random_valid_multiitem_seq            item_seq_hdl;
  currency_random_valid_multiitem_seq        currency_seq_hdl;

  item_random_user_sequence_mix_seq          i_user;
  currency_random_user_sequence_mix_seq      c_user;

  item_randomized_back_to_back_seq           i_b2b;
  currency_randomized_back_to_back_seq       c_b2b;

  function new(string name = "operation_random_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("test6", "Virtual ctrl_vif not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("OP_RANDOM_TEST",
              "Starting randomized operational sequences...",
              UVM_LOW)

    // -------- Configuration mode (per spec) --------
    ctrl_vif.cfg_mode = 1'b1;

    cfg_seq = cfg_sequence::type_id::create("cfg_seq");
    cfg_seq.start(env.cfg_ag.seqr);

    `uvm_info("OP_RANDOM_TEST",
              "Configuration sequence completed.",
              UVM_LOW)

    ctrl_vif.cfg_mode = 1'b0;  // enter Operation mode
    #100;

    // -------- 1) Random valid multi-item --------
    fork
      begin
        item_seq_hdl = item_random_valid_multiitem_seq::type_id::create("item_seq_hdl");
        item_seq_hdl.start(env.item_ag.seqr);
      end
      begin
        #10;
        currency_seq_hdl = currency_random_valid_multiitem_seq::type_id::create("currency_seq_hdl");
        currency_seq_hdl.start(env.currency_ag.seqr);
      end
    join

    `uvm_info("RAND_MULTIITEM_TEST", "Both item & currency VALID random sequences done.", UVM_MEDIUM)

    #50;

    // -------- 2) Random mixed user sequence (valid + unsupported) --------
    fork
      begin
        i_user = item_random_user_sequence_mix_seq::type_id::create("i_user");
        i_user.start(env.item_ag.seqr);
      end
      begin
        #10;
        c_user = currency_random_user_sequence_mix_seq::type_id::create("c_user");
        c_user.start(env.currency_ag.seqr);
      end
    join

    `uvm_info("USER_MIX_TEST", "Random user mix sequences completed.", UVM_LOW)

    #50;

    // -------- 3) Back-to-back transactions --------
    fork
      begin
        i_b2b = item_randomized_back_to_back_seq::type_id::create("i_b2b");
        i_b2b.start(env.item_ag.seqr);
      end
      begin
        #10;
        c_b2b = currency_randomized_back_to_back_seq::type_id::create("c_b2b");
        c_b2b.start(env.currency_ag.seqr);
      end
    join

    `uvm_info("BACK2BACK_OPS_TEST", "Back-to-back operations done.", UVM_LOW)

    #50;

    phase.drop_objection(this);
  endtask
endclass
