class cfg_monitor extends uvm_monitor;
  `uvm_component_utils(cfg_monitor)
  
  virtual cfg_if vif;
  
  uvm_analysis_port #(cfg_transaction) cfg_ap;
  
  function new(string name="cfg_monitor", uvm_component parent=null);
    super.new(name, parent);
    cfg_ap = new("cfg_ap", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual cfg_if)::get(this, "", "cfg_vif", vif))
      `uvm_fatal("CFG_MONITOR", "Virtual interface not found")
  endfunction
  
  task run_phase(uvm_phase phase);
    cfg_transaction tx;

    forever begin
      @(posedge vif.pclk);

      if (vif.psel) begin

        while (!vif.pready) @(posedge vif.pclk);


        tx = cfg_transaction::type_id::create("tx");
        tx.paddr  = vif.paddr;
        tx.pwrite = vif.pwrite;
        tx.rstn_ctrl = vif.prstn;
        tx.psel = vif.psel;
        tx.pready = vif.pready;

        if (vif.pwrite) begin
          tx.pwdata = vif.pwdata;
          `uvm_info("CFG_MONITOR", $sformatf("WRITE: addr=0x%0h data=0x%0h (pready=1)", tx.paddr, tx.pwdata), UVM_LOW)
        end else begin
          tx.prdata = vif.prdata;
          `uvm_info("CFG_MONITOR", $sformatf("READ : addr=0x%0h data=0x%0h (pready=1)", tx.paddr, tx.prdata), UVM_LOW)
        end


        cfg_ap.write(tx);
      end
    end
  endtask


  
endclass