class cfg_driver extends uvm_driver#(cfg_transaction, cfg_transaction);
  `uvm_component_utils(cfg_driver)
  
  virtual cfg_if vif;
  
  function new(string name="cfg_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual cfg_if)::get(this, "", "cfg_vif", vif))
      `uvm_fatal("CFG_DRIVER", "Virtual interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    cfg_transaction req;

    vif.paddr  <= 0;
    vif.pwdata <= 0;
    vif.pwrite <= 0;
    vif.psel   <= 0;

    forever begin
      seq_item_port.get_next_item(req);
      
      @(posedge vif.pclk); 
      `uvm_info("CFG_DRIVER", $sformatf(
        "Starting APB transaction: paddr=0x%0h, pwdata=0x%0h, pwrite=%0b",
        req.paddr, req.pwdata, req.pwrite), UVM_MEDIUM)
      
      vif.paddr  <= req.paddr;
      vif.pwdata <= req.pwdata;
      vif.pwrite <= req.pwrite;
      vif.psel   <= req.psel;
      
      @(posedge vif.pclk);
      vif.paddr  <= 0;
      vif.pwdata <= 0;
      vif.pwrite <= 0;
      vif.psel   <= 0;

      `uvm_info("CFG_DRIVER", "Transaction complete", UVM_MEDIUM)
      seq_item_port.item_done();
    end
  endtask
  
endclass