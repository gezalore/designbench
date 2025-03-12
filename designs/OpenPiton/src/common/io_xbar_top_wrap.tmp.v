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

//File: dynamic_node_top_wrap.v
////Creator: Michael McKeown
////Created: Sept. 21, 2014
////
////Function: This wraps the dynamic_node top and ties off signals
//            we will not be using at the tile level
////
////State: 
////
////Instantiates: dynamic_node_top
////
////

`include "define.tmp.h"
// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml

module io_xbar_top_wrap
(
    input clk,
    input reset_in,
    
    input [`DATA_WIDTH-1:0] dataIn_0,
    input [`DATA_WIDTH-1:0] dataIn_1,
    input [`DATA_WIDTH-1:0] dataIn_2,
    input [`DATA_WIDTH-1:0] dataIn_3,
    input [`DATA_WIDTH-1:0] dataIn_4,
    input [`DATA_WIDTH-1:0] dataIn_5,
    input [`DATA_WIDTH-1:0] dataIn_6,
    input [`DATA_WIDTH-1:0] dataIn_7,

    input validIn_0,
    input validIn_1,
    input validIn_2,
    input validIn_3,
    input validIn_4,
    input validIn_5,
    input validIn_6,
    input validIn_7,

    input yummyIn_0,
    input yummyIn_1,
    input yummyIn_2,
    input yummyIn_3,
    input yummyIn_4,
    input yummyIn_5,
    input yummyIn_6,
    input yummyIn_7,

    /*
    //original
    input [`DATA_WIDTH-1:0] dataIn_N,   // data inputs from neighboring tiles
    input [`DATA_WIDTH-1:0] dataIn_E,
    input [`DATA_WIDTH-1:0] dataIn_S,
    input [`DATA_WIDTH-1:0] dataIn_W,
    input [`DATA_WIDTH-1:0] dataIn_P,   // data input from processor
       
    input validIn_N,        // valid signals from neighboring tiles
    input validIn_E,
    input validIn_S,
    input validIn_W,
    input validIn_P,        // valid signal from processor
       
    input yummyIn_N,        // neighbor consumed output data
    input yummyIn_E,
    input yummyIn_S,
    input yummyIn_W,
    input yummyIn_P,        // processor consumed output data
    */   
    input [`XY_WIDTH-1:0] myLocX,       // this tile's position
    input [`XY_WIDTH-1:0] myLocY,
    input [`CHIP_ID_WIDTH-1:0] myChipID,
    
    output [`DATA_WIDTH-1:0] dataOut_0,
    output [`DATA_WIDTH-1:0] dataOut_1,
    output [`DATA_WIDTH-1:0] dataOut_2,
    output [`DATA_WIDTH-1:0] dataOut_3,
    output [`DATA_WIDTH-1:0] dataOut_4,
    output [`DATA_WIDTH-1:0] dataOut_5,
    output [`DATA_WIDTH-1:0] dataOut_6,
    output [`DATA_WIDTH-1:0] dataOut_7,

    output validOut_0,
    output validOut_1,
    output validOut_2,
    output validOut_3,
    output validOut_4,
    output validOut_5,
    output validOut_6,
    output validOut_7,

    output yummyOut_0,
    output yummyOut_1,
    output yummyOut_2,
    output yummyOut_3,
    output yummyOut_4,
    output yummyOut_5,
    output yummyOut_6,
    output yummyOut_7,


    /*
    //original
    output [`DATA_WIDTH-1:0] dataOut_N, // data outputs to neighbors
    output [`DATA_WIDTH-1:0] dataOut_E,
    output [`DATA_WIDTH-1:0] dataOut_S,
    output [`DATA_WIDTH-1:0] dataOut_W,
    output [`DATA_WIDTH-1:0] dataOut_P, // data output to processor
    
    output validOut_N,      // valid outputs to neighbors
    output validOut_E,
    output validOut_S,
    output validOut_W,
    output validOut_P,      // valid output to processor
       
    output yummyOut_N,      // yummy signal to neighbors' output buffers
    output yummyOut_E,
    output yummyOut_S,
    output yummyOut_W,
    output yummyOut_P,      // yummy signal to processor's output buffer
    */
    
    output thanksIn_7      // thanksIn to processor's space_avail
);

    io_xbar_top io_xbar_top
    (
        .clk(clk),
        .reset_in(reset_in),
        
        .dataIn_0(dataIn_0),
        .dataIn_1(dataIn_1),
        .dataIn_2(dataIn_2),
        .dataIn_3(dataIn_3),
        .dataIn_4(dataIn_4),
        .dataIn_5(dataIn_5),
        .dataIn_6(dataIn_6),
        .dataIn_7(dataIn_7),
        .validIn_0(validIn_0),
        .validIn_1(validIn_1),
        .validIn_2(validIn_2),
        .validIn_3(validIn_3),
        .validIn_4(validIn_4),
        .validIn_5(validIn_5),
        .validIn_6(validIn_6),
        .validIn_7(validIn_7),
        .yummyIn_0(yummyIn_0),
        .yummyIn_1(yummyIn_1),
        .yummyIn_2(yummyIn_2),
        .yummyIn_3(yummyIn_3),
        .yummyIn_4(yummyIn_4),
        .yummyIn_5(yummyIn_5),
        .yummyIn_6(yummyIn_6),
        .yummyIn_7(yummyIn_7),

        .myLocX(myLocX),
        .myLocY(myLocY),
        .myChipID(myChipID),
        .ec_cfg(32'b0),
        .store_meter_partner_address_X(5'b0),
        .store_meter_partner_address_Y(5'b0),
        
        .dataOut_0(dataOut_0),
        .dataOut_1(dataOut_1),
        .dataOut_2(dataOut_2),
        .dataOut_3(dataOut_3),
        .dataOut_4(dataOut_4),
        .dataOut_5(dataOut_5),
        .dataOut_6(dataOut_6),
        .dataOut_7(dataOut_7),
        .validOut_0(validOut_0),
        .validOut_1(validOut_1),
        .validOut_2(validOut_2),
        .validOut_3(validOut_3),
        .validOut_4(validOut_4),
        .validOut_5(validOut_5),
        .validOut_6(validOut_6),
        .validOut_7(validOut_7),
        .yummyOut_0(yummyOut_0),
        .yummyOut_1(yummyOut_1),
        .yummyOut_2(yummyOut_2),
        .yummyOut_3(yummyOut_3),
        .yummyOut_4(yummyOut_4),
        .yummyOut_5(yummyOut_5),
        .yummyOut_6(yummyOut_6),
        .yummyOut_7(yummyOut_7),

        .thanksIn_7(thanksIn_7),
        .external_interrupt(),
        .store_meter_ack_partner(),
        .store_meter_ack_non_partner(),
        .ec_out()
    ); 

endmodule
