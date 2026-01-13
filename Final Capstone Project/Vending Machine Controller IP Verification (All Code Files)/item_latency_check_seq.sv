class item_latency_check_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_latency_check_seq)

  function new(string name = "item_latency_check_seq");
    super.new(name);
  endfunction


  task body();
    item_select_transaction tx;

    tx = item_select_transaction::type_id::create("latency_item_tx");
    start_item(tx);

    tx.item_select_valid = 1'b1;
    tx.item_select       = 5'd2;   
    tx.no_of_items       = 8'd1;  

    finish_item(tx);

    `uvm_info("VENDING_ITEM_TEST",
              "Latency check: item selection done",
              UVM_LOW)
  endtask
endclass
