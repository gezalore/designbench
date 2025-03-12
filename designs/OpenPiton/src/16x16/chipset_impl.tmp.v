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

`include "define.tmp.h"
`include "piton_system.vh"
`include "mc_define.h"
`ifdef PITONSYS_AXI4_MEM
`include "noc_axi4_bridge_define.vh"
`endif
`include "uart16550_define.vh"
`include "chipset_define.vh"

// Filename: chipset_impl.v
// Author: mmckeown
// Description: Top-level chipset implementation.  Instantiates
//              different versions of chipsets based on different
//              macros.  Some logic is common to all chipset implementations.

// Macros used in this file:
//  PITON_FPGA_MC_DDR3                  Set to indicate an FPGA implementation will
//                                      use a DDR2/3 memory controller.  If
//                                      this is not set, a default "fake"
//                                      simulated DRAM is used.
//  PITONSYS_NO_MC                      If set, no memory controller is used. This is used
//                                      in the testing of the Piton system, where a small test
//                                      can be run on the chip with DRAM
//                                      emulated in BRAMs
//  PITONSYS_IOCTRL                     Set to use real I/O controller, otherwise a fake I/O bridge
//                                      is used and emulates I/O in PLI C calls.  This may not be compatible
//                                      with the "fake" memory controller or no memory controller at all
//  PITONSYS_UART                       Set to include a UART in the Piton system chipset.  The UART
//                                      can be used as an I/O device and/or a device for bootloading
//                                      test programs (see PITONSYS_UART_BOOT)
//  PITONSYS_UART_LOOBACK               Set to looback UART to itself.  Used for testing purposes
//  PITONSYS_UART_BOOT                  Set for UART boot hardware to be included.  If this is the
//                                      only boot option set, it is always used.  If there is another
//                                      boot option, a switch can be used to enable UART boot
//  PITONSYS_SPI                        Set to include a SPI in the Piton system chipset.  SPI is generally
//                                      used for SD card boot, but could potentially be used for other
//                                      purposes
//  NEXYS4DDR_BOARD NEXYSVIDEO_BOARD    Used to indicate which board this code is
//                                      being synthesized for. There are more than just these
// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml


module chipset_impl(
    // Clocks and resets
    input                                       chipset_clk,
    input                                       chipset_rst_n,
    input                                       piton_ready_n,

    output                                      test_start,
    output                                      uart_rst_out_n,

    // invalid access inside packet filter
    output                                      invalid_access_o,

`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
`ifndef F1_BOARD
`ifdef PITONSYS_DDR4
    input                                       mc_clk_p,
    input                                       mc_clk_n,
`else  // PITONSYS_DDR4
    input                                       mc_clk,
`endif // PITONSYS_DDR4
`endif // ifndef F1_BOARD
`endif // endif PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC

    // Main chip interface
    output [`NOC_DATA_WIDTH-1:0]                chipset_intf_data_noc1,
    output [`NOC_DATA_WIDTH-1:0]                chipset_intf_data_noc2,
    output [`NOC_DATA_WIDTH-1:0]                chipset_intf_data_noc3,
    output                                      chipset_intf_val_noc1,
    output                                      chipset_intf_val_noc2,
    output                                      chipset_intf_val_noc3,
    input                                       chipset_intf_rdy_noc1,
    input                                       chipset_intf_rdy_noc2,
    input                                       chipset_intf_rdy_noc3,

    input  [`NOC_DATA_WIDTH-1:0]                intf_chipset_data_noc1,
    input  [`NOC_DATA_WIDTH-1:0]                intf_chipset_data_noc2,
    input  [`NOC_DATA_WIDTH-1:0]                intf_chipset_data_noc3,
    input                                       intf_chipset_val_noc1,
    input                                       intf_chipset_val_noc2,
    input                                       intf_chipset_val_noc3,
    output                                      intf_chipset_rdy_noc1,
    output                                      intf_chipset_rdy_noc2,
    output                                      intf_chipset_rdy_noc3

    // DRAM and I/O interfaces
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
    ,
    output                                      init_calib_complete
`ifndef F1_BOARD
    // Generalized interface for any FPGA board we support.
    // Not all signals will be used for all FPGA boards (see constraints)
`ifdef PITONSYS_DDR4
    ,
    output                                      ddr_act_n,
    output [`DDR3_BG_WIDTH-1:0]                 ddr_bg,
`else // PITONSYS_DDR4
    ,
    output                                      ddr_cas_n,
    output                                      ddr_ras_n,
    output                                      ddr_we_n,
`endif // PITONSYS_DDR4
    output [`DDR3_ADDR_WIDTH-1:0]               ddr_addr,
    output [`DDR3_BA_WIDTH-1:0]                 ddr_ba,
    output [`DDR3_CK_WIDTH-1:0]                 ddr_ck_n,
    output [`DDR3_CK_WIDTH-1:0]                 ddr_ck_p,
    output [`DDR3_CKE_WIDTH-1:0]                ddr_cke,
    output                                      ddr_reset_n,
    inout  [`DDR3_DQ_WIDTH-1:0]                 ddr_dq,
    inout  [`DDR3_DQS_WIDTH-1:0]                ddr_dqs_n,
    inout  [`DDR3_DQS_WIDTH-1:0]                ddr_dqs_p,
`ifndef NEXYSVIDEO_BOARD
    output [`DDR3_CS_WIDTH-1:0]                 ddr_cs_n,
`endif // endif NEXYSVIDEO_BOARD
`ifdef PITONSYS_DDR4
`ifdef XUPP3R_BOARD
    output                                      ddr_parity,
`else
    inout [`DDR3_DM_WIDTH-1:0]                  ddr_dm,
`endif // XUPP3R_BOARD
`else // PITONSYS_DDR4
    output [`DDR3_DM_WIDTH-1:0]                 ddr_dm,
`endif // PITONSYS_DDR4
    output [`DDR3_ODT_WIDTH-1:0]                ddr_odt
`else // ifndef F1_BOARD
    // AXI Write Address Channel Signals
    ,
    input                                        mc_clk,
    output wire [`AXI4_ID_WIDTH     -1:0]    m_axi_awid,
    output wire [`AXI4_ADDR_WIDTH   -1:0]    m_axi_awaddr,
    output wire [`AXI4_LEN_WIDTH    -1:0]    m_axi_awlen,
    output wire [`AXI4_SIZE_WIDTH   -1:0]    m_axi_awsize,
    output wire [`AXI4_BURST_WIDTH  -1:0]    m_axi_awburst,
    output wire                                  m_axi_awlock,
    output wire [`AXI4_CACHE_WIDTH  -1:0]    m_axi_awcache,
    output wire [`AXI4_PROT_WIDTH   -1:0]    m_axi_awprot,
    output wire [`AXI4_QOS_WIDTH    -1:0]    m_axi_awqos,
    output wire [`AXI4_REGION_WIDTH -1:0]    m_axi_awregion,
    output wire [`AXI4_USER_WIDTH   -1:0]    m_axi_awuser,
    output wire                                  m_axi_awvalid,
    input  wire                                  m_axi_awready,

    // AXI Write Data Channel Signals
    output wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_wid,
    output wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_wdata,
    output wire  [`AXI4_STRB_WIDTH   -1:0]    m_axi_wstrb,
    output wire                                   m_axi_wlast,
    output wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_wuser,
    output wire                                   m_axi_wvalid,
    input  wire                                   m_axi_wready,

    // AXI Read Address Channel Signals
    output wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_arid,
    output wire  [`AXI4_ADDR_WIDTH   -1:0]    m_axi_araddr,
    output wire  [`AXI4_LEN_WIDTH    -1:0]    m_axi_arlen,
    output wire  [`AXI4_SIZE_WIDTH   -1:0]    m_axi_arsize,
    output wire  [`AXI4_BURST_WIDTH  -1:0]    m_axi_arburst,
    output wire                                   m_axi_arlock,
    output wire  [`AXI4_CACHE_WIDTH  -1:0]    m_axi_arcache,
    output wire  [`AXI4_PROT_WIDTH   -1:0]    m_axi_arprot,
    output wire  [`AXI4_QOS_WIDTH    -1:0]    m_axi_arqos,
    output wire  [`AXI4_REGION_WIDTH -1:0]    m_axi_arregion,
    output wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_aruser,
    output wire                                   m_axi_arvalid,
    input  wire                                   m_axi_arready,

    // AXI Read Data Channel Signals
    input  wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_rid,
    input  wire  [`AXI4_DATA_WIDTH   -1:0]    m_axi_rdata,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_rresp,
    input  wire                                   m_axi_rlast,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_ruser,
    input  wire                                   m_axi_rvalid,
    output wire                                   m_axi_rready,

    // AXI Write Response Channel Signals
    input  wire  [`AXI4_ID_WIDTH     -1:0]    m_axi_bid,
    input  wire  [`AXI4_RESP_WIDTH   -1:0]    m_axi_bresp,
    input  wire  [`AXI4_USER_WIDTH   -1:0]    m_axi_buser,
    input  wire                                   m_axi_bvalid,
    output wire                                   m_axi_bready, 

    input  wire                                   ddr_ready
`endif // ifndef F1_BOARD
`endif // ifdef PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC

`ifdef PITONSYS_IOCTRL
`ifdef PITONSYS_UART
    ,
    output                                      uart_tx,
    input                                       uart_rx
`ifdef PITONSYS_UART_BOOT
    ,
    input                                       uart_boot_en,
    input                                       uart_timeout_en
`endif // endif PITONSYS_UART_BOOT
`endif // endif PITONSYS_UART

`ifdef PITONSYS_SPI
    ,
    input                                       sd_clk,
    input                                       sd_cd,
    output                                      sd_reset,
    output                                      sd_clk_out,
    inout                                       sd_cmd,
    inout   [3:0]                               sd_dat
`endif // endif PITONSYS_SPI
`ifdef PITON_FPGA_ETHERNETLITE
    ,
    input                                       net_axi_clk,
    output                                      net_phy_rst_n,

    input                                       net_phy_tx_clk,
    output                                      net_phy_tx_en,
    output  [3 : 0]                             net_phy_tx_data,

    input                                       net_phy_rx_clk,
    input                                       net_phy_dv,
    input  [3 : 0]                              net_phy_rx_data,
    input                                       net_phy_rx_er,

    inout                                       net_phy_mdio_io,
    output                                      net_phy_mdc
`endif // PITON_FPGA_ETHERNETLITE
`endif // endif PITONSYS_IO_CTRL
`ifdef PITON_RV64_PLATFORM
`ifdef PITON_RV64_DEBUGUNIT
    // Debug
,   output                                      ndmreset_o      // non-debug module reset
,   output                                      dmactive_o      // debug module is active
,   output [`PITON_NUM_TILES-1:0]               debug_req_o     // async debug request
,   input  [`PITON_NUM_TILES-1:0]               unavailable_i   // communicate whether the hart is unavailable (e.g.: power down)
    // JTAG
,   input                                       tck_i
,   input                                       tms_i
,   input                                       trst_ni
,   input                                       td_i
,   output                                      td_o
,   output                                      tdo_oe_o
`endif // ifdef PITON_RV64_DEBUGUNIT

`ifdef PITON_RV64_CLINT
    // CLINT
,   input                                       rtc_i           // Real-time clock in (usually 32.768 kHz)
,   output [`PITON_NUM_TILES-1:0]               timer_irq_o     // Timer interrupts
,   output [`PITON_NUM_TILES-1:0]               ipi_o           // software interrupt (a.k.a inter-process-interrupt)
`endif // ifdef PITON_RV64_CLINT

`ifdef PITON_RV64_PLIC
    // PLIC
,   output [`PITON_NUM_TILES*2-1:0]             irq_o           // level sensitive IR lines, mip & sip (async)
`endif // ifdef PITON_RV64_PLIC
`endif // ifdef PITON_RV64_PLATFORM
);

///////////////////////
// Type declarations //
///////////////////////
wire                                            mc_ui_clk_sync_rst;

reg                                             init_calib_complete_f;
reg                                             init_calib_complete_ff;

reg                                             io_ctrl_rst_n;

`ifndef PITONSYS_IOCTRL
wire                                            uart_boot_en;
wire                                            uart_timeout_en;
`else // ifdef PITONSYS_IOCTRL
`ifndef PITONSYS_UART
wire                                            uart_boot_en;
wire                                            uart_timeout_en;
`else // ifdef PITONSYS_UART
`ifndef PITONSYS_UART_BOOT
wire                                            uart_boot_en;
wire                                            uart_timeout_en;
`endif // endif PITONSYS_UART_BOOT
`endif // endif PITONSYS_UART
`endif // endif PITONSYS_IOCTRL

wire                                            cpu_mem_traffic;
wire                                            chip_filter_noc2_valid;
wire    [`NOC_DATA_WIDTH-1:0]                   chip_filter_noc2_data;
wire                                            filter_chip_noc2_ready;
wire                                            filter_chip_noc3_valid;
wire    [`NOC_DATA_WIDTH-1:0]                   filter_chip_noc3_data;
wire                                            chip_filter_noc3_ready;


wire                                            test_good_end;
wire                                            test_bad_end;


wire [`DATA_WIDTH-1:0] chip_buf_xbar_noc2_data;
wire                   chip_buf_xbar_noc2_valid;
wire                   chip_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_chip_noc2_data;
wire                   xbar_buf_chip_noc2_valid;
wire                   xbar_buf_chip_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_chip_noc2_data;
wire                   buf_chip_noc2_valid;
wire                   chip_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] chip_buf_noc2_data;
wire                   chip_buf_noc2_valid;
wire                   buf_chip_noc2_ready;


wire [`DATA_WIDTH-1:0] chip_buf_xbar_noc3_data;
wire                   chip_buf_xbar_noc3_valid;
wire                   chip_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_chip_noc3_data;
wire                   xbar_buf_chip_noc3_valid;
wire                   xbar_buf_chip_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_chip_noc3_data;
wire                   buf_chip_noc3_valid;
wire                   chip_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] chip_buf_noc3_data;
wire                   chip_buf_noc3_valid;
wire                   buf_chip_noc3_ready;


wire [`DATA_WIDTH-1:0] mem_buf_xbar_noc2_data;
wire                   mem_buf_xbar_noc2_valid;
wire                   mem_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_mem_noc2_data;
wire                   xbar_buf_mem_noc2_valid;
wire                   xbar_buf_mem_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_mem_noc2_data;
wire                   buf_mem_noc2_valid;
wire                   mem_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] mem_buf_noc2_data;
wire                   mem_buf_noc2_valid;
wire                   buf_mem_noc2_ready;


wire [`DATA_WIDTH-1:0] mem_buf_xbar_noc3_data;
wire                   mem_buf_xbar_noc3_valid;
wire                   mem_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_mem_noc3_data;
wire                   xbar_buf_mem_noc3_valid;
wire                   xbar_buf_mem_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_mem_noc3_data;
wire                   buf_mem_noc3_valid;
wire                   mem_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] mem_buf_noc3_data;
wire                   mem_buf_noc3_valid;
wire                   buf_mem_noc3_ready;


assign mem_buf_noc2_data = `DATA_WIDTH'b0;
assign mem_buf_noc2_valid = 1'b0;
assign mem_buf_noc3_ready = 1'b0;


wire [`DATA_WIDTH-1:0] iob_buf_xbar_noc2_data;
wire                   iob_buf_xbar_noc2_valid;
wire                   iob_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_iob_noc2_data;
wire                   xbar_buf_iob_noc2_valid;
wire                   xbar_buf_iob_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_iob_noc2_data;
wire                   buf_iob_noc2_valid;
wire                   iob_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] iob_buf_noc2_data;
wire                   iob_buf_noc2_valid;
wire                   buf_iob_noc2_ready;


wire [`DATA_WIDTH-1:0] iob_buf_xbar_noc3_data;
wire                   iob_buf_xbar_noc3_valid;
wire                   iob_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_iob_noc3_data;
wire                   xbar_buf_iob_noc3_valid;
wire                   xbar_buf_iob_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_iob_noc3_data;
wire                   buf_iob_noc3_valid;
wire                   iob_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] iob_buf_noc3_data;
wire                   iob_buf_noc3_valid;
wire                   buf_iob_noc3_ready;


wire [`DATA_WIDTH-1:0]            iob_filter_noc2_data;
wire                              iob_filter_noc2_valid;
wire                              filter_iob_noc2_ready;


wire [`DATA_WIDTH-1:0]             filter_iob_noc3_data;
wire                               filter_iob_noc3_valid;
wire                               iob_filter_noc3_ready;


wire [`DATA_WIDTH-1:0] uart_buf_xbar_noc2_data;
wire                   uart_buf_xbar_noc2_valid;
wire                   uart_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_uart_noc2_data;
wire                   xbar_buf_uart_noc2_valid;
wire                   xbar_buf_uart_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_uart_noc2_data;
wire                   buf_uart_noc2_valid;
wire                   uart_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] uart_buf_noc2_data;
wire                   uart_buf_noc2_valid;
wire                   buf_uart_noc2_ready;


wire [`DATA_WIDTH-1:0] uart_buf_xbar_noc3_data;
wire                   uart_buf_xbar_noc3_valid;
wire                   uart_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_uart_noc3_data;
wire                   xbar_buf_uart_noc3_valid;
wire                   xbar_buf_uart_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_uart_noc3_data;
wire                   buf_uart_noc3_valid;
wire                   uart_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] uart_buf_noc3_data;
wire                   uart_buf_noc3_valid;
wire                   buf_uart_noc3_ready;


wire [`DATA_WIDTH-1:0]            uart_filter_noc2_data;
wire                              uart_filter_noc2_valid;
wire                              filter_uart_noc2_ready;


wire [`DATA_WIDTH-1:0]             filter_uart_noc3_data;
wire                               filter_uart_noc3_valid;
wire                               uart_filter_noc3_ready;


wire [`DATA_WIDTH-1:0] ariane_debug_buf_xbar_noc2_data;
wire                   ariane_debug_buf_xbar_noc2_valid;
wire                   ariane_debug_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_debug_noc2_data;
wire                   xbar_buf_ariane_debug_noc2_valid;
wire                   xbar_buf_ariane_debug_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_debug_noc2_data;
wire                   buf_ariane_debug_noc2_valid;
wire                   ariane_debug_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] ariane_debug_buf_noc2_data;
wire                   ariane_debug_buf_noc2_valid;
wire                   buf_ariane_debug_noc2_ready;


wire [`DATA_WIDTH-1:0] ariane_debug_buf_xbar_noc3_data;
wire                   ariane_debug_buf_xbar_noc3_valid;
wire                   ariane_debug_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_debug_noc3_data;
wire                   xbar_buf_ariane_debug_noc3_valid;
wire                   xbar_buf_ariane_debug_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_debug_noc3_data;
wire                   buf_ariane_debug_noc3_valid;
wire                   ariane_debug_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] ariane_debug_buf_noc3_data;
wire                   ariane_debug_buf_noc3_valid;
wire                   buf_ariane_debug_noc3_ready;


assign ariane_debug_buf_noc2_data = `DATA_WIDTH'b0;
assign ariane_debug_buf_noc2_valid = 1'b0;
assign ariane_debug_buf_noc3_ready = 1'b0;


wire [`DATA_WIDTH-1:0] ariane_bootrom_buf_xbar_noc2_data;
wire                   ariane_bootrom_buf_xbar_noc2_valid;
wire                   ariane_bootrom_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_bootrom_noc2_data;
wire                   xbar_buf_ariane_bootrom_noc2_valid;
wire                   xbar_buf_ariane_bootrom_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_bootrom_noc2_data;
wire                   buf_ariane_bootrom_noc2_valid;
wire                   ariane_bootrom_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] ariane_bootrom_buf_noc2_data;
wire                   ariane_bootrom_buf_noc2_valid;
wire                   buf_ariane_bootrom_noc2_ready;


wire [`DATA_WIDTH-1:0] ariane_bootrom_buf_xbar_noc3_data;
wire                   ariane_bootrom_buf_xbar_noc3_valid;
wire                   ariane_bootrom_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_bootrom_noc3_data;
wire                   xbar_buf_ariane_bootrom_noc3_valid;
wire                   xbar_buf_ariane_bootrom_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_bootrom_noc3_data;
wire                   buf_ariane_bootrom_noc3_valid;
wire                   ariane_bootrom_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] ariane_bootrom_buf_noc3_data;
wire                   ariane_bootrom_buf_noc3_valid;
wire                   buf_ariane_bootrom_noc3_ready;


assign ariane_bootrom_buf_noc2_data = `DATA_WIDTH'b0;
assign ariane_bootrom_buf_noc2_valid = 1'b0;
assign ariane_bootrom_buf_noc3_ready = 1'b0;


wire [`DATA_WIDTH-1:0] ariane_clint_buf_xbar_noc2_data;
wire                   ariane_clint_buf_xbar_noc2_valid;
wire                   ariane_clint_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_clint_noc2_data;
wire                   xbar_buf_ariane_clint_noc2_valid;
wire                   xbar_buf_ariane_clint_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_clint_noc2_data;
wire                   buf_ariane_clint_noc2_valid;
wire                   ariane_clint_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] ariane_clint_buf_noc2_data;
wire                   ariane_clint_buf_noc2_valid;
wire                   buf_ariane_clint_noc2_ready;


wire [`DATA_WIDTH-1:0] ariane_clint_buf_xbar_noc3_data;
wire                   ariane_clint_buf_xbar_noc3_valid;
wire                   ariane_clint_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_clint_noc3_data;
wire                   xbar_buf_ariane_clint_noc3_valid;
wire                   xbar_buf_ariane_clint_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_clint_noc3_data;
wire                   buf_ariane_clint_noc3_valid;
wire                   ariane_clint_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] ariane_clint_buf_noc3_data;
wire                   ariane_clint_buf_noc3_valid;
wire                   buf_ariane_clint_noc3_ready;


assign ariane_clint_buf_noc2_data = `DATA_WIDTH'b0;
assign ariane_clint_buf_noc2_valid = 1'b0;
assign ariane_clint_buf_noc3_ready = 1'b0;


wire [`DATA_WIDTH-1:0] ariane_plic_buf_xbar_noc2_data;
wire                   ariane_plic_buf_xbar_noc2_valid;
wire                   ariane_plic_buf_xbar_noc2_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_plic_noc2_data;
wire                   xbar_buf_ariane_plic_noc2_valid;
wire                   xbar_buf_ariane_plic_noc2_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_plic_noc2_data;
wire                   buf_ariane_plic_noc2_valid;
wire                   ariane_plic_buf_noc2_ready;

wire [`DATA_WIDTH-1:0] ariane_plic_buf_noc2_data;
wire                   ariane_plic_buf_noc2_valid;
wire                   buf_ariane_plic_noc2_ready;


wire [`DATA_WIDTH-1:0] ariane_plic_buf_xbar_noc3_data;
wire                   ariane_plic_buf_xbar_noc3_valid;
wire                   ariane_plic_buf_xbar_noc3_yummy;
wire [`DATA_WIDTH-1:0] xbar_buf_ariane_plic_noc3_data;
wire                   xbar_buf_ariane_plic_noc3_valid;
wire                   xbar_buf_ariane_plic_noc3_yummy;

wire [`DATA_WIDTH-1:0] buf_ariane_plic_noc3_data;
wire                   buf_ariane_plic_noc3_valid;
wire                   ariane_plic_buf_noc3_ready;

wire [`DATA_WIDTH-1:0] ariane_plic_buf_noc3_data;
wire                   ariane_plic_buf_noc3_valid;
wire                   buf_ariane_plic_noc3_ready;


assign ariane_plic_buf_noc2_data = `DATA_WIDTH'b0;
assign ariane_plic_buf_noc2_valid = 1'b0;
assign ariane_plic_buf_noc3_ready = 1'b0;



//////////////////////
// Sequential Logic //
//////////////////////

`ifdef PITONSYS_IOCTRL
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
always @ (posedge chipset_clk)
begin
    init_calib_complete_f <= init_calib_complete;
    init_calib_complete_ff <= init_calib_complete_f;
end
`endif // endif PITON_FPGA_MC_DDR3
`endif // endif PITONSYS_NO_MC
`endif // endif PITONSYS_IOCTRL

/////////////////////////
// Combinational Logic //
/////////////////////////

// Currently NoC 1 from chipset to interface is not used
// by any chipset implementation
assign chipset_intf_data_noc1 = {`NOC_DATA_WIDTH{1'b0}};
assign chipset_intf_val_noc1 = 1'b0;

// Currently NoC 3 from interface to chipset is not used
// by any chipset implementation
assign intf_chipset_rdy_noc3 = 1'b0;
assign chip_buf_noc3_valid = 1'b0;
assign chip_buf_noc3_data = {`NOC_DATA_WIDTH{1'b0}};

`ifdef PITONSYS_NO_MC
`ifndef PITON_FPGA_SYNTH
    // Tie off splitter memory interface
    assign mem_buf_noc2_ready = 1'b0;
    assign mem_buf_noc3_valid = 1'b0;
    assign mem_buf_noc3_data = {`NOC_DATA_WIDTH{1'b0}};
`endif // endif PITON_FPGA_SYNTH
`endif // endif PITONSYS_NO_MC


`ifdef PITONSYS_IOCTRL
    always @ *
    begin
    `ifndef PITONSYS_NO_MC
    `ifdef PITON_FPGA_MC_DDR3
        // Reset I/O ctrl as long as DRAM ctrl is not reset
        // and not calibrated or initialized
        io_ctrl_rst_n = ~mc_ui_clk_sync_rst & init_calib_complete_ff;
    `else // ifndef PITON_FPGA_MC_DDR3
        io_ctrl_rst_n = chipset_rst_n;
    `endif // endif PITON_FPGA_MC_DDR3
    `else // ifdef PITONSYS_NO_MC
        io_ctrl_rst_n = chipset_rst_n;
    `endif // PITONSYS_NO_MC
    end
`endif // endif PITONSYS_IOCTRL

`ifndef PITONSYS_IOCTRL
    assign uart_boot_en = 1'b0;
    assign uart_timeout_en = 1'b0;
`else // ifdef PITONSYS_IOCTRL
    `ifndef PITONSYS_UART
        assign uart_boot_en = 1'b0;
        assign uart_timeout_en = 1'b0;
    `else // ifdef PITONSYS_UART
        `ifndef PITONSYS_UART_BOOT
            assign uart_boot_en = 1'b0;
            assign uart_timeout_en = 1'b0;
        `endif // endif PITONSYS_UART_BOOT
    `endif // endif PITONSYS_UART
`endif // endif PITONSYS_IOCTRL

//////////////////////////
// Sub-module Instances //
//////////////////////////
`ifdef PITONSYS_IOCTRL
    assign cpu_mem_traffic = test_start | (~uart_boot_en);
`else
    assign cpu_mem_traffic = 1'b1;
`endif

assign chipset_intf_val_noc2 = buf_chip_noc2_valid;
assign chipset_intf_data_noc2 = buf_chip_noc2_data;
assign chip_buf_noc2_ready = chipset_intf_rdy_noc2;

assign chip_filter_noc2_valid = intf_chipset_val_noc2;
assign chip_filter_noc2_data = intf_chipset_data_noc2;
assign intf_chipset_rdy_noc2    = filter_chip_noc2_ready & cpu_mem_traffic;

// NoC 3
assign chipset_intf_val_noc3    = cpu_mem_traffic & filter_chip_noc3_valid;
assign chipset_intf_data_noc3   = filter_chip_noc3_data;

assign chip_filter_noc3_ready  = cpu_mem_traffic ? chipset_intf_rdy_noc3 : 1'b1;

`ifdef PITONSYS_UART_BOOT
test_end_checker test_end_checker(
    .clk                    (chipset_clk),
    .rst_n                  (chipset_rst_n),

    .src_checker_noc2_val   (chip_filter_noc2_valid),
    .src_checker_noc2_data  (chip_filter_noc2_data),
    .src_checker_noc2_rdy   (filter_chip_noc2_ready),

    .uart_boot_en           (uart_boot_en),
    .test_good_end          (test_good_end),
    .test_bad_end           (test_bad_end)
);
`else
    assign test_good_end = 1'b0;
    assign test_bad_end = 1'b0;
`endif


wire [3-1:0] invalid_access;
assign invalid_access_o = |invalid_access;


packet_filter chip_packet_filter(
    .clk(chipset_clk),
    .rst_n(chipset_rst_n),
    // need to connect this to a LED
    .invalid_access_o(invalid_access[0]),

    // noc2 to filter wires
    .noc2_filter_val(chip_filter_noc2_valid),
    .noc2_filter_data(chip_filter_noc2_data),
    .filter_noc2_rdy(filter_chip_noc2_ready),

    // filter to noc3 wires
    .filter_noc3_val(filter_chip_noc3_valid),
    .filter_noc3_data(filter_chip_noc3_data),
    .noc3_filter_rdy(chip_filter_noc3_ready),

    // filter to xbar wires
    .filter_xbar_val(chip_buf_noc2_valid),
    .filter_xbar_data(chip_buf_noc2_data),
    .xbar_filter_rdy(buf_chip_noc2_ready),

    // xbar to filter wires
    .xbar_filter_val(buf_chip_noc3_valid),
    .xbar_filter_data(buf_chip_noc3_data),
    .filter_xbar_rdy(chip_buf_noc3_ready),

    .uart_boot_en(uart_boot_en)
);


packet_filter iob_packet_filter(
    .clk(chipset_clk),
    .rst_n(chipset_rst_n),
    // need to connect this to a LED
    .invalid_access_o(invalid_access[1]),

    // noc2 to filter wires
    .noc2_filter_val(iob_filter_noc2_valid),
    .noc2_filter_data(iob_filter_noc2_data),
    .filter_noc2_rdy(filter_iob_noc2_ready),

    // filter to noc3 wires
    .filter_noc3_val(filter_iob_noc3_valid),
    .filter_noc3_data(filter_iob_noc3_data),
    .noc3_filter_rdy(iob_filter_noc3_ready),

    // filter to xbar wires
    .filter_xbar_val(iob_buf_noc2_valid),
    .filter_xbar_data(iob_buf_noc2_data),
    .xbar_filter_rdy(buf_iob_noc2_ready),

    // xbar to filter wires
    .xbar_filter_val(buf_iob_noc3_valid),
    .xbar_filter_data(buf_iob_noc3_data),
    .filter_xbar_rdy(iob_buf_noc3_ready),

    .uart_boot_en(uart_boot_en)
);


packet_filter uart_packet_filter(
    .clk(chipset_clk),
    .rst_n(chipset_rst_n),
    // need to connect this to a LED
    .invalid_access_o(invalid_access[2]),

    // noc2 to filter wires
    .noc2_filter_val(uart_filter_noc2_valid),
    .noc2_filter_data(uart_filter_noc2_data),
    .filter_noc2_rdy(filter_uart_noc2_ready),

    // filter to noc3 wires
    .filter_noc3_val(filter_uart_noc3_valid),
    .filter_noc3_data(filter_uart_noc3_data),
    .noc3_filter_rdy(uart_filter_noc3_ready),

    // filter to xbar wires
    .filter_xbar_val(uart_buf_noc2_valid),
    .filter_xbar_data(uart_buf_noc2_data),
    .xbar_filter_rdy(buf_uart_noc2_ready),

    // xbar to filter wires
    .xbar_filter_val(buf_uart_noc3_valid),
    .xbar_filter_data(buf_uart_noc3_data),
    .filter_xbar_rdy(uart_buf_noc3_ready),

    .uart_boot_en(uart_boot_en)
);




io_xbar_top_wrap io_xbar_noc2 (
    .clk                (chipset_clk),
    .reset_in           (~chipset_rst_n),

    .myChipID                   (14'b10000000000000),    // the first chip
    .myLocX                     (8'b0),  // not used
    .myLocY                     (8'b0),  // not used

    .dataIn_0(chip_buf_xbar_noc2_data),
    .validIn_0(chip_buf_xbar_noc2_valid),
    .yummyIn_0(chip_buf_xbar_noc2_yummy),
    .dataOut_0(xbar_buf_chip_noc2_data),
    .validOut_0(xbar_buf_chip_noc2_valid),
    .yummyOut_0(xbar_buf_chip_noc2_yummy),

    .dataIn_1(mem_buf_xbar_noc2_data),
    .validIn_1(mem_buf_xbar_noc2_valid),
    .yummyIn_1(mem_buf_xbar_noc2_yummy),
    .dataOut_1(xbar_buf_mem_noc2_data),
    .validOut_1(xbar_buf_mem_noc2_valid),
    .yummyOut_1(xbar_buf_mem_noc2_yummy),

    .dataIn_2(iob_buf_xbar_noc2_data),
    .validIn_2(iob_buf_xbar_noc2_valid),
    .yummyIn_2(iob_buf_xbar_noc2_yummy),
    .dataOut_2(xbar_buf_iob_noc2_data),
    .validOut_2(xbar_buf_iob_noc2_valid),
    .yummyOut_2(xbar_buf_iob_noc2_yummy),

    .dataIn_3(uart_buf_xbar_noc2_data),
    .validIn_3(uart_buf_xbar_noc2_valid),
    .yummyIn_3(uart_buf_xbar_noc2_yummy),
    .dataOut_3(xbar_buf_uart_noc2_data),
    .validOut_3(xbar_buf_uart_noc2_valid),
    .yummyOut_3(xbar_buf_uart_noc2_yummy),

    .dataIn_4(ariane_debug_buf_xbar_noc2_data),
    .validIn_4(ariane_debug_buf_xbar_noc2_valid),
    .yummyIn_4(ariane_debug_buf_xbar_noc2_yummy),
    .dataOut_4(xbar_buf_ariane_debug_noc2_data),
    .validOut_4(xbar_buf_ariane_debug_noc2_valid),
    .yummyOut_4(xbar_buf_ariane_debug_noc2_yummy),

    .dataIn_5(ariane_bootrom_buf_xbar_noc2_data),
    .validIn_5(ariane_bootrom_buf_xbar_noc2_valid),
    .yummyIn_5(ariane_bootrom_buf_xbar_noc2_yummy),
    .dataOut_5(xbar_buf_ariane_bootrom_noc2_data),
    .validOut_5(xbar_buf_ariane_bootrom_noc2_valid),
    .yummyOut_5(xbar_buf_ariane_bootrom_noc2_yummy),

    .dataIn_6(ariane_clint_buf_xbar_noc2_data),
    .validIn_6(ariane_clint_buf_xbar_noc2_valid),
    .yummyIn_6(ariane_clint_buf_xbar_noc2_yummy),
    .dataOut_6(xbar_buf_ariane_clint_noc2_data),
    .validOut_6(xbar_buf_ariane_clint_noc2_valid),
    .yummyOut_6(xbar_buf_ariane_clint_noc2_yummy),

    .dataIn_7(ariane_plic_buf_xbar_noc2_data),
    .validIn_7(ariane_plic_buf_xbar_noc2_valid),
    .yummyIn_7(ariane_plic_buf_xbar_noc2_yummy),
    .dataOut_7(xbar_buf_ariane_plic_noc2_data),
    .validOut_7(xbar_buf_ariane_plic_noc2_valid),
    .yummyOut_7(xbar_buf_ariane_plic_noc2_yummy)
);

io_xbar_top_wrap io_xbar_noc3 (
    .clk                (chipset_clk),
    .reset_in           (~chipset_rst_n),

    .myChipID                   (14'b10000000000000),    // the first chip
    .myLocX                     (8'b0),  // not used
    .myLocY                     (8'b0),  // not used

    .dataIn_0(chip_buf_xbar_noc3_data),
    .validIn_0(chip_buf_xbar_noc3_valid),
    .yummyIn_0(chip_buf_xbar_noc3_yummy),
    .dataOut_0(xbar_buf_chip_noc3_data),
    .validOut_0(xbar_buf_chip_noc3_valid),
    .yummyOut_0(xbar_buf_chip_noc3_yummy),

    .dataIn_1(mem_buf_xbar_noc3_data),
    .validIn_1(mem_buf_xbar_noc3_valid),
    .yummyIn_1(mem_buf_xbar_noc3_yummy),
    .dataOut_1(xbar_buf_mem_noc3_data),
    .validOut_1(xbar_buf_mem_noc3_valid),
    .yummyOut_1(xbar_buf_mem_noc3_yummy),

    .dataIn_2(iob_buf_xbar_noc3_data),
    .validIn_2(iob_buf_xbar_noc3_valid),
    .yummyIn_2(iob_buf_xbar_noc3_yummy),
    .dataOut_2(xbar_buf_iob_noc3_data),
    .validOut_2(xbar_buf_iob_noc3_valid),
    .yummyOut_2(xbar_buf_iob_noc3_yummy),

    .dataIn_3(uart_buf_xbar_noc3_data),
    .validIn_3(uart_buf_xbar_noc3_valid),
    .yummyIn_3(uart_buf_xbar_noc3_yummy),
    .dataOut_3(xbar_buf_uart_noc3_data),
    .validOut_3(xbar_buf_uart_noc3_valid),
    .yummyOut_3(xbar_buf_uart_noc3_yummy),

    .dataIn_4(ariane_debug_buf_xbar_noc3_data),
    .validIn_4(ariane_debug_buf_xbar_noc3_valid),
    .yummyIn_4(ariane_debug_buf_xbar_noc3_yummy),
    .dataOut_4(xbar_buf_ariane_debug_noc3_data),
    .validOut_4(xbar_buf_ariane_debug_noc3_valid),
    .yummyOut_4(xbar_buf_ariane_debug_noc3_yummy),

    .dataIn_5(ariane_bootrom_buf_xbar_noc3_data),
    .validIn_5(ariane_bootrom_buf_xbar_noc3_valid),
    .yummyIn_5(ariane_bootrom_buf_xbar_noc3_yummy),
    .dataOut_5(xbar_buf_ariane_bootrom_noc3_data),
    .validOut_5(xbar_buf_ariane_bootrom_noc3_valid),
    .yummyOut_5(xbar_buf_ariane_bootrom_noc3_yummy),

    .dataIn_6(ariane_clint_buf_xbar_noc3_data),
    .validIn_6(ariane_clint_buf_xbar_noc3_valid),
    .yummyIn_6(ariane_clint_buf_xbar_noc3_yummy),
    .dataOut_6(xbar_buf_ariane_clint_noc3_data),
    .validOut_6(xbar_buf_ariane_clint_noc3_valid),
    .yummyOut_6(xbar_buf_ariane_clint_noc3_yummy),

    .dataIn_7(ariane_plic_buf_xbar_noc3_data),
    .validIn_7(ariane_plic_buf_xbar_noc3_valid),
    .yummyIn_7(ariane_plic_buf_xbar_noc3_yummy),
    .dataOut_7(xbar_buf_ariane_plic_noc3_data),
    .validOut_7(xbar_buf_ariane_plic_noc3_valid),
    .yummyOut_7(xbar_buf_ariane_plic_noc3_yummy)
    ,
    .thanksIn_7()
);

valrdy_to_credit noc2_chip_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(chip_buf_noc2_data),
      .valid_in(chip_buf_noc2_valid),
      .ready_in(buf_chip_noc2_ready),

      .data_out(chip_buf_xbar_noc2_data),           // Data
      .valid_out(chip_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_chip_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_chip(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_chip_noc2_data),
      .valid_in(xbar_buf_chip_noc2_valid),
      .yummy_in(chip_buf_xbar_noc2_yummy),

      .data_out(buf_chip_noc2_data),           // Data
      .valid_out(buf_chip_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(chip_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_chip_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(chip_buf_noc3_data),
      .valid_in(chip_buf_noc3_valid),
      .ready_in(buf_chip_noc3_ready),

      .data_out(chip_buf_xbar_noc3_data),           // Data
      .valid_out(chip_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_chip_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_chip(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_chip_noc3_data),
      .valid_in(xbar_buf_chip_noc3_valid),
      .yummy_in(chip_buf_xbar_noc3_yummy),

      .data_out(buf_chip_noc3_data),           // Data
      .valid_out(buf_chip_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(chip_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_mem_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(mem_buf_noc2_data),
      .valid_in(mem_buf_noc2_valid),
      .ready_in(buf_mem_noc2_ready),

      .data_out(mem_buf_xbar_noc2_data),           // Data
      .valid_out(mem_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_mem_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_mem(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_mem_noc2_data),
      .valid_in(xbar_buf_mem_noc2_valid),
      .yummy_in(mem_buf_xbar_noc2_yummy),

      .data_out(buf_mem_noc2_data),           // Data
      .valid_out(buf_mem_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(mem_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_mem_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(mem_buf_noc3_data),
      .valid_in(mem_buf_noc3_valid),
      .ready_in(buf_mem_noc3_ready),

      .data_out(mem_buf_xbar_noc3_data),           // Data
      .valid_out(mem_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_mem_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_mem(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_mem_noc3_data),
      .valid_in(xbar_buf_mem_noc3_valid),
      .yummy_in(mem_buf_xbar_noc3_yummy),

      .data_out(buf_mem_noc3_data),           // Data
      .valid_out(buf_mem_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(mem_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_iob_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(iob_buf_noc2_data),
      .valid_in(iob_buf_noc2_valid),
      .ready_in(buf_iob_noc2_ready),

      .data_out(iob_buf_xbar_noc2_data),           // Data
      .valid_out(iob_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_iob_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_iob(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_iob_noc2_data),
      .valid_in(xbar_buf_iob_noc2_valid),
      .yummy_in(iob_buf_xbar_noc2_yummy),

      .data_out(buf_iob_noc2_data),           // Data
      .valid_out(buf_iob_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(iob_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_iob_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(iob_buf_noc3_data),
      .valid_in(iob_buf_noc3_valid),
      .ready_in(buf_iob_noc3_ready),

      .data_out(iob_buf_xbar_noc3_data),           // Data
      .valid_out(iob_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_iob_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_iob(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_iob_noc3_data),
      .valid_in(xbar_buf_iob_noc3_valid),
      .yummy_in(iob_buf_xbar_noc3_yummy),

      .data_out(buf_iob_noc3_data),           // Data
      .valid_out(buf_iob_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(iob_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_uart_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(uart_buf_noc2_data),
      .valid_in(uart_buf_noc2_valid),
      .ready_in(buf_uart_noc2_ready),

      .data_out(uart_buf_xbar_noc2_data),           // Data
      .valid_out(uart_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_uart_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_uart(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_uart_noc2_data),
      .valid_in(xbar_buf_uart_noc2_valid),
      .yummy_in(uart_buf_xbar_noc2_yummy),

      .data_out(buf_uart_noc2_data),           // Data
      .valid_out(buf_uart_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(uart_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_uart_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(uart_buf_noc3_data),
      .valid_in(uart_buf_noc3_valid),
      .ready_in(buf_uart_noc3_ready),

      .data_out(uart_buf_xbar_noc3_data),           // Data
      .valid_out(uart_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_uart_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_uart(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_uart_noc3_data),
      .valid_in(xbar_buf_uart_noc3_valid),
      .yummy_in(uart_buf_xbar_noc3_yummy),

      .data_out(buf_uart_noc3_data),           // Data
      .valid_out(buf_uart_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(uart_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_ariane_debug_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_debug_buf_noc2_data),
      .valid_in(ariane_debug_buf_noc2_valid),
      .ready_in(buf_ariane_debug_noc2_ready),

      .data_out(ariane_debug_buf_xbar_noc2_data),           // Data
      .valid_out(ariane_debug_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_debug_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_ariane_debug(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_debug_noc2_data),
      .valid_in(xbar_buf_ariane_debug_noc2_valid),
      .yummy_in(ariane_debug_buf_xbar_noc2_yummy),

      .data_out(buf_ariane_debug_noc2_data),           // Data
      .valid_out(buf_ariane_debug_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_debug_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_ariane_debug_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_debug_buf_noc3_data),
      .valid_in(ariane_debug_buf_noc3_valid),
      .ready_in(buf_ariane_debug_noc3_ready),

      .data_out(ariane_debug_buf_xbar_noc3_data),           // Data
      .valid_out(ariane_debug_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_debug_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_ariane_debug(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_debug_noc3_data),
      .valid_in(xbar_buf_ariane_debug_noc3_valid),
      .yummy_in(ariane_debug_buf_xbar_noc3_yummy),

      .data_out(buf_ariane_debug_noc3_data),           // Data
      .valid_out(buf_ariane_debug_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_debug_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_ariane_bootrom_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_bootrom_buf_noc2_data),
      .valid_in(ariane_bootrom_buf_noc2_valid),
      .ready_in(buf_ariane_bootrom_noc2_ready),

      .data_out(ariane_bootrom_buf_xbar_noc2_data),           // Data
      .valid_out(ariane_bootrom_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_bootrom_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_ariane_bootrom(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_bootrom_noc2_data),
      .valid_in(xbar_buf_ariane_bootrom_noc2_valid),
      .yummy_in(ariane_bootrom_buf_xbar_noc2_yummy),

      .data_out(buf_ariane_bootrom_noc2_data),           // Data
      .valid_out(buf_ariane_bootrom_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_bootrom_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_ariane_bootrom_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_bootrom_buf_noc3_data),
      .valid_in(ariane_bootrom_buf_noc3_valid),
      .ready_in(buf_ariane_bootrom_noc3_ready),

      .data_out(ariane_bootrom_buf_xbar_noc3_data),           // Data
      .valid_out(ariane_bootrom_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_bootrom_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_ariane_bootrom(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_bootrom_noc3_data),
      .valid_in(xbar_buf_ariane_bootrom_noc3_valid),
      .yummy_in(ariane_bootrom_buf_xbar_noc3_yummy),

      .data_out(buf_ariane_bootrom_noc3_data),           // Data
      .valid_out(buf_ariane_bootrom_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_bootrom_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_ariane_clint_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_clint_buf_noc2_data),
      .valid_in(ariane_clint_buf_noc2_valid),
      .ready_in(buf_ariane_clint_noc2_ready),

      .data_out(ariane_clint_buf_xbar_noc2_data),           // Data
      .valid_out(ariane_clint_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_clint_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_ariane_clint(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_clint_noc2_data),
      .valid_in(xbar_buf_ariane_clint_noc2_valid),
      .yummy_in(ariane_clint_buf_xbar_noc2_yummy),

      .data_out(buf_ariane_clint_noc2_data),           // Data
      .valid_out(buf_ariane_clint_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_clint_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_ariane_clint_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_clint_buf_noc3_data),
      .valid_in(ariane_clint_buf_noc3_valid),
      .ready_in(buf_ariane_clint_noc3_ready),

      .data_out(ariane_clint_buf_xbar_noc3_data),           // Data
      .valid_out(ariane_clint_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_clint_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_ariane_clint(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_clint_noc3_data),
      .valid_in(xbar_buf_ariane_clint_noc3_valid),
      .yummy_in(ariane_clint_buf_xbar_noc3_yummy),

      .data_out(buf_ariane_clint_noc3_data),           // Data
      .valid_out(buf_ariane_clint_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_clint_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc2_ariane_plic_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_plic_buf_noc2_data),
      .valid_in(ariane_plic_buf_noc2_valid),
      .ready_in(buf_ariane_plic_noc2_ready),

      .data_out(ariane_plic_buf_xbar_noc2_data),           // Data
      .valid_out(ariane_plic_buf_xbar_noc2_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_plic_noc2_yummy)    // Yummy signal
);

credit_to_valrdy noc2_xbar_to_ariane_plic(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_plic_noc2_data),
      .valid_in(xbar_buf_ariane_plic_noc2_valid),
      .yummy_in(ariane_plic_buf_xbar_noc2_yummy),

      .data_out(buf_ariane_plic_noc2_data),           // Data
      .valid_out(buf_ariane_plic_noc2_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_plic_buf_noc2_ready)    // Rdy signal from processor to dynamic network
);

valrdy_to_credit noc3_ariane_plic_to_xbar (
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(ariane_plic_buf_noc3_data),
      .valid_in(ariane_plic_buf_noc3_valid),
      .ready_in(buf_ariane_plic_noc3_ready),

      .data_out(ariane_plic_buf_xbar_noc3_data),           // Data
      .valid_out(ariane_plic_buf_xbar_noc3_valid),       // Val signal
      .yummy_out(xbar_buf_ariane_plic_noc3_yummy)    // Yummy signal
);

credit_to_valrdy noc3_xbar_to_ariane_plic(
      .clk(chipset_clk),
      .reset(~chipset_rst_n),

      .data_in(xbar_buf_ariane_plic_noc3_data),
      .valid_in(xbar_buf_ariane_plic_noc3_valid),
      .yummy_in(ariane_plic_buf_xbar_noc3_yummy),

      .data_out(buf_ariane_plic_noc3_data),           // Data
      .valid_out(buf_ariane_plic_noc3_valid),       // Val signal from dynamic network to processor
      .ready_out(ariane_plic_buf_noc3_ready)    // Rdy signal from processor to dynamic network
);




`ifndef PITONSYS_NO_MC
// Memory controller.  Either uses "fake" simulated
// memory controller or FPGA memory controllers
`ifdef PITON_FPGA_MC_DDR3
    `ifdef F1_BOARD
        f1_mc_top mc_top(
            .sys_clk(chipset_clk),
            .sys_rst_n(chipset_rst_n),
            .mc_clk(mc_clk),

            .mc_flit_in_val(buf_mem_noc2_valid),
            .mc_flit_in_data(buf_mem_noc2_data),
            .mc_flit_in_rdy(mem_buf_noc2_ready),

            .mc_flit_out_val(mem_buf_noc3_valid),
            .mc_flit_out_data(mem_buf_noc3_data),
            .mc_flit_out_rdy(buf_mem_noc3_ready),

            .uart_boot_en(uart_boot_en),
            .init_calib_complete_out(init_calib_complete),
            .mc_ui_clk_sync_rst(mc_ui_clk_sync_rst),

            // AXI Write Address Channel Signals
            .m_axi_awid(m_axi_awid),
            .m_axi_awaddr(m_axi_awaddr),
            .m_axi_awlen(m_axi_awlen),
            .m_axi_awsize(m_axi_awsize),
            .m_axi_awburst(m_axi_awburst),
            .m_axi_awlock(m_axi_awlock),
            .m_axi_awcache(m_axi_awcache),
            .m_axi_awprot(m_axi_awprot),
            .m_axi_awqos(m_axi_awqos),
            .m_axi_awregion(m_axi_awregion),
            .m_axi_awuser(m_axi_awuser),
            .m_axi_awvalid(m_axi_awvalid),
            .m_axi_awready(m_axi_awready),

            // AXI Write Data Channel Signals
            .m_axi_wid(m_axi_wid),
            .m_axi_wdata(m_axi_wdata),
            .m_axi_wstrb(m_axi_wstrb),
            .m_axi_wlast(m_axi_wlast),
            .m_axi_wuser(m_axi_wuser),
            .m_axi_wvalid(m_axi_wvalid),
            .m_axi_wready(m_axi_wready),

            // AXI Read Address Channel Signals
            .m_axi_arid(m_axi_arid),
            .m_axi_araddr(m_axi_araddr),
            .m_axi_arlen(m_axi_arlen),
            .m_axi_arsize(m_axi_arsize),
            .m_axi_arburst(m_axi_arburst),
            .m_axi_arlock(m_axi_arlock),
            .m_axi_arcache(m_axi_arcache),
            .m_axi_arprot(m_axi_arprot),
            .m_axi_arqos(m_axi_arqos),
            .m_axi_arregion(m_axi_arregion),
            .m_axi_aruser(m_axi_aruser),
            .m_axi_arvalid(m_axi_arvalid),
            .m_axi_arready(m_axi_arready),

            // AXI Read Data Channel Signals
            .m_axi_rid(m_axi_rid),
            .m_axi_rdata(m_axi_rdata),
            .m_axi_rresp(m_axi_rresp),
            .m_axi_rlast(m_axi_rlast),
            .m_axi_ruser(m_axi_ruser),
            .m_axi_rvalid(m_axi_rvalid),
            .m_axi_rready(m_axi_rready),

            // AXI Write Response Channel Signals
            .m_axi_bid(m_axi_bid),
            .m_axi_bresp(m_axi_bresp),
            .m_axi_buser(m_axi_buser),
            .m_axi_bvalid(m_axi_bvalid),
            .m_axi_bready(m_axi_bready), 
            .ddr_ready(ddr_ready)
        );
    `else
        mc_top mc_top(
            .mc_ui_clk_sync_rst(mc_ui_clk_sync_rst),

            .core_ref_clk(chipset_clk),
            .sys_rst_n(chipset_rst_n),

            .mc_flit_in_val(buf_mem_noc2_valid),
            .mc_flit_in_data(buf_mem_noc2_data),
            .mc_flit_in_rdy(mem_buf_noc2_ready),

            .mc_flit_out_val(mem_buf_noc3_valid),
            .mc_flit_out_data(mem_buf_noc3_data),
            .mc_flit_out_rdy(buf_mem_noc3_ready),

            .uart_boot_en(uart_boot_en),
            .init_calib_complete_out(init_calib_complete),

        `ifdef PITONSYS_DDR4
            .sys_clk_p(mc_clk_p),
            .sys_clk_n(mc_clk_n),
            .ddr_act_n(ddr_act_n),
            .ddr_bg(ddr_bg),
        `else // PITONSYS_DDR4
            .sys_clk(mc_clk),
            .ddr_cas_n(ddr_cas_n),
            .ddr_ras_n(ddr_ras_n),
            .ddr_we_n(ddr_we_n),
        `endif // PITONSYS_DDR4

            .ddr_addr(ddr_addr),
            .ddr_ba(ddr_ba),
            .ddr_ck_n(ddr_ck_n),
            .ddr_ck_p(ddr_ck_p),
            .ddr_cke(ddr_cke),
            .ddr_reset_n(ddr_reset_n),
            .ddr_dq(ddr_dq),
            .ddr_dqs_n(ddr_dqs_n),
            .ddr_dqs_p(ddr_dqs_p),
        `ifndef NEXYSVIDEO_BOARD
            .ddr_cs_n(ddr_cs_n),
        `endif // endif NEXYSVIDEO_BOARD
        `ifdef XUPP3R_BOARD
            .ddr_parity(ddr_parity),
        `else
            .ddr_dm(ddr_dm),
        `endif // XUPP3R_BOARD
            .ddr_odt(ddr_odt)
        );
    `endif // F1_BOARD

`else

`include "cross_module.tmp.h"

// Fake Memory Controller
fake_mem_ctrl fake_mem_ctrl(
    .clk                ( chipset_clk        ),
    .rst_n              ( chipset_rst_n      ),
    .noc_valid_in       ( buf_mem_noc2_valid ),
    .noc_data_in        ( buf_mem_noc2_data  ),
    .noc_ready_in       ( mem_buf_noc2_ready ),
    .noc_valid_out      ( mem_buf_noc3_valid ),
    .noc_data_out       ( mem_buf_noc3_data  ),
    .noc_ready_out      ( buf_mem_noc3_ready )
);

`endif // endif PITON_FPGA_MC_DDR3

`else

`ifdef PITON_FPGA_BRAM_TEST

    fake_boot_ctrl  fake_boot_ctrl(
        .clk            ( chipset_clk        ),
        .rst_n          ( chipset_rst_n      ),

        .noc_valid_in   ( buf_mem_noc2_valid ),
        .noc_data_in    ( buf_mem_noc2_data  ),
        .noc_ready_in   ( mem_buf_noc2_ready ),

        .noc_valid_out  ( mem_buf_noc3_valid ),
        .noc_data_out   ( mem_buf_noc3_data  ),
        .noc_ready_out  ( buf_mem_noc3_ready )
    );

`elsif PITON_FPGA_BRAM_BOOT

    fake_boot_ctrl  fake_boot_ctrl(
        .clk            ( chipset_clk        ),
        .rst_n          ( chipset_rst_n      ),

        .noc_valid_in   ( buf_mem_noc2_valid ),
        .noc_data_in    ( buf_mem_noc2_data  ),
        .noc_ready_in   ( mem_buf_noc2_ready ),

        .noc_valid_out  ( mem_buf_noc3_valid ),
        .noc_data_out   ( mem_buf_noc3_data  ),
        .noc_ready_out  ( buf_mem_noc3_ready )
    );

`endif

`endif // endif PITONSYS_NO_MC


wire net_interrupt;
wire uart_interrupt;

`ifdef PITONSYS_IOCTRL

wire ciop_iob_rst_n;
assign ciop_iob_rst_n = io_ctrl_rst_n & test_start & ~piton_ready_n;

ciop_iob ciop_iob     (
    .chip_clk        ( chipset_clk           ),
    .fpga_clk        ( chipset_clk           ),
    .rst_n           ( ciop_iob_rst_n        ),

    .noc1_in_val     ( intf_chipset_val_noc1 ),
    .noc1_in_data    ( intf_chipset_data_noc1),
    .noc1_in_rdy     ( intf_chipset_rdy_noc1 ),

    .noc2_out_val    ( iob_filter_noc2_valid ),
    .noc2_out_data   ( iob_filter_noc2_data  ),
    .noc2_out_rdy    ( filter_iob_noc2_ready ),

    .noc3_in_val     ( filter_iob_noc3_valid ),
    .noc3_in_data    ( filter_iob_noc3_data  ),
    .noc3_in_rdy     ( iob_filter_noc3_ready ),

    .noc2_in_val     ( buf_iob_noc2_valid    ),
    .noc2_in_data    ( buf_iob_noc2_data     ),
    .noc2_in_rdy     ( iob_buf_noc2_ready    ),

    .noc3_out_val    ( iob_buf_noc3_valid    ),
    .noc3_out_data   ( iob_buf_noc3_data     ),
    .noc3_out_rdy    ( buf_iob_noc3_ready    ),

    .uart_interrupt ( uart_interrupt         ),
    .net_interrupt  ( net_interrupt          )
);


`ifdef PITONSYS_UART

uart_top        uart_top (
    .axi_clk                    ( chipset_clk                           ),
    .rst_n                      ( chipset_rst_n                         ),

    .uart_rx                    ( uart_rx                               ),
    .uart_tx                    ( uart_tx                               ),
    .uart_interrupt             ( uart_interrupt                        ),
`ifdef PITONSYS_UART_LOOBACK
    // Can be used to loobpack UART for testing
    .uart_lb_sw                 ( 1'b1                                  ),
`else // ifndef PITONSYS_UART_LOOBACK
    .uart_lb_sw                 ( 1'b0                                  ),
`endif // endif PITONSYS_UART_LOOBACK

    .uart_boot_en               ( uart_boot_en                          ),
`ifndef PITONSYS_NO_MC
`ifdef PITON_FPGA_MC_DDR3
    .init_calib_complete        (init_calib_complete_ff                 ),
`else // PITON_FPGA_MC_DDR3
    .init_calib_complete        (1'b1                                   ),
`endif //PITON_FPGA_MC_DDR3
`else // PITONSYS_NO_MC
    .init_calib_complete        (1'b1                                   ),
`endif // PITONSYS_NO_MC

    // Uncomment to connect to the switch
    // .uart_timeout_en(uart_timeout_en),
    .uart_timeout_en            ( 1'b1                                  ),

    .test_start                 ( test_start                            ),
    .test_good_end              ( test_good_end                         ),
    .test_bad_end               ( test_bad_end                          ),
    .uart_rst_out_n             ( uart_rst_out_n                        ),

    .chip_id                    ( {1'b1, {(`NOC_CHIPID_WIDTH-1){1'b0}}} ),
    .x_id                       ( `NOC_X_WIDTH'd3                      ),
    .y_id                       ( `NOC_Y_WIDTH'd0                       ),
    // input from noc2
    .xbar_uart_noc2_valid       ( buf_uart_noc2_valid                   ),
    .xbar_uart_noc2_data        ( buf_uart_noc2_data                    ),
    .uart_xbar_noc2_ready       ( uart_buf_noc2_ready                   ),

    //output to noc3
    .uart_xbar_noc3_valid       ( uart_buf_noc3_valid                   ),
    .uart_xbar_noc3_data        ( uart_buf_noc3_data                    ),
    .xbar_uart_noc3_ready       ( buf_uart_noc3_ready                   ),

    // output to noc2
    .uart_xbar_noc2_valid       ( uart_filter_noc2_valid                ),
    .uart_xbar_noc2_data        ( uart_filter_noc2_data                 ),
    .xbar_uart_noc2_ready       ( filter_uart_noc2_ready                ),

    // input from noc3
    .xbar_uart_noc3_valid       ( filter_uart_noc3_valid                ),
    .xbar_uart_noc3_data        ( filter_uart_noc3_data                 ),
    .uart_xbar_noc3_ready       ( uart_filter_noc3_ready                )
);

`else // ifndef PITONSYS_UART
    assign uart_interrupt = 1'b0;
    assign test_start = 1'b1;
`endif // endif PITONSYS_UART

// SPI interface
`ifdef PITONSYS_SPI
`ifdef PITON_FPGA_SD_BOOT

    /* Bridge between NOCs and SD Card */
    piton_sd_top piton_sd_top (
        .sys_clk          ( chipset_clk       ),
        .sd_clk           ( sd_clk            ),
        .sys_rst          ( ~chipset_rst_n    ),

        .splitter_sd_val  ( buf_sd_noc2_valid ),
        .splitter_sd_data ( buf_sd_noc2_data  ),
        .sd_splitter_rdy  ( sd_buf_noc2_ready ),

        .sd_splitter_val  ( sd_buf_noc3_valid ),
        .sd_splitter_data ( sd_buf_noc3_data  ),
        .splitter_sd_rdy  ( buf_sd_noc3_ready ),

        .sd_cd            ( sd_cd             ),
        .sd_reset         ( sd_reset          ),
        .sd_clk_out       ( sd_clk_out        ),
        .sd_cmd           ( sd_cmd            ),
        .sd_dat           ( sd_dat            )
        );

`endif
`endif


`ifdef PITON_FPGA_ETHERNETLITE

    eth_top #(
    `ifdef PITON_RV64_PLATFORM
      .SWAP_ENDIANESS(1)
    `else
      .SWAP_ENDIANESS(0)
    `endif
    ) eth_top (
        .chipset_clk     ( chipset_clk        ),
        .rst_n           ( chipset_rst_n      ),

        .net_interrupt   ( net_interrupt      ),

        .noc_in_val      ( buf_net_noc2_valid ),
        .noc_in_data     ( buf_net_noc2_data  ),
        .noc_in_rdy      ( net_buf_noc2_ready ),

        .noc_out_val     ( net_buf_noc3_valid ),
        .noc_out_data    ( net_buf_noc3_data  ),
        .noc_out_rdy     ( buf_net_noc3_ready ),

        .net_axi_clk     ( net_axi_clk        ),
        .net_phy_rst_n   ( net_phy_rst_n      ),

        .net_phy_tx_clk  ( net_phy_tx_clk     ),
        .net_phy_tx_en   ( net_phy_tx_en      ),
        .net_phy_tx_data ( net_phy_tx_data    ),

        .net_phy_rx_clk  ( net_phy_rx_clk     ),
        .net_phy_dv      ( net_phy_dv         ),
        .net_phy_rx_data ( net_phy_rx_data    ),
        .net_phy_rx_er   ( net_phy_rx_er      ),

        .net_phy_mdio_io ( net_phy_mdio_io    ),
        .net_phy_mdc     ( net_phy_mdc        )
    );
`endif // PITON_FPGA_ETHERNETLITE

`else // PITONSYS_IOCTRL

assign net_interrupt  = 1'b0;
assign uart_interrupt = 1'b0;

// Fake iobridge
// Tie noc1 input low because it's unused
assign intf_chipset_rdy_noc1 = 1'b0;
ciop_fake_iob ciop_fake_iob(
    .noc_out_val       ( iob_filter_noc2_valid ),
    .noc_out_rdy       ( filter_iob_noc2_ready ),
    .noc_out_data      ( iob_filter_noc2_data  ),

    
.spc0_inst_done    (`PITON_CORE0_INST_DONE),
.pc_w0             (`PITON_CORE0_PC_W0),


.spc1_inst_done    (`PITON_CORE1_INST_DONE),
.pc_w1             (`PITON_CORE1_PC_W1),


.spc2_inst_done    (`PITON_CORE2_INST_DONE),
.pc_w2             (`PITON_CORE2_PC_W2),


.spc3_inst_done    (`PITON_CORE3_INST_DONE),
.pc_w3             (`PITON_CORE3_PC_W3),


.spc4_inst_done    (`PITON_CORE4_INST_DONE),
.pc_w4             (`PITON_CORE4_PC_W4),


.spc5_inst_done    (`PITON_CORE5_INST_DONE),
.pc_w5             (`PITON_CORE5_PC_W5),


.spc6_inst_done    (`PITON_CORE6_INST_DONE),
.pc_w6             (`PITON_CORE6_PC_W6),


.spc7_inst_done    (`PITON_CORE7_INST_DONE),
.pc_w7             (`PITON_CORE7_PC_W7),


.spc8_inst_done    (`PITON_CORE8_INST_DONE),
.pc_w8             (`PITON_CORE8_PC_W8),


.spc9_inst_done    (`PITON_CORE9_INST_DONE),
.pc_w9             (`PITON_CORE9_PC_W9),


.spc10_inst_done    (`PITON_CORE10_INST_DONE),
.pc_w10             (`PITON_CORE10_PC_W10),


.spc11_inst_done    (`PITON_CORE11_INST_DONE),
.pc_w11             (`PITON_CORE11_PC_W11),


.spc12_inst_done    (`PITON_CORE12_INST_DONE),
.pc_w12             (`PITON_CORE12_PC_W12),


.spc13_inst_done    (`PITON_CORE13_INST_DONE),
.pc_w13             (`PITON_CORE13_PC_W13),


.spc14_inst_done    (`PITON_CORE14_INST_DONE),
.pc_w14             (`PITON_CORE14_PC_W14),


.spc15_inst_done    (`PITON_CORE15_INST_DONE),
.pc_w15             (`PITON_CORE15_PC_W15),


.spc16_inst_done    (`PITON_CORE16_INST_DONE),
.pc_w16             (`PITON_CORE16_PC_W16),


.spc17_inst_done    (`PITON_CORE17_INST_DONE),
.pc_w17             (`PITON_CORE17_PC_W17),


.spc18_inst_done    (`PITON_CORE18_INST_DONE),
.pc_w18             (`PITON_CORE18_PC_W18),


.spc19_inst_done    (`PITON_CORE19_INST_DONE),
.pc_w19             (`PITON_CORE19_PC_W19),


.spc20_inst_done    (`PITON_CORE20_INST_DONE),
.pc_w20             (`PITON_CORE20_PC_W20),


.spc21_inst_done    (`PITON_CORE21_INST_DONE),
.pc_w21             (`PITON_CORE21_PC_W21),


.spc22_inst_done    (`PITON_CORE22_INST_DONE),
.pc_w22             (`PITON_CORE22_PC_W22),


.spc23_inst_done    (`PITON_CORE23_INST_DONE),
.pc_w23             (`PITON_CORE23_PC_W23),


.spc24_inst_done    (`PITON_CORE24_INST_DONE),
.pc_w24             (`PITON_CORE24_PC_W24),


.spc25_inst_done    (`PITON_CORE25_INST_DONE),
.pc_w25             (`PITON_CORE25_PC_W25),


.spc26_inst_done    (`PITON_CORE26_INST_DONE),
.pc_w26             (`PITON_CORE26_PC_W26),


.spc27_inst_done    (`PITON_CORE27_INST_DONE),
.pc_w27             (`PITON_CORE27_PC_W27),


.spc28_inst_done    (`PITON_CORE28_INST_DONE),
.pc_w28             (`PITON_CORE28_PC_W28),


.spc29_inst_done    (`PITON_CORE29_INST_DONE),
.pc_w29             (`PITON_CORE29_PC_W29),


.spc30_inst_done    (`PITON_CORE30_INST_DONE),
.pc_w30             (`PITON_CORE30_PC_W30),


.spc31_inst_done    (`PITON_CORE31_INST_DONE),
.pc_w31             (`PITON_CORE31_PC_W31),


.spc32_inst_done    (`PITON_CORE32_INST_DONE),
.pc_w32             (`PITON_CORE32_PC_W32),


.spc33_inst_done    (`PITON_CORE33_INST_DONE),
.pc_w33             (`PITON_CORE33_PC_W33),


.spc34_inst_done    (`PITON_CORE34_INST_DONE),
.pc_w34             (`PITON_CORE34_PC_W34),


.spc35_inst_done    (`PITON_CORE35_INST_DONE),
.pc_w35             (`PITON_CORE35_PC_W35),


.spc36_inst_done    (`PITON_CORE36_INST_DONE),
.pc_w36             (`PITON_CORE36_PC_W36),


.spc37_inst_done    (`PITON_CORE37_INST_DONE),
.pc_w37             (`PITON_CORE37_PC_W37),


.spc38_inst_done    (`PITON_CORE38_INST_DONE),
.pc_w38             (`PITON_CORE38_PC_W38),


.spc39_inst_done    (`PITON_CORE39_INST_DONE),
.pc_w39             (`PITON_CORE39_PC_W39),


.spc40_inst_done    (`PITON_CORE40_INST_DONE),
.pc_w40             (`PITON_CORE40_PC_W40),


.spc41_inst_done    (`PITON_CORE41_INST_DONE),
.pc_w41             (`PITON_CORE41_PC_W41),


.spc42_inst_done    (`PITON_CORE42_INST_DONE),
.pc_w42             (`PITON_CORE42_PC_W42),


.spc43_inst_done    (`PITON_CORE43_INST_DONE),
.pc_w43             (`PITON_CORE43_PC_W43),


.spc44_inst_done    (`PITON_CORE44_INST_DONE),
.pc_w44             (`PITON_CORE44_PC_W44),


.spc45_inst_done    (`PITON_CORE45_INST_DONE),
.pc_w45             (`PITON_CORE45_PC_W45),


.spc46_inst_done    (`PITON_CORE46_INST_DONE),
.pc_w46             (`PITON_CORE46_PC_W46),


.spc47_inst_done    (`PITON_CORE47_INST_DONE),
.pc_w47             (`PITON_CORE47_PC_W47),


.spc48_inst_done    (`PITON_CORE48_INST_DONE),
.pc_w48             (`PITON_CORE48_PC_W48),


.spc49_inst_done    (`PITON_CORE49_INST_DONE),
.pc_w49             (`PITON_CORE49_PC_W49),


.spc50_inst_done    (`PITON_CORE50_INST_DONE),
.pc_w50             (`PITON_CORE50_PC_W50),


.spc51_inst_done    (`PITON_CORE51_INST_DONE),
.pc_w51             (`PITON_CORE51_PC_W51),


.spc52_inst_done    (`PITON_CORE52_INST_DONE),
.pc_w52             (`PITON_CORE52_PC_W52),


.spc53_inst_done    (`PITON_CORE53_INST_DONE),
.pc_w53             (`PITON_CORE53_PC_W53),


.spc54_inst_done    (`PITON_CORE54_INST_DONE),
.pc_w54             (`PITON_CORE54_PC_W54),


.spc55_inst_done    (`PITON_CORE55_INST_DONE),
.pc_w55             (`PITON_CORE55_PC_W55),


.spc56_inst_done    (`PITON_CORE56_INST_DONE),
.pc_w56             (`PITON_CORE56_PC_W56),


.spc57_inst_done    (`PITON_CORE57_INST_DONE),
.pc_w57             (`PITON_CORE57_PC_W57),


.spc58_inst_done    (`PITON_CORE58_INST_DONE),
.pc_w58             (`PITON_CORE58_PC_W58),


.spc59_inst_done    (`PITON_CORE59_INST_DONE),
.pc_w59             (`PITON_CORE59_PC_W59),


.spc60_inst_done    (`PITON_CORE60_INST_DONE),
.pc_w60             (`PITON_CORE60_PC_W60),


.spc61_inst_done    (`PITON_CORE61_INST_DONE),
.pc_w61             (`PITON_CORE61_PC_W61),


.spc62_inst_done    (`PITON_CORE62_INST_DONE),
.pc_w62             (`PITON_CORE62_PC_W62),


.spc63_inst_done    (`PITON_CORE63_INST_DONE),
.pc_w63             (`PITON_CORE63_PC_W63),


.spc64_inst_done    (`PITON_CORE64_INST_DONE),
.pc_w64             (`PITON_CORE64_PC_W64),


.spc65_inst_done    (`PITON_CORE65_INST_DONE),
.pc_w65             (`PITON_CORE65_PC_W65),


.spc66_inst_done    (`PITON_CORE66_INST_DONE),
.pc_w66             (`PITON_CORE66_PC_W66),


.spc67_inst_done    (`PITON_CORE67_INST_DONE),
.pc_w67             (`PITON_CORE67_PC_W67),


.spc68_inst_done    (`PITON_CORE68_INST_DONE),
.pc_w68             (`PITON_CORE68_PC_W68),


.spc69_inst_done    (`PITON_CORE69_INST_DONE),
.pc_w69             (`PITON_CORE69_PC_W69),


.spc70_inst_done    (`PITON_CORE70_INST_DONE),
.pc_w70             (`PITON_CORE70_PC_W70),


.spc71_inst_done    (`PITON_CORE71_INST_DONE),
.pc_w71             (`PITON_CORE71_PC_W71),


.spc72_inst_done    (`PITON_CORE72_INST_DONE),
.pc_w72             (`PITON_CORE72_PC_W72),


.spc73_inst_done    (`PITON_CORE73_INST_DONE),
.pc_w73             (`PITON_CORE73_PC_W73),


.spc74_inst_done    (`PITON_CORE74_INST_DONE),
.pc_w74             (`PITON_CORE74_PC_W74),


.spc75_inst_done    (`PITON_CORE75_INST_DONE),
.pc_w75             (`PITON_CORE75_PC_W75),


.spc76_inst_done    (`PITON_CORE76_INST_DONE),
.pc_w76             (`PITON_CORE76_PC_W76),


.spc77_inst_done    (`PITON_CORE77_INST_DONE),
.pc_w77             (`PITON_CORE77_PC_W77),


.spc78_inst_done    (`PITON_CORE78_INST_DONE),
.pc_w78             (`PITON_CORE78_PC_W78),


.spc79_inst_done    (`PITON_CORE79_INST_DONE),
.pc_w79             (`PITON_CORE79_PC_W79),


.spc80_inst_done    (`PITON_CORE80_INST_DONE),
.pc_w80             (`PITON_CORE80_PC_W80),


.spc81_inst_done    (`PITON_CORE81_INST_DONE),
.pc_w81             (`PITON_CORE81_PC_W81),


.spc82_inst_done    (`PITON_CORE82_INST_DONE),
.pc_w82             (`PITON_CORE82_PC_W82),


.spc83_inst_done    (`PITON_CORE83_INST_DONE),
.pc_w83             (`PITON_CORE83_PC_W83),


.spc84_inst_done    (`PITON_CORE84_INST_DONE),
.pc_w84             (`PITON_CORE84_PC_W84),


.spc85_inst_done    (`PITON_CORE85_INST_DONE),
.pc_w85             (`PITON_CORE85_PC_W85),


.spc86_inst_done    (`PITON_CORE86_INST_DONE),
.pc_w86             (`PITON_CORE86_PC_W86),


.spc87_inst_done    (`PITON_CORE87_INST_DONE),
.pc_w87             (`PITON_CORE87_PC_W87),


.spc88_inst_done    (`PITON_CORE88_INST_DONE),
.pc_w88             (`PITON_CORE88_PC_W88),


.spc89_inst_done    (`PITON_CORE89_INST_DONE),
.pc_w89             (`PITON_CORE89_PC_W89),


.spc90_inst_done    (`PITON_CORE90_INST_DONE),
.pc_w90             (`PITON_CORE90_PC_W90),


.spc91_inst_done    (`PITON_CORE91_INST_DONE),
.pc_w91             (`PITON_CORE91_PC_W91),


.spc92_inst_done    (`PITON_CORE92_INST_DONE),
.pc_w92             (`PITON_CORE92_PC_W92),


.spc93_inst_done    (`PITON_CORE93_INST_DONE),
.pc_w93             (`PITON_CORE93_PC_W93),


.spc94_inst_done    (`PITON_CORE94_INST_DONE),
.pc_w94             (`PITON_CORE94_PC_W94),


.spc95_inst_done    (`PITON_CORE95_INST_DONE),
.pc_w95             (`PITON_CORE95_PC_W95),


.spc96_inst_done    (`PITON_CORE96_INST_DONE),
.pc_w96             (`PITON_CORE96_PC_W96),


.spc97_inst_done    (`PITON_CORE97_INST_DONE),
.pc_w97             (`PITON_CORE97_PC_W97),


.spc98_inst_done    (`PITON_CORE98_INST_DONE),
.pc_w98             (`PITON_CORE98_PC_W98),


.spc99_inst_done    (`PITON_CORE99_INST_DONE),
.pc_w99             (`PITON_CORE99_PC_W99),


.spc100_inst_done    (`PITON_CORE100_INST_DONE),
.pc_w100             (`PITON_CORE100_PC_W100),


.spc101_inst_done    (`PITON_CORE101_INST_DONE),
.pc_w101             (`PITON_CORE101_PC_W101),


.spc102_inst_done    (`PITON_CORE102_INST_DONE),
.pc_w102             (`PITON_CORE102_PC_W102),


.spc103_inst_done    (`PITON_CORE103_INST_DONE),
.pc_w103             (`PITON_CORE103_PC_W103),


.spc104_inst_done    (`PITON_CORE104_INST_DONE),
.pc_w104             (`PITON_CORE104_PC_W104),


.spc105_inst_done    (`PITON_CORE105_INST_DONE),
.pc_w105             (`PITON_CORE105_PC_W105),


.spc106_inst_done    (`PITON_CORE106_INST_DONE),
.pc_w106             (`PITON_CORE106_PC_W106),


.spc107_inst_done    (`PITON_CORE107_INST_DONE),
.pc_w107             (`PITON_CORE107_PC_W107),


.spc108_inst_done    (`PITON_CORE108_INST_DONE),
.pc_w108             (`PITON_CORE108_PC_W108),


.spc109_inst_done    (`PITON_CORE109_INST_DONE),
.pc_w109             (`PITON_CORE109_PC_W109),


.spc110_inst_done    (`PITON_CORE110_INST_DONE),
.pc_w110             (`PITON_CORE110_PC_W110),


.spc111_inst_done    (`PITON_CORE111_INST_DONE),
.pc_w111             (`PITON_CORE111_PC_W111),


.spc112_inst_done    (`PITON_CORE112_INST_DONE),
.pc_w112             (`PITON_CORE112_PC_W112),


.spc113_inst_done    (`PITON_CORE113_INST_DONE),
.pc_w113             (`PITON_CORE113_PC_W113),


.spc114_inst_done    (`PITON_CORE114_INST_DONE),
.pc_w114             (`PITON_CORE114_PC_W114),


.spc115_inst_done    (`PITON_CORE115_INST_DONE),
.pc_w115             (`PITON_CORE115_PC_W115),


.spc116_inst_done    (`PITON_CORE116_INST_DONE),
.pc_w116             (`PITON_CORE116_PC_W116),


.spc117_inst_done    (`PITON_CORE117_INST_DONE),
.pc_w117             (`PITON_CORE117_PC_W117),


.spc118_inst_done    (`PITON_CORE118_INST_DONE),
.pc_w118             (`PITON_CORE118_PC_W118),


.spc119_inst_done    (`PITON_CORE119_INST_DONE),
.pc_w119             (`PITON_CORE119_PC_W119),


.spc120_inst_done    (`PITON_CORE120_INST_DONE),
.pc_w120             (`PITON_CORE120_PC_W120),


.spc121_inst_done    (`PITON_CORE121_INST_DONE),
.pc_w121             (`PITON_CORE121_PC_W121),


.spc122_inst_done    (`PITON_CORE122_INST_DONE),
.pc_w122             (`PITON_CORE122_PC_W122),


.spc123_inst_done    (`PITON_CORE123_INST_DONE),
.pc_w123             (`PITON_CORE123_PC_W123),


.spc124_inst_done    (`PITON_CORE124_INST_DONE),
.pc_w124             (`PITON_CORE124_PC_W124),


.spc125_inst_done    (`PITON_CORE125_INST_DONE),
.pc_w125             (`PITON_CORE125_PC_W125),


.spc126_inst_done    (`PITON_CORE126_INST_DONE),
.pc_w126             (`PITON_CORE126_PC_W126),


.spc127_inst_done    (`PITON_CORE127_INST_DONE),
.pc_w127             (`PITON_CORE127_PC_W127),


.spc128_inst_done    (`PITON_CORE128_INST_DONE),
.pc_w128             (`PITON_CORE128_PC_W128),


.spc129_inst_done    (`PITON_CORE129_INST_DONE),
.pc_w129             (`PITON_CORE129_PC_W129),


.spc130_inst_done    (`PITON_CORE130_INST_DONE),
.pc_w130             (`PITON_CORE130_PC_W130),


.spc131_inst_done    (`PITON_CORE131_INST_DONE),
.pc_w131             (`PITON_CORE131_PC_W131),


.spc132_inst_done    (`PITON_CORE132_INST_DONE),
.pc_w132             (`PITON_CORE132_PC_W132),


.spc133_inst_done    (`PITON_CORE133_INST_DONE),
.pc_w133             (`PITON_CORE133_PC_W133),


.spc134_inst_done    (`PITON_CORE134_INST_DONE),
.pc_w134             (`PITON_CORE134_PC_W134),


.spc135_inst_done    (`PITON_CORE135_INST_DONE),
.pc_w135             (`PITON_CORE135_PC_W135),


.spc136_inst_done    (`PITON_CORE136_INST_DONE),
.pc_w136             (`PITON_CORE136_PC_W136),


.spc137_inst_done    (`PITON_CORE137_INST_DONE),
.pc_w137             (`PITON_CORE137_PC_W137),


.spc138_inst_done    (`PITON_CORE138_INST_DONE),
.pc_w138             (`PITON_CORE138_PC_W138),


.spc139_inst_done    (`PITON_CORE139_INST_DONE),
.pc_w139             (`PITON_CORE139_PC_W139),


.spc140_inst_done    (`PITON_CORE140_INST_DONE),
.pc_w140             (`PITON_CORE140_PC_W140),


.spc141_inst_done    (`PITON_CORE141_INST_DONE),
.pc_w141             (`PITON_CORE141_PC_W141),


.spc142_inst_done    (`PITON_CORE142_INST_DONE),
.pc_w142             (`PITON_CORE142_PC_W142),


.spc143_inst_done    (`PITON_CORE143_INST_DONE),
.pc_w143             (`PITON_CORE143_PC_W143),


.spc144_inst_done    (`PITON_CORE144_INST_DONE),
.pc_w144             (`PITON_CORE144_PC_W144),


.spc145_inst_done    (`PITON_CORE145_INST_DONE),
.pc_w145             (`PITON_CORE145_PC_W145),


.spc146_inst_done    (`PITON_CORE146_INST_DONE),
.pc_w146             (`PITON_CORE146_PC_W146),


.spc147_inst_done    (`PITON_CORE147_INST_DONE),
.pc_w147             (`PITON_CORE147_PC_W147),


.spc148_inst_done    (`PITON_CORE148_INST_DONE),
.pc_w148             (`PITON_CORE148_PC_W148),


.spc149_inst_done    (`PITON_CORE149_INST_DONE),
.pc_w149             (`PITON_CORE149_PC_W149),


.spc150_inst_done    (`PITON_CORE150_INST_DONE),
.pc_w150             (`PITON_CORE150_PC_W150),


.spc151_inst_done    (`PITON_CORE151_INST_DONE),
.pc_w151             (`PITON_CORE151_PC_W151),


.spc152_inst_done    (`PITON_CORE152_INST_DONE),
.pc_w152             (`PITON_CORE152_PC_W152),


.spc153_inst_done    (`PITON_CORE153_INST_DONE),
.pc_w153             (`PITON_CORE153_PC_W153),


.spc154_inst_done    (`PITON_CORE154_INST_DONE),
.pc_w154             (`PITON_CORE154_PC_W154),


.spc155_inst_done    (`PITON_CORE155_INST_DONE),
.pc_w155             (`PITON_CORE155_PC_W155),


.spc156_inst_done    (`PITON_CORE156_INST_DONE),
.pc_w156             (`PITON_CORE156_PC_W156),


.spc157_inst_done    (`PITON_CORE157_INST_DONE),
.pc_w157             (`PITON_CORE157_PC_W157),


.spc158_inst_done    (`PITON_CORE158_INST_DONE),
.pc_w158             (`PITON_CORE158_PC_W158),


.spc159_inst_done    (`PITON_CORE159_INST_DONE),
.pc_w159             (`PITON_CORE159_PC_W159),


.spc160_inst_done    (`PITON_CORE160_INST_DONE),
.pc_w160             (`PITON_CORE160_PC_W160),


.spc161_inst_done    (`PITON_CORE161_INST_DONE),
.pc_w161             (`PITON_CORE161_PC_W161),


.spc162_inst_done    (`PITON_CORE162_INST_DONE),
.pc_w162             (`PITON_CORE162_PC_W162),


.spc163_inst_done    (`PITON_CORE163_INST_DONE),
.pc_w163             (`PITON_CORE163_PC_W163),


.spc164_inst_done    (`PITON_CORE164_INST_DONE),
.pc_w164             (`PITON_CORE164_PC_W164),


.spc165_inst_done    (`PITON_CORE165_INST_DONE),
.pc_w165             (`PITON_CORE165_PC_W165),


.spc166_inst_done    (`PITON_CORE166_INST_DONE),
.pc_w166             (`PITON_CORE166_PC_W166),


.spc167_inst_done    (`PITON_CORE167_INST_DONE),
.pc_w167             (`PITON_CORE167_PC_W167),


.spc168_inst_done    (`PITON_CORE168_INST_DONE),
.pc_w168             (`PITON_CORE168_PC_W168),


.spc169_inst_done    (`PITON_CORE169_INST_DONE),
.pc_w169             (`PITON_CORE169_PC_W169),


.spc170_inst_done    (`PITON_CORE170_INST_DONE),
.pc_w170             (`PITON_CORE170_PC_W170),


.spc171_inst_done    (`PITON_CORE171_INST_DONE),
.pc_w171             (`PITON_CORE171_PC_W171),


.spc172_inst_done    (`PITON_CORE172_INST_DONE),
.pc_w172             (`PITON_CORE172_PC_W172),


.spc173_inst_done    (`PITON_CORE173_INST_DONE),
.pc_w173             (`PITON_CORE173_PC_W173),


.spc174_inst_done    (`PITON_CORE174_INST_DONE),
.pc_w174             (`PITON_CORE174_PC_W174),


.spc175_inst_done    (`PITON_CORE175_INST_DONE),
.pc_w175             (`PITON_CORE175_PC_W175),


.spc176_inst_done    (`PITON_CORE176_INST_DONE),
.pc_w176             (`PITON_CORE176_PC_W176),


.spc177_inst_done    (`PITON_CORE177_INST_DONE),
.pc_w177             (`PITON_CORE177_PC_W177),


.spc178_inst_done    (`PITON_CORE178_INST_DONE),
.pc_w178             (`PITON_CORE178_PC_W178),


.spc179_inst_done    (`PITON_CORE179_INST_DONE),
.pc_w179             (`PITON_CORE179_PC_W179),


.spc180_inst_done    (`PITON_CORE180_INST_DONE),
.pc_w180             (`PITON_CORE180_PC_W180),


.spc181_inst_done    (`PITON_CORE181_INST_DONE),
.pc_w181             (`PITON_CORE181_PC_W181),


.spc182_inst_done    (`PITON_CORE182_INST_DONE),
.pc_w182             (`PITON_CORE182_PC_W182),


.spc183_inst_done    (`PITON_CORE183_INST_DONE),
.pc_w183             (`PITON_CORE183_PC_W183),


.spc184_inst_done    (`PITON_CORE184_INST_DONE),
.pc_w184             (`PITON_CORE184_PC_W184),


.spc185_inst_done    (`PITON_CORE185_INST_DONE),
.pc_w185             (`PITON_CORE185_PC_W185),


.spc186_inst_done    (`PITON_CORE186_INST_DONE),
.pc_w186             (`PITON_CORE186_PC_W186),


.spc187_inst_done    (`PITON_CORE187_INST_DONE),
.pc_w187             (`PITON_CORE187_PC_W187),


.spc188_inst_done    (`PITON_CORE188_INST_DONE),
.pc_w188             (`PITON_CORE188_PC_W188),


.spc189_inst_done    (`PITON_CORE189_INST_DONE),
.pc_w189             (`PITON_CORE189_PC_W189),


.spc190_inst_done    (`PITON_CORE190_INST_DONE),
.pc_w190             (`PITON_CORE190_PC_W190),


.spc191_inst_done    (`PITON_CORE191_INST_DONE),
.pc_w191             (`PITON_CORE191_PC_W191),


.spc192_inst_done    (`PITON_CORE192_INST_DONE),
.pc_w192             (`PITON_CORE192_PC_W192),


.spc193_inst_done    (`PITON_CORE193_INST_DONE),
.pc_w193             (`PITON_CORE193_PC_W193),


.spc194_inst_done    (`PITON_CORE194_INST_DONE),
.pc_w194             (`PITON_CORE194_PC_W194),


.spc195_inst_done    (`PITON_CORE195_INST_DONE),
.pc_w195             (`PITON_CORE195_PC_W195),


.spc196_inst_done    (`PITON_CORE196_INST_DONE),
.pc_w196             (`PITON_CORE196_PC_W196),


.spc197_inst_done    (`PITON_CORE197_INST_DONE),
.pc_w197             (`PITON_CORE197_PC_W197),


.spc198_inst_done    (`PITON_CORE198_INST_DONE),
.pc_w198             (`PITON_CORE198_PC_W198),


.spc199_inst_done    (`PITON_CORE199_INST_DONE),
.pc_w199             (`PITON_CORE199_PC_W199),


.spc200_inst_done    (`PITON_CORE200_INST_DONE),
.pc_w200             (`PITON_CORE200_PC_W200),


.spc201_inst_done    (`PITON_CORE201_INST_DONE),
.pc_w201             (`PITON_CORE201_PC_W201),


.spc202_inst_done    (`PITON_CORE202_INST_DONE),
.pc_w202             (`PITON_CORE202_PC_W202),


.spc203_inst_done    (`PITON_CORE203_INST_DONE),
.pc_w203             (`PITON_CORE203_PC_W203),


.spc204_inst_done    (`PITON_CORE204_INST_DONE),
.pc_w204             (`PITON_CORE204_PC_W204),


.spc205_inst_done    (`PITON_CORE205_INST_DONE),
.pc_w205             (`PITON_CORE205_PC_W205),


.spc206_inst_done    (`PITON_CORE206_INST_DONE),
.pc_w206             (`PITON_CORE206_PC_W206),


.spc207_inst_done    (`PITON_CORE207_INST_DONE),
.pc_w207             (`PITON_CORE207_PC_W207),


.spc208_inst_done    (`PITON_CORE208_INST_DONE),
.pc_w208             (`PITON_CORE208_PC_W208),


.spc209_inst_done    (`PITON_CORE209_INST_DONE),
.pc_w209             (`PITON_CORE209_PC_W209),


.spc210_inst_done    (`PITON_CORE210_INST_DONE),
.pc_w210             (`PITON_CORE210_PC_W210),


.spc211_inst_done    (`PITON_CORE211_INST_DONE),
.pc_w211             (`PITON_CORE211_PC_W211),


.spc212_inst_done    (`PITON_CORE212_INST_DONE),
.pc_w212             (`PITON_CORE212_PC_W212),


.spc213_inst_done    (`PITON_CORE213_INST_DONE),
.pc_w213             (`PITON_CORE213_PC_W213),


.spc214_inst_done    (`PITON_CORE214_INST_DONE),
.pc_w214             (`PITON_CORE214_PC_W214),


.spc215_inst_done    (`PITON_CORE215_INST_DONE),
.pc_w215             (`PITON_CORE215_PC_W215),


.spc216_inst_done    (`PITON_CORE216_INST_DONE),
.pc_w216             (`PITON_CORE216_PC_W216),


.spc217_inst_done    (`PITON_CORE217_INST_DONE),
.pc_w217             (`PITON_CORE217_PC_W217),


.spc218_inst_done    (`PITON_CORE218_INST_DONE),
.pc_w218             (`PITON_CORE218_PC_W218),


.spc219_inst_done    (`PITON_CORE219_INST_DONE),
.pc_w219             (`PITON_CORE219_PC_W219),


.spc220_inst_done    (`PITON_CORE220_INST_DONE),
.pc_w220             (`PITON_CORE220_PC_W220),


.spc221_inst_done    (`PITON_CORE221_INST_DONE),
.pc_w221             (`PITON_CORE221_PC_W221),


.spc222_inst_done    (`PITON_CORE222_INST_DONE),
.pc_w222             (`PITON_CORE222_PC_W222),


.spc223_inst_done    (`PITON_CORE223_INST_DONE),
.pc_w223             (`PITON_CORE223_PC_W223),


.spc224_inst_done    (`PITON_CORE224_INST_DONE),
.pc_w224             (`PITON_CORE224_PC_W224),


.spc225_inst_done    (`PITON_CORE225_INST_DONE),
.pc_w225             (`PITON_CORE225_PC_W225),


.spc226_inst_done    (`PITON_CORE226_INST_DONE),
.pc_w226             (`PITON_CORE226_PC_W226),


.spc227_inst_done    (`PITON_CORE227_INST_DONE),
.pc_w227             (`PITON_CORE227_PC_W227),


.spc228_inst_done    (`PITON_CORE228_INST_DONE),
.pc_w228             (`PITON_CORE228_PC_W228),


.spc229_inst_done    (`PITON_CORE229_INST_DONE),
.pc_w229             (`PITON_CORE229_PC_W229),


.spc230_inst_done    (`PITON_CORE230_INST_DONE),
.pc_w230             (`PITON_CORE230_PC_W230),


.spc231_inst_done    (`PITON_CORE231_INST_DONE),
.pc_w231             (`PITON_CORE231_PC_W231),


.spc232_inst_done    (`PITON_CORE232_INST_DONE),
.pc_w232             (`PITON_CORE232_PC_W232),


.spc233_inst_done    (`PITON_CORE233_INST_DONE),
.pc_w233             (`PITON_CORE233_PC_W233),


.spc234_inst_done    (`PITON_CORE234_INST_DONE),
.pc_w234             (`PITON_CORE234_PC_W234),


.spc235_inst_done    (`PITON_CORE235_INST_DONE),
.pc_w235             (`PITON_CORE235_PC_W235),


.spc236_inst_done    (`PITON_CORE236_INST_DONE),
.pc_w236             (`PITON_CORE236_PC_W236),


.spc237_inst_done    (`PITON_CORE237_INST_DONE),
.pc_w237             (`PITON_CORE237_PC_W237),


.spc238_inst_done    (`PITON_CORE238_INST_DONE),
.pc_w238             (`PITON_CORE238_PC_W238),


.spc239_inst_done    (`PITON_CORE239_INST_DONE),
.pc_w239             (`PITON_CORE239_PC_W239),


.spc240_inst_done    (`PITON_CORE240_INST_DONE),
.pc_w240             (`PITON_CORE240_PC_W240),


.spc241_inst_done    (`PITON_CORE241_INST_DONE),
.pc_w241             (`PITON_CORE241_PC_W241),


.spc242_inst_done    (`PITON_CORE242_INST_DONE),
.pc_w242             (`PITON_CORE242_PC_W242),


.spc243_inst_done    (`PITON_CORE243_INST_DONE),
.pc_w243             (`PITON_CORE243_PC_W243),


.spc244_inst_done    (`PITON_CORE244_INST_DONE),
.pc_w244             (`PITON_CORE244_PC_W244),


.spc245_inst_done    (`PITON_CORE245_INST_DONE),
.pc_w245             (`PITON_CORE245_PC_W245),


.spc246_inst_done    (`PITON_CORE246_INST_DONE),
.pc_w246             (`PITON_CORE246_PC_W246),


.spc247_inst_done    (`PITON_CORE247_INST_DONE),
.pc_w247             (`PITON_CORE247_PC_W247),


.spc248_inst_done    (`PITON_CORE248_INST_DONE),
.pc_w248             (`PITON_CORE248_PC_W248),


.spc249_inst_done    (`PITON_CORE249_INST_DONE),
.pc_w249             (`PITON_CORE249_PC_W249),


.spc250_inst_done    (`PITON_CORE250_INST_DONE),
.pc_w250             (`PITON_CORE250_PC_W250),


.spc251_inst_done    (`PITON_CORE251_INST_DONE),
.pc_w251             (`PITON_CORE251_PC_W251),


.spc252_inst_done    (`PITON_CORE252_INST_DONE),
.pc_w252             (`PITON_CORE252_PC_W252),


.spc253_inst_done    (`PITON_CORE253_INST_DONE),
.pc_w253             (`PITON_CORE253_PC_W253),


.spc254_inst_done    (`PITON_CORE254_INST_DONE),
.pc_w254             (`PITON_CORE254_PC_W254),


.spc255_inst_done    (`PITON_CORE255_INST_DONE),
.pc_w255             (`PITON_CORE255_PC_W255),


    .clk               (chipset_clk),
    .rst_n             (chipset_rst_n)
//    .rst_n             (`SPARC_CORE0.reset_l)
);

// I/O AXI splitter, needed for uart-hello-world.s
fake_uart fake_uart (
    .clk                ( chipset_clk         ),
    .rst_n              ( chipset_rst_n       ),

    .src_uart_noc2_val  ( buf_uart_noc2_valid ),
    .src_uart_noc2_data ( buf_uart_noc2_data  ),
    .src_uart_noc2_rdy  ( uart_buf_noc2_ready ),

    .uart_dst_noc3_val  ( uart_buf_noc3_valid ),
    .uart_dst_noc3_data ( uart_buf_noc3_data  ),
    .uart_dst_noc3_rdy  ( buf_uart_noc3_ready )
);
`endif // endif PITONSYS_IOCTRL


/////////////////////////////
// Ariane-Specific Chipset //
/////////////////////////////

`ifdef PITON_RV64_PLATFORM

    wire [1:0] irq_sources, irq_le;
    // 0:level 1:edge
    // Eth is edge, Uart is level
    assign irq_le      = {1'b1, 1'b0};
    assign irq_sources = {net_interrupt, uart_interrupt};

    // this is for selecting the right bootrom (1: baremetal, 0: linux)
    wire ariane_boot_sel;
`ifdef PITON_FPGA_SYNTH
  assign ariane_boot_sel   = uart_boot_en;
`else
  `ifdef ARIANE_SIM_LINUX_BOOT
    assign ariane_boot_sel = 1'b0;
  `else
    assign ariane_boot_sel = 1'b1;
  `endif
`endif


    riscv_peripherals #(
        .DataWidth      ( `NOC_DATA_WIDTH ),
        .NumHarts       ( `PITON_NUM_TILES),
        .NumSources     (               2 ),
        .SwapEndianess  (               1 ),
        .DmBase         ( 64'h000000fff1000000 ),
        .RomBase        ( 64'h000000fff1010000 ),
        .ClintBase      ( 64'h000000fff1020000 ),
        .PlicBase       ( 64'h000000fff1100000 )
    ) i_riscv_peripherals (
        .clk_i                           ( chipset_clk                   )
,       .rst_ni                          ( chipset_rst_n                 )
`ifdef PITON_RV64_DEBUGUNIT
,       .testmode_i                      ( 1'b0                          )
,       .buf_ariane_debug_noc2_data_i    ( buf_ariane_debug_noc2_data    )
,       .buf_ariane_debug_noc2_valid_i   ( buf_ariane_debug_noc2_valid   )
,       .ariane_debug_buf_noc2_ready_o   ( ariane_debug_buf_noc2_ready   )
,       .ariane_debug_buf_noc3_data_o    ( ariane_debug_buf_noc3_data    )
,       .ariane_debug_buf_noc3_valid_o   ( ariane_debug_buf_noc3_valid   )
,       .buf_ariane_debug_noc3_ready_i   ( buf_ariane_debug_noc3_ready   )
`endif // ifdef PITON_RV64_DEBUGUNIT
,       .buf_ariane_bootrom_noc2_data_i  ( buf_ariane_bootrom_noc2_data  )
,       .buf_ariane_bootrom_noc2_valid_i ( buf_ariane_bootrom_noc2_valid )
,       .ariane_bootrom_buf_noc2_ready_o ( ariane_bootrom_buf_noc2_ready )
,       .ariane_bootrom_buf_noc3_data_o  ( ariane_bootrom_buf_noc3_data  )
,       .ariane_bootrom_buf_noc3_valid_o ( ariane_bootrom_buf_noc3_valid )
,       .buf_ariane_bootrom_noc3_ready_i ( buf_ariane_bootrom_noc3_ready )
`ifdef PITON_RV64_CLINT
,       .buf_ariane_clint_noc2_data_i    ( buf_ariane_clint_noc2_data    )
,       .buf_ariane_clint_noc2_valid_i   ( buf_ariane_clint_noc2_valid   )
,       .ariane_clint_buf_noc2_ready_o   ( ariane_clint_buf_noc2_ready   )
,       .ariane_clint_buf_noc3_data_o    ( ariane_clint_buf_noc3_data    )
,       .ariane_clint_buf_noc3_valid_o   ( ariane_clint_buf_noc3_valid   )
,       .buf_ariane_clint_noc3_ready_i   ( buf_ariane_clint_noc3_ready   )
`endif // ifdef PITON_RV64_CLINT
`ifdef PITON_RV64_PLIC
,       .buf_ariane_plic_noc2_data_i     ( buf_ariane_plic_noc2_data     )
,       .buf_ariane_plic_noc2_valid_i    ( buf_ariane_plic_noc2_valid    )
,       .ariane_plic_buf_noc2_ready_o    ( ariane_plic_buf_noc2_ready    )
,       .ariane_plic_buf_noc3_data_o     ( ariane_plic_buf_noc3_data     )
,       .ariane_plic_buf_noc3_valid_o    ( ariane_plic_buf_noc3_valid    )
,       .buf_ariane_plic_noc3_ready_i    ( buf_ariane_plic_noc3_ready    )
`endif // ifdef PITON_RV64_PLIC
        // This selects either the BM or linux bootrom
,       .ariane_boot_sel_i               ( ariane_boot_sel               )
`ifdef PITON_RV64_DEBUGUNIT
        // Debug sigs to cores
,       .ndmreset_o                      ( ndmreset_o                    )
,       .dmactive_o                      ( dmactive_o                    )
,       .debug_req_o                     ( debug_req_o                   )
,       .unavailable_i                   ( unavailable_i                 )
        // JTAG
,       .tck_i                           ( tck_i                         )
,       .tms_i                           ( tms_i                         )
,       .trst_ni                         ( trst_ni                       )
,       .td_i                            ( td_i                          )
,       .td_o                            ( td_o                          )
,       .tdo_oe_o                        (                               )
`endif // ifdef PITON_RV64_DEBUGUNIT
`ifdef PITON_RV64_CLINT
        // CLINT
,       .rtc_i                           ( rtc_i                         )
,       .timer_irq_o                     ( timer_irq_o                   )
,       .ipi_o                           ( ipi_o                         )
`endif // ifdef PITON_RV64_CLINT
`ifdef PITON_RV64_PLIC
        // PLIC
,       .irq_le_i                        ( irq_le                        ) // 0:level 1:edge
,       .irq_sources_i                   ( irq_sources                   )
,       .irq_o                           ( irq_o                         )
`endif // ifdef PITON_RV64_PLIC
    );



`else

    // tie off unused sigs
    assign ariane_debug_buf_noc2_ready   = 1'b0;
    assign ariane_debug_buf_noc3_data    = `NOC_DATA_WIDTH'b0;
    assign ariane_debug_buf_noc3_valid   = 1'b0;

    assign ariane_bootrom_buf_noc2_ready = 1'b0;
    assign ariane_bootrom_buf_noc3_data  = `NOC_DATA_WIDTH'b0;
    assign ariane_bootrom_buf_noc3_valid = 1'b0;

    assign ariane_clint_buf_noc2_ready   = 1'b0;
    assign ariane_clint_buf_noc3_data    = `NOC_DATA_WIDTH'b0;
    assign ariane_clint_buf_noc3_valid   = 1'b0;

    assign ariane_plic_buf_noc2_ready    = 1'b0;
    assign ariane_plic_buf_noc3_data     = `NOC_DATA_WIDTH'b0;
    assign ariane_plic_buf_noc3_valid    = 1'b0;

`endif // ifdef PITON_RV64_PLATFORM

endmodule
