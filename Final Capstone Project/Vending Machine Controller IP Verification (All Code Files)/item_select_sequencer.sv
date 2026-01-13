class item_select_sequencer extends uvm_sequencer#(item_select_transaction);
  `uvm_component_utils(item_select_sequencer)
  
  function new(string name="item_select_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  
endclass