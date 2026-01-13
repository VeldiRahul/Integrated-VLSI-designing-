class item_random_valid_multiitem_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_random_valid_multiitem_seq)

  function new(string name = "item_random_valid_multiitem_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction i_tx;

    repeat (10) begin
      i_tx = item_select_transaction::type_id::create("i_tx");
      start_item(i_tx);
      
      assert(i_tx.randomize() with {
        item_select       inside {[0:31]}; 
        item_select_valid == 1;
        no_of_items       inside {[1:10]}; 
      });

      finish_item(i_tx);
      #100;
    end

    `uvm_info("VENDING_TEST", "MULTIPLE VALID ITEMS ARE SELECTED.", UVM_LOW)
  endtask
endclass


class currency_random_valid_multiitem_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_random_valid_multiitem_seq)

  function new(string name = "currency_random_valid_multiitem_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction c_tx;

    
    repeat (10) begin
      repeat (5) begin
        c_tx = currency_transaction::type_id::create("c_tx");
        start_item(c_tx);

        assert(c_tx.randomize() with {
          currency_value inside {5,10,15,20,50,100};
          currency_valid == 1;
        });

        finish_item(c_tx);
        #10;
      end
      #50;
    end

    `uvm_info("CURRENCY_RAND_MULTIITEM_SEQ", "Sent multiple random VALID currency transactions.", UVM_MEDIUM)
  endtask
endclass
