
`ifndef SYNTHESIS
import "DPI-C" function void flash_read
(
  input int addr,
  output longint data
);
`endif // SYNTHESIS

module FlashHelper (
  input clock,
  input r_en,
  input [31:0] r_addr,
  output reg [63:0] r_data
);

`ifndef SYNTHESIS
  always @(posedge clock) begin
    if (r_en) flash_read(r_addr, r_data);
  end
`endif // SYNTHESIS

endmodule
