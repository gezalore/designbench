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

//Function: This maintains the control of where different signals want to go
//and counters of how many words are left in messages
//
//State:
//header_temp_f  //header_temp from the previous cycle
//count_f       //the counter of how much more we have to go
//tail_last_f   //what the tail bit wa the last cycle
//count_zero_f  //whether the counter now is zero
//count_one_f   //whether the counter now is one
//
//Instantiates: io_xbar_route_request_calc
//
//Note:
//

// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml

`include "network_define.v"
module io_xbar_input_control(thanks_all_temp_out,
                             route_req_0_out, route_req_1_out, route_req_2_out, route_req_3_out, route_req_4_out, route_req_5_out, route_req_6_out, route_req_7_out, 
                             default_ready_0, default_ready_1, default_ready_2, default_ready_3, default_ready_4, default_ready_5, default_ready_6, default_ready_7, 
                             tail_out, clk, reset,
                             my_loc_x_in, my_loc_y_in, my_chip_id_in,
                             abs_x, abs_y, abs_chip_id, final_bits, valid_in,
                             thanks_0, thanks_1, thanks_2, thanks_3, thanks_4, thanks_5, thanks_6, thanks_7, 
                             length);

// begin port declarations

output thanks_all_temp_out;
output route_req_0_out;
output route_req_1_out;
output route_req_2_out;
output route_req_3_out;
output route_req_4_out;
output route_req_5_out;
output route_req_6_out;
output route_req_7_out;
output default_ready_0;
output default_ready_1;
output default_ready_2;
output default_ready_3;
output default_ready_4;
output default_ready_5;
output default_ready_6;
output default_ready_7;

output tail_out;

input clk;
input reset;

input [`XY_WIDTH-1:0] my_loc_x_in;
input [`XY_WIDTH-1:0] my_loc_y_in;
input [`CHIP_ID_WIDTH-1:0] my_chip_id_in;
input [`XY_WIDTH-1:0] abs_x;
input [`XY_WIDTH-1:0] abs_y;
input [`CHIP_ID_WIDTH-1:0] abs_chip_id;
input [2:0] final_bits;
input valid_in;
input thanks_0;
input thanks_1;
input thanks_2;
input thanks_3;
input thanks_4;
input thanks_5;
input thanks_6;
input thanks_7;

input [`PAYLOAD_LEN-1:0] length;

// end port declarations

//This is the state
reg [`PAYLOAD_LEN-1:0] count_f;
reg header_last_f;
reg thanks_all_f;
reg count_zero_f;
reg count_one_f;
reg tail_last_f;

//inputs to the state
reg [`PAYLOAD_LEN-1:0] count_temp;
wire header_last_temp;
wire thanks_all_temp;
wire count_zero_temp;
wire count_one_temp;
wire tail_last_temp;


//wires
wire header;
wire [`PAYLOAD_LEN-1:0] count_minus_one;
wire length_zero; //for use in calculating tail bit for
                  //zero length messages on the default route
wire tail;

//wire regs
reg header_temp;

//assigns

assign thanks_all_temp = thanks_0 | thanks_1 | thanks_2 | thanks_3 | thanks_4 | thanks_5 | thanks_6 | thanks_7;
assign header = valid_in & header_temp;
assign count_zero_temp = count_temp == 0;
assign count_one_temp = count_temp == 1;
assign thanks_all_temp_out = thanks_all_temp;
assign tail_out = tail;
assign count_minus_one = count_f - 1;
assign length_zero = length == 0;
assign header_last_temp = header_temp;
//nasty control logic which I really hope is correct
assign tail = (header & length_zero) | ((~thanks_all_f) & tail_last_f) | (thanks_all_f & count_one_f);
assign tail_last_temp = tail;

//instantiations

io_xbar_route_request_calc tail_calc(.route_req_0(route_req_0_out),
                                           .route_req_1(route_req_1_out),
                                           .route_req_2(route_req_2_out),
                                           .route_req_3(route_req_3_out),
                                           .route_req_4(route_req_4_out),
                                           .route_req_5(route_req_5_out),
                                           .route_req_6(route_req_6_out),
                                           .route_req_7(route_req_7_out),

                                           .default_ready_0(default_ready_0),
                                           .default_ready_1(default_ready_1),
                                           .default_ready_2(default_ready_2),
                                           .default_ready_3(default_ready_3),
                                           .default_ready_4(default_ready_4),
                                           .default_ready_5(default_ready_5),
                                           .default_ready_6(default_ready_6),
                                           .default_ready_7(default_ready_7),

                                           .my_loc_x_in(my_loc_x_in),
                                           .my_loc_y_in(my_loc_y_in),
                                           .my_chip_id_in(my_chip_id_in),
                                           .abs_x(abs_x),
                                           .abs_y(abs_y),
                                           .abs_chip_id(abs_chip_id),
                                           .final_bits(final_bits),
                                           .length(length),
                                           .header_in(header));

always @ (header_last_f or thanks_all_f or count_zero_f)
begin
        case({header_last_f, count_zero_f, thanks_all_f})
        3'b000: header_temp <= 1'b0;
        3'b001: header_temp <= 1'b0;
        3'b010: header_temp <= 1'b0;
        3'b011: header_temp <= 1'b1;
        3'b100: header_temp <= 1'b1;
        //yanqiz change 0->1
        3'b101: header_temp <= 1'b0;
        3'b110: header_temp <= 1'b1;
        3'b111: header_temp <= 1'b1;
        default:
                header_temp <= 1'b1;
        endcase
end

always @ (header or thanks_all_f or count_f or count_minus_one or length)
begin
        if(header)
        begin
                count_temp <= length;
        end
        else
        begin
                if(thanks_all_f)
                begin
                        count_temp <= count_minus_one;
                end
                else
                begin
                        count_temp <= count_f;
                end
        end
end

//take care of synchronous stuff
always @ (posedge clk)
begin
        if(reset)
        begin
                count_f <= 5'd0;
                header_last_f <= 1'b1;
                thanks_all_f <= 1'b0;
                count_zero_f <= 1'b1; //I think that this must reset to 1 to work!
                count_one_f <= 1'b0;
                tail_last_f <= 1'b0;
        end
        else
        begin
                count_f <= count_temp;
                header_last_f <= header_last_temp;
                thanks_all_f <= thanks_all_temp;
                count_zero_f <= count_zero_temp;
                count_one_f <= count_one_temp;
                tail_last_f <= tail_last_temp;
        end
end
endmodule

