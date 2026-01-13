class currency_monitor extends uvm_monitor;
  `uvm_component_utils(currency_monitor)

  virtual currency_if vif;
  uvm_analysis_port #(currency_transaction) currency_ap;

  covergroup currency_cg;
    coverpoint currency_val_cp;
  endgroup

  int currency_val_cp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    currency_ap = new("currency_ap", this);
    currency_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual currency_if)::get(this, "", "currency_vif", vif))
      `uvm_fatal("CURRENCY_MONITOR", "Virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    currency_transaction tx;
    forever begin
      @(posedge vif.clk);
      if (vif.currency_valid) begin
        tx = currency_transaction::type_id::create("tx");
        tx.currency_value = vif.currency_value;
        tx.currency_valid = vif.currency_valid;
        currency_val_cp = vif.currency_value;
        currency_cg.sample();
        currency_ap.write(tx);
        `uvm_info("CURRENCY_MONITOR", $sformatf("Currency inserted: value = %0d, valid=%d", tx.currency_value,tx.currency_valid), UVM_LOW)
      end
    end
  endtask
endclass
