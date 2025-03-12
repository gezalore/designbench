/*
Copyright (c) 2015 Princeton University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

`include "l15.tmp.h"
`include "define.tmp.h"

// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml



module flat_id_to_xy(
    input  [(`HOME_ID_WIDTH-1):0] flat_id,
    output reg [(`NOC_X_WIDTH-1):0] x_coord,
    output reg [(`NOC_Y_WIDTH-1):0] y_coord
);

    always @*
    begin
        case (flat_id)
        
//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d0: 
`HOME_ID_WIDTH'd0: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d1: 
`HOME_ID_WIDTH'd1: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d2: 
`HOME_ID_WIDTH'd2: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d3: 
`HOME_ID_WIDTH'd3: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d4: 
`HOME_ID_WIDTH'd4: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d5: 
`HOME_ID_WIDTH'd5: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d6: 
`HOME_ID_WIDTH'd6: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d7: 
`HOME_ID_WIDTH'd7: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d8: 
`HOME_ID_WIDTH'd8: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d9: 
`HOME_ID_WIDTH'd9: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d10: 
`HOME_ID_WIDTH'd10: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d11: 
`HOME_ID_WIDTH'd11: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d12: 
`HOME_ID_WIDTH'd12: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d13: 
`HOME_ID_WIDTH'd13: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d14: 
`HOME_ID_WIDTH'd14: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d15: 
`HOME_ID_WIDTH'd15: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd0;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d16: 
`HOME_ID_WIDTH'd16: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d17: 
`HOME_ID_WIDTH'd17: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d18: 
`HOME_ID_WIDTH'd18: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d19: 
`HOME_ID_WIDTH'd19: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d20: 
`HOME_ID_WIDTH'd20: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d21: 
`HOME_ID_WIDTH'd21: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d22: 
`HOME_ID_WIDTH'd22: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d23: 
`HOME_ID_WIDTH'd23: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d24: 
`HOME_ID_WIDTH'd24: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d25: 
`HOME_ID_WIDTH'd25: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d26: 
`HOME_ID_WIDTH'd26: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d27: 
`HOME_ID_WIDTH'd27: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d28: 
`HOME_ID_WIDTH'd28: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d29: 
`HOME_ID_WIDTH'd29: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d30: 
`HOME_ID_WIDTH'd30: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d31: 
`HOME_ID_WIDTH'd31: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d32: 
`HOME_ID_WIDTH'd32: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d33: 
`HOME_ID_WIDTH'd33: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d34: 
`HOME_ID_WIDTH'd34: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d35: 
`HOME_ID_WIDTH'd35: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d36: 
`HOME_ID_WIDTH'd36: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d37: 
`HOME_ID_WIDTH'd37: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d38: 
`HOME_ID_WIDTH'd38: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d39: 
`HOME_ID_WIDTH'd39: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d40: 
`HOME_ID_WIDTH'd40: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d41: 
`HOME_ID_WIDTH'd41: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d42: 
`HOME_ID_WIDTH'd42: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d43: 
`HOME_ID_WIDTH'd43: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d44: 
`HOME_ID_WIDTH'd44: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d45: 
`HOME_ID_WIDTH'd45: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d46: 
`HOME_ID_WIDTH'd46: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d47: 
`HOME_ID_WIDTH'd47: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d48: 
`HOME_ID_WIDTH'd48: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d49: 
`HOME_ID_WIDTH'd49: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d50: 
`HOME_ID_WIDTH'd50: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d51: 
`HOME_ID_WIDTH'd51: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d52: 
`HOME_ID_WIDTH'd52: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d53: 
`HOME_ID_WIDTH'd53: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d54: 
`HOME_ID_WIDTH'd54: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d55: 
`HOME_ID_WIDTH'd55: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d56: 
`HOME_ID_WIDTH'd56: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d57: 
`HOME_ID_WIDTH'd57: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d58: 
`HOME_ID_WIDTH'd58: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d59: 
`HOME_ID_WIDTH'd59: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d60: 
`HOME_ID_WIDTH'd60: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d61: 
`HOME_ID_WIDTH'd61: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d62: 
`HOME_ID_WIDTH'd62: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d63: 
`HOME_ID_WIDTH'd63: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d64: 
`HOME_ID_WIDTH'd64: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d65: 
`HOME_ID_WIDTH'd65: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d66: 
`HOME_ID_WIDTH'd66: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d67: 
`HOME_ID_WIDTH'd67: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d68: 
`HOME_ID_WIDTH'd68: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d69: 
`HOME_ID_WIDTH'd69: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d70: 
`HOME_ID_WIDTH'd70: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d71: 
`HOME_ID_WIDTH'd71: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d72: 
`HOME_ID_WIDTH'd72: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d73: 
`HOME_ID_WIDTH'd73: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d74: 
`HOME_ID_WIDTH'd74: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d75: 
`HOME_ID_WIDTH'd75: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d76: 
`HOME_ID_WIDTH'd76: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d77: 
`HOME_ID_WIDTH'd77: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d78: 
`HOME_ID_WIDTH'd78: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d79: 
`HOME_ID_WIDTH'd79: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d80: 
`HOME_ID_WIDTH'd80: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d81: 
`HOME_ID_WIDTH'd81: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d82: 
`HOME_ID_WIDTH'd82: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d83: 
`HOME_ID_WIDTH'd83: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d84: 
`HOME_ID_WIDTH'd84: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d85: 
`HOME_ID_WIDTH'd85: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d86: 
`HOME_ID_WIDTH'd86: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d87: 
`HOME_ID_WIDTH'd87: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d88: 
`HOME_ID_WIDTH'd88: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d89: 
`HOME_ID_WIDTH'd89: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d90: 
`HOME_ID_WIDTH'd90: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d91: 
`HOME_ID_WIDTH'd91: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d92: 
`HOME_ID_WIDTH'd92: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d93: 
`HOME_ID_WIDTH'd93: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d94: 
`HOME_ID_WIDTH'd94: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d95: 
`HOME_ID_WIDTH'd95: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d96: 
`HOME_ID_WIDTH'd96: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d97: 
`HOME_ID_WIDTH'd97: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d98: 
`HOME_ID_WIDTH'd98: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d99: 
`HOME_ID_WIDTH'd99: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d100: 
`HOME_ID_WIDTH'd100: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d101: 
`HOME_ID_WIDTH'd101: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d102: 
`HOME_ID_WIDTH'd102: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d103: 
`HOME_ID_WIDTH'd103: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d104: 
`HOME_ID_WIDTH'd104: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d105: 
`HOME_ID_WIDTH'd105: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d106: 
`HOME_ID_WIDTH'd106: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d107: 
`HOME_ID_WIDTH'd107: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d108: 
`HOME_ID_WIDTH'd108: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d109: 
`HOME_ID_WIDTH'd109: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d110: 
`HOME_ID_WIDTH'd110: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d111: 
`HOME_ID_WIDTH'd111: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d112: 
`HOME_ID_WIDTH'd112: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d113: 
`HOME_ID_WIDTH'd113: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d114: 
`HOME_ID_WIDTH'd114: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d115: 
`HOME_ID_WIDTH'd115: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d116: 
`HOME_ID_WIDTH'd116: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d117: 
`HOME_ID_WIDTH'd117: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d118: 
`HOME_ID_WIDTH'd118: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d119: 
`HOME_ID_WIDTH'd119: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d120: 
`HOME_ID_WIDTH'd120: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d121: 
`HOME_ID_WIDTH'd121: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d122: 
`HOME_ID_WIDTH'd122: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d123: 
`HOME_ID_WIDTH'd123: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d124: 
`HOME_ID_WIDTH'd124: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d125: 
`HOME_ID_WIDTH'd125: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d126: 
`HOME_ID_WIDTH'd126: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d127: 
`HOME_ID_WIDTH'd127: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d128: 
`HOME_ID_WIDTH'd128: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d129: 
`HOME_ID_WIDTH'd129: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d130: 
`HOME_ID_WIDTH'd130: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d131: 
`HOME_ID_WIDTH'd131: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d132: 
`HOME_ID_WIDTH'd132: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d133: 
`HOME_ID_WIDTH'd133: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d134: 
`HOME_ID_WIDTH'd134: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d135: 
`HOME_ID_WIDTH'd135: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d136: 
`HOME_ID_WIDTH'd136: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d137: 
`HOME_ID_WIDTH'd137: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d138: 
`HOME_ID_WIDTH'd138: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d139: 
`HOME_ID_WIDTH'd139: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d140: 
`HOME_ID_WIDTH'd140: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d141: 
`HOME_ID_WIDTH'd141: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d142: 
`HOME_ID_WIDTH'd142: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d143: 
`HOME_ID_WIDTH'd143: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd8;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d144: 
`HOME_ID_WIDTH'd144: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d145: 
`HOME_ID_WIDTH'd145: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d146: 
`HOME_ID_WIDTH'd146: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d147: 
`HOME_ID_WIDTH'd147: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d148: 
`HOME_ID_WIDTH'd148: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d149: 
`HOME_ID_WIDTH'd149: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d150: 
`HOME_ID_WIDTH'd150: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d151: 
`HOME_ID_WIDTH'd151: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d152: 
`HOME_ID_WIDTH'd152: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d153: 
`HOME_ID_WIDTH'd153: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d154: 
`HOME_ID_WIDTH'd154: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d155: 
`HOME_ID_WIDTH'd155: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d156: 
`HOME_ID_WIDTH'd156: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d157: 
`HOME_ID_WIDTH'd157: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d158: 
`HOME_ID_WIDTH'd158: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d159: 
`HOME_ID_WIDTH'd159: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd9;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d160: 
`HOME_ID_WIDTH'd160: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d161: 
`HOME_ID_WIDTH'd161: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d162: 
`HOME_ID_WIDTH'd162: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d163: 
`HOME_ID_WIDTH'd163: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d164: 
`HOME_ID_WIDTH'd164: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d165: 
`HOME_ID_WIDTH'd165: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d166: 
`HOME_ID_WIDTH'd166: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d167: 
`HOME_ID_WIDTH'd167: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d168: 
`HOME_ID_WIDTH'd168: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d169: 
`HOME_ID_WIDTH'd169: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d170: 
`HOME_ID_WIDTH'd170: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d171: 
`HOME_ID_WIDTH'd171: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d172: 
`HOME_ID_WIDTH'd172: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d173: 
`HOME_ID_WIDTH'd173: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d174: 
`HOME_ID_WIDTH'd174: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d175: 
`HOME_ID_WIDTH'd175: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd10;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d176: 
`HOME_ID_WIDTH'd176: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d177: 
`HOME_ID_WIDTH'd177: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d178: 
`HOME_ID_WIDTH'd178: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d179: 
`HOME_ID_WIDTH'd179: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d180: 
`HOME_ID_WIDTH'd180: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d181: 
`HOME_ID_WIDTH'd181: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d182: 
`HOME_ID_WIDTH'd182: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d183: 
`HOME_ID_WIDTH'd183: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d184: 
`HOME_ID_WIDTH'd184: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d185: 
`HOME_ID_WIDTH'd185: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d186: 
`HOME_ID_WIDTH'd186: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d187: 
`HOME_ID_WIDTH'd187: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d188: 
`HOME_ID_WIDTH'd188: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d189: 
`HOME_ID_WIDTH'd189: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d190: 
`HOME_ID_WIDTH'd190: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d191: 
`HOME_ID_WIDTH'd191: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd11;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d192: 
`HOME_ID_WIDTH'd192: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d193: 
`HOME_ID_WIDTH'd193: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d194: 
`HOME_ID_WIDTH'd194: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d195: 
`HOME_ID_WIDTH'd195: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d196: 
`HOME_ID_WIDTH'd196: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d197: 
`HOME_ID_WIDTH'd197: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d198: 
`HOME_ID_WIDTH'd198: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d199: 
`HOME_ID_WIDTH'd199: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d200: 
`HOME_ID_WIDTH'd200: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d201: 
`HOME_ID_WIDTH'd201: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d202: 
`HOME_ID_WIDTH'd202: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d203: 
`HOME_ID_WIDTH'd203: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d204: 
`HOME_ID_WIDTH'd204: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d205: 
`HOME_ID_WIDTH'd205: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d206: 
`HOME_ID_WIDTH'd206: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d207: 
`HOME_ID_WIDTH'd207: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd12;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d208: 
`HOME_ID_WIDTH'd208: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d209: 
`HOME_ID_WIDTH'd209: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d210: 
`HOME_ID_WIDTH'd210: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d211: 
`HOME_ID_WIDTH'd211: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d212: 
`HOME_ID_WIDTH'd212: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d213: 
`HOME_ID_WIDTH'd213: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d214: 
`HOME_ID_WIDTH'd214: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d215: 
`HOME_ID_WIDTH'd215: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d216: 
`HOME_ID_WIDTH'd216: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d217: 
`HOME_ID_WIDTH'd217: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d218: 
`HOME_ID_WIDTH'd218: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d219: 
`HOME_ID_WIDTH'd219: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d220: 
`HOME_ID_WIDTH'd220: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d221: 
`HOME_ID_WIDTH'd221: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d222: 
`HOME_ID_WIDTH'd222: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d223: 
`HOME_ID_WIDTH'd223: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd13;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d224: 
`HOME_ID_WIDTH'd224: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d225: 
`HOME_ID_WIDTH'd225: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d226: 
`HOME_ID_WIDTH'd226: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d227: 
`HOME_ID_WIDTH'd227: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d228: 
`HOME_ID_WIDTH'd228: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d229: 
`HOME_ID_WIDTH'd229: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d230: 
`HOME_ID_WIDTH'd230: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d231: 
`HOME_ID_WIDTH'd231: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d232: 
`HOME_ID_WIDTH'd232: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d233: 
`HOME_ID_WIDTH'd233: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d234: 
`HOME_ID_WIDTH'd234: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d235: 
`HOME_ID_WIDTH'd235: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d236: 
`HOME_ID_WIDTH'd236: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d237: 
`HOME_ID_WIDTH'd237: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d238: 
`HOME_ID_WIDTH'd238: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d239: 
`HOME_ID_WIDTH'd239: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd14;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d240: 
`HOME_ID_WIDTH'd240: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d241: 
`HOME_ID_WIDTH'd241: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d242: 
`HOME_ID_WIDTH'd242: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d243: 
`HOME_ID_WIDTH'd243: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d244: 
`HOME_ID_WIDTH'd244: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d245: 
`HOME_ID_WIDTH'd245: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d246: 
`HOME_ID_WIDTH'd246: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d247: 
`HOME_ID_WIDTH'd247: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d248: 
`HOME_ID_WIDTH'd248: 
begin
    x_coord = `NOC_X_WIDTH'd8;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d249: 
`HOME_ID_WIDTH'd249: 
begin
    x_coord = `NOC_X_WIDTH'd9;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d250: 
`HOME_ID_WIDTH'd250: 
begin
    x_coord = `NOC_X_WIDTH'd10;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d251: 
`HOME_ID_WIDTH'd251: 
begin
    x_coord = `NOC_X_WIDTH'd11;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d252: 
`HOME_ID_WIDTH'd252: 
begin
    x_coord = `NOC_X_WIDTH'd12;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d253: 
`HOME_ID_WIDTH'd253: 
begin
    x_coord = `NOC_X_WIDTH'd13;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d254: 
`HOME_ID_WIDTH'd254: 
begin
    x_coord = `NOC_X_WIDTH'd14;
    y_coord = `NOC_Y_WIDTH'd15;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d255: 
`HOME_ID_WIDTH'd255: 
begin
    x_coord = `NOC_X_WIDTH'd15;
    y_coord = `NOC_Y_WIDTH'd15;
end

        default:
        begin
            x_coord = `NOC_X_WIDTH'dX;
            y_coord = `NOC_X_WIDTH'dX;
        end
        endcase
    end
endmodule
