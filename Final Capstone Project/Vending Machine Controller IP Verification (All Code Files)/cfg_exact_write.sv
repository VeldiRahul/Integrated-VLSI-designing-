class cfg_exact_write extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(cfg_exact_write)

  function new(string name = "cfg_exact_write");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;

    int target_item = 3;      // item to allow exact payment
    int exact_price = 50;     // price based on spec
    int exact_avail = 1;      // only 1 item to dispense

    req = cfg_transaction::type_id::create("cfg_exact_item");
    start_item(req);

    req.rstn_ctrl = 1'b1;
    req.paddr     = 16'h0004 + target_item*4;
    req.pwrite    = 1'b1;
    req.psel      = 1'b1;

    // pwdata = {disp=0, avail=1, value=exact_price}
    req.pwdata = {8'd0, exact_avail[7:0], exact_price[15:0]};

    finish_item(req);

    `uvm_info("CFG_EXACT_WRITE",
              $sformatf("Configured item %0d for exact pay: price=%0d avail=1",
                        target_item, exact_price),
              UVM_MEDIUM)

    // Idle bus
    #10;
    req = cfg_transaction::type_id::create("cfg_exact_idle");
    start_item(req);
    req.pwrite = 0;
    req.psel   = 0;
    finish_item(req);
  endtask
endclass
