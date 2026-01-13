class currency_seq_item extends uvm_sequence_item;
  `uvm_object_utils(currency_seq_item)
  
  rand bit        currency_valid;
  rand bit [6:0]  currency_value;


  function new(string name = "currency_seq_item");
    super.new(name);
    currency_valid = 1'b0;
    currency_value = 7'd0;
  endfunction

  function string convert2string();
    return $sformatf("currency_valid = %0b, currency_value = %0d", currency_valid, currency_value);
  endfunction

endclass

