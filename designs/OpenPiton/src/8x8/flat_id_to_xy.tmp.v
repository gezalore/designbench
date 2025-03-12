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
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d9: 
`HOME_ID_WIDTH'd9: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d10: 
`HOME_ID_WIDTH'd10: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d11: 
`HOME_ID_WIDTH'd11: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d12: 
`HOME_ID_WIDTH'd12: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d13: 
`HOME_ID_WIDTH'd13: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d14: 
`HOME_ID_WIDTH'd14: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d15: 
`HOME_ID_WIDTH'd15: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd1;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d16: 
`HOME_ID_WIDTH'd16: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d17: 
`HOME_ID_WIDTH'd17: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d18: 
`HOME_ID_WIDTH'd18: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d19: 
`HOME_ID_WIDTH'd19: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d20: 
`HOME_ID_WIDTH'd20: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d21: 
`HOME_ID_WIDTH'd21: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d22: 
`HOME_ID_WIDTH'd22: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d23: 
`HOME_ID_WIDTH'd23: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd2;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d24: 
`HOME_ID_WIDTH'd24: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d25: 
`HOME_ID_WIDTH'd25: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d26: 
`HOME_ID_WIDTH'd26: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d27: 
`HOME_ID_WIDTH'd27: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d28: 
`HOME_ID_WIDTH'd28: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d29: 
`HOME_ID_WIDTH'd29: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d30: 
`HOME_ID_WIDTH'd30: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d31: 
`HOME_ID_WIDTH'd31: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd3;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d32: 
`HOME_ID_WIDTH'd32: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d33: 
`HOME_ID_WIDTH'd33: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d34: 
`HOME_ID_WIDTH'd34: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d35: 
`HOME_ID_WIDTH'd35: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d36: 
`HOME_ID_WIDTH'd36: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d37: 
`HOME_ID_WIDTH'd37: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d38: 
`HOME_ID_WIDTH'd38: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d39: 
`HOME_ID_WIDTH'd39: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd4;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d40: 
`HOME_ID_WIDTH'd40: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d41: 
`HOME_ID_WIDTH'd41: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d42: 
`HOME_ID_WIDTH'd42: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d43: 
`HOME_ID_WIDTH'd43: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d44: 
`HOME_ID_WIDTH'd44: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d45: 
`HOME_ID_WIDTH'd45: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d46: 
`HOME_ID_WIDTH'd46: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d47: 
`HOME_ID_WIDTH'd47: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd5;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d48: 
`HOME_ID_WIDTH'd48: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d49: 
`HOME_ID_WIDTH'd49: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d50: 
`HOME_ID_WIDTH'd50: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d51: 
`HOME_ID_WIDTH'd51: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d52: 
`HOME_ID_WIDTH'd52: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d53: 
`HOME_ID_WIDTH'd53: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d54: 
`HOME_ID_WIDTH'd54: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d55: 
`HOME_ID_WIDTH'd55: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd6;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d56: 
`HOME_ID_WIDTH'd56: 
begin
    x_coord = `NOC_X_WIDTH'd0;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d57: 
`HOME_ID_WIDTH'd57: 
begin
    x_coord = `NOC_X_WIDTH'd1;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d58: 
`HOME_ID_WIDTH'd58: 
begin
    x_coord = `NOC_X_WIDTH'd2;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d59: 
`HOME_ID_WIDTH'd59: 
begin
    x_coord = `NOC_X_WIDTH'd3;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d60: 
`HOME_ID_WIDTH'd60: 
begin
    x_coord = `NOC_X_WIDTH'd4;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d61: 
`HOME_ID_WIDTH'd61: 
begin
    x_coord = `NOC_X_WIDTH'd5;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d62: 
`HOME_ID_WIDTH'd62: 
begin
    x_coord = `NOC_X_WIDTH'd6;
    y_coord = `NOC_Y_WIDTH'd7;
end

//(`NOC_Y_WIDTH+`NOC_X_WIDTH)'d63: 
`HOME_ID_WIDTH'd63: 
begin
    x_coord = `NOC_X_WIDTH'd7;
    y_coord = `NOC_Y_WIDTH'd7;
end

        default:
        begin
            x_coord = `NOC_X_WIDTH'dX;
            y_coord = `NOC_X_WIDTH'dX;
        end
        endcase
    end
endmodule
