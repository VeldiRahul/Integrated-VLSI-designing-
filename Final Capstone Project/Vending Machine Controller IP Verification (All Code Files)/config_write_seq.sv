class config_write_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_write_seq)

  function new(string name = "config_write_seq");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;
    
    for (int i = 0; i < MAX_ITEMS; i++) begin

      req = cfg_transaction::type_id::create($sformatf("wr_item_%0d", i));
      start_item(req);

      req.rstn_ctrl = 1'b1; 
      req.paddr     = 16'h0004 + i * 4; 
      req.pwrite    = 1'b1; 
      req.psel      = 1'b1; 

      req.pwdata = {8'd0, 8'd50, (i + 1) * 10};

      `uvm_info("VENDING_CONFIG_TEST",
                $sformatf("CONFIG WRITE @ item %0d (Addr=0x%h) : price=%0d avail=%0d",
                          i, req.paddr, req.pwdata[15:0], req.pwdata[23:16]),
                UVM_LOW)

      finish_item(req);
    end
    
    #10;
    req = cfg_transaction::type_id::create("wr_idle");
    start_item(req);

    req.pwrite = 0;
    req.psel   = 0;
    finish_item(req);
  endtask
endclass




