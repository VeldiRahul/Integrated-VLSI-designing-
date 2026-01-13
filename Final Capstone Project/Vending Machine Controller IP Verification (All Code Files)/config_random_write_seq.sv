class config_random_write_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_random_write_seq)

  function new(string name = "config_random_write_seq");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;

    for (int i = 0; i < MAX_ITEMS -1; i++) begin
      req = cfg_transaction::type_id::create($sformatf("wr_item_%0d", i));
      start_item(req);
      
      assert(req.randomize() with {
        rstn_ctrl == 1'b1;
        paddr     == (16'h0004 + i*4);
        pwrite    == 1'b1;
        psel      == 1'b1;
        pwdata[15:0]  inside {[5:100]};
        pwdata[23:16] inside {[0:255]};
        pwdata[31:24] == 8'd0;
      });

      `uvm_info("VENDING_CONFIG_TEST", $sformatf("CONFIG WRITE @ item %0d : price=%0d avail=%0d", i, req.pwdata[15:0], req.pwdata[23:16]), UVM_LOW)
    end
    
    #10;
    req = cfg_transaction::type_id::create("wr_idle");
    start_item(req);
    req.pwrite = 0;
    req.psel   = 0;
    finish_item(req);
  endtask
endclass