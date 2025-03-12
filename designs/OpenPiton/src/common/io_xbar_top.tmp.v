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

//Function: This wires everything together to make a crossbar
//

`include "define.tmp.h"
// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml

module io_xbar_top(clk,
		    reset_in,
        dataIn_0, dataIn_1, dataIn_2, dataIn_3, dataIn_4, dataIn_5, dataIn_6, dataIn_7, 
        validIn_0, validIn_1, validIn_2, validIn_3, validIn_4, validIn_5, validIn_6, validIn_7, 
        yummyIn_0,yummyIn_1,yummyIn_2,yummyIn_3,yummyIn_4,yummyIn_5,yummyIn_6,yummyIn_7,
		    myLocX,
		    myLocY,
            myChipID,
		    store_meter_partner_address_X,
		    store_meter_partner_address_Y,
		    ec_cfg,
        dataOut_0, dataOut_1, dataOut_2, dataOut_3, dataOut_4, dataOut_5, dataOut_6, dataOut_7, 
        validOut_0, validOut_1, validOut_2, validOut_3, validOut_4, validOut_5, validOut_6, validOut_7, 
        yummyOut_0,yummyOut_1,yummyOut_2,yummyOut_3,yummyOut_4,yummyOut_5,yummyOut_6,yummyOut_7,
		    thanksIn_7,
		    external_interrupt,
		    store_meter_ack_partner,
		    store_meter_ack_non_partner,
		    ec_out);

// begin port declarations

input clk;
input reset_in;

input [`DATA_WIDTH-1:0] dataIn_0;
input [`DATA_WIDTH-1:0] dataIn_1;
input [`DATA_WIDTH-1:0] dataIn_2;
input [`DATA_WIDTH-1:0] dataIn_3;
input [`DATA_WIDTH-1:0] dataIn_4;
input [`DATA_WIDTH-1:0] dataIn_5;
input [`DATA_WIDTH-1:0] dataIn_6;
input [`DATA_WIDTH-1:0] dataIn_7;

input validIn_0;
input validIn_1;
input validIn_2;
input validIn_3;
input validIn_4;
input validIn_5;
input validIn_6;
input validIn_7;

input yummyIn_0;
input yummyIn_1;
input yummyIn_2;
input yummyIn_3;
input yummyIn_4;
input yummyIn_5;
input yummyIn_6;
input yummyIn_7;

/*
//original 
input [`DATA_WIDTH-1:0] dataIn_N;	// data inputs from neighboring tiles
input [`DATA_WIDTH-1:0] dataIn_E;
input [`DATA_WIDTH-1:0] dataIn_S;
input [`DATA_WIDTH-1:0] dataIn_W;
input [`DATA_WIDTH-1:0] dataIn_P;	// data input from processor
   
input validIn_N;		// valid signals from neighboring tiles
input validIn_E;
input validIn_S;
input validIn_W;
input validIn_P;		// valid signal from processor
   
input yummyIn_N;		// neighbor consumed output data
input yummyIn_E;
input yummyIn_S;
input yummyIn_W;
input yummyIn_P;		// processor consumed output data
*/   
input [`XY_WIDTH-1:0] myLocX;		// this tile's position
input [`XY_WIDTH-1:0] myLocY;
input [`CHIP_ID_WIDTH-1:0] myChipID;

input [4:0] store_meter_partner_address_X;
input [4:0] store_meter_partner_address_Y;

input [31:0] ec_cfg;            // NESWP 3 bits each selecter of event to monitor

output [`DATA_WIDTH-1:0] dataOut_0;
output [`DATA_WIDTH-1:0] dataOut_1;
output [`DATA_WIDTH-1:0] dataOut_2;
output [`DATA_WIDTH-1:0] dataOut_3;
output [`DATA_WIDTH-1:0] dataOut_4;
output [`DATA_WIDTH-1:0] dataOut_5;
output [`DATA_WIDTH-1:0] dataOut_6;
output [`DATA_WIDTH-1:0] dataOut_7;

output validOut_0;
output validOut_1;
output validOut_2;
output validOut_3;
output validOut_4;
output validOut_5;
output validOut_6;
output validOut_7;

output yummyOut_0;
output yummyOut_1;
output yummyOut_2;
output yummyOut_3;
output yummyOut_4;
output yummyOut_5;
output yummyOut_6;
output yummyOut_7;

/*
//original
output [`DATA_WIDTH-1:0] dataOut_N;	// data outputs to neighbors
output [`DATA_WIDTH-1:0] dataOut_E;
output [`DATA_WIDTH-1:0] dataOut_S;
output [`DATA_WIDTH-1:0] dataOut_W;
output [`DATA_WIDTH-1:0] dataOut_P;	// data output to processor

output validOut_N;		// valid outputs to neighbors
output validOut_E;
output validOut_S;
output validOut_W;
output validOut_P;		// valid output to processor
   
output yummyOut_N;		// yummy signal to neighbors' output buffers
output yummyOut_E;
output yummyOut_S;
output yummyOut_W;
output yummyOut_P;		// yummy signal to processor's output buffer
*/
output thanksIn_7;		// thanksIn to processor's space_avail

output external_interrupt;	//is used for the proc to know
				//that an external interrupt occured
output store_meter_ack_partner;      // strobes high when a memory ack word is popped off of the network
                                     // and the sender ID matches the "partner port" id from the STORE_METER
output store_meter_ack_non_partner;  // strobes high when a memory ack word is popped off of the network
                                     // and the sender ID does not match the "partner port" id from the STORE_METER


output [7:0] ec_out;

wire   ec_wants_to_send_but_cannot_0;
wire   ec_wants_to_send_but_cannot_1;
wire   ec_wants_to_send_but_cannot_2;
wire   ec_wants_to_send_but_cannot_3;
wire   ec_wants_to_send_but_cannot_4;
wire   ec_wants_to_send_but_cannot_5;
wire   ec_wants_to_send_but_cannot_6;
wire   ec_wants_to_send_but_cannot_7;

// end port declarations

   wire store_ack_received;
   wire store_ack_received_r;
   wire [9:0] store_ack_addr;
   wire [9:0] store_ack_addr_r;

//wires
wire node_0_input_tail;
wire node_1_input_tail;
wire node_2_input_tail;
wire node_3_input_tail;
wire node_4_input_tail;
wire node_5_input_tail;
wire node_6_input_tail;
wire node_7_input_tail;

wire [`DATA_WIDTH-1:0] node_0_input_data;
wire [`DATA_WIDTH-1:0] node_1_input_data;
wire [`DATA_WIDTH-1:0] node_2_input_data;
wire [`DATA_WIDTH-1:0] node_3_input_data;
wire [`DATA_WIDTH-1:0] node_4_input_data;
wire [`DATA_WIDTH-1:0] node_5_input_data;
wire [`DATA_WIDTH-1:0] node_6_input_data;
wire [`DATA_WIDTH-1:0] node_7_input_data;

wire node_0_input_valid;
wire node_1_input_valid;
wire node_2_input_valid;
wire node_3_input_valid;
wire node_4_input_valid;
wire node_5_input_valid;
wire node_6_input_valid;
wire node_7_input_valid;

wire thanks_0_to_0;
wire thanks_0_to_1;
wire thanks_0_to_2;
wire thanks_0_to_3;
wire thanks_0_to_4;
wire thanks_0_to_5;
wire thanks_0_to_6;
wire thanks_0_to_7;

wire thanks_1_to_0;
wire thanks_1_to_1;
wire thanks_1_to_2;
wire thanks_1_to_3;
wire thanks_1_to_4;
wire thanks_1_to_5;
wire thanks_1_to_6;
wire thanks_1_to_7;

wire thanks_2_to_0;
wire thanks_2_to_1;
wire thanks_2_to_2;
wire thanks_2_to_3;
wire thanks_2_to_4;
wire thanks_2_to_5;
wire thanks_2_to_6;
wire thanks_2_to_7;

wire thanks_3_to_0;
wire thanks_3_to_1;
wire thanks_3_to_2;
wire thanks_3_to_3;
wire thanks_3_to_4;
wire thanks_3_to_5;
wire thanks_3_to_6;
wire thanks_3_to_7;

wire thanks_4_to_0;
wire thanks_4_to_1;
wire thanks_4_to_2;
wire thanks_4_to_3;
wire thanks_4_to_4;
wire thanks_4_to_5;
wire thanks_4_to_6;
wire thanks_4_to_7;

wire thanks_5_to_0;
wire thanks_5_to_1;
wire thanks_5_to_2;
wire thanks_5_to_3;
wire thanks_5_to_4;
wire thanks_5_to_5;
wire thanks_5_to_6;
wire thanks_5_to_7;

wire thanks_6_to_0;
wire thanks_6_to_1;
wire thanks_6_to_2;
wire thanks_6_to_3;
wire thanks_6_to_4;
wire thanks_6_to_5;
wire thanks_6_to_6;
wire thanks_6_to_7;

wire thanks_7_to_0;
wire thanks_7_to_1;
wire thanks_7_to_2;
wire thanks_7_to_3;
wire thanks_7_to_4;
wire thanks_7_to_5;
wire thanks_7_to_6;
wire thanks_7_to_7;

wire route_req_0_to_0;
wire route_req_0_to_1;
wire route_req_0_to_2;
wire route_req_0_to_3;
wire route_req_0_to_4;
wire route_req_0_to_5;
wire route_req_0_to_6;
wire route_req_0_to_7;

wire route_req_1_to_0;
wire route_req_1_to_1;
wire route_req_1_to_2;
wire route_req_1_to_3;
wire route_req_1_to_4;
wire route_req_1_to_5;
wire route_req_1_to_6;
wire route_req_1_to_7;

wire route_req_2_to_0;
wire route_req_2_to_1;
wire route_req_2_to_2;
wire route_req_2_to_3;
wire route_req_2_to_4;
wire route_req_2_to_5;
wire route_req_2_to_6;
wire route_req_2_to_7;

wire route_req_3_to_0;
wire route_req_3_to_1;
wire route_req_3_to_2;
wire route_req_3_to_3;
wire route_req_3_to_4;
wire route_req_3_to_5;
wire route_req_3_to_6;
wire route_req_3_to_7;

wire route_req_4_to_0;
wire route_req_4_to_1;
wire route_req_4_to_2;
wire route_req_4_to_3;
wire route_req_4_to_4;
wire route_req_4_to_5;
wire route_req_4_to_6;
wire route_req_4_to_7;

wire route_req_5_to_0;
wire route_req_5_to_1;
wire route_req_5_to_2;
wire route_req_5_to_3;
wire route_req_5_to_4;
wire route_req_5_to_5;
wire route_req_5_to_6;
wire route_req_5_to_7;

wire route_req_6_to_0;
wire route_req_6_to_1;
wire route_req_6_to_2;
wire route_req_6_to_3;
wire route_req_6_to_4;
wire route_req_6_to_5;
wire route_req_6_to_6;
wire route_req_6_to_7;

wire route_req_7_to_0;
wire route_req_7_to_1;
wire route_req_7_to_2;
wire route_req_7_to_3;
wire route_req_7_to_4;
wire route_req_7_to_5;
wire route_req_7_to_6;
wire route_req_7_to_7;

wire default_ready_3_to_0;
wire default_ready_4_to_1;
wire default_ready_5_to_2;
wire default_ready_6_to_3;
wire default_ready_0_to_4;
wire default_ready_1_to_5;
wire default_ready_2_to_6;
wire default_ready_3_to_7;

wire yummyOut_0_internal;
wire yummyOut_1_internal;
wire yummyOut_2_internal;
wire yummyOut_3_internal;
wire yummyOut_4_internal;
wire yummyOut_5_internal;
wire yummyOut_6_internal;
wire yummyOut_7_internal;

wire validOut_0_internal;
wire validOut_1_internal;
wire validOut_2_internal;
wire validOut_3_internal;
wire validOut_4_internal;
wire validOut_5_internal;
wire validOut_6_internal;
wire validOut_7_internal;

wire [`DATA_WIDTH-1:0] dataOut_0_internal;
wire [`DATA_WIDTH-1:0] dataOut_1_internal;
wire [`DATA_WIDTH-1:0] dataOut_2_internal;
wire [`DATA_WIDTH-1:0] dataOut_3_internal;
wire [`DATA_WIDTH-1:0] dataOut_4_internal;
wire [`DATA_WIDTH-1:0] dataOut_5_internal;
wire [`DATA_WIDTH-1:0] dataOut_6_internal;
wire [`DATA_WIDTH-1:0] dataOut_7_internal;

wire yummyOut_0_flip1_out;
wire yummyOut_1_flip1_out;
wire yummyOut_2_flip1_out;
wire yummyOut_3_flip1_out;
wire yummyOut_4_flip1_out;
wire yummyOut_5_flip1_out;
wire yummyOut_6_flip1_out;

wire validOut_0_flip1_out;
wire validOut_1_flip1_out;
wire validOut_2_flip1_out;
wire validOut_3_flip1_out;
wire validOut_4_flip1_out;
wire validOut_5_flip1_out;
wire validOut_6_flip1_out;

wire [`DATA_WIDTH-1:0] dataOut_0_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_1_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_2_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_3_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_4_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_5_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_6_flip1_out;

wire yummyIn_0_internal;
wire yummyIn_1_internal;
wire yummyIn_2_internal;
wire yummyIn_3_internal;
wire yummyIn_4_internal;
wire yummyIn_5_internal;
wire yummyIn_6_internal;
wire yummyIn_7_internal;

wire validIn_0_internal;
wire validIn_1_internal;
wire validIn_2_internal;
wire validIn_3_internal;
wire validIn_4_internal;
wire validIn_5_internal;
wire validIn_6_internal;

wire [`DATA_WIDTH-1:0] dataIn_0_internal;
wire [`DATA_WIDTH-1:0] dataIn_1_internal;
wire [`DATA_WIDTH-1:0] dataIn_2_internal;
wire [`DATA_WIDTH-1:0] dataIn_3_internal;
wire [`DATA_WIDTH-1:0] dataIn_4_internal;
wire [`DATA_WIDTH-1:0] dataIn_5_internal;
wire [`DATA_WIDTH-1:0] dataIn_6_internal;

wire yummyIn_0_flip1_out;
wire yummyIn_1_flip1_out;
wire yummyIn_2_flip1_out;
wire yummyIn_3_flip1_out;
wire yummyIn_4_flip1_out;
wire yummyIn_5_flip1_out;
wire yummyIn_6_flip1_out;

wire validIn_0_flip1_out;
wire validIn_1_flip1_out;
wire validIn_2_flip1_out;
wire validIn_3_flip1_out;
wire validIn_4_flip1_out;
wire validIn_5_flip1_out;
wire validIn_6_flip1_out;

wire [`DATA_WIDTH-1:0] dataIn_0_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_1_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_2_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_3_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_4_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_5_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_6_flip1_out;

/*
//original
wire default_ready_n_to_s;
wire default_ready_e_to_w;
wire default_ready_s_to_n;
wire default_ready_s_to_p;
wire default_ready_w_to_e;

// input/output buffered signals
wire yummyOut_N_internal;
wire yummyOut_E_internal;
wire yummyOut_S_internal;
wire yummyOut_W_internal;
wire yummyOut_P_internal;

wire validOut_N_internal;
wire validOut_E_internal;
wire validOut_S_internal;
wire validOut_W_internal;
wire validOut_P_internal;

wire [`DATA_WIDTH-1:0] dataOut_N_internal;
wire [`DATA_WIDTH-1:0] dataOut_E_internal;
wire [`DATA_WIDTH-1:0] dataOut_S_internal;
wire [`DATA_WIDTH-1:0] dataOut_W_internal;
wire [`DATA_WIDTH-1:0] dataOut_P_internal;

wire yummyOut_N_flip1_out;
wire yummyOut_E_flip1_out;
wire yummyOut_S_flip1_out;
wire yummyOut_W_flip1_out;
//wire yummyOut_P_flip1_out;

wire validOut_N_flip1_out;
wire validOut_E_flip1_out;
wire validOut_S_flip1_out;
wire validOut_W_flip1_out;
//wire validOut_P_flip1_out;

wire [`DATA_WIDTH-1:0] dataOut_N_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_E_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_S_flip1_out;
wire [`DATA_WIDTH-1:0] dataOut_W_flip1_out;
//wire [`DATA_WIDTH-1:0] dataOut_P_flip1_out;

wire yummyIn_N_internal;
wire yummyIn_E_internal;
wire yummyIn_S_internal;
wire yummyIn_W_internal;
wire yummyIn_P_internal;

wire validIn_N_internal;
wire validIn_E_internal;
wire validIn_S_internal;
wire validIn_W_internal;
//wire validIn_P_internal;

wire [`DATA_WIDTH-1:0] dataIn_N_internal;
wire [`DATA_WIDTH-1:0] dataIn_E_internal;
wire [`DATA_WIDTH-1:0] dataIn_S_internal;
wire [`DATA_WIDTH-1:0] dataIn_W_internal;
//wire [`DATA_WIDTH-1:0] dataIn_P_internal;

wire yummyIn_N_flip1_out;
wire yummyIn_E_flip1_out;
wire yummyIn_S_flip1_out;
wire yummyIn_W_flip1_out;
//wire yummyIn_P_flip1_out;

wire validIn_N_flip1_out;
wire validIn_E_flip1_out;
wire validIn_S_flip1_out;
wire validIn_W_flip1_out;
//wire validIn_P_flip1_out;

wire [`DATA_WIDTH-1:0] dataIn_N_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_E_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_S_flip1_out;
wire [`DATA_WIDTH-1:0] dataIn_W_flip1_out;
//wire [`DATA_WIDTH-1:0] dataIn_P_flip1_out;
*/
//state
reg [`XY_WIDTH-1:0] myLocX_f;
reg [`XY_WIDTH-1:0] myLocY_f;
reg [`CHIP_ID_WIDTH-1:0] myChipID_f;
wire   reset;


// event counter logic
//
//
reg ec_thanks_0_to_0_reg, ec_thanks_0_to_1_reg, ec_thanks_0_to_2_reg, ec_thanks_0_to_3_reg, ec_thanks_0_to_4_reg, ec_thanks_0_to_5_reg, ec_thanks_0_to_6_reg, ec_thanks_0_to_7_reg;
reg ec_thanks_1_to_0_reg, ec_thanks_1_to_1_reg, ec_thanks_1_to_2_reg, ec_thanks_1_to_3_reg, ec_thanks_1_to_4_reg, ec_thanks_1_to_5_reg, ec_thanks_1_to_6_reg, ec_thanks_1_to_7_reg;
reg ec_thanks_2_to_0_reg, ec_thanks_2_to_1_reg, ec_thanks_2_to_2_reg, ec_thanks_2_to_3_reg, ec_thanks_2_to_4_reg, ec_thanks_2_to_5_reg, ec_thanks_2_to_6_reg, ec_thanks_2_to_7_reg;
reg ec_thanks_3_to_0_reg, ec_thanks_3_to_1_reg, ec_thanks_3_to_2_reg, ec_thanks_3_to_3_reg, ec_thanks_3_to_4_reg, ec_thanks_3_to_5_reg, ec_thanks_3_to_6_reg, ec_thanks_3_to_7_reg;
reg ec_thanks_4_to_0_reg, ec_thanks_4_to_1_reg, ec_thanks_4_to_2_reg, ec_thanks_4_to_3_reg, ec_thanks_4_to_4_reg, ec_thanks_4_to_5_reg, ec_thanks_4_to_6_reg, ec_thanks_4_to_7_reg;
reg ec_thanks_5_to_0_reg, ec_thanks_5_to_1_reg, ec_thanks_5_to_2_reg, ec_thanks_5_to_3_reg, ec_thanks_5_to_4_reg, ec_thanks_5_to_5_reg, ec_thanks_5_to_6_reg, ec_thanks_5_to_7_reg;
reg ec_thanks_6_to_0_reg, ec_thanks_6_to_1_reg, ec_thanks_6_to_2_reg, ec_thanks_6_to_3_reg, ec_thanks_6_to_4_reg, ec_thanks_6_to_5_reg, ec_thanks_6_to_6_reg, ec_thanks_6_to_7_reg;
reg ec_thanks_7_to_0_reg, ec_thanks_7_to_1_reg, ec_thanks_7_to_2_reg, ec_thanks_7_to_3_reg, ec_thanks_7_to_4_reg, ec_thanks_7_to_5_reg, ec_thanks_7_to_6_reg, ec_thanks_7_to_7_reg;
reg ec_wants_to_send_but_cannot_0_reg, ec_wants_to_send_but_cannot_1_reg, ec_wants_to_send_but_cannot_2_reg, ec_wants_to_send_but_cannot_3_reg, ec_wants_to_send_but_cannot_4_reg, ec_wants_to_send_but_cannot_5_reg, ec_wants_to_send_but_cannot_6_reg, ec_wants_to_send_but_cannot_7_reg;
reg ec_0_input_valid_reg, ec_1_input_valid_reg, ec_2_input_valid_reg, ec_3_input_valid_reg, ec_4_input_valid_reg, ec_5_input_valid_reg, ec_6_input_valid_reg, ec_7_input_valid_reg;

/*
//original
reg ec_thanks_n_to_n_reg, ec_thanks_n_to_e_reg, ec_thanks_n_to_s_reg, ec_thanks_n_to_w_reg, ec_thanks_n_to_p_reg;
reg ec_thanks_e_to_n_reg, ec_thanks_e_to_e_reg, ec_thanks_e_to_s_reg, ec_thanks_e_to_w_reg, ec_thanks_e_to_p_reg;
reg ec_thanks_s_to_n_reg, ec_thanks_s_to_e_reg, ec_thanks_s_to_s_reg, ec_thanks_s_to_w_reg, ec_thanks_s_to_p_reg;
reg ec_thanks_w_to_n_reg, ec_thanks_w_to_e_reg, ec_thanks_w_to_s_reg, ec_thanks_w_to_w_reg, ec_thanks_w_to_p_reg;
reg ec_thanks_p_to_n_reg, ec_thanks_p_to_e_reg, ec_thanks_p_to_s_reg, ec_thanks_p_to_w_reg, ec_thanks_p_to_p_reg;
reg ec_wants_to_send_but_cannot_N_reg, ec_wants_to_send_but_cannot_E_reg, ec_wants_to_send_but_cannot_S_reg, ec_wants_to_send_but_cannot_W_reg, ec_wants_to_send_but_cannot_P_reg;
reg ec_north_input_valid_reg, ec_east_input_valid_reg, ec_south_input_valid_reg, ec_west_input_valid_reg, ec_proc_input_valid_reg;
*/

// let's register these babies before they do any damage to the cycle time -- mbt
always @(posedge clk)
  begin
    
    ec_thanks_0_to_0_reg <= thanks_0_to_0; ec_thanks_0_to_1_reg <= thanks_0_to_1; ec_thanks_0_to_2_reg <= thanks_0_to_2; ec_thanks_0_to_3_reg <= thanks_0_to_3; ec_thanks_0_to_4_reg <= thanks_0_to_4; ec_thanks_0_to_5_reg <= thanks_0_to_5; ec_thanks_0_to_6_reg <= thanks_0_to_6; ec_thanks_0_to_7_reg <= thanks_0_to_7;
    ec_thanks_1_to_0_reg <= thanks_1_to_0; ec_thanks_1_to_1_reg <= thanks_1_to_1; ec_thanks_1_to_2_reg <= thanks_1_to_2; ec_thanks_1_to_3_reg <= thanks_1_to_3; ec_thanks_1_to_4_reg <= thanks_1_to_4; ec_thanks_1_to_5_reg <= thanks_1_to_5; ec_thanks_1_to_6_reg <= thanks_1_to_6; ec_thanks_1_to_7_reg <= thanks_1_to_7;
    ec_thanks_2_to_0_reg <= thanks_2_to_0; ec_thanks_2_to_1_reg <= thanks_2_to_1; ec_thanks_2_to_2_reg <= thanks_2_to_2; ec_thanks_2_to_3_reg <= thanks_2_to_3; ec_thanks_2_to_4_reg <= thanks_2_to_4; ec_thanks_2_to_5_reg <= thanks_2_to_5; ec_thanks_2_to_6_reg <= thanks_2_to_6; ec_thanks_2_to_7_reg <= thanks_2_to_7;
    ec_thanks_3_to_0_reg <= thanks_3_to_0; ec_thanks_3_to_1_reg <= thanks_3_to_1; ec_thanks_3_to_2_reg <= thanks_3_to_2; ec_thanks_3_to_3_reg <= thanks_3_to_3; ec_thanks_3_to_4_reg <= thanks_3_to_4; ec_thanks_3_to_5_reg <= thanks_3_to_5; ec_thanks_3_to_6_reg <= thanks_3_to_6; ec_thanks_3_to_7_reg <= thanks_3_to_7;
    ec_thanks_4_to_0_reg <= thanks_4_to_0; ec_thanks_4_to_1_reg <= thanks_4_to_1; ec_thanks_4_to_2_reg <= thanks_4_to_2; ec_thanks_4_to_3_reg <= thanks_4_to_3; ec_thanks_4_to_4_reg <= thanks_4_to_4; ec_thanks_4_to_5_reg <= thanks_4_to_5; ec_thanks_4_to_6_reg <= thanks_4_to_6; ec_thanks_4_to_7_reg <= thanks_4_to_7;
    ec_thanks_5_to_0_reg <= thanks_5_to_0; ec_thanks_5_to_1_reg <= thanks_5_to_1; ec_thanks_5_to_2_reg <= thanks_5_to_2; ec_thanks_5_to_3_reg <= thanks_5_to_3; ec_thanks_5_to_4_reg <= thanks_5_to_4; ec_thanks_5_to_5_reg <= thanks_5_to_5; ec_thanks_5_to_6_reg <= thanks_5_to_6; ec_thanks_5_to_7_reg <= thanks_5_to_7;
    ec_thanks_6_to_0_reg <= thanks_6_to_0; ec_thanks_6_to_1_reg <= thanks_6_to_1; ec_thanks_6_to_2_reg <= thanks_6_to_2; ec_thanks_6_to_3_reg <= thanks_6_to_3; ec_thanks_6_to_4_reg <= thanks_6_to_4; ec_thanks_6_to_5_reg <= thanks_6_to_5; ec_thanks_6_to_6_reg <= thanks_6_to_6; ec_thanks_6_to_7_reg <= thanks_6_to_7;
    ec_thanks_7_to_0_reg <= thanks_7_to_0; ec_thanks_7_to_1_reg <= thanks_7_to_1; ec_thanks_7_to_2_reg <= thanks_7_to_2; ec_thanks_7_to_3_reg <= thanks_7_to_3; ec_thanks_7_to_4_reg <= thanks_7_to_4; ec_thanks_7_to_5_reg <= thanks_7_to_5; ec_thanks_7_to_6_reg <= thanks_7_to_6; ec_thanks_7_to_7_reg <= thanks_7_to_7;
    ec_wants_to_send_but_cannot_0_reg <= ec_wants_to_send_but_cannot_0;
    ec_wants_to_send_but_cannot_1_reg <= ec_wants_to_send_but_cannot_1;
    ec_wants_to_send_but_cannot_2_reg <= ec_wants_to_send_but_cannot_2;
    ec_wants_to_send_but_cannot_3_reg <= ec_wants_to_send_but_cannot_3;
    ec_wants_to_send_but_cannot_4_reg <= ec_wants_to_send_but_cannot_4;
    ec_wants_to_send_but_cannot_5_reg <= ec_wants_to_send_but_cannot_5;
    ec_wants_to_send_but_cannot_6_reg <= ec_wants_to_send_but_cannot_6;
    ec_wants_to_send_but_cannot_7_reg <= ec_wants_to_send_but_cannot_7;
    ec_0_input_valid_reg <= node_0_input_valid;
    ec_1_input_valid_reg <= node_1_input_valid;
    ec_2_input_valid_reg <= node_2_input_valid;
    ec_3_input_valid_reg <= node_3_input_valid;
    ec_4_input_valid_reg <= node_4_input_valid;
    ec_5_input_valid_reg <= node_5_input_valid;
    ec_6_input_valid_reg <= node_6_input_valid;
    ec_7_input_valid_reg <= node_7_input_valid;

    /*
    //original
     ec_thanks_n_to_n_reg <= thanks_n_to_n; ec_thanks_n_to_e_reg <= thanks_n_to_e; ec_thanks_n_to_s_reg <= thanks_n_to_s; ec_thanks_n_to_w_reg <= thanks_n_to_w; ec_thanks_n_to_p_reg <= thanks_n_to_p;
     ec_thanks_e_to_n_reg <= thanks_e_to_n; ec_thanks_e_to_e_reg <= thanks_e_to_e; ec_thanks_e_to_s_reg <= thanks_e_to_s; ec_thanks_e_to_w_reg <= thanks_e_to_w; ec_thanks_e_to_p_reg <= thanks_e_to_p;
     ec_thanks_s_to_n_reg <= thanks_s_to_n; ec_thanks_s_to_e_reg <= thanks_s_to_e; ec_thanks_s_to_s_reg <= thanks_s_to_s; ec_thanks_s_to_w_reg <= thanks_s_to_w; ec_thanks_s_to_p_reg <= thanks_s_to_p;
     ec_thanks_w_to_n_reg <= thanks_w_to_n; ec_thanks_w_to_e_reg <= thanks_w_to_e; ec_thanks_w_to_s_reg <= thanks_w_to_s; ec_thanks_w_to_w_reg <= thanks_w_to_w; ec_thanks_w_to_p_reg <= thanks_w_to_p;
     ec_thanks_p_to_n_reg <= thanks_p_to_n; ec_thanks_p_to_e_reg <= thanks_p_to_e; ec_thanks_p_to_s_reg <= thanks_p_to_s; ec_thanks_p_to_w_reg <= thanks_p_to_w; ec_thanks_p_to_p_reg <= thanks_p_to_p;
     ec_wants_to_send_but_cannot_N_reg <= ec_wants_to_send_but_cannot_N;
     ec_wants_to_send_but_cannot_E_reg <= ec_wants_to_send_but_cannot_E;
     ec_wants_to_send_but_cannot_S_reg <= ec_wants_to_send_but_cannot_S;
     ec_wants_to_send_but_cannot_W_reg <= ec_wants_to_send_but_cannot_W;
     ec_wants_to_send_but_cannot_P_reg <= ec_wants_to_send_but_cannot_P;
     ec_north_input_valid_reg <= north_input_valid;
     ec_east_input_valid_reg  <= east_input_valid;
     ec_south_input_valid_reg <= south_input_valid;
     ec_west_input_valid_reg  <= west_input_valid;
     ec_proc_input_valid_reg  <= proc_input_valid;
    */
  end

wire ec_thanks_to_0= ec_thanks_0_to_0_reg | ec_thanks_1_to_0_reg | ec_thanks_2_to_0_reg | ec_thanks_3_to_0_reg | ec_thanks_4_to_0_reg | ec_thanks_5_to_0_reg | ec_thanks_6_to_0_reg | ec_thanks_7_to_0_reg ;
wire ec_thanks_to_1= ec_thanks_0_to_1_reg | ec_thanks_1_to_1_reg | ec_thanks_2_to_1_reg | ec_thanks_3_to_1_reg | ec_thanks_4_to_1_reg | ec_thanks_5_to_1_reg | ec_thanks_6_to_1_reg | ec_thanks_7_to_1_reg ;
wire ec_thanks_to_2= ec_thanks_0_to_2_reg | ec_thanks_1_to_2_reg | ec_thanks_2_to_2_reg | ec_thanks_3_to_2_reg | ec_thanks_4_to_2_reg | ec_thanks_5_to_2_reg | ec_thanks_6_to_2_reg | ec_thanks_7_to_2_reg ;
wire ec_thanks_to_3= ec_thanks_0_to_3_reg | ec_thanks_1_to_3_reg | ec_thanks_2_to_3_reg | ec_thanks_3_to_3_reg | ec_thanks_4_to_3_reg | ec_thanks_5_to_3_reg | ec_thanks_6_to_3_reg | ec_thanks_7_to_3_reg ;
wire ec_thanks_to_4= ec_thanks_0_to_4_reg | ec_thanks_1_to_4_reg | ec_thanks_2_to_4_reg | ec_thanks_3_to_4_reg | ec_thanks_4_to_4_reg | ec_thanks_5_to_4_reg | ec_thanks_6_to_4_reg | ec_thanks_7_to_4_reg ;
wire ec_thanks_to_5= ec_thanks_0_to_5_reg | ec_thanks_1_to_5_reg | ec_thanks_2_to_5_reg | ec_thanks_3_to_5_reg | ec_thanks_4_to_5_reg | ec_thanks_5_to_5_reg | ec_thanks_6_to_5_reg | ec_thanks_7_to_5_reg ;
wire ec_thanks_to_6= ec_thanks_0_to_6_reg | ec_thanks_1_to_6_reg | ec_thanks_2_to_6_reg | ec_thanks_3_to_6_reg | ec_thanks_4_to_6_reg | ec_thanks_5_to_6_reg | ec_thanks_6_to_6_reg | ec_thanks_7_to_6_reg ;
wire ec_thanks_to_7= ec_thanks_0_to_7_reg | ec_thanks_1_to_7_reg | ec_thanks_2_to_7_reg | ec_thanks_3_to_7_reg | ec_thanks_4_to_7_reg | ec_thanks_5_to_7_reg | ec_thanks_6_to_7_reg | ec_thanks_7_to_7_reg ;

/*
//original
   wire ec_thanks_to_n = ec_thanks_n_to_n_reg | ec_thanks_e_to_n_reg | ec_thanks_s_to_n_reg | ec_thanks_w_to_n_reg | ec_thanks_p_to_n_reg;
   wire ec_thanks_to_e = ec_thanks_n_to_e_reg | ec_thanks_e_to_e_reg | ec_thanks_s_to_e_reg | ec_thanks_w_to_e_reg | ec_thanks_p_to_e_reg;
   wire ec_thanks_to_s = ec_thanks_n_to_s_reg | ec_thanks_e_to_s_reg | ec_thanks_s_to_s_reg | ec_thanks_w_to_s_reg | ec_thanks_p_to_s_reg;
   wire ec_thanks_to_w = ec_thanks_n_to_w_reg | ec_thanks_e_to_w_reg | ec_thanks_s_to_w_reg | ec_thanks_w_to_w_reg | ec_thanks_p_to_w_reg;
   wire ec_thanks_to_p = ec_thanks_n_to_p_reg | ec_thanks_e_to_p_reg | ec_thanks_s_to_p_reg | ec_thanks_w_to_p_reg | ec_thanks_p_to_p_reg;
*/
io_xbar_one_of_n_plus_3 #(1) ec_mux_0(.in0(ec_wants_to_send_but_cannot_0),
                        .in1(ec_thanks_7_to_0_reg),
                        .in2(ec_thanks_6_to_0_reg),
                        .in3(ec_thanks_5_to_0_reg),
                        .in4(ec_thanks_4_to_0_reg),
                        .in5(ec_thanks_3_to_0_reg),
                        .in6(ec_thanks_2_to_0_reg),
                        .in7(ec_thanks_1_to_0_reg),
                        .in8(ec_thanks_0_to_0_reg),
                        .in9(ec_thanks_to_0),
                        .in10(ec_0_input_valid_reg & ~ec_thanks_to_0),
                        .sel(ec_cfg[31:28]),
                        .out(ec_out[7]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_1(.in0(ec_wants_to_send_but_cannot_1),
                        .in1(ec_thanks_7_to_1_reg),
                        .in2(ec_thanks_6_to_1_reg),
                        .in3(ec_thanks_5_to_1_reg),
                        .in4(ec_thanks_4_to_1_reg),
                        .in5(ec_thanks_3_to_1_reg),
                        .in6(ec_thanks_2_to_1_reg),
                        .in7(ec_thanks_1_to_1_reg),
                        .in8(ec_thanks_0_to_1_reg),
                        .in9(ec_thanks_to_1),
                        .in10(ec_1_input_valid_reg & ~ec_thanks_to_1),
                        .sel(ec_cfg[27:24]),
                        .out(ec_out[6]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_2(.in0(ec_wants_to_send_but_cannot_2),
                        .in1(ec_thanks_7_to_2_reg),
                        .in2(ec_thanks_6_to_2_reg),
                        .in3(ec_thanks_5_to_2_reg),
                        .in4(ec_thanks_4_to_2_reg),
                        .in5(ec_thanks_3_to_2_reg),
                        .in6(ec_thanks_2_to_2_reg),
                        .in7(ec_thanks_1_to_2_reg),
                        .in8(ec_thanks_0_to_2_reg),
                        .in9(ec_thanks_to_2),
                        .in10(ec_2_input_valid_reg & ~ec_thanks_to_2),
                        .sel(ec_cfg[23:20]),
                        .out(ec_out[5]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_3(.in0(ec_wants_to_send_but_cannot_3),
                        .in1(ec_thanks_7_to_3_reg),
                        .in2(ec_thanks_6_to_3_reg),
                        .in3(ec_thanks_5_to_3_reg),
                        .in4(ec_thanks_4_to_3_reg),
                        .in5(ec_thanks_3_to_3_reg),
                        .in6(ec_thanks_2_to_3_reg),
                        .in7(ec_thanks_1_to_3_reg),
                        .in8(ec_thanks_0_to_3_reg),
                        .in9(ec_thanks_to_3),
                        .in10(ec_3_input_valid_reg & ~ec_thanks_to_3),
                        .sel(ec_cfg[19:16]),
                        .out(ec_out[4]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_4(.in0(ec_wants_to_send_but_cannot_4),
                        .in1(ec_thanks_7_to_4_reg),
                        .in2(ec_thanks_6_to_4_reg),
                        .in3(ec_thanks_5_to_4_reg),
                        .in4(ec_thanks_4_to_4_reg),
                        .in5(ec_thanks_3_to_4_reg),
                        .in6(ec_thanks_2_to_4_reg),
                        .in7(ec_thanks_1_to_4_reg),
                        .in8(ec_thanks_0_to_4_reg),
                        .in9(ec_thanks_to_4),
                        .in10(ec_4_input_valid_reg & ~ec_thanks_to_4),
                        .sel(ec_cfg[15:12]),
                        .out(ec_out[3]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_5(.in0(ec_wants_to_send_but_cannot_5),
                        .in1(ec_thanks_7_to_5_reg),
                        .in2(ec_thanks_6_to_5_reg),
                        .in3(ec_thanks_5_to_5_reg),
                        .in4(ec_thanks_4_to_5_reg),
                        .in5(ec_thanks_3_to_5_reg),
                        .in6(ec_thanks_2_to_5_reg),
                        .in7(ec_thanks_1_to_5_reg),
                        .in8(ec_thanks_0_to_5_reg),
                        .in9(ec_thanks_to_5),
                        .in10(ec_5_input_valid_reg & ~ec_thanks_to_5),
                        .sel(ec_cfg[11:8]),
                        .out(ec_out[2]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_6(.in0(ec_wants_to_send_but_cannot_6),
                        .in1(ec_thanks_7_to_6_reg),
                        .in2(ec_thanks_6_to_6_reg),
                        .in3(ec_thanks_5_to_6_reg),
                        .in4(ec_thanks_4_to_6_reg),
                        .in5(ec_thanks_3_to_6_reg),
                        .in6(ec_thanks_2_to_6_reg),
                        .in7(ec_thanks_1_to_6_reg),
                        .in8(ec_thanks_0_to_6_reg),
                        .in9(ec_thanks_to_6),
                        .in10(ec_6_input_valid_reg & ~ec_thanks_to_6),
                        .sel(ec_cfg[7:4]),
                        .out(ec_out[1]));
io_xbar_one_of_n_plus_3 #(1) ec_mux_7(.in0(ec_wants_to_send_but_cannot_7),
                        .in1(ec_thanks_7_to_7_reg),
                        .in2(ec_thanks_6_to_7_reg),
                        .in3(ec_thanks_5_to_7_reg),
                        .in4(ec_thanks_4_to_7_reg),
                        .in5(ec_thanks_3_to_7_reg),
                        .in6(ec_thanks_2_to_7_reg),
                        .in7(ec_thanks_1_to_7_reg),
                        .in8(ec_thanks_0_to_7_reg),
                        .in9(ec_thanks_to_7),
                        .in10(ec_7_input_valid_reg & ~ec_thanks_to_7),
                        .sel(ec_cfg[3:0]),
                        .out(ec_out[0]));

/*
//original
one_of_eight #(1) ec_mux_north(.in0(ec_wants_to_send_but_cannot_N),
                        .in1(ec_thanks_p_to_n_reg),
                        .in2(ec_thanks_w_to_n_reg),
                        .in3(ec_thanks_s_to_n_reg),
                        .in4(ec_thanks_e_to_n_reg),
                        .in5(ec_thanks_n_to_n_reg),
                        .in6(ec_thanks_to_n),
                        .in7(ec_north_input_valid_reg & ~ec_thanks_to_n),
                        .sel(ec_cfg[14:12]),
                        .out(ec_out[4]));

one_of_eight #(1) ec_mux_east(.in0(ec_wants_to_send_but_cannot_E),
                       .in1(ec_thanks_p_to_e_reg),
                       .in2(ec_thanks_w_to_e_reg),
                       .in3(ec_thanks_s_to_e_reg),
                       .in4(ec_thanks_e_to_e_reg),
                       .in5(ec_thanks_n_to_e_reg),
                       .in6(ec_thanks_to_e),
                       .in7(ec_east_input_valid_reg & ~ec_thanks_to_e),
                       .sel(ec_cfg[11:9]),
                       .out(ec_out[3]));

one_of_eight #(1) ec_mux_south(.in0(ec_wants_to_send_but_cannot_S),
                        .in1(ec_thanks_p_to_s_reg),
                        .in2(ec_thanks_w_to_s_reg),
                        .in3(ec_thanks_s_to_s_reg),
                        .in4(ec_thanks_e_to_s_reg),
                        .in5(ec_thanks_n_to_s_reg),
                        .in6(ec_thanks_to_s),
                        .in7(ec_south_input_valid_reg & ~ec_thanks_to_s),
                        .sel(ec_cfg[8:6]),
                        .out(ec_out[2]));

one_of_eight #(1) ec_mux_west( .in0(ec_wants_to_send_but_cannot_W),
                        .in1(ec_thanks_p_to_w_reg),
                        .in2(ec_thanks_w_to_w_reg),
                        .in3(ec_thanks_s_to_w_reg),
                        .in4(ec_thanks_e_to_w_reg),
                        .in5(ec_thanks_n_to_w_reg),
                        .in6(ec_thanks_to_w),
                        .in7(ec_west_input_valid_reg & ~ec_thanks_to_w),
                        .sel(ec_cfg[5:3]),
                        .out(ec_out[1]));

one_of_eight #(1) ec_mux_proc( .in0(ec_wants_to_send_but_cannot_P),
                        .in1(ec_thanks_p_to_p_reg),
                        .in2(ec_thanks_w_to_p_reg),
                        .in3(ec_thanks_s_to_p_reg),
                        .in4(ec_thanks_e_to_p_reg),
                        .in5(ec_thanks_n_to_p_reg),
                        .in6(ec_thanks_to_p),
                        .in7(ec_proc_input_valid_reg & ~ec_thanks_to_p),
                        .sel(ec_cfg[2:0]),
                        .out(ec_out[0]));
*/
// end event counter logic

io_xbar_net_dff #(1) REG_reset_fin(.d(reset_in), .q(reset), .clk(clk));

io_xbar_net_dff #(10) REG_store_ack_addr(   .d(store_ack_addr),     .q(store_ack_addr_r),     .clk(clk));
io_xbar_net_dff #(1) REG_store_ack_received(.d(store_ack_received), .q(store_ack_received_r), .clk(clk));

   wire is_partner_address_v_r;
   io_xbar_bus_compare_equal #(10) CMP_partner_address (.a(store_ack_addr_r),
                                        .b({ store_meter_partner_address_Y, store_meter_partner_address_X } ),
                                        .bus_equal(is_partner_address_v_r));

   assign store_meter_ack_partner     = is_partner_address_v_r & store_ack_received_r;
   assign store_meter_ack_non_partner = ~is_partner_address_v_r & store_ack_received_r;

//make it so that the mdn_cfg location register has
//one cycle latency when being changed
//this was done so that these flops could be put near the
//dynamic network but this does mean that the cycle directly
//folowing a mtsr MDN_CFG which changes the location bits
//will still use the old value
//likewise it would be best to make sure there are no in-flight memory
//operations when setting the X and Y location for a tile.
always @ (posedge clk)
begin
        if(reset)
        begin
                myLocY_f <= `XY_WIDTH'd0;
                myLocX_f <= `XY_WIDTH'd0;
                myChipID_f <= `CHIP_ID_WIDTH'd0;
        end
        else
        begin
                myLocY_f <= myLocY;
                myLocX_f <= myLocX;
                myChipID_f <= myChipID;
        end
end

// mmckeown: Removing DUMMY modules
//dummy signals
/*`ifdef NO_DUMMY
`else
   rDUMMY #(1) default_ready_n_to_s_dummy (.A(default_ready_n_to_s));

   rDUMMY #(1) default_ready_e_to_w_dummy (.A(default_ready_e_to_w));

   rDUMMY #(1) default_ready_s_to_n_dummy (.A(default_ready_s_to_n));

   rDUMMY #(1) default_ready_s_to_p_dummy (.A(default_ready_s_to_p));

   rDUMMY #(1) default_ready_w_to_e_dummy (.A(default_ready_w_to_e));
`endif

//dummy signals for detecting the critical path for the valid and data signals
`ifdef NO_DUMMY
`else
   rDUMMY #(1) valid_out_north(.A(validOut_N_internal));
   rDUMMY #(1) valid_out_east(.A(validOut_E_internal));
   rDUMMY #(1) valid_out_south(.A(validOut_S_internal));
   rDUMMY #(1) valid_out_west(.A(validOut_W_internal));
   rDUMMY #(1) valid_out_proc(.A(validOut_P_internal));

   rDUMMY #(`DATA_WIDTH) data_out_north(.A(dataOut_N_internal));
   rDUMMY #(`DATA_WIDTH) data_out_east(.A(dataOut_E_internal));
   rDUMMY #(`DATA_WIDTH) data_out_south(.A(dataOut_S_internal));
   rDUMMY #(`DATA_WIDTH) data_out_west(.A(dataOut_W_internal));
   rDUMMY #(`DATA_WIDTH) data_out_proc(.A(dataOut_P_internal));
`endif*/

//wire regs

//assigns
assign thanksIn_7 = thanks_0_to_7 | thanks_1_to_7 | thanks_2_to_7 | thanks_3_to_7 | thanks_4_to_7 | thanks_5_to_7 | thanks_6_to_7 | thanks_7_to_7 ;

/*
//original
assign thanksIn_P = thanks_n_to_p | thanks_e_to_p | thanks_s_to_p | thanks_w_to_p | thanks_p_to_p;
*/
//assign validOut_N = validOut_N_internal;
//assign validOut_E = validOut_E_internal;
//assign validOut_S = validOut_S_internal;
//assign validOut_W = validOut_W_internal;
assign validOut_7 = validOut_7_internal;

//assign dataOut_N = dataOut_N_internal;
//assign dataOut_E = dataOut_E_internal;
//assign dataOut_S = dataOut_S_internal;
//assign dataOut_W = dataOut_W_internal;
assign dataOut_7 = dataOut_7_internal;

//more assigns
assign yummyIn_7_internal = yummyIn_7;
assign yummyOut_7 = yummyOut_7_internal;

io_xbar_flip_bus #(1, 14) yummyOut_0_flip1(yummyOut_0_internal, yummyOut_0_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_1_flip1(yummyOut_1_internal, yummyOut_1_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_2_flip1(yummyOut_2_internal, yummyOut_2_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_3_flip1(yummyOut_3_internal, yummyOut_3_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_4_flip1(yummyOut_4_internal, yummyOut_4_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_5_flip1(yummyOut_5_internal, yummyOut_5_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_6_flip1(yummyOut_6_internal, yummyOut_6_flip1_out);

io_xbar_flip_bus #(1, 21) yummyOut_0_flip2(yummyOut_0_flip1_out, yummyOut_0);
io_xbar_flip_bus #(1, 21) yummyOut_1_flip2(yummyOut_1_flip1_out, yummyOut_1);
io_xbar_flip_bus #(1, 21) yummyOut_2_flip2(yummyOut_2_flip1_out, yummyOut_2);
io_xbar_flip_bus #(1, 21) yummyOut_3_flip2(yummyOut_3_flip1_out, yummyOut_3);
io_xbar_flip_bus #(1, 21) yummyOut_4_flip2(yummyOut_4_flip1_out, yummyOut_4);
io_xbar_flip_bus #(1, 21) yummyOut_5_flip2(yummyOut_5_flip1_out, yummyOut_5);
io_xbar_flip_bus #(1, 21) yummyOut_6_flip2(yummyOut_6_flip1_out, yummyOut_6);

io_xbar_flip_bus #(1, 14) validOut_0_flip1(validOut_0_internal, validOut_0_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_1_flip1(validOut_1_internal, validOut_1_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_2_flip1(validOut_2_internal, validOut_2_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_3_flip1(validOut_3_internal, validOut_3_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_4_flip1(validOut_4_internal, validOut_4_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_5_flip1(validOut_5_internal, validOut_5_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_6_flip1(validOut_6_internal, validOut_6_flip1_out);

io_xbar_flip_bus #(1, 21) validOut_0_flip2(validOut_0_flip1_out, validOut_0);
io_xbar_flip_bus #(1, 21) validOut_1_flip2(validOut_1_flip1_out, validOut_1);
io_xbar_flip_bus #(1, 21) validOut_2_flip2(validOut_2_flip1_out, validOut_2);
io_xbar_flip_bus #(1, 21) validOut_3_flip2(validOut_3_flip1_out, validOut_3);
io_xbar_flip_bus #(1, 21) validOut_4_flip2(validOut_4_flip1_out, validOut_4);
io_xbar_flip_bus #(1, 21) validOut_5_flip2(validOut_5_flip1_out, validOut_5);
io_xbar_flip_bus #(1, 21) validOut_6_flip2(validOut_6_flip1_out, validOut_6);

io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_0_flip1(dataOut_0_internal, dataOut_0_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_1_flip1(dataOut_1_internal, dataOut_1_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_2_flip1(dataOut_2_internal, dataOut_2_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_3_flip1(dataOut_3_internal, dataOut_3_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_4_flip1(dataOut_4_internal, dataOut_4_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_5_flip1(dataOut_5_internal, dataOut_5_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_6_flip1(dataOut_6_internal, dataOut_6_flip1_out);

io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_0_flip2(dataOut_0_flip1_out, dataOut_0);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_1_flip2(dataOut_1_flip1_out, dataOut_1);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_2_flip2(dataOut_2_flip1_out, dataOut_2);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_3_flip2(dataOut_3_flip1_out, dataOut_3);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_4_flip2(dataOut_4_flip1_out, dataOut_4);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_5_flip2(dataOut_5_flip1_out, dataOut_5);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_6_flip2(dataOut_6_flip1_out, dataOut_6);

io_xbar_flip_bus #(1, 14) yummyIn_0_flip1(yummyIn_0, yummyIn_0_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_1_flip1(yummyIn_1, yummyIn_1_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_2_flip1(yummyIn_2, yummyIn_2_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_3_flip1(yummyIn_3, yummyIn_3_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_4_flip1(yummyIn_4, yummyIn_4_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_5_flip1(yummyIn_5, yummyIn_5_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_6_flip1(yummyIn_6, yummyIn_6_flip1_out);

io_xbar_flip_bus #(1, 10) yummyIn_0_flip2(yummyIn_0_flip1_out, yummyIn_0_internal);
io_xbar_flip_bus #(1, 10) yummyIn_1_flip2(yummyIn_1_flip1_out, yummyIn_1_internal);
io_xbar_flip_bus #(1, 10) yummyIn_2_flip2(yummyIn_2_flip1_out, yummyIn_2_internal);
io_xbar_flip_bus #(1, 10) yummyIn_3_flip2(yummyIn_3_flip1_out, yummyIn_3_internal);
io_xbar_flip_bus #(1, 10) yummyIn_4_flip2(yummyIn_4_flip1_out, yummyIn_4_internal);
io_xbar_flip_bus #(1, 10) yummyIn_5_flip2(yummyIn_5_flip1_out, yummyIn_5_internal);
io_xbar_flip_bus #(1, 10) yummyIn_6_flip2(yummyIn_6_flip1_out, yummyIn_6_internal);

io_xbar_flip_bus #(1, 14) validIn_0_flip1(validIn_0, validIn_0_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_1_flip1(validIn_1, validIn_1_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_2_flip1(validIn_2, validIn_2_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_3_flip1(validIn_3, validIn_3_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_4_flip1(validIn_4, validIn_4_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_5_flip1(validIn_5, validIn_5_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_6_flip1(validIn_6, validIn_6_flip1_out);

io_xbar_flip_bus #(1, 10) validIn_0_flip2(validIn_0_flip1_out, validIn_0_internal);
io_xbar_flip_bus #(1, 10) validIn_1_flip2(validIn_1_flip1_out, validIn_1_internal);
io_xbar_flip_bus #(1, 10) validIn_2_flip2(validIn_2_flip1_out, validIn_2_internal);
io_xbar_flip_bus #(1, 10) validIn_3_flip2(validIn_3_flip1_out, validIn_3_internal);
io_xbar_flip_bus #(1, 10) validIn_4_flip2(validIn_4_flip1_out, validIn_4_internal);
io_xbar_flip_bus #(1, 10) validIn_5_flip2(validIn_5_flip1_out, validIn_5_internal);
io_xbar_flip_bus #(1, 10) validIn_6_flip2(validIn_6_flip1_out, validIn_6_internal);

io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_0_flip1(dataIn_0, dataIn_0_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_1_flip1(dataIn_1, dataIn_1_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_2_flip1(dataIn_2, dataIn_2_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_3_flip1(dataIn_3, dataIn_3_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_4_flip1(dataIn_4, dataIn_4_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_5_flip1(dataIn_5, dataIn_5_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_6_flip1(dataIn_6, dataIn_6_flip1_out);

io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_0_flip2(dataIn_0_flip1_out, dataIn_0_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_1_flip2(dataIn_1_flip1_out, dataIn_1_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_2_flip2(dataIn_2_flip1_out, dataIn_2_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_3_flip2(dataIn_3_flip1_out, dataIn_3_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_4_flip2(dataIn_4_flip1_out, dataIn_4_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_5_flip2(dataIn_5_flip1_out, dataIn_5_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_6_flip2(dataIn_6_flip1_out, dataIn_6_internal);


/*
//original
// two sets of inverters for output signals (buffering for timing purposes)
io_xbar_flip_bus #(1, 14) yummyOut_N_flip1(yummyOut_N_internal, yummyOut_N_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_E_flip1(yummyOut_E_internal, yummyOut_E_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_S_flip1(yummyOut_S_internal, yummyOut_S_flip1_out);
io_xbar_flip_bus #(1, 14) yummyOut_W_flip1(yummyOut_W_internal, yummyOut_W_flip1_out);
//io_xbar_flip_bus #(1, 14) yummyOut_P_flip1(yummyOut_P_internal, yummyOut_P_flip1_out);
io_xbar_flip_bus #(1, 21) yummyOut_N_flip2(yummyOut_N_flip1_out, yummyOut_N);
io_xbar_flip_bus #(1, 21) yummyOut_E_flip2(yummyOut_E_flip1_out, yummyOut_E);
io_xbar_flip_bus #(1, 21) yummyOut_S_flip2(yummyOut_S_flip1_out, yummyOut_S);
io_xbar_flip_bus #(1, 21) yummyOut_W_flip2(yummyOut_W_flip1_out, yummyOut_W);
//io_xbar_flip_bus #(1, 21) yummyOut_P_flip2(yummyOut_P_flip1_out, yummyOut_P);

io_xbar_flip_bus #(1, 14) validOut_N_flip1(validOut_N_internal, validOut_N_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_E_flip1(validOut_E_internal, validOut_E_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_S_flip1(validOut_S_internal, validOut_S_flip1_out);
io_xbar_flip_bus #(1, 14) validOut_W_flip1(validOut_W_internal, validOut_W_flip1_out);
//io_xbar_flip_bus #(1, 14) validOut_P_flip1(validOut_P_internal, validOut_P_flip1_out);
io_xbar_flip_bus #(1, 21) validOut_N_flip2(validOut_N_flip1_out, validOut_N);
io_xbar_flip_bus #(1, 21) validOut_E_flip2(validOut_E_flip1_out, validOut_E);
io_xbar_flip_bus #(1, 21) validOut_S_flip2(validOut_S_flip1_out, validOut_S);
io_xbar_flip_bus #(1, 21) validOut_W_flip2(validOut_W_flip1_out, validOut_W);
//io_xbar_flip_bus #(1, 21) validOut_P_flip2(validOut_P_flip1_out, validOut_P);

io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_N_flip1(dataOut_N_internal, dataOut_N_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_E_flip1(dataOut_E_internal, dataOut_E_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_S_flip1(dataOut_S_internal, dataOut_S_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_W_flip1(dataOut_W_internal, dataOut_W_flip1_out);
//io_xbar_flip_bus #(`DATA_WIDTH, 14) dataOut_P_flip1(dataOut_P_internal, dataOut_P_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_N_flip2(dataOut_N_flip1_out, dataOut_N);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_E_flip2(dataOut_E_flip1_out, dataOut_E);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_S_flip2(dataOut_S_flip1_out, dataOut_S);
io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_W_flip2(dataOut_W_flip1_out, dataOut_W);
//io_xbar_flip_bus #(`DATA_WIDTH, 21) dataOut_P_flip2(dataOut_P_flip1_out, dataOut_P);

// two sets of inverters for input signals (buffering for timing purposes)
io_xbar_flip_bus #(1, 14) yummyIn_N_flip1(yummyIn_N, yummyIn_N_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_E_flip1(yummyIn_E, yummyIn_E_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_S_flip1(yummyIn_S, yummyIn_S_flip1_out);
io_xbar_flip_bus #(1, 14) yummyIn_W_flip1(yummyIn_W, yummyIn_W_flip1_out);
//io_xbar_flip_bus #(1, 14) yummyIn_P_flip1(yummyIn_P, yummyIn_P_flip1_out);
io_xbar_flip_bus #(1, 10) yummyIn_N_flip2(yummyIn_N_flip1_out, yummyIn_N_internal);
io_xbar_flip_bus #(1, 10) yummyIn_E_flip2(yummyIn_E_flip1_out, yummyIn_E_internal);
io_xbar_flip_bus #(1, 10) yummyIn_S_flip2(yummyIn_S_flip1_out, yummyIn_S_internal);
io_xbar_flip_bus #(1, 10) yummyIn_W_flip2(yummyIn_W_flip1_out, yummyIn_W_internal);
//io_xbar_flip_bus #(1, 10) yummyIn_P_flip2(yummyIn_P_flip1_out, yummyIn_P_internal);

io_xbar_flip_bus #(1, 14) validIn_N_flip1(validIn_N, validIn_N_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_E_flip1(validIn_E, validIn_E_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_S_flip1(validIn_S, validIn_S_flip1_out);
io_xbar_flip_bus #(1, 14) validIn_W_flip1(validIn_W, validIn_W_flip1_out);
//io_xbar_flip_bus #(1, 14) validIn_P_flip1(validIn_P, validIn_P_flip1_out);
io_xbar_flip_bus #(1, 10) validIn_N_flip2(validIn_N_flip1_out, validIn_N_internal);
io_xbar_flip_bus #(1, 10) validIn_E_flip2(validIn_E_flip1_out, validIn_E_internal);
io_xbar_flip_bus #(1, 10) validIn_S_flip2(validIn_S_flip1_out, validIn_S_internal);
io_xbar_flip_bus #(1, 10) validIn_W_flip2(validIn_W_flip1_out, validIn_W_internal);
//io_xbar_flip_bus #(1, 10) validIn_P_flip2(validIn_P_flip1_out, validIn_P_internal);

io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_N_flip1(dataIn_N, dataIn_N_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_E_flip1(dataIn_E, dataIn_E_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_S_flip1(dataIn_S, dataIn_S_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_W_flip1(dataIn_W, dataIn_W_flip1_out);
//io_xbar_flip_bus #(`DATA_WIDTH, 14) dataIn_P_flip1(dataIn_P, dataIn_P_flip1_out);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_N_flip2(dataIn_N_flip1_out, dataIn_N_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_E_flip2(dataIn_E_flip1_out, dataIn_E_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_S_flip2(dataIn_S_flip1_out, dataIn_S_internal);
io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_W_flip2(dataIn_W_flip1_out, dataIn_W_internal);
//io_xbar_flip_bus #(`DATA_WIDTH, 10) dataIn_P_flip2(dataIn_P_flip1_out, dataIn_P_internal);
*/

//instantiations


//the following dense code impliments a full crossbar.
//The two main components are a io_xbar_input_top_X and a io_xbar_output_top

//the difference between io_xbar_input_top_4 and io_xbar_input_top_16 are the size of
//the nibs inside of them.

//dynamic inputs
io_xbar_input_top_4 node_0_input(.route_req_0_out(route_req_0_to_0), .route_req_1_out(route_req_0_to_1), .route_req_2_out(route_req_0_to_2), .route_req_3_out(route_req_0_to_3), .route_req_4_out(route_req_0_to_4), .route_req_5_out(route_req_0_to_5), .route_req_6_out(route_req_0_to_6), .route_req_7_out(route_req_0_to_7), .default_ready_0_out(), .default_ready_1_out(), .default_ready_2_out(), .default_ready_3_out(), .default_ready_4_out(default_ready_0_to_4), .default_ready_5_out(), .default_ready_6_out(), .default_ready_7_out(), .tail_out(node_0_input_tail), .yummy_out(yummyOut_0_internal), .data_out(node_0_input_data), .valid_out(node_0_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_0_internal), .data_in(dataIn_0_internal), .thanks_0(thanks_0_to_0), .thanks_1(thanks_1_to_0), .thanks_2(thanks_2_to_0), .thanks_3(thanks_3_to_0), .thanks_4(thanks_4_to_0), .thanks_5(thanks_5_to_0), .thanks_6(thanks_6_to_0), .thanks_7(thanks_7_to_0));
io_xbar_input_top_4 node_1_input(.route_req_0_out(route_req_1_to_0), .route_req_1_out(route_req_1_to_1), .route_req_2_out(route_req_1_to_2), .route_req_3_out(route_req_1_to_3), .route_req_4_out(route_req_1_to_4), .route_req_5_out(route_req_1_to_5), .route_req_6_out(route_req_1_to_6), .route_req_7_out(route_req_1_to_7), .default_ready_0_out(), .default_ready_1_out(), .default_ready_2_out(), .default_ready_3_out(), .default_ready_4_out(), .default_ready_5_out(default_ready_1_to_5), .default_ready_6_out(), .default_ready_7_out(), .tail_out(node_1_input_tail), .yummy_out(yummyOut_1_internal), .data_out(node_1_input_data), .valid_out(node_1_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_1_internal), .data_in(dataIn_1_internal), .thanks_0(thanks_0_to_1), .thanks_1(thanks_1_to_1), .thanks_2(thanks_2_to_1), .thanks_3(thanks_3_to_1), .thanks_4(thanks_4_to_1), .thanks_5(thanks_5_to_1), .thanks_6(thanks_6_to_1), .thanks_7(thanks_7_to_1));
io_xbar_input_top_4 node_2_input(.route_req_0_out(route_req_2_to_0), .route_req_1_out(route_req_2_to_1), .route_req_2_out(route_req_2_to_2), .route_req_3_out(route_req_2_to_3), .route_req_4_out(route_req_2_to_4), .route_req_5_out(route_req_2_to_5), .route_req_6_out(route_req_2_to_6), .route_req_7_out(route_req_2_to_7), .default_ready_0_out(), .default_ready_1_out(), .default_ready_2_out(), .default_ready_3_out(), .default_ready_4_out(), .default_ready_5_out(), .default_ready_6_out(default_ready_2_to_6), .default_ready_7_out(), .tail_out(node_2_input_tail), .yummy_out(yummyOut_2_internal), .data_out(node_2_input_data), .valid_out(node_2_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_2_internal), .data_in(dataIn_2_internal), .thanks_0(thanks_0_to_2), .thanks_1(thanks_1_to_2), .thanks_2(thanks_2_to_2), .thanks_3(thanks_3_to_2), .thanks_4(thanks_4_to_2), .thanks_5(thanks_5_to_2), .thanks_6(thanks_6_to_2), .thanks_7(thanks_7_to_2));
io_xbar_input_top_4 node_3_input(.route_req_0_out(route_req_3_to_0), .route_req_1_out(route_req_3_to_1), .route_req_2_out(route_req_3_to_2), .route_req_3_out(route_req_3_to_3), .route_req_4_out(route_req_3_to_4), .route_req_5_out(route_req_3_to_5), .route_req_6_out(route_req_3_to_6), .route_req_7_out(route_req_3_to_7), .default_ready_0_out(default_ready_3_to_0), .default_ready_1_out(), .default_ready_2_out(), .default_ready_3_out(), .default_ready_4_out(), .default_ready_5_out(), .default_ready_6_out(), .default_ready_7_out(default_ready_3_to_7), .tail_out(node_3_input_tail), .yummy_out(yummyOut_3_internal), .data_out(node_3_input_data), .valid_out(node_3_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_3_internal), .data_in(dataIn_3_internal), .thanks_0(thanks_0_to_3), .thanks_1(thanks_1_to_3), .thanks_2(thanks_2_to_3), .thanks_3(thanks_3_to_3), .thanks_4(thanks_4_to_3), .thanks_5(thanks_5_to_3), .thanks_6(thanks_6_to_3), .thanks_7(thanks_7_to_3));
io_xbar_input_top_4 node_4_input(.route_req_0_out(route_req_4_to_0), .route_req_1_out(route_req_4_to_1), .route_req_2_out(route_req_4_to_2), .route_req_3_out(route_req_4_to_3), .route_req_4_out(route_req_4_to_4), .route_req_5_out(route_req_4_to_5), .route_req_6_out(route_req_4_to_6), .route_req_7_out(route_req_4_to_7), .default_ready_0_out(), .default_ready_1_out(default_ready_4_to_1), .default_ready_2_out(), .default_ready_3_out(), .default_ready_4_out(), .default_ready_5_out(), .default_ready_6_out(), .default_ready_7_out(), .tail_out(node_4_input_tail), .yummy_out(yummyOut_4_internal), .data_out(node_4_input_data), .valid_out(node_4_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_4_internal), .data_in(dataIn_4_internal), .thanks_0(thanks_0_to_4), .thanks_1(thanks_1_to_4), .thanks_2(thanks_2_to_4), .thanks_3(thanks_3_to_4), .thanks_4(thanks_4_to_4), .thanks_5(thanks_5_to_4), .thanks_6(thanks_6_to_4), .thanks_7(thanks_7_to_4));
io_xbar_input_top_4 node_5_input(.route_req_0_out(route_req_5_to_0), .route_req_1_out(route_req_5_to_1), .route_req_2_out(route_req_5_to_2), .route_req_3_out(route_req_5_to_3), .route_req_4_out(route_req_5_to_4), .route_req_5_out(route_req_5_to_5), .route_req_6_out(route_req_5_to_6), .route_req_7_out(route_req_5_to_7), .default_ready_0_out(), .default_ready_1_out(), .default_ready_2_out(default_ready_5_to_2), .default_ready_3_out(), .default_ready_4_out(), .default_ready_5_out(), .default_ready_6_out(), .default_ready_7_out(), .tail_out(node_5_input_tail), .yummy_out(yummyOut_5_internal), .data_out(node_5_input_data), .valid_out(node_5_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_5_internal), .data_in(dataIn_5_internal), .thanks_0(thanks_0_to_5), .thanks_1(thanks_1_to_5), .thanks_2(thanks_2_to_5), .thanks_3(thanks_3_to_5), .thanks_4(thanks_4_to_5), .thanks_5(thanks_5_to_5), .thanks_6(thanks_6_to_5), .thanks_7(thanks_7_to_5));
io_xbar_input_top_4 node_6_input(.route_req_0_out(route_req_6_to_0), .route_req_1_out(route_req_6_to_1), .route_req_2_out(route_req_6_to_2), .route_req_3_out(route_req_6_to_3), .route_req_4_out(route_req_6_to_4), .route_req_5_out(route_req_6_to_5), .route_req_6_out(route_req_6_to_6), .route_req_7_out(route_req_6_to_7), .default_ready_0_out(), .default_ready_1_out(), .default_ready_2_out(), .default_ready_3_out(default_ready_6_to_3), .default_ready_4_out(), .default_ready_5_out(), .default_ready_6_out(), .default_ready_7_out(), .tail_out(node_6_input_tail), .yummy_out(yummyOut_6_internal), .data_out(node_6_input_data), .valid_out(node_6_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_6_internal), .data_in(dataIn_6_internal), .thanks_0(thanks_0_to_6), .thanks_1(thanks_1_to_6), .thanks_2(thanks_2_to_6), .thanks_3(thanks_3_to_6), .thanks_4(thanks_4_to_6), .thanks_5(thanks_5_to_6), .thanks_6(thanks_6_to_6), .thanks_7(thanks_7_to_6));
io_xbar_input_top_4 node_7_input(.route_req_0_out(route_req_7_to_0), .route_req_1_out(route_req_7_to_1), .route_req_2_out(route_req_7_to_2), .route_req_3_out(route_req_7_to_3), .route_req_4_out(route_req_7_to_4), .route_req_5_out(route_req_7_to_5), .route_req_6_out(route_req_7_to_6), .route_req_7_out(route_req_7_to_7), .default_ready_0_out(), .default_ready_1_out(), .default_ready_2_out(), .default_ready_3_out(), .default_ready_4_out(), .default_ready_5_out(), .default_ready_6_out(), .default_ready_7_out(), .tail_out(node_7_input_tail), .yummy_out(yummyOut_7_internal), .data_out(node_7_input_data), .valid_out(node_7_input_valid), .clk(clk), .reset(reset), .my_loc_x_in(myLocX_f), .my_loc_y_in(myLocY_f), .my_chip_id_in(myChipID_f), .valid_in(validIn_7), .data_in(dataIn_7), .thanks_0(thanks_0_to_7), .thanks_1(thanks_1_to_7), .thanks_2(thanks_2_to_7), .thanks_3(thanks_3_to_7), .thanks_4(thanks_4_to_7), .thanks_5(thanks_5_to_7), .thanks_6(thanks_6_to_7), .thanks_7(thanks_7_to_7));


//dynamic outputs
io_xbar_output_top node_0_output(.data_out(dataOut_0_internal), .thanks_0_out(thanks_0_to_3), .thanks_1_out(thanks_0_to_4), .thanks_2_out(thanks_0_to_5), .thanks_3_out(thanks_0_to_6), .thanks_4_out(thanks_0_to_7), .thanks_5_out(thanks_0_to_1), .thanks_6_out(thanks_0_to_2), .thanks_7_out(thanks_0_to_0), .valid_out(validOut_0_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_0), .clk(clk), .reset(reset), .route_req_0_in(route_req_3_to_0), .route_req_1_in(route_req_4_to_0), .route_req_2_in(route_req_5_to_0), .route_req_3_in(route_req_6_to_0), .route_req_4_in(route_req_7_to_0), .route_req_5_in(route_req_1_to_0), .route_req_6_in(route_req_2_to_0), .route_req_7_in(route_req_0_to_0), .tail_0_in(node_3_input_tail), .tail_1_in(node_4_input_tail), .tail_2_in(node_5_input_tail), .tail_3_in(node_6_input_tail), .tail_4_in(node_7_input_tail), .tail_5_in(node_1_input_tail), .tail_6_in(node_2_input_tail), .tail_7_in(node_0_input_tail), .data_0_in(node_3_input_data), .data_1_in(node_4_input_data), .data_2_in(node_5_input_data), .data_3_in(node_6_input_data), .data_4_in(node_7_input_data), .data_5_in(node_1_input_data), .data_6_in(node_2_input_data), .data_7_in(node_0_input_data), .valid_0_in(node_3_input_valid), .valid_1_in(node_4_input_valid), .valid_2_in(node_5_input_valid), .valid_3_in(node_6_input_valid), .valid_4_in(node_7_input_valid), .valid_5_in(node_1_input_valid), .valid_6_in(node_2_input_valid), .valid_7_in(node_0_input_valid), .default_ready_in(default_ready_3_to_0),.yummy_in(yummyIn_0_internal));
io_xbar_output_top node_1_output(.data_out(dataOut_1_internal), .thanks_0_out(thanks_1_to_4), .thanks_1_out(thanks_1_to_5), .thanks_2_out(thanks_1_to_6), .thanks_3_out(thanks_1_to_7), .thanks_4_out(thanks_1_to_0), .thanks_5_out(thanks_1_to_2), .thanks_6_out(thanks_1_to_3), .thanks_7_out(thanks_1_to_1), .valid_out(validOut_1_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_1), .clk(clk), .reset(reset), .route_req_0_in(route_req_4_to_1), .route_req_1_in(route_req_5_to_1), .route_req_2_in(route_req_6_to_1), .route_req_3_in(route_req_7_to_1), .route_req_4_in(route_req_0_to_1), .route_req_5_in(route_req_2_to_1), .route_req_6_in(route_req_3_to_1), .route_req_7_in(route_req_1_to_1), .tail_0_in(node_4_input_tail), .tail_1_in(node_5_input_tail), .tail_2_in(node_6_input_tail), .tail_3_in(node_7_input_tail), .tail_4_in(node_0_input_tail), .tail_5_in(node_2_input_tail), .tail_6_in(node_3_input_tail), .tail_7_in(node_1_input_tail), .data_0_in(node_4_input_data), .data_1_in(node_5_input_data), .data_2_in(node_6_input_data), .data_3_in(node_7_input_data), .data_4_in(node_0_input_data), .data_5_in(node_2_input_data), .data_6_in(node_3_input_data), .data_7_in(node_1_input_data), .valid_0_in(node_4_input_valid), .valid_1_in(node_5_input_valid), .valid_2_in(node_6_input_valid), .valid_3_in(node_7_input_valid), .valid_4_in(node_0_input_valid), .valid_5_in(node_2_input_valid), .valid_6_in(node_3_input_valid), .valid_7_in(node_1_input_valid), .default_ready_in(default_ready_4_to_1),.yummy_in(yummyIn_1_internal));
io_xbar_output_top node_2_output(.data_out(dataOut_2_internal), .thanks_0_out(thanks_2_to_5), .thanks_1_out(thanks_2_to_6), .thanks_2_out(thanks_2_to_7), .thanks_3_out(thanks_2_to_0), .thanks_4_out(thanks_2_to_1), .thanks_5_out(thanks_2_to_3), .thanks_6_out(thanks_2_to_4), .thanks_7_out(thanks_2_to_2), .valid_out(validOut_2_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_2), .clk(clk), .reset(reset), .route_req_0_in(route_req_5_to_2), .route_req_1_in(route_req_6_to_2), .route_req_2_in(route_req_7_to_2), .route_req_3_in(route_req_0_to_2), .route_req_4_in(route_req_1_to_2), .route_req_5_in(route_req_3_to_2), .route_req_6_in(route_req_4_to_2), .route_req_7_in(route_req_2_to_2), .tail_0_in(node_5_input_tail), .tail_1_in(node_6_input_tail), .tail_2_in(node_7_input_tail), .tail_3_in(node_0_input_tail), .tail_4_in(node_1_input_tail), .tail_5_in(node_3_input_tail), .tail_6_in(node_4_input_tail), .tail_7_in(node_2_input_tail), .data_0_in(node_5_input_data), .data_1_in(node_6_input_data), .data_2_in(node_7_input_data), .data_3_in(node_0_input_data), .data_4_in(node_1_input_data), .data_5_in(node_3_input_data), .data_6_in(node_4_input_data), .data_7_in(node_2_input_data), .valid_0_in(node_5_input_valid), .valid_1_in(node_6_input_valid), .valid_2_in(node_7_input_valid), .valid_3_in(node_0_input_valid), .valid_4_in(node_1_input_valid), .valid_5_in(node_3_input_valid), .valid_6_in(node_4_input_valid), .valid_7_in(node_2_input_valid), .default_ready_in(default_ready_5_to_2),.yummy_in(yummyIn_2_internal));
io_xbar_output_top node_3_output(.data_out(dataOut_3_internal), .thanks_0_out(thanks_3_to_6), .thanks_1_out(thanks_3_to_7), .thanks_2_out(thanks_3_to_0), .thanks_3_out(thanks_3_to_1), .thanks_4_out(thanks_3_to_2), .thanks_5_out(thanks_3_to_4), .thanks_6_out(thanks_3_to_5), .thanks_7_out(thanks_3_to_3), .valid_out(validOut_3_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_3), .clk(clk), .reset(reset), .route_req_0_in(route_req_6_to_3), .route_req_1_in(route_req_7_to_3), .route_req_2_in(route_req_0_to_3), .route_req_3_in(route_req_1_to_3), .route_req_4_in(route_req_2_to_3), .route_req_5_in(route_req_4_to_3), .route_req_6_in(route_req_5_to_3), .route_req_7_in(route_req_3_to_3), .tail_0_in(node_6_input_tail), .tail_1_in(node_7_input_tail), .tail_2_in(node_0_input_tail), .tail_3_in(node_1_input_tail), .tail_4_in(node_2_input_tail), .tail_5_in(node_4_input_tail), .tail_6_in(node_5_input_tail), .tail_7_in(node_3_input_tail), .data_0_in(node_6_input_data), .data_1_in(node_7_input_data), .data_2_in(node_0_input_data), .data_3_in(node_1_input_data), .data_4_in(node_2_input_data), .data_5_in(node_4_input_data), .data_6_in(node_5_input_data), .data_7_in(node_3_input_data), .valid_0_in(node_6_input_valid), .valid_1_in(node_7_input_valid), .valid_2_in(node_0_input_valid), .valid_3_in(node_1_input_valid), .valid_4_in(node_2_input_valid), .valid_5_in(node_4_input_valid), .valid_6_in(node_5_input_valid), .valid_7_in(node_3_input_valid), .default_ready_in(default_ready_6_to_3),.yummy_in(yummyIn_3_internal));
io_xbar_output_top node_4_output(.data_out(dataOut_4_internal), .thanks_0_out(thanks_4_to_0), .thanks_1_out(thanks_4_to_1), .thanks_2_out(thanks_4_to_2), .thanks_3_out(thanks_4_to_3), .thanks_4_out(thanks_4_to_5), .thanks_5_out(thanks_4_to_6), .thanks_6_out(thanks_4_to_7), .thanks_7_out(thanks_4_to_4), .valid_out(validOut_4_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_4), .clk(clk), .reset(reset), .route_req_0_in(route_req_0_to_4), .route_req_1_in(route_req_1_to_4), .route_req_2_in(route_req_2_to_4), .route_req_3_in(route_req_3_to_4), .route_req_4_in(route_req_5_to_4), .route_req_5_in(route_req_6_to_4), .route_req_6_in(route_req_7_to_4), .route_req_7_in(route_req_4_to_4), .tail_0_in(node_0_input_tail), .tail_1_in(node_1_input_tail), .tail_2_in(node_2_input_tail), .tail_3_in(node_3_input_tail), .tail_4_in(node_5_input_tail), .tail_5_in(node_6_input_tail), .tail_6_in(node_7_input_tail), .tail_7_in(node_4_input_tail), .data_0_in(node_0_input_data), .data_1_in(node_1_input_data), .data_2_in(node_2_input_data), .data_3_in(node_3_input_data), .data_4_in(node_5_input_data), .data_5_in(node_6_input_data), .data_6_in(node_7_input_data), .data_7_in(node_4_input_data), .valid_0_in(node_0_input_valid), .valid_1_in(node_1_input_valid), .valid_2_in(node_2_input_valid), .valid_3_in(node_3_input_valid), .valid_4_in(node_5_input_valid), .valid_5_in(node_6_input_valid), .valid_6_in(node_7_input_valid), .valid_7_in(node_4_input_valid), .default_ready_in(default_ready_0_to_4),.yummy_in(yummyIn_4_internal));
io_xbar_output_top node_5_output(.data_out(dataOut_5_internal), .thanks_0_out(thanks_5_to_1), .thanks_1_out(thanks_5_to_2), .thanks_2_out(thanks_5_to_3), .thanks_3_out(thanks_5_to_4), .thanks_4_out(thanks_5_to_6), .thanks_5_out(thanks_5_to_7), .thanks_6_out(thanks_5_to_0), .thanks_7_out(thanks_5_to_5), .valid_out(validOut_5_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_5), .clk(clk), .reset(reset), .route_req_0_in(route_req_1_to_5), .route_req_1_in(route_req_2_to_5), .route_req_2_in(route_req_3_to_5), .route_req_3_in(route_req_4_to_5), .route_req_4_in(route_req_6_to_5), .route_req_5_in(route_req_7_to_5), .route_req_6_in(route_req_0_to_5), .route_req_7_in(route_req_5_to_5), .tail_0_in(node_1_input_tail), .tail_1_in(node_2_input_tail), .tail_2_in(node_3_input_tail), .tail_3_in(node_4_input_tail), .tail_4_in(node_6_input_tail), .tail_5_in(node_7_input_tail), .tail_6_in(node_0_input_tail), .tail_7_in(node_5_input_tail), .data_0_in(node_1_input_data), .data_1_in(node_2_input_data), .data_2_in(node_3_input_data), .data_3_in(node_4_input_data), .data_4_in(node_6_input_data), .data_5_in(node_7_input_data), .data_6_in(node_0_input_data), .data_7_in(node_5_input_data), .valid_0_in(node_1_input_valid), .valid_1_in(node_2_input_valid), .valid_2_in(node_3_input_valid), .valid_3_in(node_4_input_valid), .valid_4_in(node_6_input_valid), .valid_5_in(node_7_input_valid), .valid_6_in(node_0_input_valid), .valid_7_in(node_5_input_valid), .default_ready_in(default_ready_1_to_5),.yummy_in(yummyIn_5_internal));
io_xbar_output_top node_6_output(.data_out(dataOut_6_internal), .thanks_0_out(thanks_6_to_2), .thanks_1_out(thanks_6_to_3), .thanks_2_out(thanks_6_to_4), .thanks_3_out(thanks_6_to_5), .thanks_4_out(thanks_6_to_7), .thanks_5_out(thanks_6_to_0), .thanks_6_out(thanks_6_to_1), .thanks_7_out(thanks_6_to_6), .valid_out(validOut_6_internal), .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_6), .clk(clk), .reset(reset), .route_req_0_in(route_req_2_to_6), .route_req_1_in(route_req_3_to_6), .route_req_2_in(route_req_4_to_6), .route_req_3_in(route_req_5_to_6), .route_req_4_in(route_req_7_to_6), .route_req_5_in(route_req_0_to_6), .route_req_6_in(route_req_1_to_6), .route_req_7_in(route_req_6_to_6), .tail_0_in(node_2_input_tail), .tail_1_in(node_3_input_tail), .tail_2_in(node_4_input_tail), .tail_3_in(node_5_input_tail), .tail_4_in(node_7_input_tail), .tail_5_in(node_0_input_tail), .tail_6_in(node_1_input_tail), .tail_7_in(node_6_input_tail), .data_0_in(node_2_input_data), .data_1_in(node_3_input_data), .data_2_in(node_4_input_data), .data_3_in(node_5_input_data), .data_4_in(node_7_input_data), .data_5_in(node_0_input_data), .data_6_in(node_1_input_data), .data_7_in(node_6_input_data), .valid_0_in(node_2_input_valid), .valid_1_in(node_3_input_valid), .valid_2_in(node_4_input_valid), .valid_3_in(node_5_input_valid), .valid_4_in(node_7_input_valid), .valid_5_in(node_0_input_valid), .valid_6_in(node_1_input_valid), .valid_7_in(node_6_input_valid), .default_ready_in(default_ready_2_to_6),.yummy_in(yummyIn_6_internal));
io_xbar_output_top #(1'b0) node_7_output(.data_out(dataOut_7_internal), .thanks_0_out(thanks_7_to_3), .thanks_1_out(thanks_7_to_4), .thanks_2_out(thanks_7_to_5), .thanks_3_out(thanks_7_to_6), .thanks_4_out(thanks_7_to_0), .thanks_5_out(thanks_7_to_1), .thanks_6_out(thanks_7_to_2), .thanks_7_out(thanks_7_to_7), .valid_out(validOut_7_internal), .popped_interrupt_mesg_out(external_interrupt), .popped_memory_ack_mesg_out(store_ack_received), .popped_memory_ack_mesg_out_sender(store_ack_addr), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_7), .clk(clk), .reset(reset), .route_req_0_in(route_req_3_to_7), .route_req_1_in(route_req_4_to_7), .route_req_2_in(route_req_5_to_7), .route_req_3_in(route_req_6_to_7), .route_req_4_in(route_req_0_to_7), .route_req_5_in(route_req_1_to_7), .route_req_6_in(route_req_2_to_7), .route_req_7_in(route_req_7_to_7), .tail_0_in(node_3_input_tail), .tail_1_in(node_4_input_tail), .tail_2_in(node_5_input_tail), .tail_3_in(node_6_input_tail), .tail_4_in(node_0_input_tail), .tail_5_in(node_1_input_tail), .tail_6_in(node_2_input_tail), .tail_7_in(node_7_input_tail), .data_0_in(node_3_input_data), .data_1_in(node_4_input_data), .data_2_in(node_5_input_data), .data_3_in(node_6_input_data), .data_4_in(node_0_input_data), .data_5_in(node_1_input_data), .data_6_in(node_2_input_data), .data_7_in(node_7_input_data), .valid_0_in(node_3_input_valid), .valid_1_in(node_4_input_valid), .valid_2_in(node_5_input_valid), .valid_3_in(node_6_input_valid), .valid_4_in(node_0_input_valid), .valid_5_in(node_1_input_valid), .valid_6_in(node_2_input_valid), .valid_7_in(node_7_input_valid), .default_ready_in(default_ready_3_to_7),.yummy_in(yummyIn_7_internal));

/*
//original
dynamic_output_top north_output(.data_out(dataOut_N_internal), .thanks_a_out(thanks_n_to_s), .thanks_b_out(thanks_n_to_w), .thanks_c_out(thanks_n_to_p), .thanks_d_out(thanks_n_to_e), .thanks_x_out(thanks_n_to_n), .valid_out(validOut_N_internal),  .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(), .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_N), .clk(clk), .reset(reset), .route_req_a_in(route_req_s_to_n), .route_req_b_in(route_req_w_to_n), .route_req_c_in(route_req_p_to_n), .route_req_d_in(route_req_e_to_n), .route_req_x_in(route_req_n_to_n), .tail_a_in(south_input_tail), .tail_b_in(west_input_tail), .tail_c_in(proc_input_tail), .tail_d_in(east_input_tail), .tail_x_in(north_input_tail), .data_a_in(south_input_data), .data_b_in(west_input_data), .data_c_in(proc_input_data), .data_d_in(east_input_data), .data_x_in(north_input_data), .valid_a_in(south_input_valid), .valid_b_in(west_input_valid), .valid_c_in(proc_input_valid), .valid_d_in(east_input_valid), .valid_x_in(north_input_valid), .default_ready_in(default_ready_s_to_n), .yummy_in(yummyIn_N_internal));

dynamic_output_top east_output(.data_out(dataOut_E_internal), .thanks_a_out(thanks_e_to_w), .thanks_b_out(thanks_e_to_p), .thanks_c_out(thanks_e_to_n), .thanks_d_out(thanks_e_to_s), .thanks_x_out(thanks_e_to_e), .valid_out(validOut_E_internal),   .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_E), .clk(clk), .reset(reset), .route_req_a_in(route_req_w_to_e), .route_req_b_in(route_req_p_to_e), .route_req_c_in(route_req_n_to_e), .route_req_d_in(route_req_s_to_e), .route_req_x_in(route_req_e_to_e), .tail_a_in(west_input_tail), .tail_b_in(proc_input_tail), .tail_c_in(north_input_tail), .tail_d_in(south_input_tail), .tail_x_in(east_input_tail), .data_a_in(west_input_data), .data_b_in(proc_input_data), .data_c_in(north_input_data), .data_d_in(south_input_data), .data_x_in(east_input_data), .valid_a_in(west_input_valid), .valid_b_in(proc_input_valid), .valid_c_in(north_input_valid), .valid_d_in(south_input_valid), .valid_x_in(east_input_valid), .default_ready_in(default_ready_w_to_e), .yummy_in(yummyIn_E_internal));

dynamic_output_top south_output(.data_out(dataOut_S_internal), .thanks_a_out(thanks_s_to_n), .thanks_b_out(thanks_s_to_e), .thanks_c_out(thanks_s_to_w), .thanks_d_out(thanks_s_to_p), .thanks_x_out(thanks_s_to_s), .valid_out(validOut_S_internal),   .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_S), .clk(clk), .reset(reset), .route_req_a_in(route_req_n_to_s), .route_req_b_in(route_req_e_to_s), .route_req_c_in(route_req_w_to_s), .route_req_d_in(route_req_p_to_s), .route_req_x_in(route_req_s_to_s), .tail_a_in(north_input_tail), .tail_b_in(east_input_tail), .tail_c_in(west_input_tail), .tail_d_in(proc_input_tail), .tail_x_in(south_input_tail), .data_a_in(north_input_data), .data_b_in(east_input_data), .data_c_in(west_input_data), .data_d_in(proc_input_data), .data_x_in(south_input_data), .valid_a_in(north_input_valid), .valid_b_in(east_input_valid), .valid_c_in(west_input_valid), .valid_d_in(proc_input_valid), .valid_x_in(south_input_valid), .default_ready_in(default_ready_n_to_s), .yummy_in(yummyIn_S_internal));

dynamic_output_top west_output(.data_out(dataOut_W_internal), .thanks_a_out(thanks_w_to_e), .thanks_b_out(thanks_w_to_s), .thanks_c_out(thanks_w_to_p), .thanks_d_out(thanks_w_to_n), .thanks_x_out(thanks_w_to_w), .valid_out(validOut_W_internal),   .popped_interrupt_mesg_out(), .popped_memory_ack_mesg_out(), .popped_memory_ack_mesg_out_sender(),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_W), .clk(clk), .reset(reset), .route_req_a_in(route_req_e_to_w), .route_req_b_in(route_req_s_to_w), .route_req_c_in(route_req_p_to_w), .route_req_d_in(route_req_n_to_w), .route_req_x_in(route_req_w_to_w), .tail_a_in(east_input_tail), .tail_b_in(south_input_tail), .tail_c_in(proc_input_tail), .tail_d_in(north_input_tail), .tail_x_in(west_input_tail), .data_a_in(east_input_data), .data_b_in(south_input_data), .data_c_in(proc_input_data), .data_d_in(north_input_data), .data_x_in(west_input_data), .valid_a_in(east_input_valid), .valid_b_in(south_input_valid), .valid_c_in(proc_input_valid), .valid_d_in(north_input_valid), .valid_x_in(west_input_valid), .default_ready_in(default_ready_e_to_w), .yummy_in(yummyIn_W_internal));
//yanqi change kill headers to 0
dynamic_output_top #(1'b0) proc_output(.data_out(dataOut_P_internal), .thanks_a_out(thanks_p_to_s), .thanks_b_out(thanks_p_to_w), .thanks_c_out(thanks_p_to_n), .thanks_d_out(thanks_p_to_e), .thanks_x_out(thanks_p_to_p), .valid_out(validOut_P_internal),  .popped_interrupt_mesg_out(external_interrupt), .popped_memory_ack_mesg_out(store_ack_received), .popped_memory_ack_mesg_out_sender(store_ack_addr),  .ec_wants_to_send_but_cannot(ec_wants_to_send_but_cannot_P), .clk(clk), .reset(reset), .route_req_a_in(route_req_s_to_p), .route_req_b_in(route_req_w_to_p), .route_req_c_in(route_req_n_to_p), .route_req_d_in(route_req_e_to_p), .route_req_x_in(route_req_p_to_p), .tail_a_in(south_input_tail), .tail_b_in(west_input_tail), .tail_c_in(north_input_tail), .tail_d_in(east_input_tail), .tail_x_in(proc_input_tail), .data_a_in(south_input_data), .data_b_in(west_input_data), .data_c_in(north_input_data), .data_d_in(east_input_data), .data_x_in(proc_input_data), .valid_a_in(south_input_valid), .valid_b_in(west_input_valid), .valid_c_in(north_input_valid), .valid_d_in(east_input_valid), .valid_x_in(proc_input_valid), .default_ready_in(default_ready_s_to_p), .yummy_in(yummyIn_P_internal));
*/

endmodule // dynamic_node
