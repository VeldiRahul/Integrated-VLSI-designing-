class item_select_monitor extends uvm_monitor;
  `uvm_component_utils(item_select_monitor)

  virtual item_select_if vif;
  uvm_analysis_port #(item_select_transaction) item_ap;


  covergroup item_cg;
    coverpoint item_select_cp;
  endgroup

  int item_select_cp;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_ap = new("item_ap", this);
    item_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual item_select_if)::get(this, "", "item_select_vif", vif))
      `uvm_fatal("ITEM_MONITOR", "Virtual interface not found")
  endfunction

  task run_phase(uvm_phase phase);
    item_select_transaction tx;

    forever begin
      @(posedge vif.clk);

      if (vif.item_select_valid) begin
        tx = item_select_transaction::type_id::create("tx");

        tx.item_select       = vif.item_select;
        tx.item_select_valid = vif.item_select_valid;
        tx.no_of_items       = vif.no_of_items;
        tx.trig_time         = $time;

        item_select_cp = vif.item_select;
        item_cg.sample();
        item_ap.write(tx);

        `uvm_info("ITEM_MONITOR",
          $sformatf("Item select: %0d @ %0t, item_valid=%d, no_of_items=%d",
                    tx.item_select, tx.trig_time,
                    tx.item_select_valid, tx.no_of_items),
          UVM_LOW);
      end
    end
  endtask
endclass
