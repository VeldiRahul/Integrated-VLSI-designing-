class currency_random_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_random_seq)

  function new(string name = "currency_random_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction req; 

    repeat (MAX_ITEMS) begin
      req = currency_transaction::type_id::create("req");
      start_item(req);
      
      assert(req.randomize() with {
        currency_value inside {5, 10, 15, 20, 50, 100}; 
        currency_valid == 1'b1;
      })
      else begin
        `uvm_error("CURRENCY_SEQ", "Randomization failed for currency transaction")
      end
      
      finish_item(req);
      `uvm_info("CURRENCY_SEQ", req.convert2string(), UVM_MEDIUM)
      
   
      #150; 
    end
  endtask
endclass