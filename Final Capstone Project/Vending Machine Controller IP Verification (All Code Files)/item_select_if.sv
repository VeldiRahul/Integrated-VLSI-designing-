interface item_select_if #(parameter int  MAX_ITEMS =32 )(input logic clk) ;
  logic        item_select_valid;
  logic [$clog2(MAX_ITEMS)-1:0]  item_select; 
  logic [7:0] no_of_items;
endinterface
