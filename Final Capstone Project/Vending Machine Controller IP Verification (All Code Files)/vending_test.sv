class vending_test extends uvm_test;
  `uvm_component_utils(vending_test)

  cfg_sequence            cfg_seq;
  item_select_sequence    item_seq;
  currency_sequence       curr_seq;
  vending_env env;
  
  virtual vmc_if ctrl_vif;

  function new(string name="vending_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = vending_env::type_id::create("env", this);
    
    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
    `uvm_fatal("VENDING_TEST", "Virtual ctrl_vif not found")
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    `uvm_info("VENDING_TEST", "Starting test sequences...", UVM_LOW)
    ctrl_vif.cfg_mode = 1;
    cfg_seq = cfg_sequence::type_id::create("cfg_seq");
    cfg_seq.start(env.cfg_ag.seqr);
    `uvm_info("VENDING_TEST", "Configuration sequence completed.", UVM_LOW)
    ctrl_vif.cfg_mode = 0;

    #320;

    item_seq = item_select_sequence::type_id::create("item_seq");
    item_seq.start(env.item_ag.seqr);
    `uvm_info("VENDING_TEST", "Item selection sequence completed.", UVM_LOW)
   
    curr_seq = currency_sequence::type_id::create("curr_seq");
    curr_seq.start(env.currency_ag.seqr);
    `uvm_info("VENDING_TEST", "Currency insertion completed.", UVM_LOW)


    #200; 

    `uvm_info("VENDING_TEST", "Test sequence finished.", UVM_LOW)
    
    `uvm_info("TEST", "Printing topology only...", UVM_LOW)
   #10;

	
    phase.drop_objection(this);
  endtask
endclass
