class item_select_driver extends uvm_driver#(item_select_transaction);
  `uvm_component_utils(item_select_driver)

  virtual item_select_if vif;
  virtual vmc_if ctrl_vif;

  function new(string name="item_select_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual item_select_if)::get(this, "", "item_select_vif", vif))
      `uvm_fatal("ITEM_DRIVER", "Virtual interface not found")

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("ITEM_DRIVER", "Virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    item_select_transaction req;

    vif.item_select       <= 0;
    vif.item_select_valid <= 0;
    vif.no_of_items       <= 0;

    forever begin
      @(posedge ctrl_vif.clk);
      seq_item_port.get_next_item(req);

      `uvm_info("ITEM_DRIVER", $sformatf("Selecting item: item_select=%0d, valid=%0b",
                req.item_select, req.item_select_valid), UVM_MEDIUM)

      vif.item_select       <= req.item_select;
      vif.item_select_valid <= req.item_select_valid;
      vif.no_of_items       <= req.no_of_items;

      @(posedge ctrl_vif.clk);
      vif.item_select_valid <= 0;

      `uvm_info("ITEM_DRIVER", "Item selection complete", UVM_MEDIUM)

      seq_item_port.item_done();
    end
  endtask

endclass
