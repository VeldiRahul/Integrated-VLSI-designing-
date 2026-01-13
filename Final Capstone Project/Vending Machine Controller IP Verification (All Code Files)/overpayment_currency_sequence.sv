class item_overpayment_with_change_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_overpayment_with_change_seq)

  function new(string name = "item_overpayment_with_change_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction item_tx;

    item_tx = item_select_transaction::type_id::create("item_tx");
    start_item(item_tx);
    item_tx.item_select       = 3;     // same item as exact-pay case
    item_tx.item_select_valid = 1'b1;
    item_tx.no_of_items       = 8'd1;
    finish_item(item_tx);

    `uvm_info("ITEM_OVERPAY_SEQ",
              "Sent item select for overpayment test.",
              UVM_MEDIUM);
  endtask
endclass


class currency_overpayment_with_change_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_overpayment_with_change_seq)

  function new(string name = "currency_overpayment_with_change_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction curr_tx;

    curr_tx = currency_transaction::type_id::create("curr_tx");
    start_item(curr_tx);
    curr_tx.currency_value = 8'd100;  // valid note, > item price -> change expected
    curr_tx.currency_valid = 1'b1;
    finish_item(curr_tx);

    `uvm_info("CURRENCY_OVERPAY_SEQ",
              "Sent overpayment currency value.",
              UVM_MEDIUM);
  endtask
endclass
