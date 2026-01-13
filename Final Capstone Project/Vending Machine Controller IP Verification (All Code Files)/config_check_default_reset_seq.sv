class config_check_default_reset_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_check_default_reset_seq)

  cfg_transaction tx;

  function new(string name = "config_check_default_reset_seq");
    super.new(name);
  endfunction

  task body();

    // Assert reset
    tx = cfg_transaction::type_id::create("rst_assert");
    start_item(tx);
    tx.rstn_ctrl = 0;
    tx.psel      = 0;
    tx.pwrite    = 0;
    tx.paddr     = 0;
    finish_item(tx);

    #20;

    // Deassert reset
    tx = cfg_transaction::type_id::create("rst_deassert");
    start_item(tx);
    tx.rstn_ctrl = 1;
    tx.psel      = 0;
    tx.pwrite    = 0;
    tx.paddr     = 0;
    finish_item(tx);

    #20;

    // Read default values — FIXED addr i instead of 4+i*4
    for (int i = 0; i < MAX_ITEMS; i++) begin
      tx = cfg_transaction::type_id::create($sformatf("rst_read_%0d", i));
      start_item(tx);
      tx.rstn_ctrl = 1;
      tx.paddr     = (16'h0004 + i*4);      // <<< FIXED
      tx.pwrite    = 0;
      tx.psel      = 1;
      finish_item(tx);
    end

  endtask
endclass
