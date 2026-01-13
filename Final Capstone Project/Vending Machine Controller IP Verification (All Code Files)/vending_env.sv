class vending_env extends uvm_env;
  `uvm_component_utils(vending_env)
  
  cfg_agent          cfg_ag;
  currency_agent     currency_ag;
  item_select_agent  item_ag;
  dispense_agent     dispense_ag;

  vending_sb         v_scoreboard;
  checker_sb         c_scoreboard;
  
  vending_ref_model ref_m;
  
  function new(string name="vending_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    cfg_ag       = cfg_agent::type_id::create("cfg_ag", this);
    currency_ag  = currency_agent::type_id::create("currency_ag", this);
    item_ag      = item_select_agent::type_id::create("item_ag", this);
    dispense_ag  = dispense_agent::type_id::create("dispense_ag", this);

    v_scoreboard = vending_sb::type_id::create("v_scoreboard", this);
    c_scoreboard = checker_sb::type_id::create("c_scoreboard", this);
    
    ref_m = vending_ref_model::type_id::create("ref_m", this);
    uvm_config_db#(vending_ref_model)::set(this, "*", "ref_m", ref_m);

  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    cfg_ag.mon.cfg_ap.connect(c_scoreboard.a_chk.imp);
    currency_ag.mon.currency_ap.connect(c_scoreboard.c_chk.imp);
    item_ag.mon.item_ap.connect(c_scoreboard.i_chk.imp);
    dispense_ag.mon.dispense_ap.connect(c_scoreboard.d_chk.imp);
  endfunction

endclass





