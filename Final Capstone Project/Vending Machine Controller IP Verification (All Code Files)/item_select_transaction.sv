class item_select_transaction extends uvm_sequence_item;
  `uvm_object_utils(item_select_transaction)

  // Randomizable fields
  rand bit [15:0] item_select; 
  rand bit        item_select_valid;
  rand bit [7:0]  no_of_items;
       time      trig_time;

  function new(string name = "item_select_transaction");
    super.new(name);
  endfunction

  constraint item_id_range {
    item_select inside {[0:31]};  
  }

  constraint weighted_item_id {
    item_select dist {
      0       := 2,    // low weight
      31      := 2,    // low weight
      [10:20] := 10    // high weight → chosen more often
    };
  }

constraint valid_item { 
        item_select < MAX_ITEMS; 
    }

  constraint implication_logic {
    (item_select_valid == 0) -> (no_of_items == 0);
  }
  
    constraint valid_qty { 
        no_of_items >= 1; 
        no_of_items <= 255; 
    }



  

  function string convert2string();
    return $sformatf("ITEM TX: valid=%0b item=%0d count=%0d",
                     item_select_valid, item_select, no_of_items);
  endfunction

endclass