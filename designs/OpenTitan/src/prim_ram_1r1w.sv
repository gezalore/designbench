// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This file is auto-generated.
// Used parser: Fallback (regex)


// This is to prevent AscentLint warnings in the generated
// abstract prim wrapper. These warnings occur due to the .*
// use. TODO: we may want to move these inline waivers
// into a separate, generated waiver file for consistency.
//ri lint_check_off OUTPUT_NOT_DRIVEN INPUT_NOT_READ HIER_BRANCH_NOT_READ
module prim_ram_1r1w
import prim_ram_2p_pkg::*;
#(

  parameter  int Width           = 32, // bit
  parameter  int Depth           = 128,
  parameter  int DataBitsPerMask = 1, // Number of data bits per bit of write mask
  parameter      MemInitFile     = "", // VMEM file to initialize the memory with

  localparam int Aw              = $clog2(Depth)  // derived parameter

) (
  input logic              clk_a_i,
  input logic              clk_b_i,
  input logic              rst_a_ni,
  input logic              rst_b_ni,

  // Port A can only write
  input                    a_req_i,
  input        [Aw-1:0]    a_addr_i,
  input        [Width-1:0] a_wdata_i,
  input  logic [Width-1:0] a_wmask_i,

  // Port B can only read
  input                    b_req_i,
  input        [Aw-1:0]    b_addr_i,
  output logic [Width-1:0] b_rdata_o,

  input  ram_2p_cfg_t      cfg_i,
  output ram_2p_cfg_rsp_t  cfg_rsp_o
);

  if (1) begin : gen_generic
    prim_generic_ram_1r1w #(
      .DataBitsPerMask(DataBitsPerMask),
      .Depth(Depth),
      .MemInitFile(MemInitFile),
      .Width(Width)
    ) u_impl_generic (
      .*
    );

  end

endmodule
//ri lint_check_on OUTPUT_NOT_DRIVEN INPUT_NOT_READ HIER_BRANCH_NOT_READ
