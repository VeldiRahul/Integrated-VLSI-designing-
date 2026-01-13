class basic_random_test extends uvm_test;
  `uvm_component_utils(basic_random_test)
  
  vending_env env;  
  virtual vmc_if ctrl_vif;
  virtual cfg_if cif;
  
  config_random_write_seq cfg_write_r;
  config_random_read_seq  cfg_read_r;
  item_random_seq    item_r;
  currency_random_seq currency_r;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = vending_env::type_id::create("env", this);
       if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
         `uvm_fatal("test5", "Virtual interface not found")
    endfunction
      
      function void end_of_elaboration_phase (uvm_phase phase);
		uvm_top.print_topology ();
	  endfunction
 
    task run_phase(uvm_phase phase);
    phase.raise_objection(this);

      `uvm_info("VENDING_TEST", "Starting randomization config test...", UVM_LOW)
    ctrl_vif.cfg_mode = 1;  //cfg_mode is high
      
    cfg_write_r = config_random_write_seq::type_id::create("cfg_write");
    cfg_write_r.start(env.cfg_ag.seqr);
    `uvm_info("VENDING_TEST", "Configuration sequence completed.", UVM_LOW)
    #100;
      
      ctrl_vif.cfg_mode = 0;
      #10;
      ctrl_vif.cfg_mode = 1;
      
      cfg_read_r = config_random_read_seq::type_id::create("cfg_read");
      cfg_read_r.start(env.cfg_ag.seqr);
      #10;
      ctrl_vif.cfg_mode = 0; #10;
      
    fork 
      begin
        item_r = item_random_seq::type_id::create("item_r");
        item_r.start(env.item_ag.seqr);
        `uvm_info("VENDING_TEST", "Item selection sequence completed.", UVM_LOW)
      end
      
      begin 
         #10;
         currency_r =  currency_random_seq::type_id::create(" currency_r");
         currency_r.start(env.currency_ag.seqr);
        `uvm_info("VENDING_TEST", "Currency insertion completed.", UVM_LOW)
      end
        join
    #200; 

    `uvm_info("VENDING_TEST", "Test sequence finished.", UVM_LOW)
    phase.drop_objection(this);
  endtask


endclass