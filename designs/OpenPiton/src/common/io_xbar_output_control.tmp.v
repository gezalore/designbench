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

//Function: This maintains the control of the output mux for a dynamic network port.
//	This does the scheduling for the output.
//	It takes as input what all of the other ports want to do and outputs the control
//	for the respective crossbar mux and the validOut signal for a respective direction.
//
//Instantiates:
//
//State: current_route_f [2:0], planned_f
//
//Note:
//
`include "network_define.v"
// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml

module io_xbar_output_control(thanks_0, thanks_1, thanks_2, thanks_3, thanks_4, thanks_5, thanks_6, thanks_7, 
                              valid_out, current_route, ec_wants_to_send_but_cannot, clk, reset, 
                              route_req_0_in, route_req_1_in, route_req_2_in, route_req_3_in, route_req_4_in, route_req_5_in, route_req_6_in, route_req_7_in, 
                              tail_0_in, tail_1_in, tail_2_in, tail_3_in, tail_4_in, tail_5_in, tail_6_in, tail_7_in, 
                              valid_out_temp, default_ready, space_avail);
// begin port declarations
output thanks_0;
output thanks_1;
output thanks_2;
output thanks_3;
output thanks_4;
output thanks_5;
output thanks_6;
output thanks_7;

output valid_out;

output [2:0] current_route;
output    ec_wants_to_send_but_cannot;

input clk;
input reset;

input route_req_0_in;
input route_req_1_in;
input route_req_2_in;
input route_req_3_in;
input route_req_4_in;
input route_req_5_in;
input route_req_6_in;
input route_req_7_in;

input tail_0_in;
input tail_1_in;
input tail_2_in;
input tail_3_in;
input tail_4_in;
input tail_5_in;
input tail_6_in;
input tail_7_in;

input valid_out_temp;

input default_ready;

input space_avail;

// end port declarations

`define IO_XBAR_ROUTE_0 3'b000
`define IO_XBAR_ROUTE_1 3'b001
`define IO_XBAR_ROUTE_2 3'b010
`define IO_XBAR_ROUTE_3 3'b011
`define IO_XBAR_ROUTE_4 3'b100
`define IO_XBAR_ROUTE_5 3'b101
`define IO_XBAR_ROUTE_6 3'b110
`define IO_XBAR_ROUTE_7 3'b111

//This is the state
reg [2:0]current_route_f;
reg planned_f;

//inputs to the state
wire [2:0] current_route_temp;

//wires
wire planned_or_default;
// wire route_req_all_or;
wire route_req_all_or_with_planned;
wire route_req_all_but_default;
wire valid_out_internal;

//wire regs
reg new_route_needed;
reg planned_temp;
reg [2:0] new_route;
reg tail_current_route;
/*reg route_req_planned;*/
reg route_req_0_mask;
reg route_req_1_mask;
reg route_req_2_mask;
reg route_req_3_mask;
reg route_req_4_mask;
reg route_req_5_mask;
reg route_req_6_mask;
reg route_req_7_mask;


//more wire regs for the thanks lines
reg thanks_0;
reg thanks_1;
reg thanks_2;
reg thanks_3;
reg thanks_4;
reg thanks_5;
reg thanks_6;
reg thanks_7;

reg    ec_wants_to_send_but_cannot;

//assigns
assign planned_or_default = planned_f | default_ready;
assign valid_out_internal = valid_out_temp & planned_or_default & space_avail;

// mbt: if valid_out_interal is a critical path, we can use some "bleeder" gates to decrease the load of the ec stuff
always @(posedge clk)
  begin
     ec_wants_to_send_but_cannot <= valid_out_temp & planned_or_default & ~space_avail;
  end

/* assign route_req_all_or = route_req_a_in | route_req_b_in | route_req_c_in | route_req_d_in | route_req_x_in; */
assign current_route_temp = (new_route_needed) ? new_route : current_route_f;
assign current_route = current_route_f;
//this is everything except the currentl planned route's request

assign route_req_all_or_with_planned = (route_req_0_in & route_req_0_mask) | (route_req_1_in & route_req_1_mask) | (route_req_2_in & route_req_2_mask) | (route_req_3_in & route_req_3_mask) | (route_req_4_in & route_req_4_mask) | (route_req_5_in & route_req_5_mask) | (route_req_6_in & route_req_6_mask) | (route_req_7_in & route_req_7_mask);
//calculates whether the nib that we are going to has space

assign route_req_all_but_default = (route_req_1_in) | (route_req_2_in) | (route_req_3_in) | (route_req_4_in) | (route_req_5_in) | (route_req_6_in) | (route_req_7_in);

assign valid_out = valid_out_internal;

//instantiations
//space_avail space(.valid(valid_out_internal), .clk(clk), .reset(reset), .yummy(yummy_in), .spc_avail(space_avail));
//THIS HAS BEEN MOVED to dynamic_output_top

//a mux for current_route_f's tail bit

always @ (current_route_f or tail_0_in or tail_1_in or tail_2_in or tail_3_in or tail_4_in or tail_5_in or tail_6_in or tail_7_in)
begin
	case(current_route_f) //synopsys parallel_case
	
	`IO_XBAR_ROUTE_0:
	begin
		tail_current_route <= tail_0_in;
	end
	`IO_XBAR_ROUTE_1:
	begin
		tail_current_route <= tail_1_in;
	end
	`IO_XBAR_ROUTE_2:
	begin
		tail_current_route <= tail_2_in;
	end
	`IO_XBAR_ROUTE_3:
	begin
		tail_current_route <= tail_3_in;
	end
	`IO_XBAR_ROUTE_4:
	begin
		tail_current_route <= tail_4_in;
	end
	`IO_XBAR_ROUTE_5:
	begin
		tail_current_route <= tail_5_in;
	end
	`IO_XBAR_ROUTE_6:
	begin
		tail_current_route <= tail_6_in;
	end
	`IO_XBAR_ROUTE_7:
	begin
		tail_current_route <= tail_7_in;
	end

	default:
	begin
		tail_current_route <= 1'bx; //This is probably dangerous, but I
					    //really need the speed here and
					    //I don't want the synthesizer to
					    //mess me up if I put a real value
					    //here
	end
	endcase
end

always @ (current_route_f or valid_out_internal)
begin
	case(current_route_f)
	/*
	//original
	`ROUTE_A:
	begin
		thanks_a <= valid_out_internal;
		thanks_b <= 1'b0;
		thanks_c <= 1'b0;
		thanks_d <= 1'b0;
		thanks_x <= 1'b0;
	end
	*/
	
	`IO_XBAR_ROUTE_0:
	begin
		thanks_0 <= valid_out_internal;
		thanks_1 <= 1'b0;
		thanks_2 <= 1'b0;
		thanks_3 <= 1'b0;
		thanks_4 <= 1'b0;
		thanks_5 <= 1'b0;
		thanks_6 <= 1'b0;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_1:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= valid_out_internal;
		thanks_2 <= 1'b0;
		thanks_3 <= 1'b0;
		thanks_4 <= 1'b0;
		thanks_5 <= 1'b0;
		thanks_6 <= 1'b0;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_2:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= 1'b0;
		thanks_2 <= valid_out_internal;
		thanks_3 <= 1'b0;
		thanks_4 <= 1'b0;
		thanks_5 <= 1'b0;
		thanks_6 <= 1'b0;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_3:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= 1'b0;
		thanks_2 <= 1'b0;
		thanks_3 <= valid_out_internal;
		thanks_4 <= 1'b0;
		thanks_5 <= 1'b0;
		thanks_6 <= 1'b0;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_4:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= 1'b0;
		thanks_2 <= 1'b0;
		thanks_3 <= 1'b0;
		thanks_4 <= valid_out_internal;
		thanks_5 <= 1'b0;
		thanks_6 <= 1'b0;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_5:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= 1'b0;
		thanks_2 <= 1'b0;
		thanks_3 <= 1'b0;
		thanks_4 <= 1'b0;
		thanks_5 <= valid_out_internal;
		thanks_6 <= 1'b0;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_6:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= 1'b0;
		thanks_2 <= 1'b0;
		thanks_3 <= 1'b0;
		thanks_4 <= 1'b0;
		thanks_5 <= 1'b0;
		thanks_6 <= valid_out_internal;
		thanks_7 <= 1'b0;
	end
	`IO_XBAR_ROUTE_7:
	begin
		thanks_0 <= 1'b0;
		thanks_1 <= 1'b0;
		thanks_2 <= 1'b0;
		thanks_3 <= 1'b0;
		thanks_4 <= 1'b0;
		thanks_5 <= 1'b0;
		thanks_6 <= 1'b0;
		thanks_7 <= valid_out_internal;
	end

	default:
	begin
	
		thanks_0 <= 1'bx;
		thanks_1 <= 1'bx;
		thanks_2 <= 1'bx;
		thanks_3 <= 1'bx;
		thanks_4 <= 1'bx;
		thanks_5 <= 1'bx;
		thanks_6 <= 1'bx;
		thanks_7 <= 1'bx;

	/*
	//original
		thanks_a <= 1'bx;
		thanks_b <= 1'bx;
		thanks_c <= 1'bx;
		thanks_d <= 1'bx;
		thanks_x <= 1'bx;
	*/
					//once again this is very dangerous
					//but I want to see the timing this
					//way and we sould never get here
	end
	endcase
end

//this is the rotating priority encoder
/*
always @(current_route_f or route_req_a_in or route_req_b_in or route_req_c_in or route_req_d_in or route_req_x_in)
begin
	case(current_route_f)
	`ROUTE_A:
	begin
		new_route <= (route_req_b_in)?`ROUTE_B:((route_req_c_in)?`ROUTE_C:((route_req_d_in)?`ROUTE_D:((route_req_x_in)?`ROUTE_X:`ROUTE_A)));
	end
	`ROUTE_B:
	begin
		new_route <= (route_req_c_in)?`ROUTE_C:((route_req_d_in)?`ROUTE_D:((route_req_x_in)?`ROUTE_X:((route_req_a_in)?`ROUTE_A:((route_req_b_in)?`ROUTE_B:`ROUTE_A))));
	end
	`ROUTE_C:
	begin
		new_route <= (route_req_d_in)?`ROUTE_D:((route_req_x_in)?`ROUTE_X:((route_req_a_in)?`ROUTE_A:((route_req_b_in)?`ROUTE_B:((route_req_c_in)?`ROUTE_C:`ROUTE_A))));
	end
	`ROUTE_D:
	begin
		new_route <= (route_req_c_in)?`ROUTE_C:((route_req_d_in)?`ROUTE_D:((route_req_x_in)?`ROUTE_X:((route_req_a_in)?`ROUTE_A:((route_req_b_in)?`ROUTE_B:`ROUTE_A))));
	end
	`ROUTE_X:
	begin
		new_route <= (route_req_x_in)?`ROUTE_X:((route_req_a_in)?`ROUTE_A:((route_req_b_in)?`ROUTE_B:((route_req_c_in)?`ROUTE_C:((route_req_d_in)?`ROUTE_D:`ROUTE_A))));
	end
	default:
	begin
		new_route <= `ROUTE_A;
			//this one I am not willing to chince on
	end
	endcase
end
*/
//end the rotating priority encoder

//this is the rotating priority encoder
always @(current_route_f or route_req_0_in or route_req_1_in or route_req_2_in or route_req_3_in or route_req_4_in or route_req_5_in or route_req_6_in or route_req_7_in)
begin
	case(current_route_f)
	/*
	//original
	`ROUTE_A:
	begin
		new_route <= (route_req_b_in)?`ROUTE_B:((route_req_c_in)?`ROUTE_C:((route_req_d_in)?`ROUTE_D:((route_req_x_in)?`ROUTE_X:`ROUTE_A)));
	end
	*/
	
	`IO_XBAR_ROUTE_0:
	begin
		new_route <= (route_req_1_in)?`IO_XBAR_ROUTE_1:((route_req_2_in)?`IO_XBAR_ROUTE_2:((route_req_3_in)?`IO_XBAR_ROUTE_3:((route_req_4_in)?`IO_XBAR_ROUTE_4:((route_req_5_in)?`IO_XBAR_ROUTE_5:((route_req_6_in)?`IO_XBAR_ROUTE_6:((route_req_7_in)?`IO_XBAR_ROUTE_7:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_1:
	begin
		new_route <= (route_req_2_in)?`IO_XBAR_ROUTE_2:((route_req_3_in)?`IO_XBAR_ROUTE_3:((route_req_4_in)?`IO_XBAR_ROUTE_4:((route_req_5_in)?`IO_XBAR_ROUTE_5:((route_req_6_in)?`IO_XBAR_ROUTE_6:((route_req_7_in)?`IO_XBAR_ROUTE_7:((route_req_0_in)?`IO_XBAR_ROUTE_0:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_2:
	begin
		new_route <= (route_req_3_in)?`IO_XBAR_ROUTE_3:((route_req_4_in)?`IO_XBAR_ROUTE_4:((route_req_5_in)?`IO_XBAR_ROUTE_5:((route_req_6_in)?`IO_XBAR_ROUTE_6:((route_req_7_in)?`IO_XBAR_ROUTE_7:((route_req_0_in)?`IO_XBAR_ROUTE_0:((route_req_1_in)?`IO_XBAR_ROUTE_1:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_3:
	begin
		new_route <= (route_req_4_in)?`IO_XBAR_ROUTE_4:((route_req_5_in)?`IO_XBAR_ROUTE_5:((route_req_6_in)?`IO_XBAR_ROUTE_6:((route_req_7_in)?`IO_XBAR_ROUTE_7:((route_req_0_in)?`IO_XBAR_ROUTE_0:((route_req_1_in)?`IO_XBAR_ROUTE_1:((route_req_2_in)?`IO_XBAR_ROUTE_2:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_4:
	begin
		new_route <= (route_req_5_in)?`IO_XBAR_ROUTE_5:((route_req_6_in)?`IO_XBAR_ROUTE_6:((route_req_7_in)?`IO_XBAR_ROUTE_7:((route_req_0_in)?`IO_XBAR_ROUTE_0:((route_req_1_in)?`IO_XBAR_ROUTE_1:((route_req_2_in)?`IO_XBAR_ROUTE_2:((route_req_3_in)?`IO_XBAR_ROUTE_3:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_5:
	begin
		new_route <= (route_req_6_in)?`IO_XBAR_ROUTE_6:((route_req_7_in)?`IO_XBAR_ROUTE_7:((route_req_0_in)?`IO_XBAR_ROUTE_0:((route_req_1_in)?`IO_XBAR_ROUTE_1:((route_req_2_in)?`IO_XBAR_ROUTE_2:((route_req_3_in)?`IO_XBAR_ROUTE_3:((route_req_4_in)?`IO_XBAR_ROUTE_4:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_6:
	begin
		new_route <= (route_req_7_in)?`IO_XBAR_ROUTE_7:((route_req_0_in)?`IO_XBAR_ROUTE_0:((route_req_1_in)?`IO_XBAR_ROUTE_1:((route_req_2_in)?`IO_XBAR_ROUTE_2:((route_req_3_in)?`IO_XBAR_ROUTE_3:((route_req_4_in)?`IO_XBAR_ROUTE_4:((route_req_5_in)?`IO_XBAR_ROUTE_5:`IO_XBAR_ROUTE_0))))));
	end
	`IO_XBAR_ROUTE_7:
	begin
		new_route <= (route_req_0_in)?`IO_XBAR_ROUTE_0:((route_req_1_in)?`IO_XBAR_ROUTE_1:((route_req_2_in)?`IO_XBAR_ROUTE_2:((route_req_3_in)?`IO_XBAR_ROUTE_3:((route_req_4_in)?`IO_XBAR_ROUTE_4:((route_req_5_in)?`IO_XBAR_ROUTE_5:((route_req_6_in)?`IO_XBAR_ROUTE_6:`IO_XBAR_ROUTE_0))))));
	end

	default:
	begin
		new_route <= `IO_XBAR_ROUTE_0;
			//this one I am not willing to chince on
	end
	endcase
end
//end the rotating priority encoder

always @(current_route_f or planned_f)
begin
	if(planned_f)
	begin
		case(current_route_f)
		
		`IO_XBAR_ROUTE_0:
			begin
				route_req_0_mask <= 1'b0;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_1:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b0;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_2:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b0;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_3:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b0;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_4:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b0;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_5:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b0;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_6:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b0;
				route_req_7_mask <= 1'b1;
			end
		`IO_XBAR_ROUTE_7:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b0;
			end
		default:
			begin
				route_req_0_mask <= 1'b1;
				route_req_1_mask <= 1'b1;
				route_req_2_mask <= 1'b1;
				route_req_3_mask <= 1'b1;
				route_req_4_mask <= 1'b1;
				route_req_5_mask <= 1'b1;
				route_req_6_mask <= 1'b1;
				route_req_7_mask <= 1'b1;
			end

		/*
		original
		`ROUTE_A:	
			begin
				route_req_a_mask <= 1'b0;
				route_req_b_mask <= 1'b1;
				route_req_c_mask <= 1'b1;
				route_req_d_mask <= 1'b1;
				route_req_x_mask <= 1'b1;
			end
		default:
			begin
				route_req_a_mask <= 1'b1;
				route_req_b_mask <= 1'b1;
				route_req_c_mask <= 1'b1;
				route_req_d_mask <= 1'b1;
				route_req_x_mask <= 1'b1;
			end
		*/
		endcase
	end
	else
	begin
	
		route_req_0_mask <= 1'b1;
		route_req_1_mask <= 1'b1;
		route_req_2_mask <= 1'b1;
		route_req_3_mask <= 1'b1;
		route_req_4_mask <= 1'b1;
		route_req_5_mask <= 1'b1;
		route_req_6_mask <= 1'b1;
		route_req_7_mask <= 1'b1;

	/*
	//original
		route_req_a_mask <= 1'b1;
		route_req_b_mask <= 1'b1;
		route_req_c_mask <= 1'b1;
		route_req_d_mask <= 1'b1;
		route_req_x_mask <= 1'b1;
	*/
	end
end

//calculation of new_route_needed
always @ (planned_f or tail_current_route or valid_out_internal or default_ready)
begin
	case({default_ready, valid_out_internal, tail_current_route, planned_f}) //synopsys parallel_case
	4'b0000:	new_route_needed <= 1'b1;
	4'b0001:	new_route_needed <= 1'b0;
	4'b0010:	new_route_needed <= 1'b1;
	4'b0011:	new_route_needed <= 1'b0;
	4'b0100:	new_route_needed <= 1'b0;	//This line should probably be turned to a 1 if we are to implement "Mikes fairness" schema
	4'b0101:	new_route_needed <= 1'b0;	//This line should probably be turned to a 1 if we are to implement "Mikes fairness" schema
	4'b0110:	new_route_needed <= 1'b1;
	4'b0111:	new_route_needed <= 1'b1;

	4'b1000:	new_route_needed <= 1'b1;
	4'b1001:	new_route_needed <= 1'b0;
//	4'b1010:	new_route_needed <= 1'b0;	//this is scary CHECK THIS BEFORE CHIP SHIPS
	4'b1010:	new_route_needed <= 1'b1;	//this is the case where there is a zero length message on the default route that is not being sent this cycle therefore we should let something be locked in, but it doesn't necessarily just the default route.  Remember that the default route is the last choice in the priority encoder, but if nothing else is requesting, the default route will be planned and locked in.
    //yanqiz change from 0->1
	4'b1011:	new_route_needed <= 1'b0;
	4'b1100:	new_route_needed <= 1'b0;
	4'b1101:	new_route_needed <= 1'b0;
	4'b1110:	new_route_needed <= 1'b1;
	4'b1111:	new_route_needed <= 1'b1;
	default:	new_route_needed <= 1'b1;
			//safest choice should never occur
	endcase
end

//calculation of planned_temp
//random five input function
always @ (planned_f or tail_current_route or valid_out_internal or default_ready or route_req_all_or_with_planned or route_req_all_but_default)
begin
	case({route_req_all_or_with_planned, default_ready, valid_out_internal, tail_current_route, planned_f}) //synopsys parallel_case
	5'b00000:	planned_temp <= 1'b0;
	5'b00001:	planned_temp <= 1'b1;
	5'b00010:	planned_temp <= 1'b0;
	5'b00011:	planned_temp <= 1'b1;
	5'b00100:	planned_temp <= 1'b0;	//error what did we just send
	5'b00101:	planned_temp <= 1'b1;
	5'b00110:	planned_temp <= 1'b0;	//error
	5'b00111:	planned_temp <= 1'b0;

	5'b01000:	planned_temp <= 1'b0;	//error
	5'b01001:	planned_temp <= 1'b1;
	5'b01010:	planned_temp <= 1'b0;	//This actually cannot happen
	5'b01011:	planned_temp <= 1'b1;
	5'b01100:	planned_temp <= 1'b0;	//What did we just send?
	5'b01101:	planned_temp <= 1'b1;
	5'b01110:	planned_temp <= 1'b0;	//error
	5'b01111:	planned_temp <= 1'b0;	//The default route is
						//currently planned but
						//is ending this cycle
						//and nobody else wants to go
						//This is a delayed zero length
						//message on the through route
	5'b10000:	planned_temp <= 1'b1;
	5'b10001:	planned_temp <= 1'b1;
	5'b10010:	planned_temp <= 1'b1;
	5'b10011:	planned_temp <= 1'b1;
	5'b10100:	planned_temp <= 1'b1;
	5'b10101:	planned_temp <= 1'b1;
	5'b10110:	planned_temp <= 1'b1;
	5'b10111:	planned_temp <= 1'b1;
	5'b11000:	planned_temp <= 1'b1;
	5'b11001:	planned_temp <= 1'b1;
	5'b11010:	planned_temp <= 1'b1;
	5'b11011:	planned_temp <= 1'b1;
	5'b11100:	planned_temp <= 1'b1;
	5'b11101:	planned_temp <= 1'b1;
//	5'b11110:	planned_temp <= 1'b0;	//This is wrong becasue if
						//there is a default
						//route zero length message
						//that is being sent and
						//somebody else wants to send
						//on the next cycle
	5'b11110:	planned_temp <= route_req_all_but_default;
	5'b11111:	planned_temp <= 1'b1;
	default:	planned_temp <= 1'b0;
	endcase
end

//take care of syncrhonous stuff
always @(posedge clk)
begin
	if(reset)
	begin
		current_route_f <= 3'd0;
		planned_f <= 1'd0;
	end
	else
	begin
		current_route_f <= current_route_temp;
		planned_f <= planned_temp;
	end
end

endmodule
