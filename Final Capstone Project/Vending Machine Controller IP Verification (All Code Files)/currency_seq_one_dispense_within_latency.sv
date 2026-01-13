class currency_one_dispense_within_latency_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_one_dispense_within_latency_seq)

  function new(string name = "currency_one_dispense_within_latency_seq");
    super.new(name);
  endfunction


  task body();
    currency_transaction c_tx;

    c_tx = currency_transaction::type_id::create("within_lat_curr_tx");
    start_item(c_tx);

    c_tx.currency_valid = 1'b1;
    c_tx.currency_value = 100;   

    finish_item(c_tx);

    `uvm_info("VENDING_CURRENCY_TEST",
              "Within-latency: currency insertion done",
              UVM_LOW)
  endtask
endclass
