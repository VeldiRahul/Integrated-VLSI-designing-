class config_total_item_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_total_item_seq)

  function new(string name="config_total_item_seq");
    super.new(name);
  endfunction

  task body();
    cfg_transaction tx;

    tx = cfg_transaction::type_id::create("tx");
    start_item(tx);
	
    
    tx.paddr   = 16'h0000;        
    tx.pwrite  = 1;               
    tx.psel    = 1;               
    tx.pwdata  = MAX_ITEMS;
    
    finish_item(tx);
    
    //ideal state
    tx = cfg_transaction::type_id::create("tx_idle");
    start_item(tx);
    tx.psel = 0;
    tx.pwrite = 0;
    finish_item(tx);

    `uvm_info("CFG_SEQ", "Successfully wrote number of items", UVM_MEDIUM);
  endtask

endclass
