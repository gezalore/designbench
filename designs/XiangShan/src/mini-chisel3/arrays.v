// name:array_0_ext depth:64 width:512 masked:true maskGran:256 maskSeg:2
module array_0_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [511:0] RW0_wdata,
  output [511:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [511:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {16 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][255:0] <= RW0_wdata[255:0];
      if (RW0_wmask[1]) ram[RW0_addr][511:256] <= RW0_wdata[511:256];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [511:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[511:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_10_ext depth:8 width:249 masked:false maskGran:249 maskSeg:1
module array_10_ext(
  input R0_clk,
  input [2:0] R0_addr,
  input R0_en,
  output [248:0] R0_data,
  input W0_clk,
  input [2:0] W0_addr,
  input W0_en,
  input [248:0] W0_data
);


  reg reg_R0_ren;
  reg [2:0] reg_R0_addr;
  reg [248:0] ram [7:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 8; initvar = initvar+1)
        ram[initvar] = {8 {$random}};
      reg_R0_addr = {1 {$random}};
    end
  `endif
  always @(posedge R0_clk)
    reg_R0_ren <= R0_en;
  always @(posedge R0_clk)
    if (R0_en) reg_R0_addr <= R0_addr;
  always @(posedge W0_clk)
    if (W0_en) begin
      ram[W0_addr][248:0] <= W0_data[248:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [255:0] R0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      R0_random = {$random, $random, $random, $random, $random, $random, $random, $random};
      reg_R0_ren = R0_random[0];
    end
  `endif
  always @(posedge R0_clk) R0_random <= {$random, $random, $random, $random, $random, $random, $random, $random};
  assign R0_data = reg_R0_ren ? ram[reg_R0_addr] : R0_random[248:0];
  `else
  assign R0_data = ram[reg_R0_addr];
  `endif

endmodule// name:array_11_ext depth:8 width:512 masked:false maskGran:512 maskSeg:1
module array_11_ext(
  input R0_clk,
  input [2:0] R0_addr,
  input R0_en,
  output [511:0] R0_data,
  input W0_clk,
  input [2:0] W0_addr,
  input W0_en,
  input [511:0] W0_data
);


  reg reg_R0_ren;
  reg [2:0] reg_R0_addr;
  reg [511:0] ram [7:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 8; initvar = initvar+1)
        ram[initvar] = {16 {$random}};
      reg_R0_addr = {1 {$random}};
    end
  `endif
  always @(posedge R0_clk)
    reg_R0_ren <= R0_en;
  always @(posedge R0_clk)
    if (R0_en) reg_R0_addr <= R0_addr;
  always @(posedge W0_clk)
    if (W0_en) begin
      ram[W0_addr][511:0] <= W0_data[511:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [511:0] R0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      R0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_R0_ren = R0_random[0];
    end
  `endif
  always @(posedge R0_clk) R0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign R0_data = reg_R0_ren ? ram[reg_R0_addr] : R0_random[511:0];
  `else
  assign R0_data = ram[reg_R0_addr];
  `endif

endmodule// name:array_12_ext depth:64 width:64 masked:false maskGran:64 maskSeg:1
module array_12_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [63:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      ram[RW0_addr][63:0] <= RW0_wdata[63:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[63:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_13_ext depth:64 width:192 masked:true maskGran:24 maskSeg:8
module array_13_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [191:0] RW0_wdata,
  output [191:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [191:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {6 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][23:0] <= RW0_wdata[23:0];
      if (RW0_wmask[1]) ram[RW0_addr][47:24] <= RW0_wdata[47:24];
      if (RW0_wmask[2]) ram[RW0_addr][71:48] <= RW0_wdata[71:48];
      if (RW0_wmask[3]) ram[RW0_addr][95:72] <= RW0_wdata[95:72];
      if (RW0_wmask[4]) ram[RW0_addr][119:96] <= RW0_wdata[119:96];
      if (RW0_wmask[5]) ram[RW0_addr][143:120] <= RW0_wdata[143:120];
      if (RW0_wmask[6]) ram[RW0_addr][167:144] <= RW0_wdata[167:144];
      if (RW0_wmask[7]) ram[RW0_addr][191:168] <= RW0_wdata[191:168];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [191:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[191:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_14_ext depth:64 width:48 masked:true maskGran:6 maskSeg:8
module array_14_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [47:0] RW0_wdata,
  output [47:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [47:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][5:0] <= RW0_wdata[5:0];
      if (RW0_wmask[1]) ram[RW0_addr][11:6] <= RW0_wdata[11:6];
      if (RW0_wmask[2]) ram[RW0_addr][17:12] <= RW0_wdata[17:12];
      if (RW0_wmask[3]) ram[RW0_addr][23:18] <= RW0_wdata[23:18];
      if (RW0_wmask[4]) ram[RW0_addr][29:24] <= RW0_wdata[29:24];
      if (RW0_wmask[5]) ram[RW0_addr][35:30] <= RW0_wdata[35:30];
      if (RW0_wmask[6]) ram[RW0_addr][41:36] <= RW0_wdata[41:36];
      if (RW0_wmask[7]) ram[RW0_addr][47:42] <= RW0_wdata[47:42];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[47:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_15_ext depth:4 width:1044 masked:true maskGran:261 maskSeg:4
module array_15_ext(
  input RW0_clk,
  input [1:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [1043:0] RW0_wdata,
  output [1043:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [1:0] reg_RW0_addr;
  reg [1043:0] ram [3:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4; initvar = initvar+1)
        ram[initvar] = {33 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][260:0] <= RW0_wdata[260:0];
      if (RW0_wmask[1]) ram[RW0_addr][521:261] <= RW0_wdata[521:261];
      if (RW0_wmask[2]) ram[RW0_addr][782:522] <= RW0_wdata[782:522];
      if (RW0_wmask[3]) ram[RW0_addr][1043:783] <= RW0_wdata[1043:783];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [1055:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[1043:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_16_ext depth:4 width:2672 masked:true maskGran:334 maskSeg:8
module array_16_ext(
  input RW0_clk,
  input [1:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [2671:0] RW0_wdata,
  output [2671:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [1:0] reg_RW0_addr;
  reg [2671:0] ram [3:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4; initvar = initvar+1)
        ram[initvar] = {84 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][333:0] <= RW0_wdata[333:0];
      if (RW0_wmask[1]) ram[RW0_addr][667:334] <= RW0_wdata[667:334];
      if (RW0_wmask[2]) ram[RW0_addr][1001:668] <= RW0_wdata[1001:668];
      if (RW0_wmask[3]) ram[RW0_addr][1335:1002] <= RW0_wdata[1335:1002];
      if (RW0_wmask[4]) ram[RW0_addr][1669:1336] <= RW0_wdata[1669:1336];
      if (RW0_wmask[5]) ram[RW0_addr][2003:1670] <= RW0_wdata[2003:1670];
      if (RW0_wmask[6]) ram[RW0_addr][2337:2004] <= RW0_wdata[2337:2004];
      if (RW0_wmask[7]) ram[RW0_addr][2671:2338] <= RW0_wdata[2671:2338];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [2687:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[2671:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_17_ext depth:128 width:176 masked:true maskGran:22 maskSeg:8
module array_17_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [175:0] RW0_wdata,
  output [175:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [175:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {6 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][21:0] <= RW0_wdata[21:0];
      if (RW0_wmask[1]) ram[RW0_addr][43:22] <= RW0_wdata[43:22];
      if (RW0_wmask[2]) ram[RW0_addr][65:44] <= RW0_wdata[65:44];
      if (RW0_wmask[3]) ram[RW0_addr][87:66] <= RW0_wdata[87:66];
      if (RW0_wmask[4]) ram[RW0_addr][109:88] <= RW0_wdata[109:88];
      if (RW0_wmask[5]) ram[RW0_addr][131:110] <= RW0_wdata[131:110];
      if (RW0_wmask[6]) ram[RW0_addr][153:132] <= RW0_wdata[153:132];
      if (RW0_wmask[7]) ram[RW0_addr][175:154] <= RW0_wdata[175:154];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [191:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[175:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_18_ext depth:128 width:40 masked:true maskGran:5 maskSeg:8
module array_18_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [39:0] RW0_wdata,
  output [39:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [39:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][4:0] <= RW0_wdata[4:0];
      if (RW0_wmask[1]) ram[RW0_addr][9:5] <= RW0_wdata[9:5];
      if (RW0_wmask[2]) ram[RW0_addr][14:10] <= RW0_wdata[14:10];
      if (RW0_wmask[3]) ram[RW0_addr][19:15] <= RW0_wdata[19:15];
      if (RW0_wmask[4]) ram[RW0_addr][24:20] <= RW0_wdata[24:20];
      if (RW0_wmask[5]) ram[RW0_addr][29:25] <= RW0_wdata[29:25];
      if (RW0_wmask[6]) ram[RW0_addr][34:30] <= RW0_wdata[34:30];
      if (RW0_wmask[7]) ram[RW0_addr][39:35] <= RW0_wdata[39:35];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[39:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_19_ext depth:128 width:7 masked:false maskGran:7 maskSeg:1
module array_19_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [6:0] RW0_wdata,
  output [6:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [6:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      ram[RW0_addr][6:0] <= RW0_wdata[6:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[6:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_1_ext depth:64 width:64 masked:true maskGran:16 maskSeg:4
module array_1_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [63:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][15:0] <= RW0_wdata[15:0];
      if (RW0_wmask[1]) ram[RW0_addr][31:16] <= RW0_wdata[31:16];
      if (RW0_wmask[2]) ram[RW0_addr][47:32] <= RW0_wdata[47:32];
      if (RW0_wmask[3]) ram[RW0_addr][63:48] <= RW0_wdata[63:48];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[63:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_20_ext depth:1024 width:512 masked:false maskGran:512 maskSeg:1
module array_20_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [511:0] RW0_wdata,
  output [511:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [511:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {16 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      ram[RW0_addr][511:0] <= RW0_wdata[511:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [511:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[511:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_21_ext depth:8192 width:64 masked:false maskGran:64 maskSeg:1
module array_21_ext(
  input RW0_clk,
  input [12:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [12:0] reg_RW0_addr;
  reg [63:0] ram [8191:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 8192; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      ram[RW0_addr][63:0] <= RW0_wdata[63:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[63:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_22_ext depth:256 width:16 masked:true maskGran:2 maskSeg:8
module array_22_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [15:0] RW0_wdata,
  output [15:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [15:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][1:0] <= RW0_wdata[1:0];
      if (RW0_wmask[1]) ram[RW0_addr][3:2] <= RW0_wdata[3:2];
      if (RW0_wmask[2]) ram[RW0_addr][5:4] <= RW0_wdata[5:4];
      if (RW0_wmask[3]) ram[RW0_addr][7:6] <= RW0_wdata[7:6];
      if (RW0_wmask[4]) ram[RW0_addr][9:8] <= RW0_wdata[9:8];
      if (RW0_wmask[5]) ram[RW0_addr][11:10] <= RW0_wdata[11:10];
      if (RW0_wmask[6]) ram[RW0_addr][13:12] <= RW0_wdata[13:12];
      if (RW0_wmask[7]) ram[RW0_addr][15:14] <= RW0_wdata[15:14];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[15:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_23_ext depth:256 width:176 masked:true maskGran:22 maskSeg:8
module array_23_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [175:0] RW0_wdata,
  output [175:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [175:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
        ram[initvar] = {6 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][21:0] <= RW0_wdata[21:0];
      if (RW0_wmask[1]) ram[RW0_addr][43:22] <= RW0_wdata[43:22];
      if (RW0_wmask[2]) ram[RW0_addr][65:44] <= RW0_wdata[65:44];
      if (RW0_wmask[3]) ram[RW0_addr][87:66] <= RW0_wdata[87:66];
      if (RW0_wmask[4]) ram[RW0_addr][109:88] <= RW0_wdata[109:88];
      if (RW0_wmask[5]) ram[RW0_addr][131:110] <= RW0_wdata[131:110];
      if (RW0_wmask[6]) ram[RW0_addr][153:132] <= RW0_wdata[153:132];
      if (RW0_wmask[7]) ram[RW0_addr][175:154] <= RW0_wdata[175:154];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [191:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[175:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_24_ext depth:1024 width:40 masked:true maskGran:5 maskSeg:8
module array_24_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [39:0] RW0_wdata,
  output [39:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [39:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][4:0] <= RW0_wdata[4:0];
      if (RW0_wmask[1]) ram[RW0_addr][9:5] <= RW0_wdata[9:5];
      if (RW0_wmask[2]) ram[RW0_addr][14:10] <= RW0_wdata[14:10];
      if (RW0_wmask[3]) ram[RW0_addr][19:15] <= RW0_wdata[19:15];
      if (RW0_wmask[4]) ram[RW0_addr][24:20] <= RW0_wdata[24:20];
      if (RW0_wmask[5]) ram[RW0_addr][29:25] <= RW0_wdata[29:25];
      if (RW0_wmask[6]) ram[RW0_addr][34:30] <= RW0_wdata[34:30];
      if (RW0_wmask[7]) ram[RW0_addr][39:35] <= RW0_wdata[39:35];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[39:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_25_ext depth:1024 width:160 masked:true maskGran:20 maskSeg:8
module array_25_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [159:0] RW0_wdata,
  output [159:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [159:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {5 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][19:0] <= RW0_wdata[19:0];
      if (RW0_wmask[1]) ram[RW0_addr][39:20] <= RW0_wdata[39:20];
      if (RW0_wmask[2]) ram[RW0_addr][59:40] <= RW0_wdata[59:40];
      if (RW0_wmask[3]) ram[RW0_addr][79:60] <= RW0_wdata[79:60];
      if (RW0_wmask[4]) ram[RW0_addr][99:80] <= RW0_wdata[99:80];
      if (RW0_wmask[5]) ram[RW0_addr][119:100] <= RW0_wdata[119:100];
      if (RW0_wmask[6]) ram[RW0_addr][139:120] <= RW0_wdata[139:120];
      if (RW0_wmask[7]) ram[RW0_addr][159:140] <= RW0_wdata[159:140];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [159:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[159:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_26_ext depth:1024 width:7 masked:false maskGran:7 maskSeg:1
module array_26_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [6:0] RW0_wdata,
  output [6:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [6:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      ram[RW0_addr][6:0] <= RW0_wdata[6:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[6:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_2_ext depth:64 width:100 masked:true maskGran:25 maskSeg:4
module array_2_ext(
  input RW0_clk,
  input [5:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [99:0] RW0_wdata,
  output [99:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [5:0] reg_RW0_addr;
  reg [99:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
        ram[initvar] = {4 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][24:0] <= RW0_wdata[24:0];
      if (RW0_wmask[1]) ram[RW0_addr][49:25] <= RW0_wdata[49:25];
      if (RW0_wmask[2]) ram[RW0_addr][74:50] <= RW0_wdata[74:50];
      if (RW0_wmask[3]) ram[RW0_addr][99:75] <= RW0_wdata[99:75];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [127:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[99:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_3_ext depth:512 width:308 masked:true maskGran:77 maskSeg:4
module array_3_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [307:0] RW0_wdata,
  output [307:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [307:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
        ram[initvar] = {10 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][76:0] <= RW0_wdata[76:0];
      if (RW0_wmask[1]) ram[RW0_addr][153:77] <= RW0_wdata[153:77];
      if (RW0_wmask[2]) ram[RW0_addr][230:154] <= RW0_wdata[230:154];
      if (RW0_wmask[3]) ram[RW0_addr][307:231] <= RW0_wdata[307:231];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [319:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[307:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_4_ext depth:256 width:16 masked:true maskGran:1 maskSeg:16
module array_4_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [15:0] RW0_wmask,
  input [15:0] RW0_wdata,
  output [15:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [15:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][0:0] <= RW0_wdata[0:0];
      if (RW0_wmask[1]) ram[RW0_addr][1:1] <= RW0_wdata[1:1];
      if (RW0_wmask[2]) ram[RW0_addr][2:2] <= RW0_wdata[2:2];
      if (RW0_wmask[3]) ram[RW0_addr][3:3] <= RW0_wdata[3:3];
      if (RW0_wmask[4]) ram[RW0_addr][4:4] <= RW0_wdata[4:4];
      if (RW0_wmask[5]) ram[RW0_addr][5:5] <= RW0_wdata[5:5];
      if (RW0_wmask[6]) ram[RW0_addr][6:6] <= RW0_wdata[6:6];
      if (RW0_wmask[7]) ram[RW0_addr][7:7] <= RW0_wdata[7:7];
      if (RW0_wmask[8]) ram[RW0_addr][8:8] <= RW0_wdata[8:8];
      if (RW0_wmask[9]) ram[RW0_addr][9:9] <= RW0_wdata[9:9];
      if (RW0_wmask[10]) ram[RW0_addr][10:10] <= RW0_wdata[10:10];
      if (RW0_wmask[11]) ram[RW0_addr][11:11] <= RW0_wdata[11:11];
      if (RW0_wmask[12]) ram[RW0_addr][12:12] <= RW0_wdata[12:12];
      if (RW0_wmask[13]) ram[RW0_addr][13:13] <= RW0_wdata[13:13];
      if (RW0_wmask[14]) ram[RW0_addr][14:14] <= RW0_wdata[14:14];
      if (RW0_wmask[15]) ram[RW0_addr][15:15] <= RW0_wdata[15:15];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[15:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_5_ext depth:512 width:24 masked:true maskGran:12 maskSeg:2
module array_5_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [23:0] RW0_wdata,
  output [23:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [23:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][11:0] <= RW0_wdata[11:0];
      if (RW0_wmask[1]) ram[RW0_addr][23:12] <= RW0_wdata[23:12];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[23:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_6_ext depth:512 width:16 masked:true maskGran:2 maskSeg:8
module array_6_ext(
  input R0_clk,
  input [8:0] R0_addr,
  input R0_en,
  output [15:0] R0_data,
  input W0_clk,
  input [8:0] W0_addr,
  input W0_en,
  input [15:0] W0_data,
  input [7:0] W0_mask
);


  reg reg_R0_ren;
  reg [8:0] reg_R0_addr;
  reg [15:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_R0_addr = {1 {$random}};
    end
  `endif
  always @(posedge R0_clk)
    reg_R0_ren <= R0_en;
  always @(posedge R0_clk)
    if (R0_en) reg_R0_addr <= R0_addr;
  always @(posedge W0_clk)
    if (W0_en) begin
      if (W0_mask[0]) ram[W0_addr][1:0] <= W0_data[1:0];
      if (W0_mask[1]) ram[W0_addr][3:2] <= W0_data[3:2];
      if (W0_mask[2]) ram[W0_addr][5:4] <= W0_data[5:4];
      if (W0_mask[3]) ram[W0_addr][7:6] <= W0_data[7:6];
      if (W0_mask[4]) ram[W0_addr][9:8] <= W0_data[9:8];
      if (W0_mask[5]) ram[W0_addr][11:10] <= W0_data[11:10];
      if (W0_mask[6]) ram[W0_addr][13:12] <= W0_data[13:12];
      if (W0_mask[7]) ram[W0_addr][15:14] <= W0_data[15:14];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] R0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      R0_random = {$random};
      reg_R0_ren = R0_random[0];
    end
  `endif
  always @(posedge R0_clk) R0_random <= {$random};
  assign R0_data = reg_R0_ren ? ram[reg_R0_addr] : R0_random[15:0];
  `else
  assign R0_data = ram[reg_R0_addr];
  `endif

endmodule// name:array_7_ext depth:256 width:24 masked:true maskGran:6 maskSeg:4
module array_7_ext(
  input R0_clk,
  input [7:0] R0_addr,
  input R0_en,
  output [23:0] R0_data,
  input W0_clk,
  input [7:0] W0_addr,
  input W0_en,
  input [23:0] W0_data,
  input [3:0] W0_mask
);


  reg reg_R0_ren;
  reg [7:0] reg_R0_addr;
  reg [23:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
        ram[initvar] = {1 {$random}};
      reg_R0_addr = {1 {$random}};
    end
  `endif
  always @(posedge R0_clk)
    reg_R0_ren <= R0_en;
  always @(posedge R0_clk)
    if (R0_en) reg_R0_addr <= R0_addr;
  always @(posedge W0_clk)
    if (W0_en) begin
      if (W0_mask[0]) ram[W0_addr][5:0] <= W0_data[5:0];
      if (W0_mask[1]) ram[W0_addr][11:6] <= W0_data[11:6];
      if (W0_mask[2]) ram[W0_addr][17:12] <= W0_data[17:12];
      if (W0_mask[3]) ram[W0_addr][23:18] <= W0_data[23:18];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [31:0] R0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      R0_random = {$random};
      reg_R0_ren = R0_random[0];
    end
  `endif
  always @(posedge R0_clk) R0_random <= {$random};
  assign R0_data = reg_R0_ren ? ram[reg_R0_addr] : R0_random[23:0];
  `else
  assign R0_data = ram[reg_R0_addr];
  `endif

endmodule// name:array_8_ext depth:128 width:50 masked:false maskGran:50 maskSeg:1
module array_8_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [49:0] RW0_wdata,
  output [49:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [49:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {2 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      ram[RW0_addr][49:0] <= RW0_wdata[49:0];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [63:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[49:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_9_ext depth:128 width:100 masked:true maskGran:50 maskSeg:2
module array_9_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [99:0] RW0_wdata,
  output [99:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [6:0] reg_RW0_addr;
  reg [99:0] ram [127:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 128; initvar = initvar+1)
        ram[initvar] = {4 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][49:0] <= RW0_wdata[49:0];
      if (RW0_wmask[1]) ram[RW0_addr][99:50] <= RW0_wdata[99:50];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [127:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[99:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule// name:array_ext depth:32 width:100 masked:true maskGran:25 maskSeg:4
module array_ext(
  input RW0_clk,
  input [4:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [99:0] RW0_wdata,
  output [99:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [4:0] reg_RW0_addr;
  reg [99:0] ram [31:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 32; initvar = initvar+1)
        ram[initvar] = {4 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][24:0] <= RW0_wdata[24:0];
      if (RW0_wmask[1]) ram[RW0_addr][49:25] <= RW0_wdata[49:25];
      if (RW0_wmask[2]) ram[RW0_addr][74:50] <= RW0_wdata[74:50];
      if (RW0_wmask[3]) ram[RW0_addr][99:75] <= RW0_wdata[99:75];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [127:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[99:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule