class vending_ref_model extends uvm_component;
  `uvm_component_utils(vending_ref_model)

  virtual vmc_if ctrl_vif;
  int MAX_ITEMS;

  typedef struct {
    bit [15:0] item_val;       // bits 15:0
    bit [7:0]  avail_items;    // bits 23:16
    bit [7:0]  disp_items;     // bits 31:24
  } item_info_t;

  item_info_t item_table[];

  // Transaction State Variables
  int credit;
  int selected_item_id;
  int selected_no_of_items;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    selected_item_id     = -1;
    selected_no_of_items = 0;
    credit               = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual vmc_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("REF_MODEL", "Virtual interface not found")

    if (!uvm_config_db#(int)::get(this, "", "MAX_ITEMS", MAX_ITEMS))
      `uvm_fatal("REF_MODEL", "MAX_ITEMS parameter not found")

    item_table = new[MAX_ITEMS];

    foreach(item_table[i]) begin
      item_table[i].item_val    = 0;
      item_table[i].avail_items = 0;
      item_table[i].disp_items  = 0;
    end

    `uvm_info("REF_MODEL",
              $sformatf("Reference Model initialized MAX_ITEMS=%0d", MAX_ITEMS),
              UVM_MEDIUM)
  endfunction

  // ---------------------------------------------------------
  // RESET
  // ---------------------------------------------------------
  function void reset_model();
    credit               = 0;
    selected_item_id     = -1;
    selected_no_of_items = 0;

    foreach (item_table[i]) begin
      item_table[i].item_val    = 0;
      item_table[i].avail_items = 0;
      item_table[i].disp_items  = 0;
    end
  endfunction

  // ---------------------------------------------------------
  // CONFIGURE ITEM – FIXED FIELD EXTRACTION
  // ---------------------------------------------------------
  function void configure_item(int item_id, int pwdata);

    if (!ctrl_vif.cfg_mode) begin
      `uvm_error("REF_MODEL", "Attempt to configure while not in cfg_mode")
      return;
    end

    if (item_id < 0 || item_id >= MAX_ITEMS) begin
      `uvm_error("REF_MODEL",
        $sformatf("Invalid item_id=%0d", item_id))
      return;
    end

    item_table[item_id].item_val    = pwdata[15:0];
    item_table[item_id].avail_items = pwdata[23:16];
    item_table[item_id].disp_items  = 0; // always clear on config
    
    `uvm_info("REF_MODEL",
          $sformatf("CONFIG: id=%0d val=%0d avail=%0d", item_id,
                    pwdata[15:0], pwdata[23:16]),
          UVM_LOW)


  endfunction

  // ---------------------------------------------------------
  // READBACK – MATCHES DUT PRDATA FORMAT
  // ---------------------------------------------------------
  function void read_configure_item(int item_id,
                                    output int item_value,
                                    output int item_avail,
                                    output int item_disp);

    if (!ctrl_vif.cfg_mode) begin
      item_value = 0; item_avail = 0; item_disp = 0;
      return;
    end

    item_value = item_table[item_id].item_val;
    item_avail = item_table[item_id].avail_items;
    item_disp  = item_table[item_id].disp_items;
  endfunction

  // ---------------------------------------------------------
  // CURRENCY INSERTION
  // ---------------------------------------------------------
  function void insert_currency(int currency_value);
    if (ctrl_vif.cfg_mode) return;
    credit += currency_value;
  endfunction

  // ---------------------------------------------------------
  // ITEM SELECT
  // ---------------------------------------------------------
  function void select_item(int item_select,
                            int no_of_items,
                            output int item_value,
                            output int items_avail);

    selected_item_id     = item_select;
    selected_no_of_items = no_of_items;

    item_value  = item_table[item_select].item_val;
    items_avail = item_table[item_select].avail_items;
  endfunction

  // ---------------------------------------------------------
  // DISPENSE LOGIC
  // ---------------------------------------------------------
  function automatic void dispense_item(output bit item_dispense_valid,
                                        output int item_dispense,
                                        output int no_of_items_dispensed,
                                        output int currency_change);

    int total_cost;

    item_dispense_valid   = 0;
    item_dispense         = selected_item_id;
    no_of_items_dispensed = 0;
    currency_change       = 0;

    if (ctrl_vif.cfg_mode) begin
      currency_change = credit;
      credit = 0;
      return;
    end

    if (selected_item_id == -1) begin
      currency_change = credit;
      credit = 0;
      return;
    end

    total_cost = item_table[selected_item_id].item_val *
                 selected_no_of_items;

    if (credit >= total_cost &&
        item_table[selected_item_id].avail_items >= selected_no_of_items) begin

      item_dispense_valid   = 1;
      no_of_items_dispensed = selected_no_of_items;
      currency_change       = credit - total_cost;

      item_table[selected_item_id].avail_items -= selected_no_of_items;
      item_table[selected_item_id].disp_items  += selected_no_of_items;

      credit = 0;
      selected_item_id = -1;
      selected_no_of_items = 0;
    end
    else begin
      item_dispense_valid   = 1;
      currency_change       = credit;
      credit = 0;
      selected_item_id = -1;
      selected_no_of_items = 0;
    end

  endfunction

endclass


