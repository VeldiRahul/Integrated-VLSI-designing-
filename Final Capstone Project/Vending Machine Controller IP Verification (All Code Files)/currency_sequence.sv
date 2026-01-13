
class currency_sequence extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_sequence)

  function new(string name = "currency_sequence");
    super.new(name);
  endfunction

  task body();
   currency_transaction req = currency_transaction ::type_id::create("req");
    start_item(req);
    req.currency_valid = 1'b1;
    req.currency_value = 8'd100;
	finish_item(req);
    
     `uvm_info("************************Currency sequence***********************", "Currency insertion completed successfully", UVM_MEDIUM)
  endtask
endclass


