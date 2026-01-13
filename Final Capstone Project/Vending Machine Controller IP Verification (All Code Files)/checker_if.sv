interface checker_if (input logic clk);

  bit expected_dispense;
  int expected_item;
  int expected_qty;
  int expected_change;

  bit dut_dispense_valid;
  int dut_item;
  int dut_qty;
  int dut_change;

  bit resetn = 1;

  property p_dispense_valid;
    @(posedge clk) disable iff (!resetn)
      expected_dispense |-> ##[0:10] dut_dispense_valid;
  endproperty

  property p_dut_matches_expected;
    @(posedge clk) disable iff (!resetn)
      dut_dispense_valid |-> (dut_item == expected_item &&
                              dut_qty  == expected_qty  &&
                              dut_change == expected_change);
  endproperty

  // Move assertions inside an initial block in the interface
  initial begin
    assert property (p_dispense_valid)
      else `uvm_error("CHECKER_IF", "dispense_valid not asserted in time");

    assert property (p_dut_matches_expected)
      else `uvm_error("CHECKER_IF", "DUT output mismatch");
  end

endinterface
