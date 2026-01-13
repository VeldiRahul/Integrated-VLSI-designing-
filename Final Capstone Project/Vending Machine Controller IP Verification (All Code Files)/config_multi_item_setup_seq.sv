class config_multi_item_setup_seq extends uvm_sequence;
  `uvm_object_utils(config_multi_item_setup_seq)
    cfg_transaction cfg_tx;
  function new(string name = "config_multi_item_setup_seq"); super.new(name); endfunction

  task body();
    for (int i = 0; i < MAX_ITEMS; i++) begin
      cfg_tx = cfg_transaction::type_id::create($sformatf("cfg_tx_%0d", i));
      start_item(cfg_tx);
      cfg_tx.paddr  = 16'h0004 + i*4;
      cfg_tx.pwrite = 1;
      cfg_tx.psel   = 1;
      cfg_tx.pwdata[15:0]  = i;       // price
      cfg_tx.pwdata[23:16] = i+1;     // avail
      cfg_tx.pwdata[31:24] = 0;

      finish_item(cfg_tx);
    end
  endtask
endclass