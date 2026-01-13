import uvm_pkg::*;
`include "uvm_macros.svh"
`include "package.sv"

module top;
  
  logic clk = 0;
  always #5 clk = ~clk;

  logic pclk = 0;
  always #10 pclk = ~pclk;

  parameter MAX_ITEMS = 32;
  parameter MAX_NOTE_VAL = 100;

  
  checker_if     checker_vif(clk);
  vmc_if         ctrl_vif(clk);
  cfg_if         cfg_vif(pclk);
  currency_if    currency_vif(clk);
  item_select_if #(.MAX_ITEMS(MAX_ITEMS)) item_vif(clk);
  dispense_if    #(.MAX_ITEMS(MAX_ITEMS)) dispense_vif(clk);
  
  vending_machine #(.MAX_ITEMS(MAX_ITEMS), .MAX_NOTE_VAL(MAX_NOTE_VAL)) dut (
    .clk(clk),
    .rstn(ctrl_vif.rstn),
    .cfg_mode(ctrl_vif.cfg_mode),
    
    .pclk(pclk),
    .prstn(cfg_vif.prstn),
    .paddr(cfg_vif.paddr),
    .psel(cfg_vif.psel),
    .pwrite(cfg_vif.pwrite),
    .pwdata(cfg_vif.pwdata),
    .prdata(cfg_vif.prdata),
    .pready(cfg_vif.pready),
    
    .currency_valid(currency_vif.currency_valid),
    .currency_value(currency_vif.currency_value),
    
    .item_select_valid(item_vif.item_select_valid),
    .item_select(item_vif.item_select),
    .no_of_items(item_vif.no_of_items),
    
    .item_dispense_valid(dispense_vif.item_dispense_valid),
    .item_dispense(dispense_vif.item_dispense),
    .no_of_items_dispensed(dispense_vif.no_of_items_dispensed),
    .currency_change(dispense_vif.currency_change)
  );

	 //assign cfg_vif.pready = 1'b1;
     assign cfg_vif.prstn = ctrl_vif.rstn; 
  
  initial begin
    uvm_config_db#(int)::set(null, "*", "MAX_ITEMS", MAX_ITEMS);
    uvm_config_db#(int)::set(null, "*", "max_currency", MAX_NOTE_VAL);
    uvm_config_db #(virtual vmc_if)       ::set(null, "*", "ctrl_vif", ctrl_vif);
    uvm_config_db #(virtual cfg_if)        ::set(null, "*", "cfg_vif", cfg_vif);
    uvm_config_db #(virtual currency_if)   ::set(null, "*", "currency_vif", currency_vif);
    uvm_config_db #(virtual item_select_if #(MAX_ITEMS) )::set(null, "*", "item_select_vif", item_vif);
    uvm_config_db #(virtual dispense_if #(MAX_ITEMS))   ::set(null, "*", "dispense_vif", dispense_vif);
    
   //Run tests here
    
    //run_test("vending_test");
   //run_test("reset_mode_test");
   //run_test("config_mode_test");
   //run_test("config_negative_test");
   //run_test("config_full_test");
    //run_test("config_edge_test");
    //run_test("basic_random_test");        
    //run_test("error_operation_test");        
    //run_test("latency_output_test");       
    run_test("operation_random_test");

    
    $finish;
  end
  
  initial begin
  	$dumpfile ("vending_wave.vcd"); 
  	$dumpvars();
  	ctrl_vif.rstn = 0;
  	#20 ctrl_vif.rstn = 1;
  end
  
endmodule
