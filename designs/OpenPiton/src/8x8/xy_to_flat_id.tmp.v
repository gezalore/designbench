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
        flat_id = `HOME_ID_WIDTH'd8;
    end

    // (x,y) = (0, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd16;
    end

    // (x,y) = (0, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd24;
    end

    // (x,y) = (0, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd32;
    end

    // (x,y) = (0, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd40;
    end

    // (x,y) = (0, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd48;
    end

    // (x,y) = (0, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd56;
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
        flat_id = `HOME_ID_WIDTH'd9;
    end

    // (x,y) = (1, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd17;
    end

    // (x,y) = (1, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd25;
    end

    // (x,y) = (1, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd33;
    end

    // (x,y) = (1, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd41;
    end

    // (x,y) = (1, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd49;
    end

    // (x,y) = (1, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd57;
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
        flat_id = `HOME_ID_WIDTH'd10;
    end

    // (x,y) = (2, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd18;
    end

    // (x,y) = (2, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd26;
    end

    // (x,y) = (2, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd34;
    end

    // (x,y) = (2, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd42;
    end

    // (x,y) = (2, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd50;
    end

    // (x,y) = (2, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd58;
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
        flat_id = `HOME_ID_WIDTH'd11;
    end

    // (x,y) = (3, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd19;
    end

    // (x,y) = (3, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd27;
    end

    // (x,y) = (3, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd35;
    end

    // (x,y) = (3, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd43;
    end

    // (x,y) = (3, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd51;
    end

    // (x,y) = (3, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd59;
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
        flat_id = `HOME_ID_WIDTH'd12;
    end

    // (x,y) = (4, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd20;
    end

    // (x,y) = (4, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd28;
    end

    // (x,y) = (4, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd36;
    end

    // (x,y) = (4, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd44;
    end

    // (x,y) = (4, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd52;
    end

    // (x,y) = (4, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd60;
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
        flat_id = `HOME_ID_WIDTH'd13;
    end

    // (x,y) = (5, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd21;
    end

    // (x,y) = (5, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd29;
    end

    // (x,y) = (5, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd37;
    end

    // (x,y) = (5, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd45;
    end

    // (x,y) = (5, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd53;
    end

    // (x,y) = (5, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd61;
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
        flat_id = `HOME_ID_WIDTH'd14;
    end

    // (x,y) = (6, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd22;
    end

    // (x,y) = (6, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd30;
    end

    // (x,y) = (6, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd38;
    end

    // (x,y) = (6, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd46;
    end

    // (x,y) = (6, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd54;
    end

    // (x,y) = (6, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd62;
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
        flat_id = `HOME_ID_WIDTH'd15;
    end

    // (x,y) = (7, 2)
    `NOC_Y_WIDTH'd2:
    begin
        flat_id = `HOME_ID_WIDTH'd23;
    end

    // (x,y) = (7, 3)
    `NOC_Y_WIDTH'd3:
    begin
        flat_id = `HOME_ID_WIDTH'd31;
    end

    // (x,y) = (7, 4)
    `NOC_Y_WIDTH'd4:
    begin
        flat_id = `HOME_ID_WIDTH'd39;
    end

    // (x,y) = (7, 5)
    `NOC_Y_WIDTH'd5:
    begin
        flat_id = `HOME_ID_WIDTH'd47;
    end

    // (x,y) = (7, 6)
    `NOC_Y_WIDTH'd6:
    begin
        flat_id = `HOME_ID_WIDTH'd55;
    end

    // (x,y) = (7, 7)
    `NOC_Y_WIDTH'd7:
    begin
        flat_id = `HOME_ID_WIDTH'd63;
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

