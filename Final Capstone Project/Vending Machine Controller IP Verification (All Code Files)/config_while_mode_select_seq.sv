class config_while_mode_select_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_while_mode_select_seq)

  cfg_transaction tx;

  function new(string name = "config_while_mode_select_seq");
    super.new(name);
  endfunction

  task body();

    for (int i = 0; i < 5; i++) begin
      tx = cfg_transaction::type_id::create($sformatf("cfg_tx_%0d", i));
      start_item(tx);

      tx.paddr  = 16'h0004 + i * 4;;         
      tx.pwrite = 1;
      tx.psel   = 1;
      tx.pwdata = 32'hBADC0DE + i;

      finish_item(tx);
    end

    #100;

    for (int i = 0; i < 5; i++) begin
      tx = cfg_transaction::type_id::create($sformatf("cfg_tx_rd_%0d", i));
      start_item(tx);

      tx.paddr  = 4 + i*4;        
      tx.pwrite = 0;
      tx.psel   = 1;
      tx.pwdata = 32'hBADC0DE;    // ignored during read

      finish_item(tx);
    end

  endtask
endclass
