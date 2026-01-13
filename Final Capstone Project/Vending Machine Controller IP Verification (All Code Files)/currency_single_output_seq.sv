class currency_single_output_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_single_output_seq)

  function new(string name = "currency_single_output_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction c_tx;

    c_tx = currency_transaction::type_id::create("single_out_curr_tx");
    start_item(c_tx);

    c_tx.currency_valid = 1'b1;
    c_tx.currency_value = 50;   

    finish_item(c_tx);

    `uvm_info("VENDING_CURRENCY_TEST",
              "Single-output: currency insertion done",
              UVM_LOW)
  endtask
endclass
