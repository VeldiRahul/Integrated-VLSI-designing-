class dispense_monitor extends uvm_monitor;
  `uvm_component_utils(dispense_monitor)

  virtual dispense_if #(MAX_ITEMS) vif;
  uvm_analysis_port #(dispense_transaction) dispense_ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    dispense_ap = new("dispense_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual dispense_if #(MAX_ITEMS))::get(this, "", "dispense_vif", vif))
      `uvm_fatal("DISPENSE_MONITOR", "Virtual interface not found");
  endfunction

  task run_phase(uvm_phase phase);
    dispense_transaction tx;

    forever begin
      @(posedge vif.clk);

      if (vif.item_dispense_valid) begin
        tx = dispense_transaction::type_id::create("tx");

        tx.item_dispense_valid     = vif.item_dispense_valid;
        tx.item_dispense           = vif.item_dispense;
        tx.no_of_items_dispensed   = vif.no_of_items_dispensed;
        tx.currency_change         = vif.currency_change;
        tx.trig_time               = $time;

        `uvm_info("DISPENSE_MONITOR",
                  $sformatf("Dispense: valid=%0d item=%0d qty=%0d change=%0d time=%0t",
                            tx.item_dispense_valid,
                            tx.item_dispense,
                            tx.no_of_items_dispensed,
                            tx.currency_change,
                            tx.trig_time),
                  UVM_LOW)

        dispense_ap.write(tx);
      end
    end
  endtask
endclass
