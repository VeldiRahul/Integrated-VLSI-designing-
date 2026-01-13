class cfg_seq_item extends uvm_sequence_item;
  `uvm_object_utils(cfg_seq_item)
 
  rand bit [14:0] paddr;
  rand bit        psel;
  rand bit        pwrite;
  rand bit [31:0] pwdata;
  bit             pready;
  bit [31:0]      prdata;
  rand bit         rstn_ctrl; 
  
  function new(string name="cfg_seq_item");
    super.new(name);
    paddr   = 15'd0;
    psel    = 1'b0;
    pwrite  = 1'b0;
    pwdata  = 32'd0;
    pready  = 1'b0;
    prdata  = 32'd0;
  endfunction
 
  //required constraints to be added here
  
  
  //develop any pre defined  functions based on requirement
  //ex - print,copy or compare
  function string convert2string();
    return $sformatf("paddr=0x%0h, psel=%0b, pwrite=%0b, pwdata=0x%0h", paddr, psel, pwrite, pwdata);
  endfunction
  
endclass