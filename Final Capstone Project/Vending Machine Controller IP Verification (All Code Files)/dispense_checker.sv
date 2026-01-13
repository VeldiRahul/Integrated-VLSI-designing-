class dispense_checker extends uvm_component;
  `uvm_component_utils(dispense_checker)

  uvm_analysis_imp#(dispense_transaction, dispense_checker) imp;

  vending_ref_model ref_m;
  virtual vmc_if ctrl_vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(vending_ref_model)::get(this, "", "ref_m", ref_m))
      `uvm_fatal("DISPENSE_CHECKER", "ref_m not found in config DB")

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("DISPENSE_CHECKER", "ctrl_vif not found in config DB")
  endfunction

  function void write(dispense_transaction tr);
    bit exp_valid;
    int exp_item, exp_count, exp_change;

    // Ask ref_model what SHOULD have happened
    ref_m.dispense_item(exp_valid, exp_item, exp_count, exp_change);

    `uvm_info("dispense_CHECK",
      $sformatf("expected_item: %0d", exp_item),
      UVM_LOW)

    `uvm_info("DISPENSE_CHECKER",
      $sformatf("DUT: valid=%0b item=%0d count=%0d change=%0d | REF: valid=%0b item=%0d count=%0d change=%0d",
                tr.item_dispense_valid,
                tr.item_dispense,
                tr.no_of_items_dispensed,
                tr.currency_change,
                exp_valid,
                exp_item,
                exp_count,
                exp_change),
      UVM_MEDIUM)

    // Now compare and flag mismatches
    if (tr.item_dispense_valid !== exp_valid ||
        tr.item_dispense        !== exp_item ||
        tr.no_of_items_dispensed !== exp_count ||
        tr.currency_change      !== exp_change) begin

      `uvm_error("DISPENSE_CHECKER",
        $sformatf("DISPENSE MISMATCH: DUT {valid=%0b item=%0d count=%0d change=%0d}  REF {valid=%0b item=%0d count=%0d change=%0d}",
                  tr.item_dispense_valid,
                  tr.item_dispense,
                  tr.no_of_items_dispensed,
                  tr.currency_change,
                  exp_valid,
                  exp_item,
                  exp_count,
                  exp_change))
    end
  endfunction

endclass


// class dispense_checker extends uvm_component;
//   `uvm_component_utils(dispense_checker)

//   uvm_analysis_imp#(dispense_transaction, dispense_checker) imp;
//   vending_ref_model ref_m;

//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//     imp = new("imp", this);
//   endfunction

//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);

//     if (!uvm_config_db#(vending_ref_model)::get(this, "", "ref_m", ref_m))
//       `uvm_fatal("DISPENSE_CHECKER", "Reference model handle not found")
//   endfunction

//   function void write(dispense_transaction t);

//     bit exp_valid;
//     int exp_item;
//     int exp_qty;
//     int exp_change;

//     // Get expected results from reference model
//     ref_m.dispense_item(exp_valid,
//                         exp_item,
//                         exp_qty,
//                         exp_change);

//     `uvm_info("DISPENSE_CHECKER",$sformatf("REF: valid=%0b item=%0d qty=%0d change=%0d",
//                                            exp_valid, exp_item, exp_qty, exp_change), UVM_LOW)

//     `uvm_info("DISPENSE_CHECKER",$sformatf("DUT: valid=%0b item=%0d qty=%0d change=%0d",
//                         t.item_dispense_valid, t.item_dispense, t.no_of_items_dispensed, t.currency_change), UVM_LOW)


//     // Compare dispense_valid
    
//     if (t.item_dispense_valid !== exp_valid)
//       `uvm_error("DISPENSE_VALID_MISMATCH",$sformatf("DUT=%0b REF=%0b", t.item_dispense_valid, exp_valid))

//     // If both valid, check remaining fields
//     if (exp_valid && t.item_dispense_valid) begin

//       if (t.item_dispense != exp_item)
//         `uvm_error("ITEM_ID_MISMATCH", $sformatf("DUT=%0d REF=%0d", t.item_dispense, exp_item))

//       if (t.no_of_items_dispensed != exp_qty)
//         `uvm_error("ITEM_QTY_MISMATCH", $sformatf("DUT=%0d REF=%0d", t.no_of_items_dispensed, exp_qty))

//       if (t.currency_change != exp_change)
//         `uvm_error("CHANGE_MISMATCH", $sformatf("DUT=%0d REF=%0d", t.currency_change, exp_change))
//     end

//   endfunction

// endclass

