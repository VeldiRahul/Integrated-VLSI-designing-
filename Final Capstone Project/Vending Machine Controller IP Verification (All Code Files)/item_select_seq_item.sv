class item_select_seq_item extends uvm_sequence_item;
  `uvm_object_utils(item_select_seq_item)
  
  rand bit        item_select_valid;
  rand bit [9:0]  item_select;
  rand bit [7:0]  no_of_items;
  time            trig_time;

  function new(string name = "item_select_seq_item");
    super.new(name);
    item_select_valid = 1'b0;
    item_select       = 10'd0;
    no_of_items       =  8'd0;
  endfunction

  function string convert2string();
    return $sformatf("item_select_valid = %0b, item_select = %0d,  no_of_items = %0d " , item_select_valid, item_select ,  no_of_items);
  endfunction

endclass

