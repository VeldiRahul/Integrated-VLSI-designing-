class config_clear_dispense_count_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_clear_dispense_count_seq)

  function new(string name = "config_clear_dispense_count_seq");
    super.new(name);
  endfunction

  task body();
     cfg_transaction cfg_tx;
    
    for (int i = 0; i < MAX_ITEMS; i++) begin
      cfg_tx = cfg_transaction::type_id::create($sformatf("cfg_%0d", i));
      start_item(cfg_tx);

      cfg_tx.paddr  = (16'h0004 + i*4);      
      cfg_tx.pwrite = 1;
      cfg_tx.psel   = 1;

      cfg_tx.pwdata = {8'h00, 8'd6, 16'(30 + i*5)};
      finish_item(cfg_tx);
    end
    
	// clearing dispense count ,other ignored
    for (int i = 0; i < MAX_ITEMS; i++) begin
      cfg_tx = cfg_transaction::type_id::create($sformatf("clr_%0d", i));
      start_item(cfg_tx);

      cfg_tx.paddr  = (16'h0004 + i*4);   
      cfg_tx.pwrite = 1;
      cfg_tx.psel   = 1;

      cfg_tx.pwdata = {8'h00, 8'hXX, 16'hXXXX};
      finish_item(cfg_tx);
    end

    // Read back
    for (int i = 0; i < MAX_ITEMS; i++) begin
      cfg_tx = cfg_transaction::type_id::create($sformatf("rd_%0d", i));
      start_item(cfg_tx);

      cfg_tx.paddr  = (16'h0004 + i*4);
      cfg_tx.pwrite = 0;
      cfg_tx.psel   = 1;

      finish_item(cfg_tx);
    end

  endtask
endclass


// class config_clear_dispense_count_seq extends uvm_sequence #(cfg_transaction);
//   `uvm_object_utils(config_clear_dispense_count_seq)

//   cfg_transaction cfg_tx;

//   function new(string name = "config_clear_dispense_count_seq");
//     super.new(name);
//   endfunction

//   task body();

//     // Configure first 8 items with known values
//     for (int i = 0; i < 8; i++) begin
//       cfg_tx = cfg_transaction::type_id::create($sformatf("cfg_clear_disp_%0d", i));
//       start_item(cfg_tx);

//       cfg_tx.paddr  = (4 + i*4);        // item index
//       cfg_tx.pwrite = 1;
//       cfg_tx.psel   = 1;

//       // price = 30,35,40...
//       // avail = 6
//       // disp_count = 0
//       cfg_tx.pwdata = {8'h00, 8'd6, 16'(30 + i*5)};

//       finish_item(cfg_tx);
//     end

//     // Now clear disp-count again for the same items
//     for (int i = 0; i < 8; i++) begin
//       cfg_tx = cfg_transaction::type_id::create($sformatf("clr_disp_%0d", i));
//       start_item(cfg_tx);

//       cfg_tx.paddr  = (4 + i*4);
//       cfg_tx.pwrite = 1;
//       cfg_tx.psel   = 1;

//       cfg_tx.pwdata = {8'h00, 8'hxx, 16'hxxxx};  

//       finish_item(cfg_tx);
//     end

//     // readback to verify
//     for (int i = 0; i < 8; i++) begin
//       cfg_tx = cfg_transaction::type_id::create($sformatf("rd_disp_%0d", i));
//       start_item(cfg_tx);

//       cfg_tx.paddr  = (4 + i*4);
//       cfg_tx.pwrite = 0;
//       cfg_tx.psel   = 1;

//       finish_item(cfg_tx);
//     end

//   endtask

// endclass
