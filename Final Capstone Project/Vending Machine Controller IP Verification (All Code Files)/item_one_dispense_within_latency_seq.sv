class item_one_dispense_within_latency_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_one_dispense_within_latency_seq)

  function new(string name = "item_one_dispense_within_latency_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction tx;

    tx = item_select_transaction::type_id::create("within_lat_item_tx1");
    start_item(tx);
    tx.item_select_valid = 1'b1;
    tx.item_select       = 5'd3;
    tx.no_of_items       = 8'd1;
    finish_item(tx);

    `uvm_info("VENDING_ITEM_TEST",
              "Within-latency: item insertion 1 done",
              UVM_LOW)

    #10;

    tx = item_select_transaction::type_id::create("within_lat_item_tx2");
    start_item(tx);
    tx.item_select_valid = 1'b1;
    tx.item_select       = 5'd3;
    tx.no_of_items       = 8'd1;
    finish_item(tx);

    `uvm_info("VENDING_ITEM_TEST",
              "Within-latency: item insertion 2 done",
              UVM_LOW)
  endtask
endclass
