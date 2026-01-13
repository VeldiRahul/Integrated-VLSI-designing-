class item_randomized_back_to_back_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_randomized_back_to_back_seq)

  function new(string name = "item_randomized_back_to_back_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction item_tx;

    repeat (6) begin
      item_tx = item_select_transaction::type_id::create("item_tx");
      start_item(item_tx);

      item_tx.item_select       = 5'd30; // valid index (0..31)
      item_tx.item_select_valid = 1'b1;
      item_tx.no_of_items       = 8'd1;  // single item

      finish_item(item_tx);
      #50;
    end

    `uvm_info("ITEM_BACK2BACK_SEQ", "Sent 6 back-to-back item selects.", UVM_MEDIUM)
  endtask
endclass


class currency_randomized_back_to_back_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_randomized_back_to_back_seq)

  function new(string name = "currency_randomized_back_to_back_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction curr_tx;

    repeat (6) begin
      curr_tx = currency_transaction::type_id::create("curr_tx");
      start_item(curr_tx);

      // Fixed valid note (50 Rs)
      curr_tx.currency_value = 8'd50;
      curr_tx.currency_valid = 1'b1;

      finish_item(curr_tx);
      #50;
    end

    `uvm_info("CURRENCY_BACK2BACK_SEQ", "Sent 6 back-to-back currency values.", UVM_MEDIUM)
  endtask
endclass
