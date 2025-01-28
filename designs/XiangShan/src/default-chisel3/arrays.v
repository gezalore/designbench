module array_0_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [511:0] RW0_wdata,
  output [511:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [511:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
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

endmodule
module array_10_ext(
  input R0_clk,
  input [5:0] R0_addr,
  input R0_en,
  output [248:0] R0_data,
  input W0_clk,
  input [5:0] W0_addr,
  input W0_en,
  input [248:0] W0_data
);


  reg reg_R0_ren;
  reg [5:0] reg_R0_addr;
  reg [248:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
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

endmodule
module array_11_ext(
  input R0_clk,
  input [5:0] R0_addr,
  input R0_en,
  output [511:0] R0_data,
  input W0_clk,
  input [5:0] W0_addr,
  input W0_en,
  input [511:0] W0_data
);


  reg reg_R0_ren;
  reg [5:0] reg_R0_addr;
  reg [511:0] ram [63:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 64; initvar = initvar+1)
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

endmodule
module array_12_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [63:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
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

endmodule
module array_13_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [95:0] RW0_wdata,
  output [95:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [95:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
        ram[initvar] = {3 {$random}};
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
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [95:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[95:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_14_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [23:0] RW0_wdata,
  output [23:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [23:0] ram [255:0];
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
      if (RW0_wmask[0]) ram[RW0_addr][5:0] <= RW0_wdata[5:0];
      if (RW0_wmask[1]) ram[RW0_addr][11:6] <= RW0_wdata[11:6];
      if (RW0_wmask[2]) ram[RW0_addr][17:12] <= RW0_wdata[17:12];
      if (RW0_wmask[3]) ram[RW0_addr][23:18] <= RW0_wdata[23:18];
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

endmodule
module array_15_ext(
  input RW0_clk,
  input [2:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [1039:0] RW0_wdata,
  output [1039:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [2:0] reg_RW0_addr;
  reg [1039:0] ram [7:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 8; initvar = initvar+1)
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
      if (RW0_wmask[0]) ram[RW0_addr][259:0] <= RW0_wdata[259:0];
      if (RW0_wmask[1]) ram[RW0_addr][519:260] <= RW0_wdata[519:260];
      if (RW0_wmask[2]) ram[RW0_addr][779:520] <= RW0_wdata[779:520];
      if (RW0_wmask[3]) ram[RW0_addr][1039:780] <= RW0_wdata[1039:780];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[1039:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_16_ext(
  input RW0_clk,
  input [4:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [2647:0] RW0_wdata,
  output [2647:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [4:0] reg_RW0_addr;
  reg [2647:0] ram [31:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 32; initvar = initvar+1)
        ram[initvar] = {83 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][330:0] <= RW0_wdata[330:0];
      if (RW0_wmask[1]) ram[RW0_addr][661:331] <= RW0_wdata[661:331];
      if (RW0_wmask[2]) ram[RW0_addr][992:662] <= RW0_wdata[992:662];
      if (RW0_wmask[3]) ram[RW0_addr][1323:993] <= RW0_wdata[1323:993];
      if (RW0_wmask[4]) ram[RW0_addr][1654:1324] <= RW0_wdata[1654:1324];
      if (RW0_wmask[5]) ram[RW0_addr][1985:1655] <= RW0_wdata[1985:1655];
      if (RW0_wmask[6]) ram[RW0_addr][2316:1986] <= RW0_wdata[2316:1986];
      if (RW0_wmask[7]) ram[RW0_addr][2647:2317] <= RW0_wdata[2647:2317];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [2655:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[2647:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_17_ext(
  input RW0_clk,
  input [4:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [1:0] RW0_wmask,
  input [147:0] RW0_wdata,
  output [147:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [4:0] reg_RW0_addr;
  reg [147:0] ram [31:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 32; initvar = initvar+1)
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
      if (RW0_wmask[0]) ram[RW0_addr][73:0] <= RW0_wdata[73:0];
      if (RW0_wmask[1]) ram[RW0_addr][147:74] <= RW0_wdata[147:74];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[147:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_18_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [12:0] RW0_wdata,
  output [12:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [12:0] ram [255:0];
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
      ram[RW0_addr][12:0] <= RW0_wdata[12:0];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[12:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_19_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [15:0] RW0_wmask,
  input [383:0] RW0_wdata,
  output [383:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [383:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {12 {$random}};
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
      if (RW0_wmask[8]) ram[RW0_addr][215:192] <= RW0_wdata[215:192];
      if (RW0_wmask[9]) ram[RW0_addr][239:216] <= RW0_wdata[239:216];
      if (RW0_wmask[10]) ram[RW0_addr][263:240] <= RW0_wdata[263:240];
      if (RW0_wmask[11]) ram[RW0_addr][287:264] <= RW0_wdata[287:264];
      if (RW0_wmask[12]) ram[RW0_addr][311:288] <= RW0_wdata[311:288];
      if (RW0_wmask[13]) ram[RW0_addr][335:312] <= RW0_wdata[335:312];
      if (RW0_wmask[14]) ram[RW0_addr][359:336] <= RW0_wdata[359:336];
      if (RW0_wmask[15]) ram[RW0_addr][383:360] <= RW0_wdata[383:360];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [383:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[383:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_1_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [63:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
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

endmodule
module array_20_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [151:0] RW0_wdata,
  output [151:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [151:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
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
      if (RW0_wmask[0]) ram[RW0_addr][18:0] <= RW0_wdata[18:0];
      if (RW0_wmask[1]) ram[RW0_addr][37:19] <= RW0_wdata[37:19];
      if (RW0_wmask[2]) ram[RW0_addr][56:38] <= RW0_wdata[56:38];
      if (RW0_wmask[3]) ram[RW0_addr][75:57] <= RW0_wdata[75:57];
      if (RW0_wmask[4]) ram[RW0_addr][94:76] <= RW0_wdata[94:76];
      if (RW0_wmask[5]) ram[RW0_addr][113:95] <= RW0_wdata[113:95];
      if (RW0_wmask[6]) ram[RW0_addr][132:114] <= RW0_wdata[132:114];
      if (RW0_wmask[7]) ram[RW0_addr][151:133] <= RW0_wdata[151:133];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[151:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_21_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [7:0] RW0_wmask,
  input [87:0] RW0_wdata,
  output [87:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [87:0] ram [511:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 512; initvar = initvar+1)
        ram[initvar] = {3 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][10:0] <= RW0_wdata[10:0];
      if (RW0_wmask[1]) ram[RW0_addr][21:11] <= RW0_wdata[21:11];
      if (RW0_wmask[2]) ram[RW0_addr][32:22] <= RW0_wdata[32:22];
      if (RW0_wmask[3]) ram[RW0_addr][43:33] <= RW0_wdata[43:33];
      if (RW0_wmask[4]) ram[RW0_addr][54:44] <= RW0_wdata[54:44];
      if (RW0_wmask[5]) ram[RW0_addr][65:55] <= RW0_wdata[65:55];
      if (RW0_wmask[6]) ram[RW0_addr][76:66] <= RW0_wdata[76:66];
      if (RW0_wmask[7]) ram[RW0_addr][87:77] <= RW0_wdata[87:77];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [95:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[87:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_22_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [6:0] RW0_wdata,
  output [6:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [6:0] ram [511:0];
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

endmodule
module array_23_ext(
  input RW0_clk,
  input [11:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [511:0] RW0_wdata,
  output [511:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [11:0] reg_RW0_addr;
  reg [511:0] ram [4095:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4096; initvar = initvar+1)
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

endmodule
module array_24_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [15:0] RW0_wmask,
  input [7743:0] RW0_wdata,
  output [7743:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [7743:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
        ram[initvar] = {242 {$random}};
      reg_RW0_addr = {1 {$random}};
    end
  `endif
  always @(posedge RW0_clk)
    reg_RW0_ren <= RW0_en && !RW0_wmode;
  always @(posedge RW0_clk)
    if (RW0_en && !RW0_wmode) reg_RW0_addr <= RW0_addr;
  always @(posedge RW0_clk)
    if (RW0_en && RW0_wmode) begin
      if (RW0_wmask[0]) ram[RW0_addr][483:0] <= RW0_wdata[483:0];
      if (RW0_wmask[1]) ram[RW0_addr][967:484] <= RW0_wdata[967:484];
      if (RW0_wmask[2]) ram[RW0_addr][1451:968] <= RW0_wdata[1451:968];
      if (RW0_wmask[3]) ram[RW0_addr][1935:1452] <= RW0_wdata[1935:1452];
      if (RW0_wmask[4]) ram[RW0_addr][2419:1936] <= RW0_wdata[2419:1936];
      if (RW0_wmask[5]) ram[RW0_addr][2903:2420] <= RW0_wdata[2903:2420];
      if (RW0_wmask[6]) ram[RW0_addr][3387:2904] <= RW0_wdata[3387:2904];
      if (RW0_wmask[7]) ram[RW0_addr][3871:3388] <= RW0_wdata[3871:3388];
      if (RW0_wmask[8]) ram[RW0_addr][4355:3872] <= RW0_wdata[4355:3872];
      if (RW0_wmask[9]) ram[RW0_addr][4839:4356] <= RW0_wdata[4839:4356];
      if (RW0_wmask[10]) ram[RW0_addr][5323:4840] <= RW0_wdata[5323:4840];
      if (RW0_wmask[11]) ram[RW0_addr][5807:5324] <= RW0_wdata[5807:5324];
      if (RW0_wmask[12]) ram[RW0_addr][6291:5808] <= RW0_wdata[6291:5808];
      if (RW0_wmask[13]) ram[RW0_addr][6775:6292] <= RW0_wdata[6775:6292];
      if (RW0_wmask[14]) ram[RW0_addr][7259:6776] <= RW0_wdata[7259:6776];
      if (RW0_wmask[15]) ram[RW0_addr][7743:7260] <= RW0_wdata[7743:7260];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [7743:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[7743:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_25_ext(
  input RW0_clk,
  input [13:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [63:0] RW0_wdata,
  output [63:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [13:0] reg_RW0_addr;
  reg [63:0] ram [16383:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 16384; initvar = initvar+1)
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

endmodule
module array_26_ext(
  input RW0_clk,
  input [13:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [31:0] RW0_wdata,
  output [31:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [13:0] reg_RW0_addr;
  reg [31:0] ram [16383:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 16384; initvar = initvar+1)
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
      ram[RW0_addr][31:0] <= RW0_wdata[31:0];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[31:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_27_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [9:0] RW0_wmask,
  input [19:0] RW0_wdata,
  output [19:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [19:0] ram [1023:0];
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
      if (RW0_wmask[0]) ram[RW0_addr][1:0] <= RW0_wdata[1:0];
      if (RW0_wmask[1]) ram[RW0_addr][3:2] <= RW0_wdata[3:2];
      if (RW0_wmask[2]) ram[RW0_addr][5:4] <= RW0_wdata[5:4];
      if (RW0_wmask[3]) ram[RW0_addr][7:6] <= RW0_wdata[7:6];
      if (RW0_wmask[4]) ram[RW0_addr][9:8] <= RW0_wdata[9:8];
      if (RW0_wmask[5]) ram[RW0_addr][11:10] <= RW0_wdata[11:10];
      if (RW0_wmask[6]) ram[RW0_addr][13:12] <= RW0_wdata[13:12];
      if (RW0_wmask[7]) ram[RW0_addr][15:14] <= RW0_wdata[15:14];
      if (RW0_wmask[8]) ram[RW0_addr][17:16] <= RW0_wdata[17:16];
      if (RW0_wmask[9]) ram[RW0_addr][19:18] <= RW0_wdata[19:18];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[19:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_28_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [9:0] RW0_wmask,
  input [179:0] RW0_wdata,
  output [179:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [179:0] ram [1023:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 1024; initvar = initvar+1)
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
      if (RW0_wmask[0]) ram[RW0_addr][17:0] <= RW0_wdata[17:0];
      if (RW0_wmask[1]) ram[RW0_addr][35:18] <= RW0_wdata[35:18];
      if (RW0_wmask[2]) ram[RW0_addr][53:36] <= RW0_wdata[53:36];
      if (RW0_wmask[3]) ram[RW0_addr][71:54] <= RW0_wdata[71:54];
      if (RW0_wmask[4]) ram[RW0_addr][89:72] <= RW0_wdata[89:72];
      if (RW0_wmask[5]) ram[RW0_addr][107:90] <= RW0_wdata[107:90];
      if (RW0_wmask[6]) ram[RW0_addr][125:108] <= RW0_wdata[125:108];
      if (RW0_wmask[7]) ram[RW0_addr][143:126] <= RW0_wdata[143:126];
      if (RW0_wmask[8]) ram[RW0_addr][161:144] <= RW0_wdata[161:144];
      if (RW0_wmask[9]) ram[RW0_addr][179:162] <= RW0_wdata[179:162];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[179:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_29_ext(
  input RW0_clk,
  input [9:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [9:0] RW0_wmask,
  input [59:0] RW0_wdata,
  output [59:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [9:0] reg_RW0_addr;
  reg [59:0] ram [1023:0];
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
      if (RW0_wmask[0]) ram[RW0_addr][5:0] <= RW0_wdata[5:0];
      if (RW0_wmask[1]) ram[RW0_addr][11:6] <= RW0_wdata[11:6];
      if (RW0_wmask[2]) ram[RW0_addr][17:12] <= RW0_wdata[17:12];
      if (RW0_wmask[3]) ram[RW0_addr][23:18] <= RW0_wdata[23:18];
      if (RW0_wmask[4]) ram[RW0_addr][29:24] <= RW0_wdata[29:24];
      if (RW0_wmask[5]) ram[RW0_addr][35:30] <= RW0_wdata[35:30];
      if (RW0_wmask[6]) ram[RW0_addr][41:36] <= RW0_wdata[41:36];
      if (RW0_wmask[7]) ram[RW0_addr][47:42] <= RW0_wdata[47:42];
      if (RW0_wmask[8]) ram[RW0_addr][53:48] <= RW0_wdata[53:48];
      if (RW0_wmask[9]) ram[RW0_addr][59:54] <= RW0_wdata[59:54];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[59:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_2_ext(
  input RW0_clk,
  input [7:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [99:0] RW0_wdata,
  output [99:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [7:0] reg_RW0_addr;
  reg [99:0] ram [255:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 256; initvar = initvar+1)
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
module array_30_ext(
  input RW0_clk,
  input [11:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [15:0] RW0_wmask,
  input [95:0] RW0_wdata,
  output [95:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [11:0] reg_RW0_addr;
  reg [95:0] ram [4095:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4096; initvar = initvar+1)
        ram[initvar] = {3 {$random}};
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
      if (RW0_wmask[8]) ram[RW0_addr][53:48] <= RW0_wdata[53:48];
      if (RW0_wmask[9]) ram[RW0_addr][59:54] <= RW0_wdata[59:54];
      if (RW0_wmask[10]) ram[RW0_addr][65:60] <= RW0_wdata[65:60];
      if (RW0_wmask[11]) ram[RW0_addr][71:66] <= RW0_wdata[71:66];
      if (RW0_wmask[12]) ram[RW0_addr][77:72] <= RW0_wdata[77:72];
      if (RW0_wmask[13]) ram[RW0_addr][83:78] <= RW0_wdata[83:78];
      if (RW0_wmask[14]) ram[RW0_addr][89:84] <= RW0_wdata[89:84];
      if (RW0_wmask[15]) ram[RW0_addr][95:90] <= RW0_wdata[95:90];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [95:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[95:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_31_ext(
  input RW0_clk,
  input [11:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [15:0] RW0_wmask,
  input [255:0] RW0_wdata,
  output [255:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [11:0] reg_RW0_addr;
  reg [255:0] ram [4095:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4096; initvar = initvar+1)
        ram[initvar] = {8 {$random}};
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
      if (RW0_wmask[4]) ram[RW0_addr][79:64] <= RW0_wdata[79:64];
      if (RW0_wmask[5]) ram[RW0_addr][95:80] <= RW0_wdata[95:80];
      if (RW0_wmask[6]) ram[RW0_addr][111:96] <= RW0_wdata[111:96];
      if (RW0_wmask[7]) ram[RW0_addr][127:112] <= RW0_wdata[127:112];
      if (RW0_wmask[8]) ram[RW0_addr][143:128] <= RW0_wdata[143:128];
      if (RW0_wmask[9]) ram[RW0_addr][159:144] <= RW0_wdata[159:144];
      if (RW0_wmask[10]) ram[RW0_addr][175:160] <= RW0_wdata[175:160];
      if (RW0_wmask[11]) ram[RW0_addr][191:176] <= RW0_wdata[191:176];
      if (RW0_wmask[12]) ram[RW0_addr][207:192] <= RW0_wdata[207:192];
      if (RW0_wmask[13]) ram[RW0_addr][223:208] <= RW0_wdata[223:208];
      if (RW0_wmask[14]) ram[RW0_addr][239:224] <= RW0_wdata[239:224];
      if (RW0_wmask[15]) ram[RW0_addr][255:240] <= RW0_wdata[255:240];
    end
  `ifdef RANDOMIZE_GARBAGE_ASSIGN
  reg [255:0] RW0_random;
  `ifdef RANDOMIZE_MEM_INIT
    initial begin
      #`RANDOMIZE_DELAY begin end
      RW0_random = {$random, $random, $random, $random, $random, $random, $random, $random};
      reg_RW0_ren = RW0_random[0];
    end
  `endif
  always @(posedge RW0_clk) RW0_random <= {$random, $random, $random, $random, $random, $random, $random, $random};
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[255:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_32_ext(
  input RW0_clk,
  input [11:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [14:0] RW0_wdata,
  output [14:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [11:0] reg_RW0_addr;
  reg [14:0] ram [4095:0];
  `ifdef RANDOMIZE_MEM_INIT
    integer initvar;
    initial begin
      #`RANDOMIZE_DELAY begin end
      for (initvar = 0; initvar < 4096; initvar = initvar+1)
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
      ram[RW0_addr][14:0] <= RW0_wdata[14:0];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[14:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
module array_3_ext(
  input RW0_clk,
  input [8:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
  input [319:0] RW0_wdata,
  output [319:0] RW0_rdata
);


  reg reg_RW0_ren;
  reg [8:0] reg_RW0_addr;
  reg [319:0] ram [511:0];
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
      if (RW0_wmask[0]) ram[RW0_addr][79:0] <= RW0_wdata[79:0];
      if (RW0_wmask[1]) ram[RW0_addr][159:80] <= RW0_wdata[159:80];
      if (RW0_wmask[2]) ram[RW0_addr][239:160] <= RW0_wdata[239:160];
      if (RW0_wmask[3]) ram[RW0_addr][319:240] <= RW0_wdata[319:240];
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
  assign RW0_rdata = reg_RW0_ren ? ram[reg_RW0_addr] : RW0_random[319:0];
  `else
  assign RW0_rdata = ram[reg_RW0_addr];
  `endif

endmodule
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

endmodule
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

endmodule
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

endmodule
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

endmodule
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

endmodule
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

endmodule
module array_ext(
  input RW0_clk,
  input [6:0] RW0_addr,
  input RW0_en,
  input RW0_wmode,
  input [3:0] RW0_wmask,
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
