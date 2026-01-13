class cfg_checker extends uvm_component;
  `uvm_component_utils(cfg_checker)

  uvm_analysis_imp#(cfg_transaction, cfg_checker) imp;
  vending_ref_model ref_m;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
    ref_m = null;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(vending_ref_model)::get(this, "", "ref_m", ref_m)) begin
      ref_m = vending_ref_model::type_id::create("ref_m", this);
    end
  endfunction

  function void write(cfg_transaction t);
    int id;
    int val, avail, disp;

    // Reset case
    if (ref_m.ctrl_vif.rstn == 0) begin
      ref_m.reset_model();
      return;
    end

    // Ignore if no APB access
    if (!t.psel)
      return;

    // Skip vending_machine_cfg (0x0000)
    if (t.paddr < 16'h0004)
      return;

    // Calculate item index
    id = (t.paddr - 16'h0004) >> 2;

    if (id < 0 || id >= ref_m.MAX_ITEMS)
      return;

    // ----------------------------------------------------
    // WRITE → UPDATE REFERENCE MODEL (IMPORTANT FIX HERE)
    // ----------------------------------------------------
    if (t.pwrite) begin

      // PASS FULL PWDATA because ref_m.configure_item()
      // expects (id, pwdata)
      ref_m.configure_item(id, t.pwdata);

    end

    // ----------------------------------------------------
    // READ → COMPARE AGAINST REFERENCE MODEL
    // ----------------------------------------------------
    else begin

      ref_m.read_configure_item(id, val, avail, disp);

      if (t.prdata[15:0] != val)
        `uvm_error("APB_CHECKER",
                   $sformatf("VALUE mismatch : DUT=%0d REF=%0d",
                              t.prdata[15:0], val))

      if (t.prdata[23:16] != avail)
        `uvm_error("APB_CHECKER",
                   $sformatf("AVAIL mismatch : DUT=%0d REF=%0d",
                              t.prdata[23:16], avail))

      if (t.prdata[31:24] != disp)
        `uvm_error("APB_CHECKER",
                   $sformatf("DISP mismatch : DUT=%0d REF=%0d",
                              t.prdata[31:24], disp))
    end

  endfunction

endclass


// class cfg_checker extends uvm_component;
//   `uvm_component_utils(cfg_checker)

//   uvm_analysis_imp#(cfg_transaction, cfg_checker) imp;
//   vending_ref_model ref_m;

//   function new(string name, uvm_component parent);
//     super.new(name, parent);
//     imp = new("imp", this);
//     ref_m = null;
//   endfunction


//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);

//     if (!uvm_config_db#(vending_ref_model)::get(this, "", "ref_m", ref_m)) begin
//       ref_m = vending_ref_model::type_id::create("ref_m", this);
//     end
//   endfunction

//   function void write(cfg_transaction t);
//     int id;
//     int val, avail, disp;

//     if (ref_m.ctrl_vif.rstn == 0) begin
//       ref_m.reset_model();
//       return;
//     end

//     if (!t.psel)
//       return;

//     if (t.paddr < 16'h0004)
//       return;

//     id = (t.paddr - 16'h0004) >> 2;

//     if (id < 0 || id >= ref_m.MAX_ITEMS)
//       return;


//     if (t.pwrite) begin
//       val   = t.pwdata[15:0];
//       avail = t.pwdata[23:16];


//       ref_m.configure_item(id, val, avail);
//     end

//     else begin
//       ref_m.read_configure_item(id, val, avail, disp);

//       if (t.prdata[15:0] != val)
//         `uvm_error("APB_CHECKER",
//                    $sformatf("VALUE mismatch : DUT=%0d REF=%0d",
//                               t.prdata[15:0], val))

//       if (t.prdata[23:16] != avail)
//         `uvm_error("APB_CHECKER",
//                    $sformatf("AVAIL mismatch : DUT=%0d REF=%0d",
//                               t.prdata[23:16], avail))

//       if (t.prdata[31:24] != disp)
//         `uvm_error("APB_CHECKER",
//                    $sformatf("DISP mismatch : DUT=%0d REF=%0d",
//                               t.prdata[31:24], disp))
//     end

//   endfunction

// endclass


