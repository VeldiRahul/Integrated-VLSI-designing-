class cfg_write_zero extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(cfg_write_zero)

  function new(string name = "cfg_write_zero");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;

    for (int i = 0; i < MAX_ITEMS; i++) begin

      req = cfg_transaction::type_id::create($sformatf("cfg_zero_%0d", i));
      start_item(req);

      req.rstn_ctrl = 1'b1;
      req.paddr     = 16'h0004 + i*4;
      req.pwrite    = 1'b1;
      req.psel      = 1'b1;

      // pwdata = {disp=0, avail=0, value=item_price}
      req.pwdata = {8'd0, 8'd0, (i+1)*10};

      finish_item(req);

      `uvm_info("CFG_WRITE_ZERO",
                $sformatf("Configured item %0d -> price=%0d avail=0",
                          i, req.pwdata[15:0]),
                UVM_LOW)
    end

    // Idle write-off
    #10;
    req = cfg_transaction::type_id::create("cfg_zero_idle");
    start_item(req);
    req.pwrite = 0;
    req.psel   = 0;
    finish_item(req);
  endtask
endclass
