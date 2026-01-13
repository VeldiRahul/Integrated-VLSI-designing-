class config_invalid_address_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_invalid_address_seq)

  cfg_transaction tx, tx1;

  function new(string name = "config_invalid_address_seq");
    super.new(name);
  endfunction

  task body();

    for (int i = 0; i < MAX_ITEMS; i++) begin
      tx = cfg_transaction::type_id::create($sformatf("cfg_tx_%0d", i));
      start_item(tx);

      tx.paddr  = 16'h0004 + i * 4;;      
      tx.pwrite = 1;
      tx.psel   = 1;
      tx.pwdata = i;             
      
      finish_item(tx);
    end

    tx = cfg_transaction::type_id::create("invalid_addr_cfg");
    start_item(tx);

    tx.paddr  = 16'hFFFC;         // invalid
    tx.pwrite = 1;
    tx.psel   = 1;
    tx.pwdata = 32'hDEAD_BEEF;

    finish_item(tx);
    
    tx1 = cfg_transaction::type_id::create("invalid_cfg");
    start_item(tx1);

    tx1.paddr  = 16'hFFFC;        // invalid read
    tx1.pwrite = 0;
    tx1.psel   = 1;
    tx1.pwdata = 0;

    finish_item(tx1);

  endtask
endclass
