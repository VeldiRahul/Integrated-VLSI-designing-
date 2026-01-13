class item_random_user_sequence_mix_seq extends uvm_sequence #(item_select_transaction);
  `uvm_object_utils(item_random_user_sequence_mix_seq)

  function new(string name = "item_random_user_sequence_mix_seq");
    super.new(name);
  endfunction

  task body();
    item_select_transaction item_req;

    repeat (2) begin
      item_req = item_select_transaction::type_id::create("item_req");
      start_item(item_req);

      // Choose items from upper range (e.g., 12..31)
      assert(item_req.randomize() with {
        item_select       inside {[12:31]};
        item_select_valid == 1;
        no_of_items       inside {[1:8]};
      });

      finish_item(item_req);
      #100;
    end
  endtask
endclass



class currency_random_user_sequence_mix_seq extends uvm_sequence #(currency_transaction);
  `uvm_object_utils(currency_random_user_sequence_mix_seq)

  function new(string name = "currency_random_user_sequence_mix_seq");
    super.new(name);
  endfunction

  task body();
    currency_transaction c_tx;

    // Mix of supported and UNSUPPORTED values, all <= 100
    repeat (2) begin
      c_tx = currency_transaction::type_id::create("c_tx");
      start_item(c_tx);

      assert(c_tx.randomize() with {
        // 7 and 30 are unsupported; 50 is supported
        currency_value inside {7,30,50};
        currency_valid == 1;
      });

      finish_item(c_tx);
      #100;
    end
  endtask
endclass
