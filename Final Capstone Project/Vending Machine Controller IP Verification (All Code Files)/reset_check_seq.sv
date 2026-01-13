class reset_check_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(reset_check_seq)

  function new(string name = "reset_register_check_seq");
    super.new(name);
  endfunction

  task body();
    cfg_transaction tx;

    // AFTER 

    for (int i = 0; i < MAX_ITEMS; i++) begin
      tx = cfg_transaction::type_id::create($sformatf("read_%0d", i));
      start_item(tx);

      tx.paddr  = 16'h0004 + i * 4;
      tx.pwrite = 0;
      tx.psel   = 1;

      finish_item(tx);
    end

    `uvm_info("REG_CHECK_SEQ", 
      "######## Register default check (after reset) complete ########", 
      UVM_MEDIUM
    );
  endtask
endclass
