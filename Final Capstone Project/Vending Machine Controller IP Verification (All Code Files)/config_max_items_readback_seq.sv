class config_max_items_readback_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_max_items_readback_seq)

  cfg_transaction cfg_tx;

  function new(string name = "config_max_items_readback_seq");
    super.new(name);
  endfunction

  task body();
    for (int i = 0; i < MAX_ITEMS; i++) begin
      cfg_tx = cfg_transaction::type_id::create($sformatf("cfg_rd_tx_%0d", i));
      start_item(cfg_tx);

      cfg_tx.paddr  = 16'h0004 + i*4;    
      cfg_tx.pwrite = 0;        
      cfg_tx.psel   = 1;

      finish_item(cfg_tx);
    end
  endtask
endclass
