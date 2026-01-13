import uvm_pkg::*;
`include "uvm_macros.svh"


// // Interfaces
`include "vmc_if.sv"
`include "cfg_if.sv"
`include "item_select_if.sv"
`include "currency_if.sv"
`include "dispense_if.sv"
`include "checker_if.sv"


// Sequence Items
`include "cfg_seq_item.sv"
`include "item_select_seq_item.sv"
`include "currency_seq_item.sv"
`include "cfg_transaction.sv"
`include "currency_transaction.sv"
`include "item_select_transaction.sv"
`include "dispense_transaction.sv"



//sequences
`include "cfg_sequence.sv"
`include "item_select_sequence.sv"
`include "currency_sequence.sv"

`include "config_write_seq.sv"
`include "config_read_seq.sv"
`include "config_total_item_seq.sv"
`include "reset_seq.sv"
`include "reset_check_seq.sv"

`include "config_invalid_address_seq.sv"
`include "config_while_mode_select_seq.sv"
`include "config_multi_item_setup_seq.sv"
`include "config_max_items_seq.sv"
`include "config_max_items_readback_seq.sv"

`include "config_check_default_reset_seq.sv"
`include "config_clear_dispense_count_seq.sv"
`include "config_random_item_setup_seq.sv"

`include "config_random_write_seq.sv"
`include "config_random_read_seq.sv"
`include "item_random_seq.sv"
`include "currency_random_seq.sv"

`include "invalid_item_select_seq.sv"
`include "currency_unsupported_seq.sv"
`include "currency_before_item_seq.sv"
`include "item_after_currency_seq.sv"

`include "item_latency_check_seq.sv"
`include "currency_latency_check_seq.sv"
`include "item_single_output_seq.sv"
`include "currency_single_output_seq.sv"
`include "item_one_dispense_within_latency_seq.sv"
`include "currency_seq_one_dispense_within_latency.sv"

`include "cfg_write_zero.sv"
`include "cfg_exact_write.sv"
`include "random_vaild_multiitem_seq.sv"
`include "random_usermix_sequence.sv"
`include "random_back_toback_seq.sv"



// Sequencers
`include "cfg_sequencer.sv"
`include "item_select_sequencer.sv"
`include "currency_sequencer.sv"


//drivers
`include "cfg_driver.sv"
`include "item_select_driver.sv"
`include "currency_driver.sv"


//monitors
`include "cfg_monitor.sv"
`include "item_select_monitor.sv"
`include "currency_monitor.sv"
`include "dispense_monitor.sv"



//agents
`include "cfg_agent.sv"
`include "item_select_agent.sv"
`include "currency_agent.sv"
`include "dispense_agent.sv"

//Ref_model

`include "vending_ref_model.sv"

//checkers & scoreboards
`include "cfg_checker.sv"
`include "item_select_checker.sv"
`include "currency_checker.sv"
`include "dispense_checker.sv"

`include "vending_sb.sv"
`include "checker_sb.sv"



//environment & Test
`include "vending_env.sv"

`include "vending_test.sv"

`include "config_mode_test.sv"
`include "reset_mode_test.sv"
`include "config_negative_test.sv"
`include "config_full_test.sv"
`include "config_edge_test.sv"
`include "basic_random_test.sv"
`include "error_operation_test.sv"
`include "latency_output_test.sv"
`include "operation_random_test.sv"
