class operation_basic_test extends uvm_test;
  `uvm_component_utils(operation_basic_test)

  vending_env env;
  cfg_sequence cfg_seq;
  virtual vmc_if ctrl_vif;   // matches top: vmc_if ctrl_vif(clk)

  cfg_write_zero  cfg_zero;
  cfg_exact_write cfg_exact;

  zero_stock_item_dispense_seq          zero_item;
  zero_stock_currency_dispense_seq      zero_curr;

  item_exact_currency_dispense_seq      i_exact_currency;
  currency_exact_currency_dispense_seq  c_exact_currency;

  item_overpayment_with_change_seq      i_overpayment;
  currency_overpayment_with_change_seq  c_overpayment;

  item_multi_part_currency_seq          i_multicurrency;
  currency_multi_part_currency_seq      c_multicurrency;

  function new(string name = "operation_basic_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = vending_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("CFG_DRIVER", "Virtual ctrl_vif not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("VENDING_TEST",
              "ZERO AVAILABLE ITEM CONFIG",
              UVM_LOW)

    // ------------------------------------------------
    // Configuration mode: load zero + exact item info
    // ------------------------------------------------
    ctrl_vif.cfg_mode = 1'b1;

    cfg_zero = cfg_write_zero::type_id::create("cfg_zero");
    cfg_zero.start(env.cfg_ag.seqr);
    #20;

    cfg_exact = cfg_exact_write::type_id::create("cfg_exact");
    cfg_exact.start(env.cfg_ag.seqr);
    #20;

    ctrl_vif.cfg_mode = 1'b0;  // enter Operation mode
    #20;

    

    // ------------------------------------------------
    // Exact-stock transaction
    // ------------------------------------------------
    i_exact_currency = item_exact_currency_dispense_seq::type_id::create("i_exact_currency");
    i_exact_currency.start(env.item_ag.seqr);
    #10;

    c_exact_currency = currency_exact_currency_dispense_seq::type_id::create("c_exact_currency");
    c_exact_currency.start(env.currency_ag.seqr);
    #100;

    `uvm_info("EXACT_DISPENSE_TEST",
              "Exact dispense sequences completed.",
              UVM_LOW)

    // ------------------------------------------------
    // Overpayment transaction (expect change)
    // ------------------------------------------------
    i_overpayment = item_overpayment_with_change_seq::type_id::create("i_overpayment");
    i_overpayment.start(env.item_ag.seqr);
    #10;

    c_overpayment = currency_overpayment_with_change_seq::type_id::create("c_overpayment");
    c_overpayment.start(env.currency_ag.seqr);
    #100;

    `uvm_info("OVERPAYMENT_TEST",
              "Overpayment with change test done.",
              UVM_LOW)

    // ------------------------------------------------
    // Multi-part currency payment
    // ------------------------------------------------
    i_multicurrency = item_multi_part_currency_seq::type_id::create("i_multicurrency");
    i_multicurrency.start(env.item_ag.seqr);
    #10;

    c_multicurrency = currency_multi_part_currency_seq::type_id::create("c_multicurrency");
    c_multicurrency.start(env.currency_ag.seqr);
    #20;

    `uvm_info("MULTI_PART_TEST",
              "Multi-part currency + item selection completed.",
              UVM_LOW)
    
    // ------------------------------------------------
    // Zero-stock transaction
    // ------------------------------------------------
    zero_item = zero_stock_item_dispense_seq::type_id::create("zero_item");
    zero_item.start(env.item_ag.seqr);
    #10;

    zero_curr = zero_stock_currency_dispense_seq::type_id::create("zero_curr");
    zero_curr.start(env.currency_ag.seqr);
    #100;

    `uvm_info("ZERO_STOCK_TEST",
              "ZERO_STOCK_DISPENSE_TEST completed.",
              UVM_LOW)

    phase.drop_objection(this);
  endtask
endclass
