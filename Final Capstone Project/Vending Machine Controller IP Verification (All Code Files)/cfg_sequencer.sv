class cfg_sequencer extends uvm_sequencer#(cfg_transaction);
  `uvm_component_utils(cfg_sequencer)
  
  function new(string name="cfg_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass