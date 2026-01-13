class currency_before_item_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_before_item_seq)

  function new(string name = "currency_before_item_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction req;
    req = currency_transaction::type_id::create("req");

    start_item(req);
    req.currency_valid = 1;
    req.currency_value = 50;
    finish_item(req);

    `uvm_info("VENDING_ERROR", 
              "Currency inserted BEFORE item selection (Invalid as per spec)", 
              UVM_LOW)
  endtask
endclass
