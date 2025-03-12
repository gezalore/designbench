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
        flat_id = `HOME_ID_WIDTH'd32;
    end

    // (x,y) = (0, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd64;
    end

    // (x,y) = (0, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd96;
    end

    // (x,y) = (0, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd128;
    end

    // (x,y) = (0, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd160;
    end

    // (x,y) = (0, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd192;
    end

    // (x,y) = (0, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd224;
    end

    // (x,y) = (0, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd256;
    end

    // (x,y) = (0, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd288;
    end

    // (x,y) = (0, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd320;
    end

    // (x,y) = (0, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd352;
    end

    // (x,y) = (0, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd384;
    end

    // (x,y) = (0, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd416;
    end

    // (x,y) = (0, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd448;
    end

    // (x,y) = (0, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd480;
    end

    // (x,y) = (0, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd512;
    end

    // (x,y) = (0, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd544;
    end

    // (x,y) = (0, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd576;
    end

    // (x,y) = (0, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd608;
    end

    // (x,y) = (0, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd640;
    end

    // (x,y) = (0, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd672;
    end

    // (x,y) = (0, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd704;
    end

    // (x,y) = (0, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd736;
    end

    // (x,y) = (0, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd768;
    end

    // (x,y) = (0, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd800;
    end

    // (x,y) = (0, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd832;
    end

    // (x,y) = (0, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd864;
    end

    // (x,y) = (0, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd896;
    end

    // (x,y) = (0, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd928;
    end

    // (x,y) = (0, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd960;
    end

    // (x,y) = (0, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd992;
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
        flat_id = `HOME_ID_WIDTH'd33;
    end

    // (x,y) = (1, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd65;
    end

    // (x,y) = (1, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd97;
    end

    // (x,y) = (1, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd129;
    end

    // (x,y) = (1, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd161;
    end

    // (x,y) = (1, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd193;
    end

    // (x,y) = (1, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd225;
    end

    // (x,y) = (1, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd257;
    end

    // (x,y) = (1, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd289;
    end

    // (x,y) = (1, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd321;
    end

    // (x,y) = (1, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd353;
    end

    // (x,y) = (1, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd385;
    end

    // (x,y) = (1, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd417;
    end

    // (x,y) = (1, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd449;
    end

    // (x,y) = (1, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd481;
    end

    // (x,y) = (1, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd513;
    end

    // (x,y) = (1, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd545;
    end

    // (x,y) = (1, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd577;
    end

    // (x,y) = (1, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd609;
    end

    // (x,y) = (1, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd641;
    end

    // (x,y) = (1, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd673;
    end

    // (x,y) = (1, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd705;
    end

    // (x,y) = (1, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd737;
    end

    // (x,y) = (1, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd769;
    end

    // (x,y) = (1, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd801;
    end

    // (x,y) = (1, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd833;
    end

    // (x,y) = (1, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd865;
    end

    // (x,y) = (1, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd897;
    end

    // (x,y) = (1, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd929;
    end

    // (x,y) = (1, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd961;
    end

    // (x,y) = (1, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd993;
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
        flat_id = `HOME_ID_WIDTH'd34;
    end

    // (x,y) = (2, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd66;
    end

    // (x,y) = (2, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd98;
    end

    // (x,y) = (2, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd130;
    end

    // (x,y) = (2, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd162;
    end

    // (x,y) = (2, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd194;
    end

    // (x,y) = (2, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd226;
    end

    // (x,y) = (2, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd258;
    end

    // (x,y) = (2, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd290;
    end

    // (x,y) = (2, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd322;
    end

    // (x,y) = (2, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd354;
    end

    // (x,y) = (2, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd386;
    end

    // (x,y) = (2, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd418;
    end

    // (x,y) = (2, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd450;
    end

    // (x,y) = (2, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd482;
    end

    // (x,y) = (2, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd514;
    end

    // (x,y) = (2, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd546;
    end

    // (x,y) = (2, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd578;
    end

    // (x,y) = (2, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd610;
    end

    // (x,y) = (2, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd642;
    end

    // (x,y) = (2, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd674;
    end

    // (x,y) = (2, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd706;
    end

    // (x,y) = (2, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd738;
    end

    // (x,y) = (2, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd770;
    end

    // (x,y) = (2, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd802;
    end

    // (x,y) = (2, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd834;
    end

    // (x,y) = (2, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd866;
    end

    // (x,y) = (2, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd898;
    end

    // (x,y) = (2, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd930;
    end

    // (x,y) = (2, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd962;
    end

    // (x,y) = (2, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd994;
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
        flat_id = `HOME_ID_WIDTH'd35;
    end

    // (x,y) = (3, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd67;
    end

    // (x,y) = (3, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd99;
    end

    // (x,y) = (3, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd131;
    end

    // (x,y) = (3, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd163;
    end

    // (x,y) = (3, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd195;
    end

    // (x,y) = (3, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd227;
    end

    // (x,y) = (3, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd259;
    end

    // (x,y) = (3, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd291;
    end

    // (x,y) = (3, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd323;
    end

    // (x,y) = (3, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd355;
    end

    // (x,y) = (3, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd387;
    end

    // (x,y) = (3, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd419;
    end

    // (x,y) = (3, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd451;
    end

    // (x,y) = (3, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd483;
    end

    // (x,y) = (3, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd515;
    end

    // (x,y) = (3, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd547;
    end

    // (x,y) = (3, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd579;
    end

    // (x,y) = (3, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd611;
    end

    // (x,y) = (3, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd643;
    end

    // (x,y) = (3, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd675;
    end

    // (x,y) = (3, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd707;
    end

    // (x,y) = (3, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd739;
    end

    // (x,y) = (3, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd771;
    end

    // (x,y) = (3, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd803;
    end

    // (x,y) = (3, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd835;
    end

    // (x,y) = (3, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd867;
    end

    // (x,y) = (3, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd899;
    end

    // (x,y) = (3, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd931;
    end

    // (x,y) = (3, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd963;
    end

    // (x,y) = (3, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd995;
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
        flat_id = `HOME_ID_WIDTH'd36;
    end

    // (x,y) = (4, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd68;
    end

    // (x,y) = (4, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd100;
    end

    // (x,y) = (4, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd132;
    end

    // (x,y) = (4, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd164;
    end

    // (x,y) = (4, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd196;
    end

    // (x,y) = (4, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd228;
    end

    // (x,y) = (4, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd260;
    end

    // (x,y) = (4, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd292;
    end

    // (x,y) = (4, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd324;
    end

    // (x,y) = (4, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd356;
    end

    // (x,y) = (4, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd388;
    end

    // (x,y) = (4, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd420;
    end

    // (x,y) = (4, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd452;
    end

    // (x,y) = (4, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd484;
    end

    // (x,y) = (4, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd516;
    end

    // (x,y) = (4, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd548;
    end

    // (x,y) = (4, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd580;
    end

    // (x,y) = (4, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd612;
    end

    // (x,y) = (4, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd644;
    end

    // (x,y) = (4, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd676;
    end

    // (x,y) = (4, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd708;
    end

    // (x,y) = (4, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd740;
    end

    // (x,y) = (4, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd772;
    end

    // (x,y) = (4, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd804;
    end

    // (x,y) = (4, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd836;
    end

    // (x,y) = (4, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd868;
    end

    // (x,y) = (4, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd900;
    end

    // (x,y) = (4, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd932;
    end

    // (x,y) = (4, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd964;
    end

    // (x,y) = (4, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd996;
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
        flat_id = `HOME_ID_WIDTH'd37;
    end

    // (x,y) = (5, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd69;
    end

    // (x,y) = (5, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd101;
    end

    // (x,y) = (5, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd133;
    end

    // (x,y) = (5, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd165;
    end

    // (x,y) = (5, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd197;
    end

    // (x,y) = (5, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd229;
    end

    // (x,y) = (5, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd261;
    end

    // (x,y) = (5, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd293;
    end

    // (x,y) = (5, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd325;
    end

    // (x,y) = (5, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd357;
    end

    // (x,y) = (5, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd389;
    end

    // (x,y) = (5, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd421;
    end

    // (x,y) = (5, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd453;
    end

    // (x,y) = (5, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd485;
    end

    // (x,y) = (5, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd517;
    end

    // (x,y) = (5, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd549;
    end

    // (x,y) = (5, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd581;
    end

    // (x,y) = (5, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd613;
    end

    // (x,y) = (5, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd645;
    end

    // (x,y) = (5, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd677;
    end

    // (x,y) = (5, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd709;
    end

    // (x,y) = (5, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd741;
    end

    // (x,y) = (5, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd773;
    end

    // (x,y) = (5, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd805;
    end

    // (x,y) = (5, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd837;
    end

    // (x,y) = (5, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd869;
    end

    // (x,y) = (5, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd901;
    end

    // (x,y) = (5, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd933;
    end

    // (x,y) = (5, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd965;
    end

    // (x,y) = (5, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd997;
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
        flat_id = `HOME_ID_WIDTH'd38;
    end

    // (x,y) = (6, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd70;
    end

    // (x,y) = (6, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd102;
    end

    // (x,y) = (6, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd134;
    end

    // (x,y) = (6, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd166;
    end

    // (x,y) = (6, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd198;
    end

    // (x,y) = (6, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd230;
    end

    // (x,y) = (6, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd262;
    end

    // (x,y) = (6, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd294;
    end

    // (x,y) = (6, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd326;
    end

    // (x,y) = (6, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd358;
    end

    // (x,y) = (6, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd390;
    end

    // (x,y) = (6, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd422;
    end

    // (x,y) = (6, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd454;
    end

    // (x,y) = (6, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd486;
    end

    // (x,y) = (6, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd518;
    end

    // (x,y) = (6, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd550;
    end

    // (x,y) = (6, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd582;
    end

    // (x,y) = (6, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd614;
    end

    // (x,y) = (6, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd646;
    end

    // (x,y) = (6, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd678;
    end

    // (x,y) = (6, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd710;
    end

    // (x,y) = (6, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd742;
    end

    // (x,y) = (6, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd774;
    end

    // (x,y) = (6, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd806;
    end

    // (x,y) = (6, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd838;
    end

    // (x,y) = (6, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd870;
    end

    // (x,y) = (6, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd902;
    end

    // (x,y) = (6, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd934;
    end

    // (x,y) = (6, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd966;
    end

    // (x,y) = (6, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd998;
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
        flat_id = `HOME_ID_WIDTH'd39;
    end

    // (x,y) = (7, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd71;
    end

    // (x,y) = (7, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd103;
    end

    // (x,y) = (7, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd135;
    end

    // (x,y) = (7, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd167;
    end

    // (x,y) = (7, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd199;
    end

    // (x,y) = (7, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd231;
    end

    // (x,y) = (7, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd263;
    end

    // (x,y) = (7, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd295;
    end

    // (x,y) = (7, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd327;
    end

    // (x,y) = (7, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd359;
    end

    // (x,y) = (7, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd391;
    end

    // (x,y) = (7, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd423;
    end

    // (x,y) = (7, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd455;
    end

    // (x,y) = (7, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd487;
    end

    // (x,y) = (7, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd519;
    end

    // (x,y) = (7, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd551;
    end

    // (x,y) = (7, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd583;
    end

    // (x,y) = (7, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd615;
    end

    // (x,y) = (7, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd647;
    end

    // (x,y) = (7, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd679;
    end

    // (x,y) = (7, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd711;
    end

    // (x,y) = (7, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd743;
    end

    // (x,y) = (7, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd775;
    end

    // (x,y) = (7, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd807;
    end

    // (x,y) = (7, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd839;
    end

    // (x,y) = (7, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd871;
    end

    // (x,y) = (7, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd903;
    end

    // (x,y) = (7, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd935;
    end

    // (x,y) = (7, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd967;
    end

    // (x,y) = (7, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd999;
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
        flat_id = `HOME_ID_WIDTH'd40;
    end

    // (x,y) = (8, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd72;
    end

    // (x,y) = (8, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd104;
    end

    // (x,y) = (8, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd136;
    end

    // (x,y) = (8, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd168;
    end

    // (x,y) = (8, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd200;
    end

    // (x,y) = (8, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd232;
    end

    // (x,y) = (8, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd264;
    end

    // (x,y) = (8, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd296;
    end

    // (x,y) = (8, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd328;
    end

    // (x,y) = (8, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd360;
    end

    // (x,y) = (8, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd392;
    end

    // (x,y) = (8, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd424;
    end

    // (x,y) = (8, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd456;
    end

    // (x,y) = (8, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd488;
    end

    // (x,y) = (8, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd520;
    end

    // (x,y) = (8, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd552;
    end

    // (x,y) = (8, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd584;
    end

    // (x,y) = (8, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd616;
    end

    // (x,y) = (8, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd648;
    end

    // (x,y) = (8, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd680;
    end

    // (x,y) = (8, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd712;
    end

    // (x,y) = (8, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd744;
    end

    // (x,y) = (8, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd776;
    end

    // (x,y) = (8, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd808;
    end

    // (x,y) = (8, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd840;
    end

    // (x,y) = (8, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd872;
    end

    // (x,y) = (8, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd904;
    end

    // (x,y) = (8, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd936;
    end

    // (x,y) = (8, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd968;
    end

    // (x,y) = (8, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1000;
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
        flat_id = `HOME_ID_WIDTH'd41;
    end

    // (x,y) = (9, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd73;
    end

    // (x,y) = (9, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd105;
    end

    // (x,y) = (9, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd137;
    end

    // (x,y) = (9, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd169;
    end

    // (x,y) = (9, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd201;
    end

    // (x,y) = (9, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd233;
    end

    // (x,y) = (9, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd265;
    end

    // (x,y) = (9, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd297;
    end

    // (x,y) = (9, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd329;
    end

    // (x,y) = (9, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd361;
    end

    // (x,y) = (9, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd393;
    end

    // (x,y) = (9, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd425;
    end

    // (x,y) = (9, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd457;
    end

    // (x,y) = (9, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd489;
    end

    // (x,y) = (9, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd521;
    end

    // (x,y) = (9, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd553;
    end

    // (x,y) = (9, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd585;
    end

    // (x,y) = (9, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd617;
    end

    // (x,y) = (9, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd649;
    end

    // (x,y) = (9, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd681;
    end

    // (x,y) = (9, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd713;
    end

    // (x,y) = (9, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd745;
    end

    // (x,y) = (9, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd777;
    end

    // (x,y) = (9, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd809;
    end

    // (x,y) = (9, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd841;
    end

    // (x,y) = (9, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd873;
    end

    // (x,y) = (9, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd905;
    end

    // (x,y) = (9, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd937;
    end

    // (x,y) = (9, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd969;
    end

    // (x,y) = (9, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1001;
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
        flat_id = `HOME_ID_WIDTH'd42;
    end

    // (x,y) = (10, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd74;
    end

    // (x,y) = (10, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd106;
    end

    // (x,y) = (10, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd138;
    end

    // (x,y) = (10, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd170;
    end

    // (x,y) = (10, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd202;
    end

    // (x,y) = (10, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd234;
    end

    // (x,y) = (10, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd266;
    end

    // (x,y) = (10, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd298;
    end

    // (x,y) = (10, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd330;
    end

    // (x,y) = (10, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd362;
    end

    // (x,y) = (10, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd394;
    end

    // (x,y) = (10, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd426;
    end

    // (x,y) = (10, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd458;
    end

    // (x,y) = (10, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd490;
    end

    // (x,y) = (10, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd522;
    end

    // (x,y) = (10, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd554;
    end

    // (x,y) = (10, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd586;
    end

    // (x,y) = (10, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd618;
    end

    // (x,y) = (10, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd650;
    end

    // (x,y) = (10, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd682;
    end

    // (x,y) = (10, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd714;
    end

    // (x,y) = (10, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd746;
    end

    // (x,y) = (10, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd778;
    end

    // (x,y) = (10, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd810;
    end

    // (x,y) = (10, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd842;
    end

    // (x,y) = (10, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd874;
    end

    // (x,y) = (10, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd906;
    end

    // (x,y) = (10, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd938;
    end

    // (x,y) = (10, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd970;
    end

    // (x,y) = (10, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1002;
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
        flat_id = `HOME_ID_WIDTH'd43;
    end

    // (x,y) = (11, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd75;
    end

    // (x,y) = (11, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd107;
    end

    // (x,y) = (11, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd139;
    end

    // (x,y) = (11, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd171;
    end

    // (x,y) = (11, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd203;
    end

    // (x,y) = (11, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd235;
    end

    // (x,y) = (11, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd267;
    end

    // (x,y) = (11, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd299;
    end

    // (x,y) = (11, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd331;
    end

    // (x,y) = (11, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd363;
    end

    // (x,y) = (11, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd395;
    end

    // (x,y) = (11, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd427;
    end

    // (x,y) = (11, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd459;
    end

    // (x,y) = (11, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd491;
    end

    // (x,y) = (11, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd523;
    end

    // (x,y) = (11, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd555;
    end

    // (x,y) = (11, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd587;
    end

    // (x,y) = (11, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd619;
    end

    // (x,y) = (11, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd651;
    end

    // (x,y) = (11, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd683;
    end

    // (x,y) = (11, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd715;
    end

    // (x,y) = (11, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd747;
    end

    // (x,y) = (11, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd779;
    end

    // (x,y) = (11, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd811;
    end

    // (x,y) = (11, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd843;
    end

    // (x,y) = (11, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd875;
    end

    // (x,y) = (11, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd907;
    end

    // (x,y) = (11, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd939;
    end

    // (x,y) = (11, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd971;
    end

    // (x,y) = (11, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1003;
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
        flat_id = `HOME_ID_WIDTH'd44;
    end

    // (x,y) = (12, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd76;
    end

    // (x,y) = (12, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd108;
    end

    // (x,y) = (12, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd140;
    end

    // (x,y) = (12, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd172;
    end

    // (x,y) = (12, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd204;
    end

    // (x,y) = (12, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd236;
    end

    // (x,y) = (12, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd268;
    end

    // (x,y) = (12, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd300;
    end

    // (x,y) = (12, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd332;
    end

    // (x,y) = (12, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd364;
    end

    // (x,y) = (12, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd396;
    end

    // (x,y) = (12, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd428;
    end

    // (x,y) = (12, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd460;
    end

    // (x,y) = (12, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd492;
    end

    // (x,y) = (12, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd524;
    end

    // (x,y) = (12, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd556;
    end

    // (x,y) = (12, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd588;
    end

    // (x,y) = (12, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd620;
    end

    // (x,y) = (12, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd652;
    end

    // (x,y) = (12, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd684;
    end

    // (x,y) = (12, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd716;
    end

    // (x,y) = (12, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd748;
    end

    // (x,y) = (12, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd780;
    end

    // (x,y) = (12, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd812;
    end

    // (x,y) = (12, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd844;
    end

    // (x,y) = (12, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd876;
    end

    // (x,y) = (12, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd908;
    end

    // (x,y) = (12, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd940;
    end

    // (x,y) = (12, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd972;
    end

    // (x,y) = (12, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1004;
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
        flat_id = `HOME_ID_WIDTH'd45;
    end

    // (x,y) = (13, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd77;
    end

    // (x,y) = (13, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd109;
    end

    // (x,y) = (13, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd141;
    end

    // (x,y) = (13, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd173;
    end

    // (x,y) = (13, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd205;
    end

    // (x,y) = (13, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd237;
    end

    // (x,y) = (13, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd269;
    end

    // (x,y) = (13, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd301;
    end

    // (x,y) = (13, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd333;
    end

    // (x,y) = (13, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd365;
    end

    // (x,y) = (13, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd397;
    end

    // (x,y) = (13, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd429;
    end

    // (x,y) = (13, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd461;
    end

    // (x,y) = (13, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd493;
    end

    // (x,y) = (13, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd525;
    end

    // (x,y) = (13, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd557;
    end

    // (x,y) = (13, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd589;
    end

    // (x,y) = (13, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd621;
    end

    // (x,y) = (13, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd653;
    end

    // (x,y) = (13, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd685;
    end

    // (x,y) = (13, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd717;
    end

    // (x,y) = (13, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd749;
    end

    // (x,y) = (13, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd781;
    end

    // (x,y) = (13, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd813;
    end

    // (x,y) = (13, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd845;
    end

    // (x,y) = (13, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd877;
    end

    // (x,y) = (13, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd909;
    end

    // (x,y) = (13, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd941;
    end

    // (x,y) = (13, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd973;
    end

    // (x,y) = (13, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1005;
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
        flat_id = `HOME_ID_WIDTH'd46;
    end

    // (x,y) = (14, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd78;
    end

    // (x,y) = (14, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd110;
    end

    // (x,y) = (14, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd142;
    end

    // (x,y) = (14, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd174;
    end

    // (x,y) = (14, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd206;
    end

    // (x,y) = (14, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd238;
    end

    // (x,y) = (14, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd270;
    end

    // (x,y) = (14, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd302;
    end

    // (x,y) = (14, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd334;
    end

    // (x,y) = (14, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd366;
    end

    // (x,y) = (14, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd398;
    end

    // (x,y) = (14, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd430;
    end

    // (x,y) = (14, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd462;
    end

    // (x,y) = (14, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd494;
    end

    // (x,y) = (14, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd526;
    end

    // (x,y) = (14, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd558;
    end

    // (x,y) = (14, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd590;
    end

    // (x,y) = (14, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd622;
    end

    // (x,y) = (14, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd654;
    end

    // (x,y) = (14, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd686;
    end

    // (x,y) = (14, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd718;
    end

    // (x,y) = (14, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd750;
    end

    // (x,y) = (14, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd782;
    end

    // (x,y) = (14, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd814;
    end

    // (x,y) = (14, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd846;
    end

    // (x,y) = (14, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd878;
    end

    // (x,y) = (14, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd910;
    end

    // (x,y) = (14, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd942;
    end

    // (x,y) = (14, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd974;
    end

    // (x,y) = (14, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1006;
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
        flat_id = `HOME_ID_WIDTH'd47;
    end

    // (x,y) = (15, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd79;
    end

    // (x,y) = (15, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd111;
    end

    // (x,y) = (15, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd143;
    end

    // (x,y) = (15, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd175;
    end

    // (x,y) = (15, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd207;
    end

    // (x,y) = (15, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd239;
    end

    // (x,y) = (15, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd271;
    end

    // (x,y) = (15, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd303;
    end

    // (x,y) = (15, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd335;
    end

    // (x,y) = (15, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd367;
    end

    // (x,y) = (15, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd399;
    end

    // (x,y) = (15, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd431;
    end

    // (x,y) = (15, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd463;
    end

    // (x,y) = (15, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd495;
    end

    // (x,y) = (15, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd527;
    end

    // (x,y) = (15, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd559;
    end

    // (x,y) = (15, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd591;
    end

    // (x,y) = (15, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd623;
    end

    // (x,y) = (15, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd655;
    end

    // (x,y) = (15, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd687;
    end

    // (x,y) = (15, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd719;
    end

    // (x,y) = (15, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd751;
    end

    // (x,y) = (15, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd783;
    end

    // (x,y) = (15, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd815;
    end

    // (x,y) = (15, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd847;
    end

    // (x,y) = (15, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd879;
    end

    // (x,y) = (15, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd911;
    end

    // (x,y) = (15, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd943;
    end

    // (x,y) = (15, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd975;
    end

    // (x,y) = (15, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1007;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd16:
begin
     case (y_coord)

    // (x,y) = (16, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd16;
    end

    // (x,y) = (16, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd48;
    end

    // (x,y) = (16, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd80;
    end

    // (x,y) = (16, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd112;
    end

    // (x,y) = (16, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd144;
    end

    // (x,y) = (16, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd176;
    end

    // (x,y) = (16, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd208;
    end

    // (x,y) = (16, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd240;
    end

    // (x,y) = (16, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd272;
    end

    // (x,y) = (16, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd304;
    end

    // (x,y) = (16, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd336;
    end

    // (x,y) = (16, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd368;
    end

    // (x,y) = (16, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd400;
    end

    // (x,y) = (16, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd432;
    end

    // (x,y) = (16, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd464;
    end

    // (x,y) = (16, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd496;
    end

    // (x,y) = (16, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd528;
    end

    // (x,y) = (16, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd560;
    end

    // (x,y) = (16, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd592;
    end

    // (x,y) = (16, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd624;
    end

    // (x,y) = (16, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd656;
    end

    // (x,y) = (16, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd688;
    end

    // (x,y) = (16, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd720;
    end

    // (x,y) = (16, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd752;
    end

    // (x,y) = (16, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd784;
    end

    // (x,y) = (16, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd816;
    end

    // (x,y) = (16, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd848;
    end

    // (x,y) = (16, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd880;
    end

    // (x,y) = (16, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd912;
    end

    // (x,y) = (16, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd944;
    end

    // (x,y) = (16, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd976;
    end

    // (x,y) = (16, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1008;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd17:
begin
     case (y_coord)

    // (x,y) = (17, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd17;
    end

    // (x,y) = (17, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd49;
    end

    // (x,y) = (17, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd81;
    end

    // (x,y) = (17, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd113;
    end

    // (x,y) = (17, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd145;
    end

    // (x,y) = (17, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd177;
    end

    // (x,y) = (17, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd209;
    end

    // (x,y) = (17, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd241;
    end

    // (x,y) = (17, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd273;
    end

    // (x,y) = (17, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd305;
    end

    // (x,y) = (17, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd337;
    end

    // (x,y) = (17, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd369;
    end

    // (x,y) = (17, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd401;
    end

    // (x,y) = (17, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd433;
    end

    // (x,y) = (17, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd465;
    end

    // (x,y) = (17, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd497;
    end

    // (x,y) = (17, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd529;
    end

    // (x,y) = (17, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd561;
    end

    // (x,y) = (17, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd593;
    end

    // (x,y) = (17, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd625;
    end

    // (x,y) = (17, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd657;
    end

    // (x,y) = (17, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd689;
    end

    // (x,y) = (17, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd721;
    end

    // (x,y) = (17, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd753;
    end

    // (x,y) = (17, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd785;
    end

    // (x,y) = (17, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd817;
    end

    // (x,y) = (17, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd849;
    end

    // (x,y) = (17, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd881;
    end

    // (x,y) = (17, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd913;
    end

    // (x,y) = (17, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd945;
    end

    // (x,y) = (17, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd977;
    end

    // (x,y) = (17, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1009;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd18:
begin
     case (y_coord)

    // (x,y) = (18, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd18;
    end

    // (x,y) = (18, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd50;
    end

    // (x,y) = (18, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd82;
    end

    // (x,y) = (18, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd114;
    end

    // (x,y) = (18, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd146;
    end

    // (x,y) = (18, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd178;
    end

    // (x,y) = (18, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd210;
    end

    // (x,y) = (18, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd242;
    end

    // (x,y) = (18, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd274;
    end

    // (x,y) = (18, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd306;
    end

    // (x,y) = (18, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd338;
    end

    // (x,y) = (18, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd370;
    end

    // (x,y) = (18, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd402;
    end

    // (x,y) = (18, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd434;
    end

    // (x,y) = (18, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd466;
    end

    // (x,y) = (18, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd498;
    end

    // (x,y) = (18, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd530;
    end

    // (x,y) = (18, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd562;
    end

    // (x,y) = (18, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd594;
    end

    // (x,y) = (18, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd626;
    end

    // (x,y) = (18, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd658;
    end

    // (x,y) = (18, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd690;
    end

    // (x,y) = (18, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd722;
    end

    // (x,y) = (18, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd754;
    end

    // (x,y) = (18, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd786;
    end

    // (x,y) = (18, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd818;
    end

    // (x,y) = (18, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd850;
    end

    // (x,y) = (18, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd882;
    end

    // (x,y) = (18, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd914;
    end

    // (x,y) = (18, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd946;
    end

    // (x,y) = (18, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd978;
    end

    // (x,y) = (18, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1010;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd19:
begin
     case (y_coord)

    // (x,y) = (19, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd19;
    end

    // (x,y) = (19, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd51;
    end

    // (x,y) = (19, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd83;
    end

    // (x,y) = (19, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd115;
    end

    // (x,y) = (19, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd147;
    end

    // (x,y) = (19, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd179;
    end

    // (x,y) = (19, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd211;
    end

    // (x,y) = (19, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd243;
    end

    // (x,y) = (19, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd275;
    end

    // (x,y) = (19, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd307;
    end

    // (x,y) = (19, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd339;
    end

    // (x,y) = (19, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd371;
    end

    // (x,y) = (19, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd403;
    end

    // (x,y) = (19, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd435;
    end

    // (x,y) = (19, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd467;
    end

    // (x,y) = (19, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd499;
    end

    // (x,y) = (19, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd531;
    end

    // (x,y) = (19, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd563;
    end

    // (x,y) = (19, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd595;
    end

    // (x,y) = (19, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd627;
    end

    // (x,y) = (19, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd659;
    end

    // (x,y) = (19, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd691;
    end

    // (x,y) = (19, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd723;
    end

    // (x,y) = (19, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd755;
    end

    // (x,y) = (19, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd787;
    end

    // (x,y) = (19, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd819;
    end

    // (x,y) = (19, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd851;
    end

    // (x,y) = (19, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd883;
    end

    // (x,y) = (19, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd915;
    end

    // (x,y) = (19, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd947;
    end

    // (x,y) = (19, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd979;
    end

    // (x,y) = (19, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1011;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd20:
begin
     case (y_coord)

    // (x,y) = (20, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd20;
    end

    // (x,y) = (20, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd52;
    end

    // (x,y) = (20, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd84;
    end

    // (x,y) = (20, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd116;
    end

    // (x,y) = (20, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd148;
    end

    // (x,y) = (20, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd180;
    end

    // (x,y) = (20, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd212;
    end

    // (x,y) = (20, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd244;
    end

    // (x,y) = (20, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd276;
    end

    // (x,y) = (20, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd308;
    end

    // (x,y) = (20, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd340;
    end

    // (x,y) = (20, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd372;
    end

    // (x,y) = (20, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd404;
    end

    // (x,y) = (20, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd436;
    end

    // (x,y) = (20, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd468;
    end

    // (x,y) = (20, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd500;
    end

    // (x,y) = (20, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd532;
    end

    // (x,y) = (20, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd564;
    end

    // (x,y) = (20, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd596;
    end

    // (x,y) = (20, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd628;
    end

    // (x,y) = (20, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd660;
    end

    // (x,y) = (20, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd692;
    end

    // (x,y) = (20, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd724;
    end

    // (x,y) = (20, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd756;
    end

    // (x,y) = (20, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd788;
    end

    // (x,y) = (20, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd820;
    end

    // (x,y) = (20, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd852;
    end

    // (x,y) = (20, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd884;
    end

    // (x,y) = (20, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd916;
    end

    // (x,y) = (20, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd948;
    end

    // (x,y) = (20, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd980;
    end

    // (x,y) = (20, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1012;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd21:
begin
     case (y_coord)

    // (x,y) = (21, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd21;
    end

    // (x,y) = (21, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd53;
    end

    // (x,y) = (21, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd85;
    end

    // (x,y) = (21, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd117;
    end

    // (x,y) = (21, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd149;
    end

    // (x,y) = (21, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd181;
    end

    // (x,y) = (21, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd213;
    end

    // (x,y) = (21, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd245;
    end

    // (x,y) = (21, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd277;
    end

    // (x,y) = (21, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd309;
    end

    // (x,y) = (21, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd341;
    end

    // (x,y) = (21, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd373;
    end

    // (x,y) = (21, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd405;
    end

    // (x,y) = (21, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd437;
    end

    // (x,y) = (21, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd469;
    end

    // (x,y) = (21, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd501;
    end

    // (x,y) = (21, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd533;
    end

    // (x,y) = (21, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd565;
    end

    // (x,y) = (21, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd597;
    end

    // (x,y) = (21, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd629;
    end

    // (x,y) = (21, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd661;
    end

    // (x,y) = (21, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd693;
    end

    // (x,y) = (21, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd725;
    end

    // (x,y) = (21, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd757;
    end

    // (x,y) = (21, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd789;
    end

    // (x,y) = (21, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd821;
    end

    // (x,y) = (21, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd853;
    end

    // (x,y) = (21, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd885;
    end

    // (x,y) = (21, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd917;
    end

    // (x,y) = (21, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd949;
    end

    // (x,y) = (21, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd981;
    end

    // (x,y) = (21, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1013;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd22:
begin
     case (y_coord)

    // (x,y) = (22, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd22;
    end

    // (x,y) = (22, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd54;
    end

    // (x,y) = (22, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd86;
    end

    // (x,y) = (22, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd118;
    end

    // (x,y) = (22, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd150;
    end

    // (x,y) = (22, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd182;
    end

    // (x,y) = (22, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd214;
    end

    // (x,y) = (22, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd246;
    end

    // (x,y) = (22, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd278;
    end

    // (x,y) = (22, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd310;
    end

    // (x,y) = (22, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd342;
    end

    // (x,y) = (22, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd374;
    end

    // (x,y) = (22, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd406;
    end

    // (x,y) = (22, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd438;
    end

    // (x,y) = (22, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd470;
    end

    // (x,y) = (22, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd502;
    end

    // (x,y) = (22, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd534;
    end

    // (x,y) = (22, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd566;
    end

    // (x,y) = (22, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd598;
    end

    // (x,y) = (22, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd630;
    end

    // (x,y) = (22, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd662;
    end

    // (x,y) = (22, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd694;
    end

    // (x,y) = (22, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd726;
    end

    // (x,y) = (22, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd758;
    end

    // (x,y) = (22, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd790;
    end

    // (x,y) = (22, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd822;
    end

    // (x,y) = (22, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd854;
    end

    // (x,y) = (22, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd886;
    end

    // (x,y) = (22, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd918;
    end

    // (x,y) = (22, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd950;
    end

    // (x,y) = (22, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd982;
    end

    // (x,y) = (22, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1014;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd23:
begin
     case (y_coord)

    // (x,y) = (23, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd23;
    end

    // (x,y) = (23, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd55;
    end

    // (x,y) = (23, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd87;
    end

    // (x,y) = (23, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd119;
    end

    // (x,y) = (23, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd151;
    end

    // (x,y) = (23, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd183;
    end

    // (x,y) = (23, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd215;
    end

    // (x,y) = (23, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd247;
    end

    // (x,y) = (23, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd279;
    end

    // (x,y) = (23, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd311;
    end

    // (x,y) = (23, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd343;
    end

    // (x,y) = (23, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd375;
    end

    // (x,y) = (23, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd407;
    end

    // (x,y) = (23, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd439;
    end

    // (x,y) = (23, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd471;
    end

    // (x,y) = (23, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd503;
    end

    // (x,y) = (23, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd535;
    end

    // (x,y) = (23, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd567;
    end

    // (x,y) = (23, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd599;
    end

    // (x,y) = (23, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd631;
    end

    // (x,y) = (23, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd663;
    end

    // (x,y) = (23, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd695;
    end

    // (x,y) = (23, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd727;
    end

    // (x,y) = (23, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd759;
    end

    // (x,y) = (23, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd791;
    end

    // (x,y) = (23, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd823;
    end

    // (x,y) = (23, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd855;
    end

    // (x,y) = (23, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd887;
    end

    // (x,y) = (23, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd919;
    end

    // (x,y) = (23, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd951;
    end

    // (x,y) = (23, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd983;
    end

    // (x,y) = (23, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1015;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd24:
begin
     case (y_coord)

    // (x,y) = (24, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd24;
    end

    // (x,y) = (24, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd56;
    end

    // (x,y) = (24, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd88;
    end

    // (x,y) = (24, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd120;
    end

    // (x,y) = (24, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd152;
    end

    // (x,y) = (24, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd184;
    end

    // (x,y) = (24, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd216;
    end

    // (x,y) = (24, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd248;
    end

    // (x,y) = (24, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd280;
    end

    // (x,y) = (24, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd312;
    end

    // (x,y) = (24, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd344;
    end

    // (x,y) = (24, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd376;
    end

    // (x,y) = (24, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd408;
    end

    // (x,y) = (24, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd440;
    end

    // (x,y) = (24, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd472;
    end

    // (x,y) = (24, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd504;
    end

    // (x,y) = (24, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd536;
    end

    // (x,y) = (24, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd568;
    end

    // (x,y) = (24, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd600;
    end

    // (x,y) = (24, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd632;
    end

    // (x,y) = (24, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd664;
    end

    // (x,y) = (24, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd696;
    end

    // (x,y) = (24, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd728;
    end

    // (x,y) = (24, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd760;
    end

    // (x,y) = (24, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd792;
    end

    // (x,y) = (24, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd824;
    end

    // (x,y) = (24, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd856;
    end

    // (x,y) = (24, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd888;
    end

    // (x,y) = (24, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd920;
    end

    // (x,y) = (24, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd952;
    end

    // (x,y) = (24, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd984;
    end

    // (x,y) = (24, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1016;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd25:
begin
     case (y_coord)

    // (x,y) = (25, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd25;
    end

    // (x,y) = (25, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd57;
    end

    // (x,y) = (25, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd89;
    end

    // (x,y) = (25, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd121;
    end

    // (x,y) = (25, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd153;
    end

    // (x,y) = (25, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd185;
    end

    // (x,y) = (25, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd217;
    end

    // (x,y) = (25, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd249;
    end

    // (x,y) = (25, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd281;
    end

    // (x,y) = (25, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd313;
    end

    // (x,y) = (25, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd345;
    end

    // (x,y) = (25, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd377;
    end

    // (x,y) = (25, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd409;
    end

    // (x,y) = (25, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd441;
    end

    // (x,y) = (25, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd473;
    end

    // (x,y) = (25, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd505;
    end

    // (x,y) = (25, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd537;
    end

    // (x,y) = (25, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd569;
    end

    // (x,y) = (25, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd601;
    end

    // (x,y) = (25, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd633;
    end

    // (x,y) = (25, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd665;
    end

    // (x,y) = (25, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd697;
    end

    // (x,y) = (25, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd729;
    end

    // (x,y) = (25, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd761;
    end

    // (x,y) = (25, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd793;
    end

    // (x,y) = (25, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd825;
    end

    // (x,y) = (25, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd857;
    end

    // (x,y) = (25, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd889;
    end

    // (x,y) = (25, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd921;
    end

    // (x,y) = (25, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd953;
    end

    // (x,y) = (25, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd985;
    end

    // (x,y) = (25, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1017;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd26:
begin
     case (y_coord)

    // (x,y) = (26, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd26;
    end

    // (x,y) = (26, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd58;
    end

    // (x,y) = (26, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd90;
    end

    // (x,y) = (26, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd122;
    end

    // (x,y) = (26, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd154;
    end

    // (x,y) = (26, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd186;
    end

    // (x,y) = (26, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd218;
    end

    // (x,y) = (26, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd250;
    end

    // (x,y) = (26, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd282;
    end

    // (x,y) = (26, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd314;
    end

    // (x,y) = (26, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd346;
    end

    // (x,y) = (26, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd378;
    end

    // (x,y) = (26, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd410;
    end

    // (x,y) = (26, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd442;
    end

    // (x,y) = (26, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd474;
    end

    // (x,y) = (26, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd506;
    end

    // (x,y) = (26, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd538;
    end

    // (x,y) = (26, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd570;
    end

    // (x,y) = (26, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd602;
    end

    // (x,y) = (26, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd634;
    end

    // (x,y) = (26, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd666;
    end

    // (x,y) = (26, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd698;
    end

    // (x,y) = (26, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd730;
    end

    // (x,y) = (26, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd762;
    end

    // (x,y) = (26, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd794;
    end

    // (x,y) = (26, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd826;
    end

    // (x,y) = (26, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd858;
    end

    // (x,y) = (26, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd890;
    end

    // (x,y) = (26, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd922;
    end

    // (x,y) = (26, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd954;
    end

    // (x,y) = (26, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd986;
    end

    // (x,y) = (26, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1018;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd27:
begin
     case (y_coord)

    // (x,y) = (27, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd27;
    end

    // (x,y) = (27, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd59;
    end

    // (x,y) = (27, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd91;
    end

    // (x,y) = (27, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd123;
    end

    // (x,y) = (27, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd155;
    end

    // (x,y) = (27, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd187;
    end

    // (x,y) = (27, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd219;
    end

    // (x,y) = (27, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd251;
    end

    // (x,y) = (27, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd283;
    end

    // (x,y) = (27, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd315;
    end

    // (x,y) = (27, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd347;
    end

    // (x,y) = (27, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd379;
    end

    // (x,y) = (27, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd411;
    end

    // (x,y) = (27, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd443;
    end

    // (x,y) = (27, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd475;
    end

    // (x,y) = (27, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd507;
    end

    // (x,y) = (27, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd539;
    end

    // (x,y) = (27, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd571;
    end

    // (x,y) = (27, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd603;
    end

    // (x,y) = (27, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd635;
    end

    // (x,y) = (27, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd667;
    end

    // (x,y) = (27, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd699;
    end

    // (x,y) = (27, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd731;
    end

    // (x,y) = (27, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd763;
    end

    // (x,y) = (27, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd795;
    end

    // (x,y) = (27, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd827;
    end

    // (x,y) = (27, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd859;
    end

    // (x,y) = (27, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd891;
    end

    // (x,y) = (27, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd923;
    end

    // (x,y) = (27, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd955;
    end

    // (x,y) = (27, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd987;
    end

    // (x,y) = (27, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1019;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd28:
begin
     case (y_coord)

    // (x,y) = (28, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd28;
    end

    // (x,y) = (28, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd60;
    end

    // (x,y) = (28, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd92;
    end

    // (x,y) = (28, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd124;
    end

    // (x,y) = (28, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd156;
    end

    // (x,y) = (28, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd188;
    end

    // (x,y) = (28, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd220;
    end

    // (x,y) = (28, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd252;
    end

    // (x,y) = (28, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd284;
    end

    // (x,y) = (28, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd316;
    end

    // (x,y) = (28, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd348;
    end

    // (x,y) = (28, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd380;
    end

    // (x,y) = (28, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd412;
    end

    // (x,y) = (28, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd444;
    end

    // (x,y) = (28, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd476;
    end

    // (x,y) = (28, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd508;
    end

    // (x,y) = (28, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd540;
    end

    // (x,y) = (28, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd572;
    end

    // (x,y) = (28, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd604;
    end

    // (x,y) = (28, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd636;
    end

    // (x,y) = (28, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd668;
    end

    // (x,y) = (28, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd700;
    end

    // (x,y) = (28, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd732;
    end

    // (x,y) = (28, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd764;
    end

    // (x,y) = (28, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd796;
    end

    // (x,y) = (28, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd828;
    end

    // (x,y) = (28, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd860;
    end

    // (x,y) = (28, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd892;
    end

    // (x,y) = (28, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd924;
    end

    // (x,y) = (28, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd956;
    end

    // (x,y) = (28, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd988;
    end

    // (x,y) = (28, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1020;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd29:
begin
     case (y_coord)

    // (x,y) = (29, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd29;
    end

    // (x,y) = (29, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd61;
    end

    // (x,y) = (29, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd93;
    end

    // (x,y) = (29, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd125;
    end

    // (x,y) = (29, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd157;
    end

    // (x,y) = (29, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd189;
    end

    // (x,y) = (29, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd221;
    end

    // (x,y) = (29, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd253;
    end

    // (x,y) = (29, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd285;
    end

    // (x,y) = (29, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd317;
    end

    // (x,y) = (29, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd349;
    end

    // (x,y) = (29, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd381;
    end

    // (x,y) = (29, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd413;
    end

    // (x,y) = (29, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd445;
    end

    // (x,y) = (29, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd477;
    end

    // (x,y) = (29, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd509;
    end

    // (x,y) = (29, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd541;
    end

    // (x,y) = (29, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd573;
    end

    // (x,y) = (29, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd605;
    end

    // (x,y) = (29, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd637;
    end

    // (x,y) = (29, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd669;
    end

    // (x,y) = (29, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd701;
    end

    // (x,y) = (29, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd733;
    end

    // (x,y) = (29, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd765;
    end

    // (x,y) = (29, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd797;
    end

    // (x,y) = (29, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd829;
    end

    // (x,y) = (29, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd861;
    end

    // (x,y) = (29, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd893;
    end

    // (x,y) = (29, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd925;
    end

    // (x,y) = (29, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd957;
    end

    // (x,y) = (29, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd989;
    end

    // (x,y) = (29, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1021;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd30:
begin
     case (y_coord)

    // (x,y) = (30, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd30;
    end

    // (x,y) = (30, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd62;
    end

    // (x,y) = (30, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd94;
    end

    // (x,y) = (30, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd126;
    end

    // (x,y) = (30, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd158;
    end

    // (x,y) = (30, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd190;
    end

    // (x,y) = (30, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd222;
    end

    // (x,y) = (30, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd254;
    end

    // (x,y) = (30, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd286;
    end

    // (x,y) = (30, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd318;
    end

    // (x,y) = (30, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd350;
    end

    // (x,y) = (30, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd382;
    end

    // (x,y) = (30, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd414;
    end

    // (x,y) = (30, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd446;
    end

    // (x,y) = (30, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd478;
    end

    // (x,y) = (30, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd510;
    end

    // (x,y) = (30, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd542;
    end

    // (x,y) = (30, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd574;
    end

    // (x,y) = (30, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd606;
    end

    // (x,y) = (30, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd638;
    end

    // (x,y) = (30, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd670;
    end

    // (x,y) = (30, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd702;
    end

    // (x,y) = (30, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd734;
    end

    // (x,y) = (30, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd766;
    end

    // (x,y) = (30, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd798;
    end

    // (x,y) = (30, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd830;
    end

    // (x,y) = (30, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd862;
    end

    // (x,y) = (30, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd894;
    end

    // (x,y) = (30, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd926;
    end

    // (x,y) = (30, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd958;
    end

    // (x,y) = (30, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd990;
    end

    // (x,y) = (30, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1022;
    end
     default:
     begin
         flat_id = `HOME_ID_WIDTH'dX;
     end
     endcase
end

`NOC_X_WIDTH'd31:
begin
     case (y_coord)

    // (x,y) = (31, 0)
    `NOC_Y_WIDTH'd0:
    begin
        flat_id = `HOME_ID_WIDTH'd31;
    end

    // (x,y) = (31, 1)
    `NOC_Y_WIDTH'd1:
    begin
        flat_id = `HOME_ID_WIDTH'd63;
    end

    // (x,y) = (31, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd95;
    end

    // (x,y) = (31, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd127;
    end

    // (x,y) = (31, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd159;
    end

    // (x,y) = (31, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd191;
    end

    // (x,y) = (31, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd223;
    end

    // (x,y) = (31, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd255;
    end

    // (x,y) = (31, 8)
    `NOC_Y_WIDTH'd8:
    begin
        flat_id = `HOME_ID_WIDTH'd287;
    end

    // (x,y) = (31, 9)
    `NOC_Y_WIDTH'd9:
    begin
        flat_id = `HOME_ID_WIDTH'd319;
    end

    // (x,y) = (31, 10)
    `NOC_Y_WIDTH'd10:
    begin
        flat_id = `HOME_ID_WIDTH'd351;
    end

    // (x,y) = (31, 11)
    `NOC_Y_WIDTH'd11:
    begin
        flat_id = `HOME_ID_WIDTH'd383;
    end

    // (x,y) = (31, 12)
    `NOC_Y_WIDTH'd12:
    begin
        flat_id = `HOME_ID_WIDTH'd415;
    end

    // (x,y) = (31, 13)
    `NOC_Y_WIDTH'd13:
    begin
        flat_id = `HOME_ID_WIDTH'd447;
    end

    // (x,y) = (31, 14)
    `NOC_Y_WIDTH'd14:
    begin
        flat_id = `HOME_ID_WIDTH'd479;
    end

    // (x,y) = (31, 15)
    `NOC_Y_WIDTH'd15:
    begin
        flat_id = `HOME_ID_WIDTH'd511;
    end

    // (x,y) = (31, 16)
    `NOC_Y_WIDTH'd16:
    begin
        flat_id = `HOME_ID_WIDTH'd543;
    end

    // (x,y) = (31, 17)
    `NOC_Y_WIDTH'd17:
    begin
        flat_id = `HOME_ID_WIDTH'd575;
    end

    // (x,y) = (31, 18)
    `NOC_Y_WIDTH'd18:
    begin
        flat_id = `HOME_ID_WIDTH'd607;
    end

    // (x,y) = (31, 19)
    `NOC_Y_WIDTH'd19:
    begin
        flat_id = `HOME_ID_WIDTH'd639;
    end

    // (x,y) = (31, 20)
    `NOC_Y_WIDTH'd20:
    begin
        flat_id = `HOME_ID_WIDTH'd671;
    end

    // (x,y) = (31, 21)
    `NOC_Y_WIDTH'd21:
    begin
        flat_id = `HOME_ID_WIDTH'd703;
    end

    // (x,y) = (31, 22)
    `NOC_Y_WIDTH'd22:
    begin
        flat_id = `HOME_ID_WIDTH'd735;
    end

    // (x,y) = (31, 23)
    `NOC_Y_WIDTH'd23:
    begin
        flat_id = `HOME_ID_WIDTH'd767;
    end

    // (x,y) = (31, 24)
    `NOC_Y_WIDTH'd24:
    begin
        flat_id = `HOME_ID_WIDTH'd799;
    end

    // (x,y) = (31, 25)
    `NOC_Y_WIDTH'd25:
    begin
        flat_id = `HOME_ID_WIDTH'd831;
    end

    // (x,y) = (31, 26)
    `NOC_Y_WIDTH'd26:
    begin
        flat_id = `HOME_ID_WIDTH'd863;
    end

    // (x,y) = (31, 27)
    `NOC_Y_WIDTH'd27:
    begin
        flat_id = `HOME_ID_WIDTH'd895;
    end

    // (x,y) = (31, 28)
    `NOC_Y_WIDTH'd28:
    begin
        flat_id = `HOME_ID_WIDTH'd927;
    end

    // (x,y) = (31, 29)
    `NOC_Y_WIDTH'd29:
    begin
        flat_id = `HOME_ID_WIDTH'd959;
    end

    // (x,y) = (31, 30)
    `NOC_Y_WIDTH'd30:
    begin
        flat_id = `HOME_ID_WIDTH'd991;
    end

    // (x,y) = (31, 31)
    `NOC_Y_WIDTH'd31:
    begin
        flat_id = `HOME_ID_WIDTH'd1023;
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

