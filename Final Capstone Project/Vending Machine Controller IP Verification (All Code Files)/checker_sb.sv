class checker_sb extends uvm_component;
  `uvm_component_utils(checker_sb)

  vending_ref_model ref_m;
  currency_checker  c_chk;
  item_select_checker      i_chk;
  cfg_checker       a_chk;
  dispense_checker  d_chk;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    ref_m = vending_ref_model::type_id::create("ref_m", this);
    c_chk = currency_checker::type_id::create("c_chk", this);
    i_chk = item_select_checker::type_id::create("i_chk", this);
    a_chk = cfg_checker::type_id::create("a_chk", this);
    d_chk = dispense_checker::type_id::create("d_chk", this);

    c_chk.ref_m = ref_m;
    i_chk.ref_m = ref_m;
    a_chk.ref_m = ref_m;
    d_chk.ref_m = ref_m;
  endfunction

endclass

