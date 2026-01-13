class dispense_transaction extends uvm_sequence_item;
  `uvm_object_utils(dispense_transaction)
  
  bit               item_dispense_valid;       
  bit [9:0]         item_dispense;             
  bit [7:0]         no_of_items_dispensed;     
  bit [7:0]         currency_change;           
  time              trig_time;                 

  function new(string name = "dispense_transaction");
    super.new(name);
  endfunction
  
  constraint c_valid {
  item_dispense_valid inside {0,1};
}

constraint c_item_range {
  item_dispense inside { [0 : MAX_ITEMS-1] };
}

constraint c_qty_range {
  no_of_items_dispensed inside { [0:255] };
}

constraint c_change_range {
  currency_change inside { [0:255] };
}


  function string convert2string();
    return $sformatf("DISPENSE_TX: valid=%0d item=%0d qty=%0d change=%0d time=%0t",
      item_dispense_valid,item_dispense,no_of_items_dispensed,currency_change,trig_time);
  endfunction
endclass
