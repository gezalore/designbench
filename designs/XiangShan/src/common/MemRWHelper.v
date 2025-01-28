
`ifndef SYNTHESIS

import "DPI-C" function longint ram_read(input longint rIdx);

import "DPI-C" function void ram_write
(
  input  longint index,
  input  longint data,
  input  longint mask
);

`endif // SYNTHESIS
module MemRWHelper(

input             r_enable,
input      [63:0] r_index,
output reg [63:0] r_data,


input         w_enable,
input  [63:0] w_index,
input  [63:0] w_data,
input  [63:0] w_mask,

  input enable,
  input clock
);
`ifndef SYNTHESIS
  always @(posedge clock) begin
    if (enable) begin

if (r_enable) begin
  r_data <= ram_read(r_index);
end


if (w_enable) begin
  ram_write(w_index, w_data, w_mask);
end

    end
  end
`endif // SYNTHESIS
endmodule
