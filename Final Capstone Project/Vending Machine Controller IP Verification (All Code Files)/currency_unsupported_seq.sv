class unsupported_currency_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(unsupported_currency_seq)

  function new(string name = "unsupported_currency_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction req;
    req = currency_transaction::type_id::create("un_currency");

    start_item(req);
    assert(req.randomize() with {
      currency_valid == 1'b1;
      currency_value inside { 2, 3, 30, 200, 500 }; // Outside (5,10,15,20,50,100)
    });
    finish_item(req);

    `uvm_info("VENDING_TEST", "Unsupported currency injected", UVM_LOW)
  endtask
endclass
