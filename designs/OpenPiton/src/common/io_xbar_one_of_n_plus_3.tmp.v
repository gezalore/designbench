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
// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml

module io_xbar_one_of_n_plus_3(
  
  in0,
  in1,
  in2,
  in3,
  in4,
  in5,
  in6,
  in7,
  in8,
  in9,
  in10,

  sel,
  out);
    parameter WIDTH = 8;
    parameter BHC = 10;
    input [3:0] sel;
    
    input [WIDTH-1:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10;
    output reg [WIDTH-1:0] out;
    always@(*)
    begin
        out={WIDTH{1'b0}};
        case(sel)
        
            4'd0:out=in0;
            4'd1:out=in1;
            4'd2:out=in2;
            4'd3:out=in3;
            4'd4:out=in4;
            4'd5:out=in5;
            4'd6:out=in6;
            4'd7:out=in7;
            4'd8:out=in8;
            4'd9:out=in9;
            4'd10:out=in10;

            default:; // indicates null
        endcase
    end
endmodule


