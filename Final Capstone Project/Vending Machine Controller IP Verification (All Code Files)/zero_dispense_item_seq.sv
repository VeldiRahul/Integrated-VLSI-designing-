class zero_stock_item_dispense_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(zero_stock_item_dispense_seq)

  function new(string name = "zero_stock_item_dispense_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction item_tx;

    // Select an item which cfg_zero has set to avail_items = 0
    item_tx = item_select_transaction::type_id::create("item_tx");
    start_item(item_tx);
    item_tx.item_select       = 3;     // assume item 3 is zero stock
    item_tx.item_select_valid = 1'b1;
    item_tx.no_of_items       = 8'd1;  // one item requested
    finish_item(item_tx);

    `uvm_info("ZERO_STOCK_SEQ",
              "Attempted to purchase item with zero stock",
              UVM_MEDIUM);
  endtask
endclass


class zero_stock_currency_dispense_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(zero_stock_currency_dispense_seq)

  function new(string name = "zero_stock_currency_dispense_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction curr_tx;

    curr_tx = currency_transaction::type_id::create("curr_tx");
    start_item(curr_tx);
    curr_tx.currency_value = 8'd50;   // valid supported note
    curr_tx.currency_valid = 1'b1;
    finish_item(curr_tx);

    `uvm_info("ZERO_STOCK_SEQ",
              "Currency inserted for zero-stock item purchase",
              UVM_MEDIUM);
  endtask
endclass
