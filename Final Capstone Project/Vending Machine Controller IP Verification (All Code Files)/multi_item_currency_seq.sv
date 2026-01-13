class item_multi_part_currency_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_multi_part_currency_seq)

  function new(string name = "item_multi_part_currency_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction item_tx;

    item_tx = item_select_transaction::type_id::create("item_tx");
    start_item(item_tx);
    item_tx.item_select       = 3;     // same item as exact/overpay
    item_tx.item_select_valid = 1'b1;
    item_tx.no_of_items       = 8'd1;
    finish_item(item_tx);

    `uvm_info("ITEM_MULTI_PART_SEQ",
              "Sent item selection for multi-part payment.",
              UVM_MEDIUM);
  endtask
endclass


class currency_multi_part_currency_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_multi_part_currency_seq)

  function new(string name = "currency_multi_part_currency_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction curr_tx1, curr_tx2, curr_tx3;
    currency_transaction curr_tx4, curr_tx5, curr_tx6;

    // Total = 5 + 5 + 5 + 10 + 5 + 20 = 50
    curr_tx1 = currency_transaction::type_id::create("curr_tx1");
    start_item(curr_tx1);
    curr_tx1.currency_value = 8'd5;
    curr_tx1.currency_valid = 1'b1;
    finish_item(curr_tx1);
    #10;

    curr_tx2 = currency_transaction::type_id::create("curr_tx2");
    start_item(curr_tx2);
    curr_tx2.currency_value = 8'd5;
    curr_tx2.currency_valid = 1'b1;
    finish_item(curr_tx2);
    #10;

    curr_tx3 = currency_transaction::type_id::create("curr_tx3");
    start_item(curr_tx3);
    curr_tx3.currency_value = 8'd5;
    curr_tx3.currency_valid = 1'b1;
    finish_item(curr_tx3);
    #10;

    curr_tx4 = currency_transaction::type_id::create("curr_tx4");
    start_item(curr_tx4);
    curr_tx4.currency_value = 8'd10;
    curr_tx4.currency_valid = 1'b1;
    finish_item(curr_tx4);
    #10;

    curr_tx5 = currency_transaction::type_id::create("curr_tx5");
    start_item(curr_tx5);
    curr_tx5.currency_value = 8'd5;
    curr_tx5.currency_valid = 1'b1;
    finish_item(curr_tx5);
    #10;

    curr_tx6 = currency_transaction::type_id::create("curr_tx6");
    start_item(curr_tx6);
    curr_tx6.currency_value = 8'd20;
    curr_tx6.currency_valid = 1'b1;
    finish_item(curr_tx6);

    `uvm_info("CURRENCY_MULTI_PART_SEQ",
              "Sent 5+5+5+10+5+20 multi-part payment.",
              UVM_MEDIUM);
  endtask
endclass
