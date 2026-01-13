class invalid_item_select_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(invalid_item_select_seq)

  function new(string name = "invalid_item_select_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction req;
    req = item_select_transaction::type_id::create("req");
    start_item(req);
    req.item_select_valid = 1;
    req.item_select       = 47; 
    finish_item(req);

    `uvm_info("ITEM_SEQ", $sformatf("Invalid item index = %0d", req.item_select), UVM_MEDIUM)
  endtask
endclass
