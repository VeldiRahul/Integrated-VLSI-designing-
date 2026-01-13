class currency_latency_check_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_latency_check_seq)

  function new(string name = "currency_latency_check_seq");
    super.new(name);
  endfunction


  task body();
    currency_transaction c_tx;

    for (int i = 0; i < 10; i++) begin
      c_tx = currency_transaction::type_id::create($sformatf("latency_curr_tx_%0d", i));
      start_item(c_tx);

      c_tx.currency_valid = 1'b1;
      c_tx.currency_value = 5;   

      finish_item(c_tx);
      #10; 
    end

    `uvm_info("VENDING_CURRENCY_TEST",
              "Latency check: currency insertion done",
              UVM_LOW)
  endtask
endclass
