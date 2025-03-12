// Modified by Princeton University on June 9th, 2015
// ========== Copyright Header Begin ==========================================
//
// OpenSPARC T1 Processor File: ciop_iob.v
// Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
// DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
//
// The above named program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// The above named program is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public
// License along with this work; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
//
// ========== Copyright Header End ============================================
`timescale 1ps/1ps
`include "define.tmp.h"
`include "cross_module.tmp.h"

// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml


module ciop_fake_iob(
    input clk,
    input rst_n,

    output reg noc_out_val,
    input noc_out_rdy,
    output reg [`NOC_DATA_WIDTH-1:0] noc_out_data
,
   input                spc0_inst_done,
   input [63:0]         pc_w0

,
   input                spc1_inst_done,
   input [63:0]         pc_w1

,
   input                spc2_inst_done,
   input [63:0]         pc_w2

,
   input                spc3_inst_done,
   input [63:0]         pc_w3

,
   input                spc4_inst_done,
   input [63:0]         pc_w4

,
   input                spc5_inst_done,
   input [63:0]         pc_w5

,
   input                spc6_inst_done,
   input [63:0]         pc_w6

,
   input                spc7_inst_done,
   input [63:0]         pc_w7

,
   input                spc8_inst_done,
   input [63:0]         pc_w8

,
   input                spc9_inst_done,
   input [63:0]         pc_w9

,
   input                spc10_inst_done,
   input [63:0]         pc_w10

,
   input                spc11_inst_done,
   input [63:0]         pc_w11

,
   input                spc12_inst_done,
   input [63:0]         pc_w12

,
   input                spc13_inst_done,
   input [63:0]         pc_w13

,
   input                spc14_inst_done,
   input [63:0]         pc_w14

,
   input                spc15_inst_done,
   input [63:0]         pc_w15

,
   input                spc16_inst_done,
   input [63:0]         pc_w16

,
   input                spc17_inst_done,
   input [63:0]         pc_w17

,
   input                spc18_inst_done,
   input [63:0]         pc_w18

,
   input                spc19_inst_done,
   input [63:0]         pc_w19

,
   input                spc20_inst_done,
   input [63:0]         pc_w20

,
   input                spc21_inst_done,
   input [63:0]         pc_w21

,
   input                spc22_inst_done,
   input [63:0]         pc_w22

,
   input                spc23_inst_done,
   input [63:0]         pc_w23

,
   input                spc24_inst_done,
   input [63:0]         pc_w24

,
   input                spc25_inst_done,
   input [63:0]         pc_w25

,
   input                spc26_inst_done,
   input [63:0]         pc_w26

,
   input                spc27_inst_done,
   input [63:0]         pc_w27

,
   input                spc28_inst_done,
   input [63:0]         pc_w28

,
   input                spc29_inst_done,
   input [63:0]         pc_w29

,
   input                spc30_inst_done,
   input [63:0]         pc_w30

,
   input                spc31_inst_done,
   input [63:0]         pc_w31

,
   input                spc32_inst_done,
   input [63:0]         pc_w32

,
   input                spc33_inst_done,
   input [63:0]         pc_w33

,
   input                spc34_inst_done,
   input [63:0]         pc_w34

,
   input                spc35_inst_done,
   input [63:0]         pc_w35

,
   input                spc36_inst_done,
   input [63:0]         pc_w36

,
   input                spc37_inst_done,
   input [63:0]         pc_w37

,
   input                spc38_inst_done,
   input [63:0]         pc_w38

,
   input                spc39_inst_done,
   input [63:0]         pc_w39

,
   input                spc40_inst_done,
   input [63:0]         pc_w40

,
   input                spc41_inst_done,
   input [63:0]         pc_w41

,
   input                spc42_inst_done,
   input [63:0]         pc_w42

,
   input                spc43_inst_done,
   input [63:0]         pc_w43

,
   input                spc44_inst_done,
   input [63:0]         pc_w44

,
   input                spc45_inst_done,
   input [63:0]         pc_w45

,
   input                spc46_inst_done,
   input [63:0]         pc_w46

,
   input                spc47_inst_done,
   input [63:0]         pc_w47

,
   input                spc48_inst_done,
   input [63:0]         pc_w48

,
   input                spc49_inst_done,
   input [63:0]         pc_w49

,
   input                spc50_inst_done,
   input [63:0]         pc_w50

,
   input                spc51_inst_done,
   input [63:0]         pc_w51

,
   input                spc52_inst_done,
   input [63:0]         pc_w52

,
   input                spc53_inst_done,
   input [63:0]         pc_w53

,
   input                spc54_inst_done,
   input [63:0]         pc_w54

,
   input                spc55_inst_done,
   input [63:0]         pc_w55

,
   input                spc56_inst_done,
   input [63:0]         pc_w56

,
   input                spc57_inst_done,
   input [63:0]         pc_w57

,
   input                spc58_inst_done,
   input [63:0]         pc_w58

,
   input                spc59_inst_done,
   input [63:0]         pc_w59

,
   input                spc60_inst_done,
   input [63:0]         pc_w60

,
   input                spc61_inst_done,
   input [63:0]         pc_w61

,
   input                spc62_inst_done,
   input [63:0]         pc_w62

,
   input                spc63_inst_done,
   input [63:0]         pc_w63



);
//temp. memory.
reg [`CPX_WIDTH-1:0] 	    fake_iob_out_data;

wire [`CPX_WIDTH-1:0]       cpx_data = fake_iob_out_data;

// Output buffer
// The output buffer need to be asynchronous and cannot ever be overflowed.
// We will ensure this by having a lot of entries
localparam NUM_ASYNC_ENTRIES = 256;

reg [`NOC_DATA_WIDTH-1:0] out_buffer [NUM_ASYNC_ENTRIES-1:0];
reg [NUM_ASYNC_ENTRIES-1:0] out_buffer_val;

reg iob_buffer_val;
reg [2*`NOC_DATA_WIDTH-1:0] iob_buffer_data;

///////////////////////////////////////////////////////////
// write port of the async fifo; runs at chip frequency
///////////////////////////////////////////////////////////
reg [7:0] out_write_index;
reg [7:0] out_write_index_next;

integer i;

always @ (posedge `CHIP.clk_muxed)
begin
    if (!rst_n)
        out_write_index <= 0;
    else
    begin
        out_write_index <= out_write_index_next;
    end

    // write port
    if (!rst_n)
        for (i = 0; i < NUM_ASYNC_ENTRIES; i = i + 1)
        begin
            out_buffer[i] = 0;
            out_buffer_val[i] = 1'b0;
        end
    else
    begin
        if (iob_buffer_val)
        begin
            // no ready; always accepting packet
            out_buffer[out_write_index + 1] = iob_buffer_data[63:0];
            out_buffer[out_write_index] = iob_buffer_data[127:64];
            out_buffer_val[out_write_index] = 1'b1;
            out_buffer_val[out_write_index + 1] = 1'b1;
        end
    end

end

always @ *
begin
    out_write_index_next = iob_buffer_val ? out_write_index + 2 : out_write_index;
end


///////////////////////////////////////////////////////////
// read port of the async fifo; runs at off-chip frequency
///////////////////////////////////////////////////////////
reg [7:0] out_read_index;
reg [7:0] out_read_index_next;

always @ (posedge clk)
begin
    if (!rst_n)
        out_read_index <= 0;
    else
    begin
        out_read_index <= out_read_index_next;
    end

    if (noc_out_rdy && noc_out_val)
    begin
        out_buffer_val[out_read_index] = 1'b0;
    end
end

always @ *
begin
    noc_out_val = out_buffer_val[out_read_index];
    noc_out_data = 0; // Tri: fixes x when out_buffer_counter == 0
    noc_out_data = out_buffer[out_read_index];

    out_read_index_next = (noc_out_rdy && noc_out_val) ? out_read_index + 1 : out_read_index;
end

///////////////////////////////////////////////////////////
// Make out going packets from IOB out data
///////////////////////////////////////////////////////////
reg [63:0] iob_buffer_flit1;
reg [63:0] iob_buffer_flit2;
reg  [`NOC_X_WIDTH-1:0] dest_x;
reg  [`NOC_Y_WIDTH-1:0] dest_y;
always @ *
begin
   iob_buffer_val = fake_iob_out_data[144];
   iob_buffer_flit1 = {14'b0,5'b0, 3'b0, 8'b0,`NOC_FBITS_L1,8'd1, `MSG_TYPE_INTERRUPT,14'b0};
   iob_buffer_flit2 = {fake_iob_out_data[63:16],7'b0,fake_iob_out_data[8:0]};

   // assuming a 8x8 topo
   iob_buffer_flit1[`MSG_DST_X] = dest_x;
   iob_buffer_flit1[`MSG_DST_Y] = dest_y;

   //if (iob_buffer_val)
   //begin
   //   $display("IOB sending to tile X:%d Y:%d", iob_buffer_flit1[`MSG_DST_X], iob_buffer_flit1[`MSG_DST_Y]);
   //   $display("   raw tileid %x", fake_iob_out_data[49:18]);
   // end

   iob_buffer_data = {iob_buffer_flit1, iob_buffer_flit2};
end

always @*
begin
    case (fake_iob_out_data[49:18])
    
32'd0:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd1:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd2:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd3:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd4:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd5:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd6:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd7:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd8:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd9:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd10:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd11:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd12:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd13:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd14:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd15:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd16:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd17:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd18:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd19:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd20:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd21:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd22:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd23:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd24:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd25:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd26:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd27:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd28:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd29:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd30:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd31:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd32:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd33:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd34:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd35:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd36:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd37:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd38:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd39:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd40:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd41:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd42:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd43:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd44:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd45:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd46:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd47:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd48:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd49:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd50:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd51:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd52:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd53:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd54:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd55:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd56:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd57:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd58:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd59:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd60:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd61:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd62:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd63:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd7;
end

    default:
    begin
        dest_x = `NOC_X_WIDTH'dX;
        dest_y = `NOC_Y_WIDTH'dX;
    end
    endcase
end


// input signals

wire                             spc0_inst_done_buf  = spc0_inst_done;
wire [63:0]                      pc_w0_buf           = pc_w0;


wire                             spc1_inst_done_buf  = spc1_inst_done;
wire [63:0]                      pc_w1_buf           = pc_w1;


wire                             spc2_inst_done_buf  = spc2_inst_done;
wire [63:0]                      pc_w2_buf           = pc_w2;


wire                             spc3_inst_done_buf  = spc3_inst_done;
wire [63:0]                      pc_w3_buf           = pc_w3;


wire                             spc4_inst_done_buf  = spc4_inst_done;
wire [63:0]                      pc_w4_buf           = pc_w4;


wire                             spc5_inst_done_buf  = spc5_inst_done;
wire [63:0]                      pc_w5_buf           = pc_w5;


wire                             spc6_inst_done_buf  = spc6_inst_done;
wire [63:0]                      pc_w6_buf           = pc_w6;


wire                             spc7_inst_done_buf  = spc7_inst_done;
wire [63:0]                      pc_w7_buf           = pc_w7;


wire                             spc8_inst_done_buf  = spc8_inst_done;
wire [63:0]                      pc_w8_buf           = pc_w8;


wire                             spc9_inst_done_buf  = spc9_inst_done;
wire [63:0]                      pc_w9_buf           = pc_w9;


wire                             spc10_inst_done_buf  = spc10_inst_done;
wire [63:0]                      pc_w10_buf           = pc_w10;


wire                             spc11_inst_done_buf  = spc11_inst_done;
wire [63:0]                      pc_w11_buf           = pc_w11;


wire                             spc12_inst_done_buf  = spc12_inst_done;
wire [63:0]                      pc_w12_buf           = pc_w12;


wire                             spc13_inst_done_buf  = spc13_inst_done;
wire [63:0]                      pc_w13_buf           = pc_w13;


wire                             spc14_inst_done_buf  = spc14_inst_done;
wire [63:0]                      pc_w14_buf           = pc_w14;


wire                             spc15_inst_done_buf  = spc15_inst_done;
wire [63:0]                      pc_w15_buf           = pc_w15;


wire                             spc16_inst_done_buf  = spc16_inst_done;
wire [63:0]                      pc_w16_buf           = pc_w16;


wire                             spc17_inst_done_buf  = spc17_inst_done;
wire [63:0]                      pc_w17_buf           = pc_w17;


wire                             spc18_inst_done_buf  = spc18_inst_done;
wire [63:0]                      pc_w18_buf           = pc_w18;


wire                             spc19_inst_done_buf  = spc19_inst_done;
wire [63:0]                      pc_w19_buf           = pc_w19;


wire                             spc20_inst_done_buf  = spc20_inst_done;
wire [63:0]                      pc_w20_buf           = pc_w20;


wire                             spc21_inst_done_buf  = spc21_inst_done;
wire [63:0]                      pc_w21_buf           = pc_w21;


wire                             spc22_inst_done_buf  = spc22_inst_done;
wire [63:0]                      pc_w22_buf           = pc_w22;


wire                             spc23_inst_done_buf  = spc23_inst_done;
wire [63:0]                      pc_w23_buf           = pc_w23;


wire                             spc24_inst_done_buf  = spc24_inst_done;
wire [63:0]                      pc_w24_buf           = pc_w24;


wire                             spc25_inst_done_buf  = spc25_inst_done;
wire [63:0]                      pc_w25_buf           = pc_w25;


wire                             spc26_inst_done_buf  = spc26_inst_done;
wire [63:0]                      pc_w26_buf           = pc_w26;


wire                             spc27_inst_done_buf  = spc27_inst_done;
wire [63:0]                      pc_w27_buf           = pc_w27;


wire                             spc28_inst_done_buf  = spc28_inst_done;
wire [63:0]                      pc_w28_buf           = pc_w28;


wire                             spc29_inst_done_buf  = spc29_inst_done;
wire [63:0]                      pc_w29_buf           = pc_w29;


wire                             spc30_inst_done_buf  = spc30_inst_done;
wire [63:0]                      pc_w30_buf           = pc_w30;


wire                             spc31_inst_done_buf  = spc31_inst_done;
wire [63:0]                      pc_w31_buf           = pc_w31;


wire                             spc32_inst_done_buf  = spc32_inst_done;
wire [63:0]                      pc_w32_buf           = pc_w32;


wire                             spc33_inst_done_buf  = spc33_inst_done;
wire [63:0]                      pc_w33_buf           = pc_w33;


wire                             spc34_inst_done_buf  = spc34_inst_done;
wire [63:0]                      pc_w34_buf           = pc_w34;


wire                             spc35_inst_done_buf  = spc35_inst_done;
wire [63:0]                      pc_w35_buf           = pc_w35;


wire                             spc36_inst_done_buf  = spc36_inst_done;
wire [63:0]                      pc_w36_buf           = pc_w36;


wire                             spc37_inst_done_buf  = spc37_inst_done;
wire [63:0]                      pc_w37_buf           = pc_w37;


wire                             spc38_inst_done_buf  = spc38_inst_done;
wire [63:0]                      pc_w38_buf           = pc_w38;


wire                             spc39_inst_done_buf  = spc39_inst_done;
wire [63:0]                      pc_w39_buf           = pc_w39;


wire                             spc40_inst_done_buf  = spc40_inst_done;
wire [63:0]                      pc_w40_buf           = pc_w40;


wire                             spc41_inst_done_buf  = spc41_inst_done;
wire [63:0]                      pc_w41_buf           = pc_w41;


wire                             spc42_inst_done_buf  = spc42_inst_done;
wire [63:0]                      pc_w42_buf           = pc_w42;


wire                             spc43_inst_done_buf  = spc43_inst_done;
wire [63:0]                      pc_w43_buf           = pc_w43;


wire                             spc44_inst_done_buf  = spc44_inst_done;
wire [63:0]                      pc_w44_buf           = pc_w44;


wire                             spc45_inst_done_buf  = spc45_inst_done;
wire [63:0]                      pc_w45_buf           = pc_w45;


wire                             spc46_inst_done_buf  = spc46_inst_done;
wire [63:0]                      pc_w46_buf           = pc_w46;


wire                             spc47_inst_done_buf  = spc47_inst_done;
wire [63:0]                      pc_w47_buf           = pc_w47;


wire                             spc48_inst_done_buf  = spc48_inst_done;
wire [63:0]                      pc_w48_buf           = pc_w48;


wire                             spc49_inst_done_buf  = spc49_inst_done;
wire [63:0]                      pc_w49_buf           = pc_w49;


wire                             spc50_inst_done_buf  = spc50_inst_done;
wire [63:0]                      pc_w50_buf           = pc_w50;


wire                             spc51_inst_done_buf  = spc51_inst_done;
wire [63:0]                      pc_w51_buf           = pc_w51;


wire                             spc52_inst_done_buf  = spc52_inst_done;
wire [63:0]                      pc_w52_buf           = pc_w52;


wire                             spc53_inst_done_buf  = spc53_inst_done;
wire [63:0]                      pc_w53_buf           = pc_w53;


wire                             spc54_inst_done_buf  = spc54_inst_done;
wire [63:0]                      pc_w54_buf           = pc_w54;


wire                             spc55_inst_done_buf  = spc55_inst_done;
wire [63:0]                      pc_w55_buf           = pc_w55;


wire                             spc56_inst_done_buf  = spc56_inst_done;
wire [63:0]                      pc_w56_buf           = pc_w56;


wire                             spc57_inst_done_buf  = spc57_inst_done;
wire [63:0]                      pc_w57_buf           = pc_w57;


wire                             spc58_inst_done_buf  = spc58_inst_done;
wire [63:0]                      pc_w58_buf           = pc_w58;


wire                             spc59_inst_done_buf  = spc59_inst_done;
wire [63:0]                      pc_w59_buf           = pc_w59;


wire                             spc60_inst_done_buf  = spc60_inst_done;
wire [63:0]                      pc_w60_buf           = pc_w60;


wire                             spc61_inst_done_buf  = spc61_inst_done;
wire [63:0]                      pc_w61_buf           = pc_w61;


wire                             spc62_inst_done_buf  = spc62_inst_done;
wire [63:0]                      pc_w62_buf           = pc_w62;


wire                             spc63_inst_done_buf  = spc63_inst_done;
wire [63:0]                      pc_w63_buf           = pc_w63;




reg 	 ok_iob;
initial
begin
    ok_iob    = 0;
    fake_iob_out_data  = 0;
end

integer cpx_driven;

//// cmp clock domain
//// trin bug #65: use reference clock from the chip b/c the fake iob
//// needs to monitor the core PC
//always @(negedge `CHIP.clk_muxed)
//begin
//    if(ok_iob)
//    begin
            
//        cpx_driven = drive_iob();
//        if (cpx_driven) begin
//            fake_iob_out_data[`CPX_WIDTH-1:128] = get_cpx_word(0);
//            fake_iob_out_data[127:96] = get_cpx_word(1);
//            fake_iob_out_data[95:64] = get_cpx_word(2);
//            fake_iob_out_data[63:32] = get_cpx_word(3);
//            fake_iob_out_data[31:0] = get_cpx_word(4);
//            //$display("Doing IOB stuff - got values: %x %x %x %x %x", fake_iob_out_data[159:128], fake_iob_out_data[127:96], fake_iob_out_data[95:64], fake_iob_out_data[63:32], fake_iob_out_data[31:0]);
//        end else begin
//            fake_iob_out_data = {160{1'b0}};
//        end
//
//        // a little error check
//        if (iob_buffer_val && (out_buffer_val[out_write_index] | out_buffer_val[out_write_index + 1] == 1'b1))
//        begin
//            $display("%d : Simulation -> FAIL(%0s)", $time, "ciop_iob.v: IOB out buffer overflowed");
//            repeat(5)@(posedge clk);
//`ifndef DISABLE_ALL_MONITORS
//            `MONITOR_PATH.fail("ciop_iob.v: IOB out buffer overflowed");
//`endif
//        end
//    end // if (ok_iob)
//end // always @ (posedge cmp_gclk)

endmodule
