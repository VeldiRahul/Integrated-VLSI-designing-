class currency_checker extends uvm_component;
  `uvm_component_utils(currency_checker)

  uvm_analysis_imp#(currency_transaction, currency_checker) imp;

  vending_ref_model ref_m;
    virtual vmc_if ctrl_vif;

  function new(string name, uvm_component parent );
    super.new(name, parent);
    imp = new("imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("NO_VIF", "Virtual interface not found for currency_checker")
      
    ref_m = vending_ref_model::type_id::create("ref_m", this);
  endfunction

  function void write(currency_transaction t);
 
    if (ctrl_vif.cfg_mode) begin
      `uvm_warning("CURRENCY_CHECKER",
                   "Config mode is asserted! Currency check ignored.")
      return;
    end

    if (t.currency_value inside {5, 10, 15, 20, 50, 100}) begin

      `uvm_info("CURRENCY_CHECKER",
                $sformatf("Valid currency inserted: %0d", t.currency_value),
                UVM_LOW)

      ref_m.insert_currency(t.currency_value);

    end else begin

      `uvm_warning("CURRENCY_CHECKER",
                   $sformatf("Invalid currency inserted: %0d",
                             t.currency_value))
    end
  endfunction
endclass
