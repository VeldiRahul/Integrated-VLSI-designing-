class currency_sequencer extends uvm_sequencer#(currency_transaction);
  `uvm_component_utils(currency_sequencer)
  
  function new(string name="currency_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  
endclass