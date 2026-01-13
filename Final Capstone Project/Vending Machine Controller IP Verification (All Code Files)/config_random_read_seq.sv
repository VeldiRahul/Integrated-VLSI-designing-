class config_random_read_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_random_read_seq)

  function new(string name = "config_random_read_seq");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;
    
    for ( int i=0; i<=MAX_ITEMS - 1; i++) begin
      req = cfg_transaction::type_id::create("req");
      start_item(req);
      assert(req.randomize() with {rstn_ctrl == 1'b1;  paddr == (16'h0004 + i*4); pwrite == 1'b0; psel == 1'b1; });;
      finish_item(req);
                 `uvm_info("VENDING_CONFIG_TEST", "CONFIG_WRITE_MODE_TEST", UVM_LOW)
           end
    #10;
    req = cfg_transaction::type_id::create("req");
    start_item(req);
    req.psel = 1'd0;
    finish_item(req);
      endtask

endclass