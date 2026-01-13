class cfg_agent extends uvm_agent;
  `uvm_component_utils(cfg_agent)
  
  cfg_sequencer  seqr;
  cfg_driver     drvr;
  cfg_monitor    mon;
  
  function new(string name="cfg_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = cfg_sequencer::type_id::create("seqr", this);
    drvr = cfg_driver::type_id::create("drvr", this);
    mon  = cfg_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drvr.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
  
endclass