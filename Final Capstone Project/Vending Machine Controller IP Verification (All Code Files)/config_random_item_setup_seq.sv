class config_randomized_item_setup_seq extends uvm_sequence;
  `uvm_object_utils(config_randomized_item_setup_seq)
  cfg_transaction cfg_tx;

  function new(string name = "config_randomized_item_setup_seq");
    super.new(name);
  endfunction

  task body();
    for (int i = 0; i < MAX_ITEMS; i++) begin
      cfg_tx = cfg_transaction::type_id::create($sformatf("cfg_rand_%0d", i));
      start_item(cfg_tx);

      cfg_tx.paddr  = (16'h0004 + i*4);    
      cfg_tx.pwrite = 1;
      cfg_tx.psel   = 1;

      cfg_tx.pwdata = {8'h00, $urandom_range(1,255), $urandom_range(5,100)};
      finish_item(cfg_tx);
    end
  endtask

endclass



// class config_randomized_item_setup_seq extends uvm_sequence;
//   `uvm_object_utils(config_randomized_item_setup_seq)
//   cfg_transaction cfg_tx;
//   function new(string name = "config_randomized_item_setup_seq"); super.new(name); endfunction

//   task body();
//     for (int i = 0; i < MAX_ITEMS; i++) begin
//       cfg_tx = cfg_transaction::type_id::create($sformatf("cfg_rand_tx_%0d", i));
//       start_item(cfg_tx);
//       cfg_tx.paddr  = (4 + i*4);
//       cfg_tx.pwrite = 1;
//       cfg_tx.psel   = 1;
//       cfg_tx.pwdata = {8'h00, $urandom_range(1,255), $urandom_range(5,100)};
//       finish_item(cfg_tx);
//     end
//   endtask
// endclass