class reset_sequence extends uvm_sequence;
  `uvm_object_utils(reset_sequence)

  virtual vmc_if ctrl_vif;
  virtual cfg_if cfg_vif;

  function new(string name="reset_sequence");
    super.new(name);
  endfunction

  task body();
    if (!uvm_config_db#(virtual vmc_if)::get(null, "uvm_test_top", "ctrl_vif", ctrl_vif))
      `uvm_fatal("RESET", "ctrl_vif missing")

    if (!uvm_config_db#(virtual cfg_if)::get(null, "uvm_test_top", "cfg_vif", cfg_vif))
      `uvm_fatal("RESET", "cfg_vif missing")

    // Assert reset
    ctrl_vif.rstn  <= 0;
    cfg_vif.prstn  <= 0;
    `uvm_info("RESET_SEQ", "Reset asserted", UVM_MEDIUM);

    #20;

    // Deassert reset
    ctrl_vif.rstn  <= 1;
    cfg_vif.prstn  <= 1;
    `uvm_info("RESET_SEQ", "Reset de-asserted", UVM_MEDIUM);
  endtask
endclass
