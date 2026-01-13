class item_random_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_random_seq)

  function new(string name = "item_random_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction req;

    repeat (MAX_ITEMS) begin
      req = item_select_transaction::type_id::create("req");
      start_item(req);
      
      assert(req.randomize() with {
        item_select         inside {[0:MAX_ITEMS-1]}; 
        item_select_valid   == 1'b1;
        no_of_items         == 8'd1; 
      })
      else begin
        `uvm_error("ITEM_SEQ", "Randomization failed for item transaction")
      end
      
      finish_item(req);
      `uvm_info("ITEM_SEQ", req.convert2string(), UVM_MEDIUM)
      
      #150; 
    end
  endtask
endclass