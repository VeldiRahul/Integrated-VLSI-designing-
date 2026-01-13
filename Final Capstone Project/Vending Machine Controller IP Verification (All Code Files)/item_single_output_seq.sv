class item_single_output_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_single_output_seq)

  function new(string name = "item_single_output_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction tx;

    tx = item_select_transaction::type_id::create("single_out_item_tx");
    start_item(tx);

    tx.item_select_valid = 1'b1;
    tx.item_select       = 5'd1;   
    tx.no_of_items       = 8'd1;

    finish_item(tx);

    `uvm_info("VENDING_ITEM_TEST",
              "Single-output: item insertion done",
              UVM_LOW)
  endtask
endclass
