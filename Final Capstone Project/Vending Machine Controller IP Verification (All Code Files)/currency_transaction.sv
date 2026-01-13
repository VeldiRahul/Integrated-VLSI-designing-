class currency_transaction extends uvm_sequence_item;
  `uvm_object_utils(currency_transaction)

  rand bit [7:0] currency_value; 
  rand bit currency_valid;

  function new(string name = "currency_transaction");
    super.new(name);
  endfunction

  constraint currency_value_range {
   soft currency_value inside {5, 10, 15, 20, 50, 100};
  }

  constraint valid_flag {
    currency_valid == 1;
  }

  constraint max_value {
    currency_value <= 100;
  }

  function string convert2string();
    return $sformatf("CURRENCY TX: coin = %0d", currency_value);
  endfunction
endclass



