interface cfg_if(input logic pclk);
  logic [15:0] paddr;
  logic        psel;
  logic        pwrite;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  logic prstn;
endinterface