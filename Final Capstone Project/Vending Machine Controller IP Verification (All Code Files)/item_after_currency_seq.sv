class item_after_currency_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_after_currency_seq)

  function new(string name = "item_after_currency_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction tx;
    tx = item_select_transaction::type_id::create("late_item");
    start_item(tx);

    tx.constraint_mode(0);
    assert(tx.randomize() with {
      item_select inside {[0 : MAX_ITEMS-1]};
      no_of_items inside {[1 : 10]};
      item_select_valid == 1;
    });

    finish_item(tx);

    `uvm_info("OUT_OF_ORDER",
              $sformatf("Item selected after currency insertion: item=%0d count=%0d",
                        tx.item_select, tx.no_of_items),
              UVM_MEDIUM);
  endtask
endclass
