class item_exact_currency_dispense_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_exact_currency_dispense_seq)

  function new(string name = "item_exact_currency_dispense_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction item_tx;

    item_tx = item_select_transaction::type_id::create("item_tx");
    start_item(item_tx);
    item_tx.item_select       = 3;     // assume price configured = 50
    item_tx.item_select_valid = 1'b1;
    item_tx.no_of_items       = 8'd1;
    finish_item(item_tx);

    `uvm_info("ITEM_EXACT_SEQ",
              "Sent exact item selection.",
              UVM_MEDIUM);
  endtask
endclass


class currency_exact_currency_dispense_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_exact_currency_dispense_seq)

  function new(string name = "currency_exact_currency_dispense_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction curr_tx;

    curr_tx = currency_transaction::type_id::create("curr_tx");
    start_item(curr_tx);
    curr_tx.currency_value = 8'd50;  // matches configured item value
    curr_tx.currency_valid = 1'b1;
    finish_item(curr_tx);

    `uvm_info("CURRENCY_EXACT_SEQ",
              "Exact currency inserted.",
              UVM_MEDIUM);
  endtask
endclass
