class dispense_agent extends uvm_agent;
  `uvm_component_utils(dispense_agent)
  
   dispense_monitor mon;

  function new(string name="dispense_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = dispense_monitor::type_id::create("mon", this);
  endfunction
  
endclass