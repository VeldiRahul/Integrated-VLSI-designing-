
class currency_driver extends uvm_driver #(currency_transaction );
  `uvm_component_utils(currency_driver)

  virtual currency_if vif;
  virtual vmc_if ctrl_vif;
  

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual currency_if)::get(this, "", "currency_vif", vif))
      `uvm_fatal("CURRENCY_DRIVER", "Virtual interface not found")
      if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("ITEM_DRIVER", "Virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    currency_transaction ct;
    vif.currency_valid <= 0;
    vif.currency_value <= 0;
    forever begin
      @(posedge ctrl_vif.clk);
      
      seq_item_port.get_next_item(req);

      `uvm_info("CURRENCY_DRIVER", $sformatf("Inserting currency: value=%0d, valid=%0b", req.currency_value, req.currency_valid), UVM_MEDIUM)

      vif.currency_value <= req.currency_value;
      vif.currency_valid <= req.currency_valid;

      @(posedge ctrl_vif.clk)
      vif.currency_valid <= 0;
       vif.currency_value <= 0;

      `uvm_info("CURRENCY_DRIVER", "Currency insertion complete", UVM_MEDIUM)

      seq_item_port.item_done();
     
    end
  endtask
endclass
