class cfg_sequence extends uvm_sequence#(cfg_transaction);
  `uvm_object_utils(cfg_sequence)
  
  rand bit [15:0] item_val;
  rand bit [7:0]  item_avail;
  rand bit [7:0]  item_disp;
  
  function new(string name="cfg_sequence");
    super.new(name);
  endfunction

  task body();
    cfg_transaction req;

    for (int i = 0; i < MAX_ITEMS; i++) begin
        req = cfg_transaction::type_id::create($sformatf("cfg_tx_%0d", i));

        start_item(req);
        req.paddr       = i;
        req.pwrite      = 1;
        req.psel        = 1;
        item_val        = i+10;
        item_avail      = i;
        item_disp       = 0;
        req.pwdata      = {item_disp,item_avail,item_val} ; 
        req.rstn_ctrl   = 1;
        finish_item(req);
        `uvm_info("CFG_SEQ", $sformatf("Configured item[%0d] at address 0x%0h", i, req.paddr), UVM_MEDIUM);
    end
    
    #10;
    req = cfg_transaction::type_id::create($sformatf("req"));
    start_item(req);
    req.psel=0;
    finish_item(req);
    
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", 32), UVM_LOW)
  endtask
  
endclass