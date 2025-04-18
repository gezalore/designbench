// Copyright (c) 2015 Princeton University
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of Princeton University nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//==================================================================================================
//  Filename      : config_regs.v
//  Created On    : 2014-01-31 18:24:47
//  Last Modified : 2018-11-16 17:23:15
//  Revision      :
//  Author        : Tri Nguyen
//  Company       : Princeton University
//  Email         : trin@princeton.edu
//
//  Description   :
//
//
//==================================================================================================

//`timescale 1 ns / 10 ps
`include "l15.tmp.h"
`include "define.tmp.h"
`include "dmbr_define.v"


`ifdef L15_EXTRA_DEBUG
`default_nettype none
`endif
module config_regs(
   input wire clk,
   input wire rst_n,

   input wire l15_config_req_val_s2,
   input wire l15_config_req_rw_s2,
   input wire [63:0] l15_config_write_req_data_s2,
   input wire [`CONFIG_REG_ADDRESS_MASK] l15_config_req_address_s2,

   input wire [`NOC_CHIPID_WIDTH-1:0] default_chipid,
   input wire [`NOC_X_WIDTH-1:0] default_coreid_x,
   input wire [`NOC_Y_WIDTH-1:0] default_coreid_y,
   input wire [31:0] default_total_num_tiles,

input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_0,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_1,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_2,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_3,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_4,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_5,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_6,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_7,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_8,
input wire [`CREDIT_WIDTH-1:0] from_dmbr_cred_bin_9,


   output wire [63:0] config_l15_read_res_data_s3,

   output wire [`L15_HMT_BASE_ADDR_WIDTH-1:0] config_hmt_base,

   output wire                         config_dmbr_func_en,
   output wire                         config_dmbr_stall_en,
   output wire                         config_dmbr_proc_ld,
   output wire [`REPLENISH_WIDTH-1:0]  config_dmbr_replenish_cycles,
   output wire [`SCALE_WIDTH-1:0]      config_dmbr_bin_scale,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_0,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_1,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_2,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_3,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_4,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_5,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_6,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_7,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_8,
output wire [`CREDIT_WIDTH-1:0] config_dmbr_cred_bin_9,



   output wire config_csm_en,
   output wire [31:0] config_system_tile_count,
   output wire [`HOME_ALLOC_METHOD_WIDTH-1:0] config_home_alloc_method,

   output wire [`NOC_CHIPID_WIDTH-1:0] config_chipid,
   output wire [`NOC_X_WIDTH-1:0] config_coreid_x,
   output wire [`NOC_Y_WIDTH-1:0] config_coreid_y,

   // r/w port for jtag to config regs
   input wire rtap_config_req_val,
   input wire rtap_config_req_rw,
   input wire [63:0] rtap_config_write_req_data,
   input wire [`CONFIG_REG_ADDRESS_MASK] rtap_config_req_address,
   output wire [63:0] config_rtap_read_res_data
);

reg [63:0] read_data_s3;
reg [63:0] read_data_s3_next;

reg                        dmbr_func_en            , dmbr_func_en_next;
reg                        dmbr_stall_en           , dmbr_stall_en_next;
reg                        dmbr_proc_ld            , dmbr_proc_ld_next;
reg                        dmbr_rd_cur_val         , dmbr_rd_cur_val_next;
reg [`REPLENISH_WIDTH-1:0] dmbr_replenish_cycles   , dmbr_replenish_cycles_next;
reg [`SCALE_WIDTH-1:0]     dmbr_bin_scale          , dmbr_bin_scale_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_0, dmbr_cred_bin_0_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_1, dmbr_cred_bin_1_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_2, dmbr_cred_bin_2_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_3, dmbr_cred_bin_3_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_4, dmbr_cred_bin_4_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_5, dmbr_cred_bin_5_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_6, dmbr_cred_bin_6_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_7, dmbr_cred_bin_7_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_8, dmbr_cred_bin_8_next;
reg [`CREDIT_WIDTH-1:0] dmbr_cred_bin_9, dmbr_cred_bin_9_next;


reg csm_en;
reg [`L15_HMT_BASE_ADDR_WIDTH-1:0] hmt_base;
reg [31:0] system_tile_count;
reg [`HOME_ALLOC_METHOD_WIDTH-1:0]  home_alloc_method;

reg csm_en_next;
reg [31:0] system_tile_count_next;
reg [`L15_HMT_BASE_ADDR_WIDTH-1:0] hmt_base_next;
reg [`HOME_ALLOC_METHOD_WIDTH-1:0]  home_alloc_method_next;

reg [`NOC_CHIPID_WIDTH-1:0] chipid;
reg [`NOC_X_WIDTH-1:0] coreid_x;
reg [`NOC_Y_WIDTH-1:0] coreid_y;
reg [`NOC_CHIPID_WIDTH-1:0] chipid_next;
reg [`NOC_X_WIDTH-1:0] coreid_x_next;
reg [`NOC_Y_WIDTH-1:0] coreid_y_next;

assign config_l15_read_res_data_s3 = read_data_s3;
assign config_rtap_read_res_data = read_data_s3; // trin: do not use jtag to read at the same time as the core!

assign config_dmbr_func_en = dmbr_func_en;
assign config_dmbr_stall_en = dmbr_stall_en;
assign config_dmbr_proc_ld = dmbr_proc_ld;
assign config_dmbr_replenish_cycles = dmbr_replenish_cycles;
assign config_dmbr_bin_scale = dmbr_bin_scale;
assign config_dmbr_cred_bin_0 = dmbr_cred_bin_0;
assign config_dmbr_cred_bin_1 = dmbr_cred_bin_1;
assign config_dmbr_cred_bin_2 = dmbr_cred_bin_2;
assign config_dmbr_cred_bin_3 = dmbr_cred_bin_3;
assign config_dmbr_cred_bin_4 = dmbr_cred_bin_4;
assign config_dmbr_cred_bin_5 = dmbr_cred_bin_5;
assign config_dmbr_cred_bin_6 = dmbr_cred_bin_6;
assign config_dmbr_cred_bin_7 = dmbr_cred_bin_7;
assign config_dmbr_cred_bin_8 = dmbr_cred_bin_8;
assign config_dmbr_cred_bin_9 = dmbr_cred_bin_9;


assign config_hmt_base = hmt_base;

`ifdef PITON_NO_CSM
   assign config_csm_en = 1'b0;
`else
   assign config_csm_en = csm_en;
`endif

assign config_system_tile_count = system_tile_count;
assign config_home_alloc_method = home_alloc_method;
assign config_chipid = chipid;
assign config_coreid_x = coreid_x;
assign config_coreid_y = coreid_y;

always @ (posedge clk)
begin
   if (!rst_n)
   begin
      read_data_s3 <= 0;

      dmbr_func_en            <= 1'b0;
      dmbr_stall_en           <= 1'b0;
      dmbr_proc_ld            <= 1'b0;
      dmbr_replenish_cycles   <= {`REPLENISH_WIDTH{1'b0}};
      dmbr_bin_scale          <= {`SCALE_WIDTH{1'b0}};
      dmbr_cred_bin_0 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_1 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_2 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_3 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_4 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_5 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_6 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_7 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_8 <= {`CREDIT_WIDTH{1'b0}};
dmbr_cred_bin_9 <= {`CREDIT_WIDTH{1'b0}};


      dmbr_rd_cur_val <= 1'b0;
      hmt_base <= `L15_HMT_BASE_ADDR_WIDTH'b0;
      csm_en <= 1'b0;
      system_tile_count <= default_total_num_tiles;
      home_alloc_method <= `HOME_ALLOC_MIXED_ORDER_BITS;
      chipid <= default_chipid;
      coreid_x <= default_coreid_x;
      coreid_y <= default_coreid_y;
   end
   else
   begin
      read_data_s3 <= read_data_s3_next;

      dmbr_func_en <= dmbr_func_en_next;
      dmbr_stall_en <= dmbr_stall_en_next;
      dmbr_proc_ld <= dmbr_proc_ld_next;
      dmbr_replenish_cycles <= dmbr_replenish_cycles_next;
      dmbr_bin_scale <= dmbr_bin_scale_next;
      dmbr_cred_bin_0 <= dmbr_cred_bin_0_next;
dmbr_cred_bin_1 <= dmbr_cred_bin_1_next;
dmbr_cred_bin_2 <= dmbr_cred_bin_2_next;
dmbr_cred_bin_3 <= dmbr_cred_bin_3_next;
dmbr_cred_bin_4 <= dmbr_cred_bin_4_next;
dmbr_cred_bin_5 <= dmbr_cred_bin_5_next;
dmbr_cred_bin_6 <= dmbr_cred_bin_6_next;
dmbr_cred_bin_7 <= dmbr_cred_bin_7_next;
dmbr_cred_bin_8 <= dmbr_cred_bin_8_next;
dmbr_cred_bin_9 <= dmbr_cred_bin_9_next;

      dmbr_rd_cur_val <= dmbr_rd_cur_val_next;
      hmt_base <= hmt_base_next;
      csm_en <= csm_en_next;
      system_tile_count <= system_tile_count_next;
      home_alloc_method <= home_alloc_method_next;
      chipid <= chipid_next;
      coreid_x <= coreid_x_next;
      coreid_y <= coreid_y_next;
   end
end

// multiplexing between core and jtag port
reg req_val;
reg req_rw;
reg [63:0] req_data;
reg [`CONFIG_REG_ADDRESS_MASK] req_address;
always @ *
begin
   req_val = rtap_config_req_val || l15_config_req_val_s2;
   req_rw = l15_config_req_rw_s2;
   req_data = l15_config_write_req_data_s2;
   req_address = l15_config_req_address_s2;

   if (rtap_config_req_val)
   begin
      req_rw = rtap_config_req_rw;
      req_data = rtap_config_write_req_data;
      req_address = rtap_config_req_address;
   end
end

// write port
always @ *
begin
   dmbr_func_en_next = dmbr_func_en;
   dmbr_stall_en_next = dmbr_stall_en;
   dmbr_proc_ld_next = dmbr_proc_ld;
   dmbr_replenish_cycles_next = dmbr_replenish_cycles;
   dmbr_bin_scale_next = dmbr_bin_scale;
   dmbr_cred_bin_0_next = dmbr_cred_bin_0;
dmbr_cred_bin_1_next = dmbr_cred_bin_1;
dmbr_cred_bin_2_next = dmbr_cred_bin_2;
dmbr_cred_bin_3_next = dmbr_cred_bin_3;
dmbr_cred_bin_4_next = dmbr_cred_bin_4;
dmbr_cred_bin_5_next = dmbr_cred_bin_5;
dmbr_cred_bin_6_next = dmbr_cred_bin_6;
dmbr_cred_bin_7_next = dmbr_cred_bin_7;
dmbr_cred_bin_8_next = dmbr_cred_bin_8;
dmbr_cred_bin_9_next = dmbr_cred_bin_9;


   dmbr_rd_cur_val_next = dmbr_rd_cur_val;
   hmt_base_next = hmt_base;
   csm_en_next = csm_en;
   system_tile_count_next = system_tile_count;
   home_alloc_method_next = home_alloc_method;
   chipid_next = chipid;
   coreid_x_next = coreid_x;
   coreid_y_next = coreid_y;

   if (req_val && req_rw == 1'b1)
   begin
      case (req_address[`CONFIG_REG_ADDRESS_MASK])
         `CONFIG_REG_CHIPID_ADDRESS:
         begin
            {chipid_next, coreid_y_next, coreid_x_next} = req_data;
         end
         `CONFIG_REG_CSM_EN_ADDRESS:
         begin
            csm_en_next = req_data[0];
         end
         `CONFIG_REG_DMBR_REG1_ADDRESS:
         begin
            dmbr_func_en_next    = req_data[`CFG_DMBR_FUNC_EN_BIT];
            dmbr_stall_en_next   = req_data[`CFG_DMBR_STALL_EN_BIT];
            dmbr_proc_ld_next    = req_data[`CFG_DMBR_PROC_LD_BIT];
            dmbr_rd_cur_val_next = req_data[`CFG_DMBR_RD_CUR_VAL_BIT];
            dmbr_cred_bin_0_next = req_data[`CFG_DMBR_CRED_BIN_0_BITS];
dmbr_cred_bin_1_next = req_data[`CFG_DMBR_CRED_BIN_1_BITS];
dmbr_cred_bin_2_next = req_data[`CFG_DMBR_CRED_BIN_2_BITS];
dmbr_cred_bin_3_next = req_data[`CFG_DMBR_CRED_BIN_3_BITS];
dmbr_cred_bin_4_next = req_data[`CFG_DMBR_CRED_BIN_4_BITS];
dmbr_cred_bin_5_next = req_data[`CFG_DMBR_CRED_BIN_5_BITS];
dmbr_cred_bin_6_next = req_data[`CFG_DMBR_CRED_BIN_6_BITS];
dmbr_cred_bin_7_next = req_data[`CFG_DMBR_CRED_BIN_7_BITS];
dmbr_cred_bin_8_next = req_data[`CFG_DMBR_CRED_BIN_8_BITS];
dmbr_cred_bin_9_next = req_data[`CFG_DMBR_CRED_BIN_9_BITS];

         end
         `CONFIG_REG_DMBR_REG2_ADDRESS:
         begin
            dmbr_replenish_cycles_next = req_data[`CFG_DMBR_REPLENISH_BITS];
            dmbr_bin_scale_next        = req_data[`CFG_DMBR_BIN_SCALE_BITS];
         end
         `CONFIG_REG_HMT_BASE_REG:
         begin
            hmt_base_next = req_data[`L15_HMT_BASE_ADDR_WIDTH-1:0];
         end
         `CONFIG_SYSTEM_TILE_COUNT_ADDRESS:
         begin
            system_tile_count_next = req_data[31:0];
         end
         `CONFIG_REG_HOME_ALLOC_METHOD:
         begin
            home_alloc_method_next = req_data[`HOME_ALLOC_METHOD_WIDTH-1:0];
         end
      endcase
   end
end

// read port
always @ *
begin
   read_data_s3_next = read_data_s3;

   if (req_val && req_rw == 1'b0)
   begin
      case (req_address[`CONFIG_REG_ADDRESS_MASK])
         `CONFIG_REG_CHIPID_ADDRESS:
         begin
               read_data_s3_next = {chipid, coreid_y, coreid_x};
         end
         `CONFIG_REG_CSM_EN_ADDRESS:
         begin
               read_data_s3_next = config_csm_en;
         end
         `CONFIG_REG_DMBR_REG1_ADDRESS:
         begin
            read_data_s3_next[3:0] = {dmbr_rd_cur_val, dmbr_proc_ld, dmbr_stall_en, dmbr_func_en};
            if (dmbr_rd_cur_val)
            begin
            read_data_s3_next[`CFG_DMBR_CRED_BIN_0_BITS] = from_dmbr_cred_bin_0;
read_data_s3_next[`CFG_DMBR_CRED_BIN_1_BITS] = from_dmbr_cred_bin_1;
read_data_s3_next[`CFG_DMBR_CRED_BIN_2_BITS] = from_dmbr_cred_bin_2;
read_data_s3_next[`CFG_DMBR_CRED_BIN_3_BITS] = from_dmbr_cred_bin_3;
read_data_s3_next[`CFG_DMBR_CRED_BIN_4_BITS] = from_dmbr_cred_bin_4;
read_data_s3_next[`CFG_DMBR_CRED_BIN_5_BITS] = from_dmbr_cred_bin_5;
read_data_s3_next[`CFG_DMBR_CRED_BIN_6_BITS] = from_dmbr_cred_bin_6;
read_data_s3_next[`CFG_DMBR_CRED_BIN_7_BITS] = from_dmbr_cred_bin_7;
read_data_s3_next[`CFG_DMBR_CRED_BIN_8_BITS] = from_dmbr_cred_bin_8;
read_data_s3_next[`CFG_DMBR_CRED_BIN_9_BITS] = from_dmbr_cred_bin_9;

            end
            else
            begin
            read_data_s3_next[`CFG_DMBR_CRED_BIN_0_BITS] = dmbr_cred_bin_0;
read_data_s3_next[`CFG_DMBR_CRED_BIN_1_BITS] = dmbr_cred_bin_1;
read_data_s3_next[`CFG_DMBR_CRED_BIN_2_BITS] = dmbr_cred_bin_2;
read_data_s3_next[`CFG_DMBR_CRED_BIN_3_BITS] = dmbr_cred_bin_3;
read_data_s3_next[`CFG_DMBR_CRED_BIN_4_BITS] = dmbr_cred_bin_4;
read_data_s3_next[`CFG_DMBR_CRED_BIN_5_BITS] = dmbr_cred_bin_5;
read_data_s3_next[`CFG_DMBR_CRED_BIN_6_BITS] = dmbr_cred_bin_6;
read_data_s3_next[`CFG_DMBR_CRED_BIN_7_BITS] = dmbr_cred_bin_7;
read_data_s3_next[`CFG_DMBR_CRED_BIN_8_BITS] = dmbr_cred_bin_8;
read_data_s3_next[`CFG_DMBR_CRED_BIN_9_BITS] = dmbr_cred_bin_9;

            end
         end
         `CONFIG_REG_DMBR_REG2_ADDRESS:
         begin
            read_data_s3_next = {{64-`REPLENISH_WIDTH-`SCALE_WIDTH{1'b0}}, {dmbr_bin_scale, dmbr_replenish_cycles}};
         end
         `CONFIG_REG_HMT_BASE_REG:
         begin
            read_data_s3_next = config_hmt_base;
         end
         `CONFIG_SYSTEM_TILE_COUNT_ADDRESS:
         begin
            read_data_s3_next = system_tile_count;
         end
         `CONFIG_REG_HOME_ALLOC_METHOD:
         begin
            read_data_s3_next = home_alloc_method;
         end
      endcase
   end
end

endmodule
