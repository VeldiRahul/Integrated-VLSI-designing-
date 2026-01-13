class currency_agent extends uvm_agent;
  `uvm_component_utils(currency_agent)
  
  currency_sequencer seqr;
  currency_driver    drvr;
  currency_monitor   mon;

  
  function new(string name="currency_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = currency_sequencer::type_id::create("seqr", this);
    drvr = currency_driver::type_id::create("drvr", this);
    mon  = currency_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drvr.seq_item_port.connect(seqr.seq_item_export);
  endfunction
 
  
endclass