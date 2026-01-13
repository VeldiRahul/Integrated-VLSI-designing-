module cfg_ctrl #(parameter MAX_ITEMS = 32) (
  // APB Interface
  input         pclk,
  input  [15:0] paddr,
  input         prstn,
  input  [31:0] pwdata,
  output [31:0] prdata,
  input         pwrite,
  input         psel,
  
  // Internal interface
  input [$clog2(MAX_ITEMS)-1 : 0] get_me_item_cfg,
  output [31:0] current_item_cfg,
  input update_vld,
  input [$clog2(MAX_ITEMS)-1 : 0] update_item_no,
  input [7:0] update_item_count
);

  // Base address for Item registers (SPEC → 0x0004)
  localparam [15:0] ITEM_BASE = 16'h0004;

  // Internal registers
  reg [31:0] prdata_r;
  reg [31:0] current_item_cfg_r;
  reg [31:0] vending_machine_cfg;
  reg [31:0] item_cfg[MAX_ITEMS];

  assign prdata = prdata_r;
  assign current_item_cfg = current_item_cfg_r;

  // Address decode logic
  wire [15:0] addr_u = paddr;
  
  // Calculate item index: (paddr - 0x0004) / 4
  wire [$clog2(MAX_ITEMS)-1:0] addr_index = (addr_u - ITEM_BASE) >> 2;
  
  // Check if address is in item range and word-aligned
  wire addr_is_item = (addr_u >= ITEM_BASE) && 
                      (addr_u < (ITEM_BASE + (MAX_ITEMS * 4))) &&
                      ((addr_u & 16'h0003) == 0);

  // ========================================================================
  // WRITE PATH: Sequential (registered on clock edge)
  // ========================================================================
  always @(posedge pclk or negedge prstn) begin
    if (!prstn) begin
      vending_machine_cfg <= 32'h0;                        /////new add
      for (int i = 0; i < MAX_ITEMS; i++)
        item_cfg[i] <= 32'h0;
    end
    else begin
      // Write operation
      if (psel & pwrite) begin
        if (addr_u == 16'h0000) begin
          vending_machine_cfg <= pwdata;
        end
        else if (addr_is_item) begin
          item_cfg[addr_index] <= pwdata;
          // SPEC: disp_items must clear during config mode
          item_cfg[addr_index][31:24] <= 8'd0;                //new add 
        end
      end
    end
  end

  // ========================================================================
  // READ PATH: Combinational (for APB read to work in same cycle)
  // ========================================================================
  always @(*) begin
    if (psel & ~pwrite) begin
      if (addr_u == 16'h0000) begin
        prdata_r = vending_machine_cfg;
      end
      else if (addr_is_item) begin
        prdata_r = item_cfg[addr_index];
      end
      else begin
        prdata_r = 32'h0;
      end
    end
    else begin
      prdata_r = 32'h0;
    end
  end

  // Combinational read for internal interface
  always @(*) begin
    current_item_cfg_r = item_cfg[get_me_item_cfg];
  end

  // ========================================================================
  // UPDATE PATH: For dispense operations
  // ========================================================================
  always @(posedge pclk or negedge prstn) begin                      //new add
    if (!prstn) begin
      // Reset handled in main write always block
    end
    else if (update_vld) begin
      // Decrement available items                                           
      item_cfg[update_item_no][23:16] <= item_cfg[update_item_no][23:16] - update_item_count;
      // Increment dispensed items
      item_cfg[update_item_no][31:24] <= item_cfg[update_item_no][31:24] + update_item_count;
    end
  end

endmodule


module posedge_det (input clk, input rstn, input sig, output posedge_sig);
  reg sig_r;

  always @(posedge clk or negedge rstn) begin
    if (!rstn) sig_r <= 1'b0;
    else       sig_r <= sig;
  end

  assign posedge_sig = !sig_r & sig;
endmodule


module vending_machine #(
parameter MAX_ITEMS = 32,
parameter MAX_NOTE_VAL = 100
)
(
//General interface
input clk,
input rstn,
input cfg_mode,

//APB Interface
input         pclk,
input         prstn,
input  [15:0] paddr,
input         psel,
input         pwrite,
input  [31:0] pwdata,
output [31:0] prdata,
output        pready,

//Currency
input currency_valid,
input [$clog2(MAX_NOTE_VAL) : 0] currency_value,

//Item Select
input item_select_valid,
input [7:0] no_of_items,
input [$clog2(MAX_ITEMS)-1 : 0] item_select,

//Output
output item_dispense_valid,
output [$clog2(MAX_ITEMS)-1 : 0] item_dispense,
output [7:0] no_of_items_dispensed,
output [15:0] currency_change
);

reg [$clog2(MAX_ITEMS)-1 : 0] current_item_code;
reg [7:0] current_item_count;
reg [31:0] current_item_cfg;
reg o_valid_r;
reg [$clog2(MAX_ITEMS)-1 : 0] out_item_r;
reg [7:0] out_item_count_r;
reg [15:0] count_notes;
reg [15:0] note_change_r;
reg item_vld_posedge;

posedge_det item_posedge(clk, rstn, item_select_valid, item_vld_posedge);

always @(posedge clk or negedge rstn) begin
  if (!rstn) begin
    current_item_code  <= 'h0;
    current_item_count <= 1;
  end
  else if (item_vld_posedge) begin
    current_item_code  <= item_select;
    current_item_count <= no_of_items;
  end
end


cfg_ctrl #(.MAX_ITEMS(MAX_ITEMS)) u_cfg_ctrl (
  .pclk    (pclk),
  .paddr   (paddr),
  .prstn   (prstn),
  .pwdata  (pwdata),
  .prdata  (prdata),

  // BUG: APB write allowed even in op mode
  // .pwrite (pwrite),  
  // .psel   (psel),

  // FIX: Block APB access during op mode                    //new added
  .pwrite  (pwrite && cfg_mode),
  .psel    (psel   && cfg_mode),

  .get_me_item_cfg  (current_item_code),
  .current_item_cfg (current_item_cfg),
  .update_vld       (o_valid_r),
  .update_item_no   (out_item_r),
  .update_item_count(out_item_count_r)
);

assign pready = 1'b1;                                     //bug : new added
assign item_dispense_valid   = o_valid_r;
assign item_dispense         = out_item_r;
assign no_of_items_dispensed = out_item_count_r;
assign currency_change       = note_change_r;


always @(posedge clk or negedge rstn) begin
  if (!rstn) begin
    o_valid_r <= 0;
    out_item_r <= 0;
    out_item_count_r <= 0;
    note_change_r <= 0;
    count_notes <= 0;
  end
  else begin

    if (currency_valid &&
        (current_item_cfg[23:16] >= current_item_count)) begin

      if ((count_notes + currency_value) >=
          (current_item_count * current_item_cfg[15:0])) begin

        o_valid_r <= 1;
        out_item_r <= current_item_code;
        out_item_count_r <= current_item_count;
        note_change_r <= (count_notes + currency_value)
                          - (current_item_count * current_item_cfg[15:0]);
        count_notes <= 0;
      end
      else begin
        o_valid_r <= 0;
        out_item_r <= 0;
        out_item_count_r <= 0;
        note_change_r <= 0;
        count_notes <= count_notes + currency_value;
      end
    end

    else if (!currency_valid) begin
      o_valid_r <= 0;
      out_item_r <= 0;
      out_item_count_r <= 0;
      note_change_r <= 0;
    end

  end
end

endmodule
//-------------------------------------------------------------------------------------------------------------

// module cfg_ctrl #(parameter MAX_ITEMS = 32) (
// //APB Interface
// input         pclk,
// input  [15:0] paddr,
// input         prstn,
// input  [31:0] pwdata,
// output [31:0] prdata,
// input         pwrite,
// input         psel,
// input [$clog2(MAX_ITEMS)-1 : 0] get_me_item_cfg,
// output [31:0] current_item_cfg,
// input update_vld,
// input [$clog2(MAX_ITEMS)-1 : 0] update_item_no,
// input [7:0] update_item_count

// );

// reg [31:0] prdata_r;
// reg [31:0] current_item_cfg_r;
// reg [31:0] vending_machine_cfg;
// reg [31:0] item_cfg[MAX_ITEMS];

// assign prdata = prdata_r;
// assign current_item_cfg = current_item_cfg_r;

// always @(posedge pclk or negedge prstn) begin
//   if (!prstn) begin
//     for (int i =0; i<MAX_ITEMS; i++) begin
//       item_cfg[i] <= 32'h0;    ////////////////Bug: only item_cfg getting reset, not vending_machine
//     end
//   end
//   else begin
//     if (psel & pwrite) begin
//       if (paddr[15:12] == 0) begin////////////////Bug: used byte addresses as direct indexes
//         vending_machine_cfg <= pwdata;
//       end
//       else begin
//         item_cfg[paddr[11:0]] <= pwdata;
//       end
//     end
//     if (psel) begin
//       if (paddr[15:12] == 0) begin
//         prdata_r <= vending_machine_cfg;
//       end
//       else begin
//         prdata_r <= item_cfg[paddr[11:0]];
//       end
//     end
//   end
// end

// always @(*) begin
//   current_item_cfg_r = item_cfg[get_me_item_cfg];
// end

// always @(*) begin
//   if (update_vld) begin
//     item_cfg[update_item_no][23:16] -= update_item_count; //Decrement no of available
//     item_cfg[update_item_no][31:24] += update_item_count; //Increment no of dispensed
//   end
// end
// endmodule // cfg_ctrl

// module posedge_det (input clk, input rstn, input sig, output posedge_sig);
//   reg sig_r;

//   always @(posedge clk or negedge rstn) begin
//     if (!rstn) begin
//       sig_r <= 1'b0;
//     end
//     else begin
//       sig_r <= sig;
//     end
//   end
//   assign posedge_sig = !sig_r & sig;
// endmodule // posedge_det


// module vending_machine #(
// parameter MAX_ITEMS = 32,
// parameter MAX_NOTE_VAL = 100
// )
// (

// //General interface
// input clk,
// input rstn,
// input cfg_mode,

// //APB Interface
// input         pclk,
// input         prstn,
// input  [15:0] paddr,
// input         psel,
// input         pwrite,
// input  [31:0] pwdata,
// output [31:0] prdata,
// output        pready,

// //Coin or Note interface
// input currency_valid,
// input [$clog2(MAX_NOTE_VAL) : 0] currency_value,

// //Item Select Interface
// input item_select_valid,
// input [7:0] no_of_items,
// input [$clog2(MAX_ITEMS)-1 : 0] item_select,

// //Ouput interface
// output item_dispense_valid,
// output [$clog2(MAX_ITEMS)-1 : 0] item_dispense,
// output [7:0] item_dispense_count,
// output [15:0] currency_change
// );

// reg [$clog2(MAX_ITEMS)-1 : 0] current_item_code;
// reg [7 : 0] current_item_count;
// reg [31:0] current_item_cfg;
// reg o_valid_r;
// reg [$clog2(MAX_ITEMS)-1 : 0] out_item_r;
// reg [7:0] out_item_count_r;
// reg [15:0] count_notes;
// reg [15:0] note_change_r;
// reg item_vld_posedge;

// //assign currency_change = note_change_r;

// //Capture Item no for current item
// posedge_det item_posedge (clk, rstn, item_select_valid, item_vld_posedge);

// always @(posedge clk or negedge rstn) begin
//     if (!rstn) begin
//       current_item_code <= 'h0;
//       current_item_count <= 'd1;
//     end
//     else if (item_vld_posedge) begin
//       current_item_code <= item_select;
//       current_item_count <= no_of_items;
//     end
// end

// cfg_ctrl #(.MAX_ITEMS(MAX_ITEMS)) u_cfg_ctrl (
//   .pclk    (pclk  ),
//   .paddr   (paddr ),
//   .prstn   (prstn ),
//   .pwdata  (pwdata),
//   .prdata  (prdata),
//   .pwrite  (pwrite && cfg_mode),
//   .psel    (psel),
//   .get_me_item_cfg  (current_item_code),
//   .current_item_cfg (current_item_cfg),
//   .update_vld       (o_valid_r),
//   .update_item_no   (out_item_r),
//   .update_item_count (out_item_count_r)

// );

// assign item_dispense_valid     = o_valid_r;
// assign item_dispense           = out_item_r;
// assign item_dispense_count     = out_item_count_r;
// assign currency_change         = note_change_r;

// // Ctrl 
// always @(posedge clk or negedge rstn) begin
//   if (!rstn) begin
//     o_valid_r     <= 'b0;
//     out_item_r    <= 'h0;
//     out_item_count_r <= 'd0;
//     note_change_r <= 'h0;
//     count_notes   <= 'h0;
//   end
//   else begin
//     if (currency_valid & (current_item_cfg[23:16] >= current_item_count)) begin //Ctrl logic should start
//     //only when there is a valid input and current item is available
// //        $display("DUT: Current total currency: %0d", (current_item_count * current_item_cfg[15:0]));
//       if ((count_notes + currency_value) >= (current_item_count * current_item_cfg[15:0])) begin
//     //When the sofar count of money including current note is sufficient i.e
//     //equal or greater than the item value then issue the item
//         o_valid_r     <= 1'b1;
//         out_item_r    <= current_item_code;
//         out_item_count_r <= current_item_count;
//         note_change_r <= (count_notes + currency_value) - (current_item_count * current_item_cfg[15:0]);
//         count_notes  <= 'h0;
//       end
//       else begin
//       // Make sure we nullify item_dispense_valid and all outputs
//         o_valid_r     <= 'b0;
//         out_item_r    <= 'h0;
//         out_item_count_r <= 'd0;
//         note_change_r <= 'h0;
//         count_notes   <= count_notes + currency_value;
//       end
//     end // The ctrl logic if 
//     else if (!currency_valid) begin
//       //Make sure oututs are nullified within a clk
//       //Also pay attention not to clear the counter
//       //So that we allow customer to input notes with bigger gap
//         o_valid_r     <= 'b0;
//         out_item_r    <= 'h0;
//         out_item_count_r <= 'd0;
//         note_change_r <= 'h0;
//     end
//   end
// end
// endmodule

