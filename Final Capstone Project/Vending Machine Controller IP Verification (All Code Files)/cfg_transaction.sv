class cfg_transaction extends uvm_sequence_item;
  `uvm_object_utils(cfg_transaction)

  randc bit [15:0] paddr;
  rand bit  [31:0] pwdata;
  rand bit         pwrite; 
  rand bit 		   pready;
  rand bit 		   psel;
  bit       [31:0] prdata;
  rand bit         rstn_ctrl; 
  

  function new(string name = "cfg_transaction");
    super.new(name);
  endfunction
  
  constraint addr_range {
    paddr inside { [16'h0004 : 16'h0004 + (MAX_ITEMS-1)*4] };
	(paddr % 4 == 0);
 
}
  constraint psel_c {
    if (!psel)
        pwrite == 0;
}
  
  constraint reset_stable {
    rstn_ctrl == 1;
}
                 
  constraint c1 {
  if (pwrite) {
    pwdata[15:0]  inside {[5:100]}; 
    pwdata[23:16] inside { [0:255] };         
    pwdata[31:24] == 8'd0;                   
  }
  else {
    pwdata == 32'd0;
  }
}
    
                         
  function string convert2string();
    return $sformatf("CFG TX: %s addr=0x%0h data=0x%0h",
                     pwrite ? "WRITE" : "READ", paddr, pwdata);
  endfunction
endclass