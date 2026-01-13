class item_select_checker extends uvm_component;
  `uvm_component_utils(item_select_checker)

  uvm_analysis_imp#(item_select_transaction, item_select_checker) imp;
  vending_ref_model ref_m;
  virtual vmc_if ctrl_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("ITEM_CHECKER", "ctrl_vif not found in config DB")
    ref_m = vending_ref_model::type_id::create("ref_m", this);
  endfunction

  function void write(item_select_transaction tr);
    if (ctrl_vif.cfg_mode)
      `uvm_warning("ITEM_CHECKER", "cfg_mode = 1 during item selection")

    else if (tr.item_select_valid) begin

      int item_value;
      int available_count;

      // FIXED CALL (4 arguments)
      ref_m.select_item(
        tr.item_select,
        tr.no_of_items,
        item_value,
        available_count
      );

      `uvm_info("ITEM_CHECKER",
        $sformatf("item=%0d val=%0d avail=%0d no_of_items=%0d",
                  tr.item_select, item_value, available_count, tr.no_of_items),
        UVM_LOW)
    end
  endfunction

endclass
