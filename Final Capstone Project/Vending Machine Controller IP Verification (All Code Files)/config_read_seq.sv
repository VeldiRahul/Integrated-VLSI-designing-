class config_read_seq extends uvm_sequence #(cfg_transaction);
  `uvm_object_utils(config_read_seq)

  function new(string name = "config_read_seq");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;

    req = cfg_transaction::type_id::create("rd_vm_cfg");
    start_item(req);
    
    req.rstn_ctrl = 1'b1; 
    req.paddr     = 16'h0000;
    req.pwrite    = 1'b0; 
    req.psel      = 1'b1;
    
  
    
    `uvm_info("VENDING_CONFIG_TEST", $sformatf("CONFIG READ @ VM_CFG (Addr=0x%h)", req.paddr), UVM_LOW)

    finish_item(req);
    

    for (int i = 0; i < 10; i++) begin
      req = cfg_transaction::type_id::create($sformatf("rd_item_%0d", i));
      start_item(req);

      req.rstn_ctrl = 1'b1; 
      req.paddr     = 32'h4000_0004 + i * 4; 
      req.pwrite    = 1'b0; 
      req.psel      = 1'b1;

      `uvm_info("VENDING_CONFIG_TEST", $sformatf("CONFIG READ @ item %0d (Addr=0x%h)", i, req.paddr), UVM_LOW)
      finish_item(req);
    end

    #10;
    req = cfg_transaction::type_id::create("rd_idle");
    start_item(req);
    req.pwrite = 0;
    req.psel   = 0;
    finish_item(req);
  endtask
endclass