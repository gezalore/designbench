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



module xy_to_flat_id(
    input  [(`NOC_X_WIDTH-1):0] x_coord,
    input  [(`NOC_Y_WIDTH-1):0] y_coord,
    output reg [(`HOME_ID_WIDTH-1):0] flat_id
);
    
    
    always @*
    begin
        case (x_coord)
        
`NOC_X_WIDTH'd0:
begin
     case (y_coord)

    // (x,y) = (0, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd0;
    end

    // (x,y) = (0, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd16;
    end

    // (x,y) = (0, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd32;
    end

    // (x,y) = (0, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd48;
    end

    // (x,y) = (0, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd64;
    end

    // (x,y) = (0, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd80;
    end

    // (x,y) = (0, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd96;
    end

    // (x,y) = (0, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd112;
    end

    // (x,y) = (0, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd128;
    end

    // (x,y) = (0, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd144;
    end

    // (x,y) = (0, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd160;
    end

    // (x,y) = (0, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd176;
    end

    // (x,y) = (0, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd192;
    end

    // (x,y) = (0, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd208;
    end

    // (x,y) = (0, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd224;
    end

    // (x,y) = (0, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd240;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd1:
begin
     case (y_coord)

    // (x,y) = (1, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd1;
    end

    // (x,y) = (1, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd17;
    end

    // (x,y) = (1, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd33;
    end

    // (x,y) = (1, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd49;
    end

    // (x,y) = (1, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd65;
    end

    // (x,y) = (1, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd81;
    end

    // (x,y) = (1, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd97;
    end

    // (x,y) = (1, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd113;
    end

    // (x,y) = (1, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd129;
    end

    // (x,y) = (1, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd145;
    end

    // (x,y) = (1, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd161;
    end

    // (x,y) = (1, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd177;
    end

    // (x,y) = (1, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd193;
    end

    // (x,y) = (1, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd209;
    end

    // (x,y) = (1, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd225;
    end

    // (x,y) = (1, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd241;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd2:
begin
     case (y_coord)

    // (x,y) = (2, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd2;
    end

    // (x,y) = (2, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd18;
    end

    // (x,y) = (2, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd34;
    end

    // (x,y) = (2, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd50;
    end

    // (x,y) = (2, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd66;
    end

    // (x,y) = (2, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd82;
    end

    // (x,y) = (2, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd98;
    end

    // (x,y) = (2, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd114;
    end

    // (x,y) = (2, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd130;
    end

    // (x,y) = (2, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd146;
    end

    // (x,y) = (2, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd162;
    end

    // (x,y) = (2, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd178;
    end

    // (x,y) = (2, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd194;
    end

    // (x,y) = (2, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd210;
    end

    // (x,y) = (2, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd226;
    end

    // (x,y) = (2, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd242;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd3:
begin
     case (y_coord)

    // (x,y) = (3, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd3;
    end

    // (x,y) = (3, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd19;
    end

    // (x,y) = (3, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd35;
    end

    // (x,y) = (3, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd51;
    end

    // (x,y) = (3, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd67;
    end

    // (x,y) = (3, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd83;
    end

    // (x,y) = (3, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd99;
    end

    // (x,y) = (3, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd115;
    end

    // (x,y) = (3, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd131;
    end

    // (x,y) = (3, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd147;
    end

    // (x,y) = (3, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd163;
    end

    // (x,y) = (3, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd179;
    end

    // (x,y) = (3, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd195;
    end

    // (x,y) = (3, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd211;
    end

    // (x,y) = (3, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd227;
    end

    // (x,y) = (3, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd243;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd4:
begin
     case (y_coord)

    // (x,y) = (4, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd4;
    end

    // (x,y) = (4, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd20;
    end

    // (x,y) = (4, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd36;
    end

    // (x,y) = (4, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd52;
    end

    // (x,y) = (4, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd68;
    end

    // (x,y) = (4, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd84;
    end

    // (x,y) = (4, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd100;
    end

    // (x,y) = (4, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd116;
    end

    // (x,y) = (4, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd132;
    end

    // (x,y) = (4, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd148;
    end

    // (x,y) = (4, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd164;
    end

    // (x,y) = (4, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd180;
    end

    // (x,y) = (4, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd196;
    end

    // (x,y) = (4, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd212;
    end

    // (x,y) = (4, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd228;
    end

    // (x,y) = (4, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd244;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd5:
begin
     case (y_coord)

    // (x,y) = (5, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd5;
    end

    // (x,y) = (5, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd21;
    end

    // (x,y) = (5, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd37;
    end

    // (x,y) = (5, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd53;
    end

    // (x,y) = (5, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd69;
    end

    // (x,y) = (5, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd85;
    end

    // (x,y) = (5, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd101;
    end

    // (x,y) = (5, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd117;
    end

    // (x,y) = (5, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd133;
    end

    // (x,y) = (5, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd149;
    end

    // (x,y) = (5, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd165;
    end

    // (x,y) = (5, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd181;
    end

    // (x,y) = (5, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd197;
    end

    // (x,y) = (5, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd213;
    end

    // (x,y) = (5, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd229;
    end

    // (x,y) = (5, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd245;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd6:
begin
     case (y_coord)

    // (x,y) = (6, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd6;
    end

    // (x,y) = (6, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd22;
    end

    // (x,y) = (6, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd38;
    end

    // (x,y) = (6, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd54;
    end

    // (x,y) = (6, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd70;
    end

    // (x,y) = (6, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd86;
    end

    // (x,y) = (6, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd102;
    end

    // (x,y) = (6, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd118;
    end

    // (x,y) = (6, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd134;
    end

    // (x,y) = (6, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd150;
    end

    // (x,y) = (6, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd166;
    end

    // (x,y) = (6, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd182;
    end

    // (x,y) = (6, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd198;
    end

    // (x,y) = (6, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd214;
    end

    // (x,y) = (6, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd230;
    end

    // (x,y) = (6, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd246;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd7:
begin
     case (y_coord)

    // (x,y) = (7, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd7;
    end

    // (x,y) = (7, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd23;
    end

    // (x,y) = (7, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd39;
    end

    // (x,y) = (7, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd55;
    end

    // (x,y) = (7, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd71;
    end

    // (x,y) = (7, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd87;
    end

    // (x,y) = (7, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd103;
    end

    // (x,y) = (7, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd119;
    end

    // (x,y) = (7, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd135;
    end

    // (x,y) = (7, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd151;
    end

    // (x,y) = (7, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd167;
    end

    // (x,y) = (7, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd183;
    end

    // (x,y) = (7, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd199;
    end

    // (x,y) = (7, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd215;
    end

    // (x,y) = (7, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd231;
    end

    // (x,y) = (7, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd247;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd8:
begin
     case (y_coord)

    // (x,y) = (8, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd8;
    end

    // (x,y) = (8, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd24;
    end

    // (x,y) = (8, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd40;
    end

    // (x,y) = (8, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd56;
    end

    // (x,y) = (8, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd72;
    end

    // (x,y) = (8, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd88;
    end

    // (x,y) = (8, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd104;
    end

    // (x,y) = (8, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd120;
    end

    // (x,y) = (8, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd136;
    end

    // (x,y) = (8, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd152;
    end

    // (x,y) = (8, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd168;
    end

    // (x,y) = (8, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd184;
    end

    // (x,y) = (8, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd200;
    end

    // (x,y) = (8, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd216;
    end

    // (x,y) = (8, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd232;
    end

    // (x,y) = (8, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd248;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd9:
begin
     case (y_coord)

    // (x,y) = (9, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd9;
    end

    // (x,y) = (9, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd25;
    end

    // (x,y) = (9, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd41;
    end

    // (x,y) = (9, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd57;
    end

    // (x,y) = (9, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd73;
    end

    // (x,y) = (9, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd89;
    end

    // (x,y) = (9, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd105;
    end

    // (x,y) = (9, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd121;
    end

    // (x,y) = (9, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd137;
    end

    // (x,y) = (9, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd153;
    end

    // (x,y) = (9, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd169;
    end

    // (x,y) = (9, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd185;
    end

    // (x,y) = (9, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd201;
    end

    // (x,y) = (9, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd217;
    end

    // (x,y) = (9, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd233;
    end

    // (x,y) = (9, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd249;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd10:
begin
     case (y_coord)

    // (x,y) = (10, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd10;
    end

    // (x,y) = (10, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd26;
    end

    // (x,y) = (10, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd42;
    end

    // (x,y) = (10, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd58;
    end

    // (x,y) = (10, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd74;
    end

    // (x,y) = (10, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd90;
    end

    // (x,y) = (10, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd106;
    end

    // (x,y) = (10, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd122;
    end

    // (x,y) = (10, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd138;
    end

    // (x,y) = (10, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd154;
    end

    // (x,y) = (10, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd170;
    end

    // (x,y) = (10, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd186;
    end

    // (x,y) = (10, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd202;
    end

    // (x,y) = (10, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd218;
    end

    // (x,y) = (10, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd234;
    end

    // (x,y) = (10, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd250;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd11:
begin
     case (y_coord)

    // (x,y) = (11, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd11;
    end

    // (x,y) = (11, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd27;
    end

    // (x,y) = (11, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd43;
    end

    // (x,y) = (11, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd59;
    end

    // (x,y) = (11, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd75;
    end

    // (x,y) = (11, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd91;
    end

    // (x,y) = (11, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd107;
    end

    // (x,y) = (11, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd123;
    end

    // (x,y) = (11, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd139;
    end

    // (x,y) = (11, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd155;
    end

    // (x,y) = (11, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd171;
    end

    // (x,y) = (11, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd187;
    end

    // (x,y) = (11, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd203;
    end

    // (x,y) = (11, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd219;
    end

    // (x,y) = (11, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd235;
    end

    // (x,y) = (11, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd251;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd12:
begin
     case (y_coord)

    // (x,y) = (12, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd12;
    end

    // (x,y) = (12, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd28;
    end

    // (x,y) = (12, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd44;
    end

    // (x,y) = (12, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd60;
    end

    // (x,y) = (12, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd76;
    end

    // (x,y) = (12, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd92;
    end

    // (x,y) = (12, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd108;
    end

    // (x,y) = (12, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd124;
    end

    // (x,y) = (12, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd140;
    end

    // (x,y) = (12, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd156;
    end

    // (x,y) = (12, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd172;
    end

    // (x,y) = (12, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd188;
    end

    // (x,y) = (12, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd204;
    end

    // (x,y) = (12, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd220;
    end

    // (x,y) = (12, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd236;
    end

    // (x,y) = (12, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd252;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd13:
begin
     case (y_coord)

    // (x,y) = (13, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd13;
    end

    // (x,y) = (13, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd29;
    end

    // (x,y) = (13, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd45;
    end

    // (x,y) = (13, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd61;
    end

    // (x,y) = (13, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd77;
    end

    // (x,y) = (13, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd93;
    end

    // (x,y) = (13, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd109;
    end

    // (x,y) = (13, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd125;
    end

    // (x,y) = (13, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd141;
    end

    // (x,y) = (13, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd157;
    end

    // (x,y) = (13, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd173;
    end

    // (x,y) = (13, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd189;
    end

    // (x,y) = (13, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd205;
    end

    // (x,y) = (13, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd221;
    end

    // (x,y) = (13, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd237;
    end

    // (x,y) = (13, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd253;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd14:
begin
     case (y_coord)

    // (x,y) = (14, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd14;
    end

    // (x,y) = (14, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd30;
    end

    // (x,y) = (14, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd46;
    end

    // (x,y) = (14, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd62;
    end

    // (x,y) = (14, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd78;
    end

    // (x,y) = (14, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd94;
    end

    // (x,y) = (14, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd110;
    end

    // (x,y) = (14, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd126;
    end

    // (x,y) = (14, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd142;
    end

    // (x,y) = (14, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd158;
    end

    // (x,y) = (14, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd174;
    end

    // (x,y) = (14, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd190;
    end

    // (x,y) = (14, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd206;
    end

    // (x,y) = (14, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd222;
    end

    // (x,y) = (14, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd238;
    end

    // (x,y) = (14, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd254;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd15:
begin
     case (y_coord)

    // (x,y) = (15, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd15;
    end

    // (x,y) = (15, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd31;
    end

    // (x,y) = (15, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd47;
    end

    // (x,y) = (15, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd63;
    end

    // (x,y) = (15, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd79;
    end

    // (x,y) = (15, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd95;
    end

    // (x,y) = (15, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd111;
    end

    // (x,y) = (15, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd127;
    end

    // (x,y) = (15, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd143;
    end

    // (x,y) = (15, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd159;
    end

    // (x,y) = (15, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd175;
    end

    // (x,y) = (15, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd191;
    end

    // (x,y) = (15, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd207;
    end

    // (x,y) = (15, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd223;
    end

    // (x,y) = (15, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd239;
    end

    // (x,y) = (15, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd255;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

        default:
        begin
            flat_id = `HOME_ID_WIDTH'dX;
        end
        endcase
    end
endmodule

