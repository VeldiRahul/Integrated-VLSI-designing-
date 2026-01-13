interface dispense_if #(parameter int MAX_ITEMS=32)(input logic clk);
  logic        item_dispense_valid;
  logic [$clog2(MAX_ITEMS)-1:0]  item_dispense;
  logic [15:0]  currency_change;
  logic [7:0] no_of_items_dispensed;
endinterface