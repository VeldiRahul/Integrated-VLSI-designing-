parameter int MAX_ITEMS = 32;
class item_select_sequence extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_select_sequence)

  function new(string name = "item_select_sequence");
    super.new(name);
  endfunction

  task body();
    item_select_transaction req;
    req = item_select_transaction::type_id::create("req");

    start_item(req);
    assert(req.randomize() with {
      item_select inside {[0 : MAX_ITEMS-1]};
      no_of_items inside {[1 : 255]};
      item_select_valid == 1;
    });
    finish_item(req);
  endtask
endclass
