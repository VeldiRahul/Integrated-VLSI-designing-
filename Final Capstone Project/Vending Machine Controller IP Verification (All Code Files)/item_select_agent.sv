//import uvm_pkg::*;
class item_select_agent extends uvm_agent;
  `uvm_component_utils(item_select_agent)
  
  item_select_sequencer seqr;
  item_select_driver    drvr;
  item_select_monitor   mon;

  function new(string name="item_select_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = item_select_sequencer::type_id::create("seqr", this);
    drvr = item_select_driver::type_id::create("drvr", this);
    mon  = item_select_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    drvr.seq_item_port.connect(seqr.seq_item_export);
  endfunction
  
endclass