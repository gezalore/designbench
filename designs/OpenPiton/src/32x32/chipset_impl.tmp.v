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


.spc256_inst_done    (`PITON_CORE256_INST_DONE),
.pc_w256             (`PITON_CORE256_PC_W256),


.spc257_inst_done    (`PITON_CORE257_INST_DONE),
.pc_w257             (`PITON_CORE257_PC_W257),


.spc258_inst_done    (`PITON_CORE258_INST_DONE),
.pc_w258             (`PITON_CORE258_PC_W258),


.spc259_inst_done    (`PITON_CORE259_INST_DONE),
.pc_w259             (`PITON_CORE259_PC_W259),


.spc260_inst_done    (`PITON_CORE260_INST_DONE),
.pc_w260             (`PITON_CORE260_PC_W260),


.spc261_inst_done    (`PITON_CORE261_INST_DONE),
.pc_w261             (`PITON_CORE261_PC_W261),


.spc262_inst_done    (`PITON_CORE262_INST_DONE),
.pc_w262             (`PITON_CORE262_PC_W262),


.spc263_inst_done    (`PITON_CORE263_INST_DONE),
.pc_w263             (`PITON_CORE263_PC_W263),


.spc264_inst_done    (`PITON_CORE264_INST_DONE),
.pc_w264             (`PITON_CORE264_PC_W264),


.spc265_inst_done    (`PITON_CORE265_INST_DONE),
.pc_w265             (`PITON_CORE265_PC_W265),


.spc266_inst_done    (`PITON_CORE266_INST_DONE),
.pc_w266             (`PITON_CORE266_PC_W266),


.spc267_inst_done    (`PITON_CORE267_INST_DONE),
.pc_w267             (`PITON_CORE267_PC_W267),


.spc268_inst_done    (`PITON_CORE268_INST_DONE),
.pc_w268             (`PITON_CORE268_PC_W268),


.spc269_inst_done    (`PITON_CORE269_INST_DONE),
.pc_w269             (`PITON_CORE269_PC_W269),


.spc270_inst_done    (`PITON_CORE270_INST_DONE),
.pc_w270             (`PITON_CORE270_PC_W270),


.spc271_inst_done    (`PITON_CORE271_INST_DONE),
.pc_w271             (`PITON_CORE271_PC_W271),


.spc272_inst_done    (`PITON_CORE272_INST_DONE),
.pc_w272             (`PITON_CORE272_PC_W272),


.spc273_inst_done    (`PITON_CORE273_INST_DONE),
.pc_w273             (`PITON_CORE273_PC_W273),


.spc274_inst_done    (`PITON_CORE274_INST_DONE),
.pc_w274             (`PITON_CORE274_PC_W274),


.spc275_inst_done    (`PITON_CORE275_INST_DONE),
.pc_w275             (`PITON_CORE275_PC_W275),


.spc276_inst_done    (`PITON_CORE276_INST_DONE),
.pc_w276             (`PITON_CORE276_PC_W276),


.spc277_inst_done    (`PITON_CORE277_INST_DONE),
.pc_w277             (`PITON_CORE277_PC_W277),


.spc278_inst_done    (`PITON_CORE278_INST_DONE),
.pc_w278             (`PITON_CORE278_PC_W278),


.spc279_inst_done    (`PITON_CORE279_INST_DONE),
.pc_w279             (`PITON_CORE279_PC_W279),


.spc280_inst_done    (`PITON_CORE280_INST_DONE),
.pc_w280             (`PITON_CORE280_PC_W280),


.spc281_inst_done    (`PITON_CORE281_INST_DONE),
.pc_w281             (`PITON_CORE281_PC_W281),


.spc282_inst_done    (`PITON_CORE282_INST_DONE),
.pc_w282             (`PITON_CORE282_PC_W282),


.spc283_inst_done    (`PITON_CORE283_INST_DONE),
.pc_w283             (`PITON_CORE283_PC_W283),


.spc284_inst_done    (`PITON_CORE284_INST_DONE),
.pc_w284             (`PITON_CORE284_PC_W284),


.spc285_inst_done    (`PITON_CORE285_INST_DONE),
.pc_w285             (`PITON_CORE285_PC_W285),


.spc286_inst_done    (`PITON_CORE286_INST_DONE),
.pc_w286             (`PITON_CORE286_PC_W286),


.spc287_inst_done    (`PITON_CORE287_INST_DONE),
.pc_w287             (`PITON_CORE287_PC_W287),


.spc288_inst_done    (`PITON_CORE288_INST_DONE),
.pc_w288             (`PITON_CORE288_PC_W288),


.spc289_inst_done    (`PITON_CORE289_INST_DONE),
.pc_w289             (`PITON_CORE289_PC_W289),


.spc290_inst_done    (`PITON_CORE290_INST_DONE),
.pc_w290             (`PITON_CORE290_PC_W290),


.spc291_inst_done    (`PITON_CORE291_INST_DONE),
.pc_w291             (`PITON_CORE291_PC_W291),


.spc292_inst_done    (`PITON_CORE292_INST_DONE),
.pc_w292             (`PITON_CORE292_PC_W292),


.spc293_inst_done    (`PITON_CORE293_INST_DONE),
.pc_w293             (`PITON_CORE293_PC_W293),


.spc294_inst_done    (`PITON_CORE294_INST_DONE),
.pc_w294             (`PITON_CORE294_PC_W294),


.spc295_inst_done    (`PITON_CORE295_INST_DONE),
.pc_w295             (`PITON_CORE295_PC_W295),


.spc296_inst_done    (`PITON_CORE296_INST_DONE),
.pc_w296             (`PITON_CORE296_PC_W296),


.spc297_inst_done    (`PITON_CORE297_INST_DONE),
.pc_w297             (`PITON_CORE297_PC_W297),


.spc298_inst_done    (`PITON_CORE298_INST_DONE),
.pc_w298             (`PITON_CORE298_PC_W298),


.spc299_inst_done    (`PITON_CORE299_INST_DONE),
.pc_w299             (`PITON_CORE299_PC_W299),


.spc300_inst_done    (`PITON_CORE300_INST_DONE),
.pc_w300             (`PITON_CORE300_PC_W300),


.spc301_inst_done    (`PITON_CORE301_INST_DONE),
.pc_w301             (`PITON_CORE301_PC_W301),


.spc302_inst_done    (`PITON_CORE302_INST_DONE),
.pc_w302             (`PITON_CORE302_PC_W302),


.spc303_inst_done    (`PITON_CORE303_INST_DONE),
.pc_w303             (`PITON_CORE303_PC_W303),


.spc304_inst_done    (`PITON_CORE304_INST_DONE),
.pc_w304             (`PITON_CORE304_PC_W304),


.spc305_inst_done    (`PITON_CORE305_INST_DONE),
.pc_w305             (`PITON_CORE305_PC_W305),


.spc306_inst_done    (`PITON_CORE306_INST_DONE),
.pc_w306             (`PITON_CORE306_PC_W306),


.spc307_inst_done    (`PITON_CORE307_INST_DONE),
.pc_w307             (`PITON_CORE307_PC_W307),


.spc308_inst_done    (`PITON_CORE308_INST_DONE),
.pc_w308             (`PITON_CORE308_PC_W308),


.spc309_inst_done    (`PITON_CORE309_INST_DONE),
.pc_w309             (`PITON_CORE309_PC_W309),


.spc310_inst_done    (`PITON_CORE310_INST_DONE),
.pc_w310             (`PITON_CORE310_PC_W310),


.spc311_inst_done    (`PITON_CORE311_INST_DONE),
.pc_w311             (`PITON_CORE311_PC_W311),


.spc312_inst_done    (`PITON_CORE312_INST_DONE),
.pc_w312             (`PITON_CORE312_PC_W312),


.spc313_inst_done    (`PITON_CORE313_INST_DONE),
.pc_w313             (`PITON_CORE313_PC_W313),


.spc314_inst_done    (`PITON_CORE314_INST_DONE),
.pc_w314             (`PITON_CORE314_PC_W314),


.spc315_inst_done    (`PITON_CORE315_INST_DONE),
.pc_w315             (`PITON_CORE315_PC_W315),


.spc316_inst_done    (`PITON_CORE316_INST_DONE),
.pc_w316             (`PITON_CORE316_PC_W316),


.spc317_inst_done    (`PITON_CORE317_INST_DONE),
.pc_w317             (`PITON_CORE317_PC_W317),


.spc318_inst_done    (`PITON_CORE318_INST_DONE),
.pc_w318             (`PITON_CORE318_PC_W318),


.spc319_inst_done    (`PITON_CORE319_INST_DONE),
.pc_w319             (`PITON_CORE319_PC_W319),


.spc320_inst_done    (`PITON_CORE320_INST_DONE),
.pc_w320             (`PITON_CORE320_PC_W320),


.spc321_inst_done    (`PITON_CORE321_INST_DONE),
.pc_w321             (`PITON_CORE321_PC_W321),


.spc322_inst_done    (`PITON_CORE322_INST_DONE),
.pc_w322             (`PITON_CORE322_PC_W322),


.spc323_inst_done    (`PITON_CORE323_INST_DONE),
.pc_w323             (`PITON_CORE323_PC_W323),


.spc324_inst_done    (`PITON_CORE324_INST_DONE),
.pc_w324             (`PITON_CORE324_PC_W324),


.spc325_inst_done    (`PITON_CORE325_INST_DONE),
.pc_w325             (`PITON_CORE325_PC_W325),


.spc326_inst_done    (`PITON_CORE326_INST_DONE),
.pc_w326             (`PITON_CORE326_PC_W326),


.spc327_inst_done    (`PITON_CORE327_INST_DONE),
.pc_w327             (`PITON_CORE327_PC_W327),


.spc328_inst_done    (`PITON_CORE328_INST_DONE),
.pc_w328             (`PITON_CORE328_PC_W328),


.spc329_inst_done    (`PITON_CORE329_INST_DONE),
.pc_w329             (`PITON_CORE329_PC_W329),


.spc330_inst_done    (`PITON_CORE330_INST_DONE),
.pc_w330             (`PITON_CORE330_PC_W330),


.spc331_inst_done    (`PITON_CORE331_INST_DONE),
.pc_w331             (`PITON_CORE331_PC_W331),


.spc332_inst_done    (`PITON_CORE332_INST_DONE),
.pc_w332             (`PITON_CORE332_PC_W332),


.spc333_inst_done    (`PITON_CORE333_INST_DONE),
.pc_w333             (`PITON_CORE333_PC_W333),


.spc334_inst_done    (`PITON_CORE334_INST_DONE),
.pc_w334             (`PITON_CORE334_PC_W334),


.spc335_inst_done    (`PITON_CORE335_INST_DONE),
.pc_w335             (`PITON_CORE335_PC_W335),


.spc336_inst_done    (`PITON_CORE336_INST_DONE),
.pc_w336             (`PITON_CORE336_PC_W336),


.spc337_inst_done    (`PITON_CORE337_INST_DONE),
.pc_w337             (`PITON_CORE337_PC_W337),


.spc338_inst_done    (`PITON_CORE338_INST_DONE),
.pc_w338             (`PITON_CORE338_PC_W338),


.spc339_inst_done    (`PITON_CORE339_INST_DONE),
.pc_w339             (`PITON_CORE339_PC_W339),


.spc340_inst_done    (`PITON_CORE340_INST_DONE),
.pc_w340             (`PITON_CORE340_PC_W340),


.spc341_inst_done    (`PITON_CORE341_INST_DONE),
.pc_w341             (`PITON_CORE341_PC_W341),


.spc342_inst_done    (`PITON_CORE342_INST_DONE),
.pc_w342             (`PITON_CORE342_PC_W342),


.spc343_inst_done    (`PITON_CORE343_INST_DONE),
.pc_w343             (`PITON_CORE343_PC_W343),


.spc344_inst_done    (`PITON_CORE344_INST_DONE),
.pc_w344             (`PITON_CORE344_PC_W344),


.spc345_inst_done    (`PITON_CORE345_INST_DONE),
.pc_w345             (`PITON_CORE345_PC_W345),


.spc346_inst_done    (`PITON_CORE346_INST_DONE),
.pc_w346             (`PITON_CORE346_PC_W346),


.spc347_inst_done    (`PITON_CORE347_INST_DONE),
.pc_w347             (`PITON_CORE347_PC_W347),


.spc348_inst_done    (`PITON_CORE348_INST_DONE),
.pc_w348             (`PITON_CORE348_PC_W348),


.spc349_inst_done    (`PITON_CORE349_INST_DONE),
.pc_w349             (`PITON_CORE349_PC_W349),


.spc350_inst_done    (`PITON_CORE350_INST_DONE),
.pc_w350             (`PITON_CORE350_PC_W350),


.spc351_inst_done    (`PITON_CORE351_INST_DONE),
.pc_w351             (`PITON_CORE351_PC_W351),


.spc352_inst_done    (`PITON_CORE352_INST_DONE),
.pc_w352             (`PITON_CORE352_PC_W352),


.spc353_inst_done    (`PITON_CORE353_INST_DONE),
.pc_w353             (`PITON_CORE353_PC_W353),


.spc354_inst_done    (`PITON_CORE354_INST_DONE),
.pc_w354             (`PITON_CORE354_PC_W354),


.spc355_inst_done    (`PITON_CORE355_INST_DONE),
.pc_w355             (`PITON_CORE355_PC_W355),


.spc356_inst_done    (`PITON_CORE356_INST_DONE),
.pc_w356             (`PITON_CORE356_PC_W356),


.spc357_inst_done    (`PITON_CORE357_INST_DONE),
.pc_w357             (`PITON_CORE357_PC_W357),


.spc358_inst_done    (`PITON_CORE358_INST_DONE),
.pc_w358             (`PITON_CORE358_PC_W358),


.spc359_inst_done    (`PITON_CORE359_INST_DONE),
.pc_w359             (`PITON_CORE359_PC_W359),


.spc360_inst_done    (`PITON_CORE360_INST_DONE),
.pc_w360             (`PITON_CORE360_PC_W360),


.spc361_inst_done    (`PITON_CORE361_INST_DONE),
.pc_w361             (`PITON_CORE361_PC_W361),


.spc362_inst_done    (`PITON_CORE362_INST_DONE),
.pc_w362             (`PITON_CORE362_PC_W362),


.spc363_inst_done    (`PITON_CORE363_INST_DONE),
.pc_w363             (`PITON_CORE363_PC_W363),


.spc364_inst_done    (`PITON_CORE364_INST_DONE),
.pc_w364             (`PITON_CORE364_PC_W364),


.spc365_inst_done    (`PITON_CORE365_INST_DONE),
.pc_w365             (`PITON_CORE365_PC_W365),


.spc366_inst_done    (`PITON_CORE366_INST_DONE),
.pc_w366             (`PITON_CORE366_PC_W366),


.spc367_inst_done    (`PITON_CORE367_INST_DONE),
.pc_w367             (`PITON_CORE367_PC_W367),


.spc368_inst_done    (`PITON_CORE368_INST_DONE),
.pc_w368             (`PITON_CORE368_PC_W368),


.spc369_inst_done    (`PITON_CORE369_INST_DONE),
.pc_w369             (`PITON_CORE369_PC_W369),


.spc370_inst_done    (`PITON_CORE370_INST_DONE),
.pc_w370             (`PITON_CORE370_PC_W370),


.spc371_inst_done    (`PITON_CORE371_INST_DONE),
.pc_w371             (`PITON_CORE371_PC_W371),


.spc372_inst_done    (`PITON_CORE372_INST_DONE),
.pc_w372             (`PITON_CORE372_PC_W372),


.spc373_inst_done    (`PITON_CORE373_INST_DONE),
.pc_w373             (`PITON_CORE373_PC_W373),


.spc374_inst_done    (`PITON_CORE374_INST_DONE),
.pc_w374             (`PITON_CORE374_PC_W374),


.spc375_inst_done    (`PITON_CORE375_INST_DONE),
.pc_w375             (`PITON_CORE375_PC_W375),


.spc376_inst_done    (`PITON_CORE376_INST_DONE),
.pc_w376             (`PITON_CORE376_PC_W376),


.spc377_inst_done    (`PITON_CORE377_INST_DONE),
.pc_w377             (`PITON_CORE377_PC_W377),


.spc378_inst_done    (`PITON_CORE378_INST_DONE),
.pc_w378             (`PITON_CORE378_PC_W378),


.spc379_inst_done    (`PITON_CORE379_INST_DONE),
.pc_w379             (`PITON_CORE379_PC_W379),


.spc380_inst_done    (`PITON_CORE380_INST_DONE),
.pc_w380             (`PITON_CORE380_PC_W380),


.spc381_inst_done    (`PITON_CORE381_INST_DONE),
.pc_w381             (`PITON_CORE381_PC_W381),


.spc382_inst_done    (`PITON_CORE382_INST_DONE),
.pc_w382             (`PITON_CORE382_PC_W382),


.spc383_inst_done    (`PITON_CORE383_INST_DONE),
.pc_w383             (`PITON_CORE383_PC_W383),


.spc384_inst_done    (`PITON_CORE384_INST_DONE),
.pc_w384             (`PITON_CORE384_PC_W384),


.spc385_inst_done    (`PITON_CORE385_INST_DONE),
.pc_w385             (`PITON_CORE385_PC_W385),


.spc386_inst_done    (`PITON_CORE386_INST_DONE),
.pc_w386             (`PITON_CORE386_PC_W386),


.spc387_inst_done    (`PITON_CORE387_INST_DONE),
.pc_w387             (`PITON_CORE387_PC_W387),


.spc388_inst_done    (`PITON_CORE388_INST_DONE),
.pc_w388             (`PITON_CORE388_PC_W388),


.spc389_inst_done    (`PITON_CORE389_INST_DONE),
.pc_w389             (`PITON_CORE389_PC_W389),


.spc390_inst_done    (`PITON_CORE390_INST_DONE),
.pc_w390             (`PITON_CORE390_PC_W390),


.spc391_inst_done    (`PITON_CORE391_INST_DONE),
.pc_w391             (`PITON_CORE391_PC_W391),


.spc392_inst_done    (`PITON_CORE392_INST_DONE),
.pc_w392             (`PITON_CORE392_PC_W392),


.spc393_inst_done    (`PITON_CORE393_INST_DONE),
.pc_w393             (`PITON_CORE393_PC_W393),


.spc394_inst_done    (`PITON_CORE394_INST_DONE),
.pc_w394             (`PITON_CORE394_PC_W394),


.spc395_inst_done    (`PITON_CORE395_INST_DONE),
.pc_w395             (`PITON_CORE395_PC_W395),


.spc396_inst_done    (`PITON_CORE396_INST_DONE),
.pc_w396             (`PITON_CORE396_PC_W396),


.spc397_inst_done    (`PITON_CORE397_INST_DONE),
.pc_w397             (`PITON_CORE397_PC_W397),


.spc398_inst_done    (`PITON_CORE398_INST_DONE),
.pc_w398             (`PITON_CORE398_PC_W398),


.spc399_inst_done    (`PITON_CORE399_INST_DONE),
.pc_w399             (`PITON_CORE399_PC_W399),


.spc400_inst_done    (`PITON_CORE400_INST_DONE),
.pc_w400             (`PITON_CORE400_PC_W400),


.spc401_inst_done    (`PITON_CORE401_INST_DONE),
.pc_w401             (`PITON_CORE401_PC_W401),


.spc402_inst_done    (`PITON_CORE402_INST_DONE),
.pc_w402             (`PITON_CORE402_PC_W402),


.spc403_inst_done    (`PITON_CORE403_INST_DONE),
.pc_w403             (`PITON_CORE403_PC_W403),


.spc404_inst_done    (`PITON_CORE404_INST_DONE),
.pc_w404             (`PITON_CORE404_PC_W404),


.spc405_inst_done    (`PITON_CORE405_INST_DONE),
.pc_w405             (`PITON_CORE405_PC_W405),


.spc406_inst_done    (`PITON_CORE406_INST_DONE),
.pc_w406             (`PITON_CORE406_PC_W406),


.spc407_inst_done    (`PITON_CORE407_INST_DONE),
.pc_w407             (`PITON_CORE407_PC_W407),


.spc408_inst_done    (`PITON_CORE408_INST_DONE),
.pc_w408             (`PITON_CORE408_PC_W408),


.spc409_inst_done    (`PITON_CORE409_INST_DONE),
.pc_w409             (`PITON_CORE409_PC_W409),


.spc410_inst_done    (`PITON_CORE410_INST_DONE),
.pc_w410             (`PITON_CORE410_PC_W410),


.spc411_inst_done    (`PITON_CORE411_INST_DONE),
.pc_w411             (`PITON_CORE411_PC_W411),


.spc412_inst_done    (`PITON_CORE412_INST_DONE),
.pc_w412             (`PITON_CORE412_PC_W412),


.spc413_inst_done    (`PITON_CORE413_INST_DONE),
.pc_w413             (`PITON_CORE413_PC_W413),


.spc414_inst_done    (`PITON_CORE414_INST_DONE),
.pc_w414             (`PITON_CORE414_PC_W414),


.spc415_inst_done    (`PITON_CORE415_INST_DONE),
.pc_w415             (`PITON_CORE415_PC_W415),


.spc416_inst_done    (`PITON_CORE416_INST_DONE),
.pc_w416             (`PITON_CORE416_PC_W416),


.spc417_inst_done    (`PITON_CORE417_INST_DONE),
.pc_w417             (`PITON_CORE417_PC_W417),


.spc418_inst_done    (`PITON_CORE418_INST_DONE),
.pc_w418             (`PITON_CORE418_PC_W418),


.spc419_inst_done    (`PITON_CORE419_INST_DONE),
.pc_w419             (`PITON_CORE419_PC_W419),


.spc420_inst_done    (`PITON_CORE420_INST_DONE),
.pc_w420             (`PITON_CORE420_PC_W420),


.spc421_inst_done    (`PITON_CORE421_INST_DONE),
.pc_w421             (`PITON_CORE421_PC_W421),


.spc422_inst_done    (`PITON_CORE422_INST_DONE),
.pc_w422             (`PITON_CORE422_PC_W422),


.spc423_inst_done    (`PITON_CORE423_INST_DONE),
.pc_w423             (`PITON_CORE423_PC_W423),


.spc424_inst_done    (`PITON_CORE424_INST_DONE),
.pc_w424             (`PITON_CORE424_PC_W424),


.spc425_inst_done    (`PITON_CORE425_INST_DONE),
.pc_w425             (`PITON_CORE425_PC_W425),


.spc426_inst_done    (`PITON_CORE426_INST_DONE),
.pc_w426             (`PITON_CORE426_PC_W426),


.spc427_inst_done    (`PITON_CORE427_INST_DONE),
.pc_w427             (`PITON_CORE427_PC_W427),


.spc428_inst_done    (`PITON_CORE428_INST_DONE),
.pc_w428             (`PITON_CORE428_PC_W428),


.spc429_inst_done    (`PITON_CORE429_INST_DONE),
.pc_w429             (`PITON_CORE429_PC_W429),


.spc430_inst_done    (`PITON_CORE430_INST_DONE),
.pc_w430             (`PITON_CORE430_PC_W430),


.spc431_inst_done    (`PITON_CORE431_INST_DONE),
.pc_w431             (`PITON_CORE431_PC_W431),


.spc432_inst_done    (`PITON_CORE432_INST_DONE),
.pc_w432             (`PITON_CORE432_PC_W432),


.spc433_inst_done    (`PITON_CORE433_INST_DONE),
.pc_w433             (`PITON_CORE433_PC_W433),


.spc434_inst_done    (`PITON_CORE434_INST_DONE),
.pc_w434             (`PITON_CORE434_PC_W434),


.spc435_inst_done    (`PITON_CORE435_INST_DONE),
.pc_w435             (`PITON_CORE435_PC_W435),


.spc436_inst_done    (`PITON_CORE436_INST_DONE),
.pc_w436             (`PITON_CORE436_PC_W436),


.spc437_inst_done    (`PITON_CORE437_INST_DONE),
.pc_w437             (`PITON_CORE437_PC_W437),


.spc438_inst_done    (`PITON_CORE438_INST_DONE),
.pc_w438             (`PITON_CORE438_PC_W438),


.spc439_inst_done    (`PITON_CORE439_INST_DONE),
.pc_w439             (`PITON_CORE439_PC_W439),


.spc440_inst_done    (`PITON_CORE440_INST_DONE),
.pc_w440             (`PITON_CORE440_PC_W440),


.spc441_inst_done    (`PITON_CORE441_INST_DONE),
.pc_w441             (`PITON_CORE441_PC_W441),


.spc442_inst_done    (`PITON_CORE442_INST_DONE),
.pc_w442             (`PITON_CORE442_PC_W442),


.spc443_inst_done    (`PITON_CORE443_INST_DONE),
.pc_w443             (`PITON_CORE443_PC_W443),


.spc444_inst_done    (`PITON_CORE444_INST_DONE),
.pc_w444             (`PITON_CORE444_PC_W444),


.spc445_inst_done    (`PITON_CORE445_INST_DONE),
.pc_w445             (`PITON_CORE445_PC_W445),


.spc446_inst_done    (`PITON_CORE446_INST_DONE),
.pc_w446             (`PITON_CORE446_PC_W446),


.spc447_inst_done    (`PITON_CORE447_INST_DONE),
.pc_w447             (`PITON_CORE447_PC_W447),


.spc448_inst_done    (`PITON_CORE448_INST_DONE),
.pc_w448             (`PITON_CORE448_PC_W448),


.spc449_inst_done    (`PITON_CORE449_INST_DONE),
.pc_w449             (`PITON_CORE449_PC_W449),


.spc450_inst_done    (`PITON_CORE450_INST_DONE),
.pc_w450             (`PITON_CORE450_PC_W450),


.spc451_inst_done    (`PITON_CORE451_INST_DONE),
.pc_w451             (`PITON_CORE451_PC_W451),


.spc452_inst_done    (`PITON_CORE452_INST_DONE),
.pc_w452             (`PITON_CORE452_PC_W452),


.spc453_inst_done    (`PITON_CORE453_INST_DONE),
.pc_w453             (`PITON_CORE453_PC_W453),


.spc454_inst_done    (`PITON_CORE454_INST_DONE),
.pc_w454             (`PITON_CORE454_PC_W454),


.spc455_inst_done    (`PITON_CORE455_INST_DONE),
.pc_w455             (`PITON_CORE455_PC_W455),


.spc456_inst_done    (`PITON_CORE456_INST_DONE),
.pc_w456             (`PITON_CORE456_PC_W456),


.spc457_inst_done    (`PITON_CORE457_INST_DONE),
.pc_w457             (`PITON_CORE457_PC_W457),


.spc458_inst_done    (`PITON_CORE458_INST_DONE),
.pc_w458             (`PITON_CORE458_PC_W458),


.spc459_inst_done    (`PITON_CORE459_INST_DONE),
.pc_w459             (`PITON_CORE459_PC_W459),


.spc460_inst_done    (`PITON_CORE460_INST_DONE),
.pc_w460             (`PITON_CORE460_PC_W460),


.spc461_inst_done    (`PITON_CORE461_INST_DONE),
.pc_w461             (`PITON_CORE461_PC_W461),


.spc462_inst_done    (`PITON_CORE462_INST_DONE),
.pc_w462             (`PITON_CORE462_PC_W462),


.spc463_inst_done    (`PITON_CORE463_INST_DONE),
.pc_w463             (`PITON_CORE463_PC_W463),


.spc464_inst_done    (`PITON_CORE464_INST_DONE),
.pc_w464             (`PITON_CORE464_PC_W464),


.spc465_inst_done    (`PITON_CORE465_INST_DONE),
.pc_w465             (`PITON_CORE465_PC_W465),


.spc466_inst_done    (`PITON_CORE466_INST_DONE),
.pc_w466             (`PITON_CORE466_PC_W466),


.spc467_inst_done    (`PITON_CORE467_INST_DONE),
.pc_w467             (`PITON_CORE467_PC_W467),


.spc468_inst_done    (`PITON_CORE468_INST_DONE),
.pc_w468             (`PITON_CORE468_PC_W468),


.spc469_inst_done    (`PITON_CORE469_INST_DONE),
.pc_w469             (`PITON_CORE469_PC_W469),


.spc470_inst_done    (`PITON_CORE470_INST_DONE),
.pc_w470             (`PITON_CORE470_PC_W470),


.spc471_inst_done    (`PITON_CORE471_INST_DONE),
.pc_w471             (`PITON_CORE471_PC_W471),


.spc472_inst_done    (`PITON_CORE472_INST_DONE),
.pc_w472             (`PITON_CORE472_PC_W472),


.spc473_inst_done    (`PITON_CORE473_INST_DONE),
.pc_w473             (`PITON_CORE473_PC_W473),


.spc474_inst_done    (`PITON_CORE474_INST_DONE),
.pc_w474             (`PITON_CORE474_PC_W474),


.spc475_inst_done    (`PITON_CORE475_INST_DONE),
.pc_w475             (`PITON_CORE475_PC_W475),


.spc476_inst_done    (`PITON_CORE476_INST_DONE),
.pc_w476             (`PITON_CORE476_PC_W476),


.spc477_inst_done    (`PITON_CORE477_INST_DONE),
.pc_w477             (`PITON_CORE477_PC_W477),


.spc478_inst_done    (`PITON_CORE478_INST_DONE),
.pc_w478             (`PITON_CORE478_PC_W478),


.spc479_inst_done    (`PITON_CORE479_INST_DONE),
.pc_w479             (`PITON_CORE479_PC_W479),


.spc480_inst_done    (`PITON_CORE480_INST_DONE),
.pc_w480             (`PITON_CORE480_PC_W480),


.spc481_inst_done    (`PITON_CORE481_INST_DONE),
.pc_w481             (`PITON_CORE481_PC_W481),


.spc482_inst_done    (`PITON_CORE482_INST_DONE),
.pc_w482             (`PITON_CORE482_PC_W482),


.spc483_inst_done    (`PITON_CORE483_INST_DONE),
.pc_w483             (`PITON_CORE483_PC_W483),


.spc484_inst_done    (`PITON_CORE484_INST_DONE),
.pc_w484             (`PITON_CORE484_PC_W484),


.spc485_inst_done    (`PITON_CORE485_INST_DONE),
.pc_w485             (`PITON_CORE485_PC_W485),


.spc486_inst_done    (`PITON_CORE486_INST_DONE),
.pc_w486             (`PITON_CORE486_PC_W486),


.spc487_inst_done    (`PITON_CORE487_INST_DONE),
.pc_w487             (`PITON_CORE487_PC_W487),


.spc488_inst_done    (`PITON_CORE488_INST_DONE),
.pc_w488             (`PITON_CORE488_PC_W488),


.spc489_inst_done    (`PITON_CORE489_INST_DONE),
.pc_w489             (`PITON_CORE489_PC_W489),


.spc490_inst_done    (`PITON_CORE490_INST_DONE),
.pc_w490             (`PITON_CORE490_PC_W490),


.spc491_inst_done    (`PITON_CORE491_INST_DONE),
.pc_w491             (`PITON_CORE491_PC_W491),


.spc492_inst_done    (`PITON_CORE492_INST_DONE),
.pc_w492             (`PITON_CORE492_PC_W492),


.spc493_inst_done    (`PITON_CORE493_INST_DONE),
.pc_w493             (`PITON_CORE493_PC_W493),


.spc494_inst_done    (`PITON_CORE494_INST_DONE),
.pc_w494             (`PITON_CORE494_PC_W494),


.spc495_inst_done    (`PITON_CORE495_INST_DONE),
.pc_w495             (`PITON_CORE495_PC_W495),


.spc496_inst_done    (`PITON_CORE496_INST_DONE),
.pc_w496             (`PITON_CORE496_PC_W496),


.spc497_inst_done    (`PITON_CORE497_INST_DONE),
.pc_w497             (`PITON_CORE497_PC_W497),


.spc498_inst_done    (`PITON_CORE498_INST_DONE),
.pc_w498             (`PITON_CORE498_PC_W498),


.spc499_inst_done    (`PITON_CORE499_INST_DONE),
.pc_w499             (`PITON_CORE499_PC_W499),


.spc500_inst_done    (`PITON_CORE500_INST_DONE),
.pc_w500             (`PITON_CORE500_PC_W500),


.spc501_inst_done    (`PITON_CORE501_INST_DONE),
.pc_w501             (`PITON_CORE501_PC_W501),


.spc502_inst_done    (`PITON_CORE502_INST_DONE),
.pc_w502             (`PITON_CORE502_PC_W502),


.spc503_inst_done    (`PITON_CORE503_INST_DONE),
.pc_w503             (`PITON_CORE503_PC_W503),


.spc504_inst_done    (`PITON_CORE504_INST_DONE),
.pc_w504             (`PITON_CORE504_PC_W504),


.spc505_inst_done    (`PITON_CORE505_INST_DONE),
.pc_w505             (`PITON_CORE505_PC_W505),


.spc506_inst_done    (`PITON_CORE506_INST_DONE),
.pc_w506             (`PITON_CORE506_PC_W506),


.spc507_inst_done    (`PITON_CORE507_INST_DONE),
.pc_w507             (`PITON_CORE507_PC_W507),


.spc508_inst_done    (`PITON_CORE508_INST_DONE),
.pc_w508             (`PITON_CORE508_PC_W508),


.spc509_inst_done    (`PITON_CORE509_INST_DONE),
.pc_w509             (`PITON_CORE509_PC_W509),


.spc510_inst_done    (`PITON_CORE510_INST_DONE),
.pc_w510             (`PITON_CORE510_PC_W510),


.spc511_inst_done    (`PITON_CORE511_INST_DONE),
.pc_w511             (`PITON_CORE511_PC_W511),


.spc512_inst_done    (`PITON_CORE512_INST_DONE),
.pc_w512             (`PITON_CORE512_PC_W512),


.spc513_inst_done    (`PITON_CORE513_INST_DONE),
.pc_w513             (`PITON_CORE513_PC_W513),


.spc514_inst_done    (`PITON_CORE514_INST_DONE),
.pc_w514             (`PITON_CORE514_PC_W514),


.spc515_inst_done    (`PITON_CORE515_INST_DONE),
.pc_w515             (`PITON_CORE515_PC_W515),


.spc516_inst_done    (`PITON_CORE516_INST_DONE),
.pc_w516             (`PITON_CORE516_PC_W516),


.spc517_inst_done    (`PITON_CORE517_INST_DONE),
.pc_w517             (`PITON_CORE517_PC_W517),


.spc518_inst_done    (`PITON_CORE518_INST_DONE),
.pc_w518             (`PITON_CORE518_PC_W518),


.spc519_inst_done    (`PITON_CORE519_INST_DONE),
.pc_w519             (`PITON_CORE519_PC_W519),


.spc520_inst_done    (`PITON_CORE520_INST_DONE),
.pc_w520             (`PITON_CORE520_PC_W520),


.spc521_inst_done    (`PITON_CORE521_INST_DONE),
.pc_w521             (`PITON_CORE521_PC_W521),


.spc522_inst_done    (`PITON_CORE522_INST_DONE),
.pc_w522             (`PITON_CORE522_PC_W522),


.spc523_inst_done    (`PITON_CORE523_INST_DONE),
.pc_w523             (`PITON_CORE523_PC_W523),


.spc524_inst_done    (`PITON_CORE524_INST_DONE),
.pc_w524             (`PITON_CORE524_PC_W524),


.spc525_inst_done    (`PITON_CORE525_INST_DONE),
.pc_w525             (`PITON_CORE525_PC_W525),


.spc526_inst_done    (`PITON_CORE526_INST_DONE),
.pc_w526             (`PITON_CORE526_PC_W526),


.spc527_inst_done    (`PITON_CORE527_INST_DONE),
.pc_w527             (`PITON_CORE527_PC_W527),


.spc528_inst_done    (`PITON_CORE528_INST_DONE),
.pc_w528             (`PITON_CORE528_PC_W528),


.spc529_inst_done    (`PITON_CORE529_INST_DONE),
.pc_w529             (`PITON_CORE529_PC_W529),


.spc530_inst_done    (`PITON_CORE530_INST_DONE),
.pc_w530             (`PITON_CORE530_PC_W530),


.spc531_inst_done    (`PITON_CORE531_INST_DONE),
.pc_w531             (`PITON_CORE531_PC_W531),


.spc532_inst_done    (`PITON_CORE532_INST_DONE),
.pc_w532             (`PITON_CORE532_PC_W532),


.spc533_inst_done    (`PITON_CORE533_INST_DONE),
.pc_w533             (`PITON_CORE533_PC_W533),


.spc534_inst_done    (`PITON_CORE534_INST_DONE),
.pc_w534             (`PITON_CORE534_PC_W534),


.spc535_inst_done    (`PITON_CORE535_INST_DONE),
.pc_w535             (`PITON_CORE535_PC_W535),


.spc536_inst_done    (`PITON_CORE536_INST_DONE),
.pc_w536             (`PITON_CORE536_PC_W536),


.spc537_inst_done    (`PITON_CORE537_INST_DONE),
.pc_w537             (`PITON_CORE537_PC_W537),


.spc538_inst_done    (`PITON_CORE538_INST_DONE),
.pc_w538             (`PITON_CORE538_PC_W538),


.spc539_inst_done    (`PITON_CORE539_INST_DONE),
.pc_w539             (`PITON_CORE539_PC_W539),


.spc540_inst_done    (`PITON_CORE540_INST_DONE),
.pc_w540             (`PITON_CORE540_PC_W540),


.spc541_inst_done    (`PITON_CORE541_INST_DONE),
.pc_w541             (`PITON_CORE541_PC_W541),


.spc542_inst_done    (`PITON_CORE542_INST_DONE),
.pc_w542             (`PITON_CORE542_PC_W542),


.spc543_inst_done    (`PITON_CORE543_INST_DONE),
.pc_w543             (`PITON_CORE543_PC_W543),


.spc544_inst_done    (`PITON_CORE544_INST_DONE),
.pc_w544             (`PITON_CORE544_PC_W544),


.spc545_inst_done    (`PITON_CORE545_INST_DONE),
.pc_w545             (`PITON_CORE545_PC_W545),


.spc546_inst_done    (`PITON_CORE546_INST_DONE),
.pc_w546             (`PITON_CORE546_PC_W546),


.spc547_inst_done    (`PITON_CORE547_INST_DONE),
.pc_w547             (`PITON_CORE547_PC_W547),


.spc548_inst_done    (`PITON_CORE548_INST_DONE),
.pc_w548             (`PITON_CORE548_PC_W548),


.spc549_inst_done    (`PITON_CORE549_INST_DONE),
.pc_w549             (`PITON_CORE549_PC_W549),


.spc550_inst_done    (`PITON_CORE550_INST_DONE),
.pc_w550             (`PITON_CORE550_PC_W550),


.spc551_inst_done    (`PITON_CORE551_INST_DONE),
.pc_w551             (`PITON_CORE551_PC_W551),


.spc552_inst_done    (`PITON_CORE552_INST_DONE),
.pc_w552             (`PITON_CORE552_PC_W552),


.spc553_inst_done    (`PITON_CORE553_INST_DONE),
.pc_w553             (`PITON_CORE553_PC_W553),


.spc554_inst_done    (`PITON_CORE554_INST_DONE),
.pc_w554             (`PITON_CORE554_PC_W554),


.spc555_inst_done    (`PITON_CORE555_INST_DONE),
.pc_w555             (`PITON_CORE555_PC_W555),


.spc556_inst_done    (`PITON_CORE556_INST_DONE),
.pc_w556             (`PITON_CORE556_PC_W556),


.spc557_inst_done    (`PITON_CORE557_INST_DONE),
.pc_w557             (`PITON_CORE557_PC_W557),


.spc558_inst_done    (`PITON_CORE558_INST_DONE),
.pc_w558             (`PITON_CORE558_PC_W558),


.spc559_inst_done    (`PITON_CORE559_INST_DONE),
.pc_w559             (`PITON_CORE559_PC_W559),


.spc560_inst_done    (`PITON_CORE560_INST_DONE),
.pc_w560             (`PITON_CORE560_PC_W560),


.spc561_inst_done    (`PITON_CORE561_INST_DONE),
.pc_w561             (`PITON_CORE561_PC_W561),


.spc562_inst_done    (`PITON_CORE562_INST_DONE),
.pc_w562             (`PITON_CORE562_PC_W562),


.spc563_inst_done    (`PITON_CORE563_INST_DONE),
.pc_w563             (`PITON_CORE563_PC_W563),


.spc564_inst_done    (`PITON_CORE564_INST_DONE),
.pc_w564             (`PITON_CORE564_PC_W564),


.spc565_inst_done    (`PITON_CORE565_INST_DONE),
.pc_w565             (`PITON_CORE565_PC_W565),


.spc566_inst_done    (`PITON_CORE566_INST_DONE),
.pc_w566             (`PITON_CORE566_PC_W566),


.spc567_inst_done    (`PITON_CORE567_INST_DONE),
.pc_w567             (`PITON_CORE567_PC_W567),


.spc568_inst_done    (`PITON_CORE568_INST_DONE),
.pc_w568             (`PITON_CORE568_PC_W568),


.spc569_inst_done    (`PITON_CORE569_INST_DONE),
.pc_w569             (`PITON_CORE569_PC_W569),


.spc570_inst_done    (`PITON_CORE570_INST_DONE),
.pc_w570             (`PITON_CORE570_PC_W570),


.spc571_inst_done    (`PITON_CORE571_INST_DONE),
.pc_w571             (`PITON_CORE571_PC_W571),


.spc572_inst_done    (`PITON_CORE572_INST_DONE),
.pc_w572             (`PITON_CORE572_PC_W572),


.spc573_inst_done    (`PITON_CORE573_INST_DONE),
.pc_w573             (`PITON_CORE573_PC_W573),


.spc574_inst_done    (`PITON_CORE574_INST_DONE),
.pc_w574             (`PITON_CORE574_PC_W574),


.spc575_inst_done    (`PITON_CORE575_INST_DONE),
.pc_w575             (`PITON_CORE575_PC_W575),


.spc576_inst_done    (`PITON_CORE576_INST_DONE),
.pc_w576             (`PITON_CORE576_PC_W576),


.spc577_inst_done    (`PITON_CORE577_INST_DONE),
.pc_w577             (`PITON_CORE577_PC_W577),


.spc578_inst_done    (`PITON_CORE578_INST_DONE),
.pc_w578             (`PITON_CORE578_PC_W578),


.spc579_inst_done    (`PITON_CORE579_INST_DONE),
.pc_w579             (`PITON_CORE579_PC_W579),


.spc580_inst_done    (`PITON_CORE580_INST_DONE),
.pc_w580             (`PITON_CORE580_PC_W580),


.spc581_inst_done    (`PITON_CORE581_INST_DONE),
.pc_w581             (`PITON_CORE581_PC_W581),


.spc582_inst_done    (`PITON_CORE582_INST_DONE),
.pc_w582             (`PITON_CORE582_PC_W582),


.spc583_inst_done    (`PITON_CORE583_INST_DONE),
.pc_w583             (`PITON_CORE583_PC_W583),


.spc584_inst_done    (`PITON_CORE584_INST_DONE),
.pc_w584             (`PITON_CORE584_PC_W584),


.spc585_inst_done    (`PITON_CORE585_INST_DONE),
.pc_w585             (`PITON_CORE585_PC_W585),


.spc586_inst_done    (`PITON_CORE586_INST_DONE),
.pc_w586             (`PITON_CORE586_PC_W586),


.spc587_inst_done    (`PITON_CORE587_INST_DONE),
.pc_w587             (`PITON_CORE587_PC_W587),


.spc588_inst_done    (`PITON_CORE588_INST_DONE),
.pc_w588             (`PITON_CORE588_PC_W588),


.spc589_inst_done    (`PITON_CORE589_INST_DONE),
.pc_w589             (`PITON_CORE589_PC_W589),


.spc590_inst_done    (`PITON_CORE590_INST_DONE),
.pc_w590             (`PITON_CORE590_PC_W590),


.spc591_inst_done    (`PITON_CORE591_INST_DONE),
.pc_w591             (`PITON_CORE591_PC_W591),


.spc592_inst_done    (`PITON_CORE592_INST_DONE),
.pc_w592             (`PITON_CORE592_PC_W592),


.spc593_inst_done    (`PITON_CORE593_INST_DONE),
.pc_w593             (`PITON_CORE593_PC_W593),


.spc594_inst_done    (`PITON_CORE594_INST_DONE),
.pc_w594             (`PITON_CORE594_PC_W594),


.spc595_inst_done    (`PITON_CORE595_INST_DONE),
.pc_w595             (`PITON_CORE595_PC_W595),


.spc596_inst_done    (`PITON_CORE596_INST_DONE),
.pc_w596             (`PITON_CORE596_PC_W596),


.spc597_inst_done    (`PITON_CORE597_INST_DONE),
.pc_w597             (`PITON_CORE597_PC_W597),


.spc598_inst_done    (`PITON_CORE598_INST_DONE),
.pc_w598             (`PITON_CORE598_PC_W598),


.spc599_inst_done    (`PITON_CORE599_INST_DONE),
.pc_w599             (`PITON_CORE599_PC_W599),


.spc600_inst_done    (`PITON_CORE600_INST_DONE),
.pc_w600             (`PITON_CORE600_PC_W600),


.spc601_inst_done    (`PITON_CORE601_INST_DONE),
.pc_w601             (`PITON_CORE601_PC_W601),


.spc602_inst_done    (`PITON_CORE602_INST_DONE),
.pc_w602             (`PITON_CORE602_PC_W602),


.spc603_inst_done    (`PITON_CORE603_INST_DONE),
.pc_w603             (`PITON_CORE603_PC_W603),


.spc604_inst_done    (`PITON_CORE604_INST_DONE),
.pc_w604             (`PITON_CORE604_PC_W604),


.spc605_inst_done    (`PITON_CORE605_INST_DONE),
.pc_w605             (`PITON_CORE605_PC_W605),


.spc606_inst_done    (`PITON_CORE606_INST_DONE),
.pc_w606             (`PITON_CORE606_PC_W606),


.spc607_inst_done    (`PITON_CORE607_INST_DONE),
.pc_w607             (`PITON_CORE607_PC_W607),


.spc608_inst_done    (`PITON_CORE608_INST_DONE),
.pc_w608             (`PITON_CORE608_PC_W608),


.spc609_inst_done    (`PITON_CORE609_INST_DONE),
.pc_w609             (`PITON_CORE609_PC_W609),


.spc610_inst_done    (`PITON_CORE610_INST_DONE),
.pc_w610             (`PITON_CORE610_PC_W610),


.spc611_inst_done    (`PITON_CORE611_INST_DONE),
.pc_w611             (`PITON_CORE611_PC_W611),


.spc612_inst_done    (`PITON_CORE612_INST_DONE),
.pc_w612             (`PITON_CORE612_PC_W612),


.spc613_inst_done    (`PITON_CORE613_INST_DONE),
.pc_w613             (`PITON_CORE613_PC_W613),


.spc614_inst_done    (`PITON_CORE614_INST_DONE),
.pc_w614             (`PITON_CORE614_PC_W614),


.spc615_inst_done    (`PITON_CORE615_INST_DONE),
.pc_w615             (`PITON_CORE615_PC_W615),


.spc616_inst_done    (`PITON_CORE616_INST_DONE),
.pc_w616             (`PITON_CORE616_PC_W616),


.spc617_inst_done    (`PITON_CORE617_INST_DONE),
.pc_w617             (`PITON_CORE617_PC_W617),


.spc618_inst_done    (`PITON_CORE618_INST_DONE),
.pc_w618             (`PITON_CORE618_PC_W618),


.spc619_inst_done    (`PITON_CORE619_INST_DONE),
.pc_w619             (`PITON_CORE619_PC_W619),


.spc620_inst_done    (`PITON_CORE620_INST_DONE),
.pc_w620             (`PITON_CORE620_PC_W620),


.spc621_inst_done    (`PITON_CORE621_INST_DONE),
.pc_w621             (`PITON_CORE621_PC_W621),


.spc622_inst_done    (`PITON_CORE622_INST_DONE),
.pc_w622             (`PITON_CORE622_PC_W622),


.spc623_inst_done    (`PITON_CORE623_INST_DONE),
.pc_w623             (`PITON_CORE623_PC_W623),


.spc624_inst_done    (`PITON_CORE624_INST_DONE),
.pc_w624             (`PITON_CORE624_PC_W624),


.spc625_inst_done    (`PITON_CORE625_INST_DONE),
.pc_w625             (`PITON_CORE625_PC_W625),


.spc626_inst_done    (`PITON_CORE626_INST_DONE),
.pc_w626             (`PITON_CORE626_PC_W626),


.spc627_inst_done    (`PITON_CORE627_INST_DONE),
.pc_w627             (`PITON_CORE627_PC_W627),


.spc628_inst_done    (`PITON_CORE628_INST_DONE),
.pc_w628             (`PITON_CORE628_PC_W628),


.spc629_inst_done    (`PITON_CORE629_INST_DONE),
.pc_w629             (`PITON_CORE629_PC_W629),


.spc630_inst_done    (`PITON_CORE630_INST_DONE),
.pc_w630             (`PITON_CORE630_PC_W630),


.spc631_inst_done    (`PITON_CORE631_INST_DONE),
.pc_w631             (`PITON_CORE631_PC_W631),


.spc632_inst_done    (`PITON_CORE632_INST_DONE),
.pc_w632             (`PITON_CORE632_PC_W632),


.spc633_inst_done    (`PITON_CORE633_INST_DONE),
.pc_w633             (`PITON_CORE633_PC_W633),


.spc634_inst_done    (`PITON_CORE634_INST_DONE),
.pc_w634             (`PITON_CORE634_PC_W634),


.spc635_inst_done    (`PITON_CORE635_INST_DONE),
.pc_w635             (`PITON_CORE635_PC_W635),


.spc636_inst_done    (`PITON_CORE636_INST_DONE),
.pc_w636             (`PITON_CORE636_PC_W636),


.spc637_inst_done    (`PITON_CORE637_INST_DONE),
.pc_w637             (`PITON_CORE637_PC_W637),


.spc638_inst_done    (`PITON_CORE638_INST_DONE),
.pc_w638             (`PITON_CORE638_PC_W638),


.spc639_inst_done    (`PITON_CORE639_INST_DONE),
.pc_w639             (`PITON_CORE639_PC_W639),


.spc640_inst_done    (`PITON_CORE640_INST_DONE),
.pc_w640             (`PITON_CORE640_PC_W640),


.spc641_inst_done    (`PITON_CORE641_INST_DONE),
.pc_w641             (`PITON_CORE641_PC_W641),


.spc642_inst_done    (`PITON_CORE642_INST_DONE),
.pc_w642             (`PITON_CORE642_PC_W642),


.spc643_inst_done    (`PITON_CORE643_INST_DONE),
.pc_w643             (`PITON_CORE643_PC_W643),


.spc644_inst_done    (`PITON_CORE644_INST_DONE),
.pc_w644             (`PITON_CORE644_PC_W644),


.spc645_inst_done    (`PITON_CORE645_INST_DONE),
.pc_w645             (`PITON_CORE645_PC_W645),


.spc646_inst_done    (`PITON_CORE646_INST_DONE),
.pc_w646             (`PITON_CORE646_PC_W646),


.spc647_inst_done    (`PITON_CORE647_INST_DONE),
.pc_w647             (`PITON_CORE647_PC_W647),


.spc648_inst_done    (`PITON_CORE648_INST_DONE),
.pc_w648             (`PITON_CORE648_PC_W648),


.spc649_inst_done    (`PITON_CORE649_INST_DONE),
.pc_w649             (`PITON_CORE649_PC_W649),


.spc650_inst_done    (`PITON_CORE650_INST_DONE),
.pc_w650             (`PITON_CORE650_PC_W650),


.spc651_inst_done    (`PITON_CORE651_INST_DONE),
.pc_w651             (`PITON_CORE651_PC_W651),


.spc652_inst_done    (`PITON_CORE652_INST_DONE),
.pc_w652             (`PITON_CORE652_PC_W652),


.spc653_inst_done    (`PITON_CORE653_INST_DONE),
.pc_w653             (`PITON_CORE653_PC_W653),


.spc654_inst_done    (`PITON_CORE654_INST_DONE),
.pc_w654             (`PITON_CORE654_PC_W654),


.spc655_inst_done    (`PITON_CORE655_INST_DONE),
.pc_w655             (`PITON_CORE655_PC_W655),


.spc656_inst_done    (`PITON_CORE656_INST_DONE),
.pc_w656             (`PITON_CORE656_PC_W656),


.spc657_inst_done    (`PITON_CORE657_INST_DONE),
.pc_w657             (`PITON_CORE657_PC_W657),


.spc658_inst_done    (`PITON_CORE658_INST_DONE),
.pc_w658             (`PITON_CORE658_PC_W658),


.spc659_inst_done    (`PITON_CORE659_INST_DONE),
.pc_w659             (`PITON_CORE659_PC_W659),


.spc660_inst_done    (`PITON_CORE660_INST_DONE),
.pc_w660             (`PITON_CORE660_PC_W660),


.spc661_inst_done    (`PITON_CORE661_INST_DONE),
.pc_w661             (`PITON_CORE661_PC_W661),


.spc662_inst_done    (`PITON_CORE662_INST_DONE),
.pc_w662             (`PITON_CORE662_PC_W662),


.spc663_inst_done    (`PITON_CORE663_INST_DONE),
.pc_w663             (`PITON_CORE663_PC_W663),


.spc664_inst_done    (`PITON_CORE664_INST_DONE),
.pc_w664             (`PITON_CORE664_PC_W664),


.spc665_inst_done    (`PITON_CORE665_INST_DONE),
.pc_w665             (`PITON_CORE665_PC_W665),


.spc666_inst_done    (`PITON_CORE666_INST_DONE),
.pc_w666             (`PITON_CORE666_PC_W666),


.spc667_inst_done    (`PITON_CORE667_INST_DONE),
.pc_w667             (`PITON_CORE667_PC_W667),


.spc668_inst_done    (`PITON_CORE668_INST_DONE),
.pc_w668             (`PITON_CORE668_PC_W668),


.spc669_inst_done    (`PITON_CORE669_INST_DONE),
.pc_w669             (`PITON_CORE669_PC_W669),


.spc670_inst_done    (`PITON_CORE670_INST_DONE),
.pc_w670             (`PITON_CORE670_PC_W670),


.spc671_inst_done    (`PITON_CORE671_INST_DONE),
.pc_w671             (`PITON_CORE671_PC_W671),


.spc672_inst_done    (`PITON_CORE672_INST_DONE),
.pc_w672             (`PITON_CORE672_PC_W672),


.spc673_inst_done    (`PITON_CORE673_INST_DONE),
.pc_w673             (`PITON_CORE673_PC_W673),


.spc674_inst_done    (`PITON_CORE674_INST_DONE),
.pc_w674             (`PITON_CORE674_PC_W674),


.spc675_inst_done    (`PITON_CORE675_INST_DONE),
.pc_w675             (`PITON_CORE675_PC_W675),


.spc676_inst_done    (`PITON_CORE676_INST_DONE),
.pc_w676             (`PITON_CORE676_PC_W676),


.spc677_inst_done    (`PITON_CORE677_INST_DONE),
.pc_w677             (`PITON_CORE677_PC_W677),


.spc678_inst_done    (`PITON_CORE678_INST_DONE),
.pc_w678             (`PITON_CORE678_PC_W678),


.spc679_inst_done    (`PITON_CORE679_INST_DONE),
.pc_w679             (`PITON_CORE679_PC_W679),


.spc680_inst_done    (`PITON_CORE680_INST_DONE),
.pc_w680             (`PITON_CORE680_PC_W680),


.spc681_inst_done    (`PITON_CORE681_INST_DONE),
.pc_w681             (`PITON_CORE681_PC_W681),


.spc682_inst_done    (`PITON_CORE682_INST_DONE),
.pc_w682             (`PITON_CORE682_PC_W682),


.spc683_inst_done    (`PITON_CORE683_INST_DONE),
.pc_w683             (`PITON_CORE683_PC_W683),


.spc684_inst_done    (`PITON_CORE684_INST_DONE),
.pc_w684             (`PITON_CORE684_PC_W684),


.spc685_inst_done    (`PITON_CORE685_INST_DONE),
.pc_w685             (`PITON_CORE685_PC_W685),


.spc686_inst_done    (`PITON_CORE686_INST_DONE),
.pc_w686             (`PITON_CORE686_PC_W686),


.spc687_inst_done    (`PITON_CORE687_INST_DONE),
.pc_w687             (`PITON_CORE687_PC_W687),


.spc688_inst_done    (`PITON_CORE688_INST_DONE),
.pc_w688             (`PITON_CORE688_PC_W688),


.spc689_inst_done    (`PITON_CORE689_INST_DONE),
.pc_w689             (`PITON_CORE689_PC_W689),


.spc690_inst_done    (`PITON_CORE690_INST_DONE),
.pc_w690             (`PITON_CORE690_PC_W690),


.spc691_inst_done    (`PITON_CORE691_INST_DONE),
.pc_w691             (`PITON_CORE691_PC_W691),


.spc692_inst_done    (`PITON_CORE692_INST_DONE),
.pc_w692             (`PITON_CORE692_PC_W692),


.spc693_inst_done    (`PITON_CORE693_INST_DONE),
.pc_w693             (`PITON_CORE693_PC_W693),


.spc694_inst_done    (`PITON_CORE694_INST_DONE),
.pc_w694             (`PITON_CORE694_PC_W694),


.spc695_inst_done    (`PITON_CORE695_INST_DONE),
.pc_w695             (`PITON_CORE695_PC_W695),


.spc696_inst_done    (`PITON_CORE696_INST_DONE),
.pc_w696             (`PITON_CORE696_PC_W696),


.spc697_inst_done    (`PITON_CORE697_INST_DONE),
.pc_w697             (`PITON_CORE697_PC_W697),


.spc698_inst_done    (`PITON_CORE698_INST_DONE),
.pc_w698             (`PITON_CORE698_PC_W698),


.spc699_inst_done    (`PITON_CORE699_INST_DONE),
.pc_w699             (`PITON_CORE699_PC_W699),


.spc700_inst_done    (`PITON_CORE700_INST_DONE),
.pc_w700             (`PITON_CORE700_PC_W700),


.spc701_inst_done    (`PITON_CORE701_INST_DONE),
.pc_w701             (`PITON_CORE701_PC_W701),


.spc702_inst_done    (`PITON_CORE702_INST_DONE),
.pc_w702             (`PITON_CORE702_PC_W702),


.spc703_inst_done    (`PITON_CORE703_INST_DONE),
.pc_w703             (`PITON_CORE703_PC_W703),


.spc704_inst_done    (`PITON_CORE704_INST_DONE),
.pc_w704             (`PITON_CORE704_PC_W704),


.spc705_inst_done    (`PITON_CORE705_INST_DONE),
.pc_w705             (`PITON_CORE705_PC_W705),


.spc706_inst_done    (`PITON_CORE706_INST_DONE),
.pc_w706             (`PITON_CORE706_PC_W706),


.spc707_inst_done    (`PITON_CORE707_INST_DONE),
.pc_w707             (`PITON_CORE707_PC_W707),


.spc708_inst_done    (`PITON_CORE708_INST_DONE),
.pc_w708             (`PITON_CORE708_PC_W708),


.spc709_inst_done    (`PITON_CORE709_INST_DONE),
.pc_w709             (`PITON_CORE709_PC_W709),


.spc710_inst_done    (`PITON_CORE710_INST_DONE),
.pc_w710             (`PITON_CORE710_PC_W710),


.spc711_inst_done    (`PITON_CORE711_INST_DONE),
.pc_w711             (`PITON_CORE711_PC_W711),


.spc712_inst_done    (`PITON_CORE712_INST_DONE),
.pc_w712             (`PITON_CORE712_PC_W712),


.spc713_inst_done    (`PITON_CORE713_INST_DONE),
.pc_w713             (`PITON_CORE713_PC_W713),


.spc714_inst_done    (`PITON_CORE714_INST_DONE),
.pc_w714             (`PITON_CORE714_PC_W714),


.spc715_inst_done    (`PITON_CORE715_INST_DONE),
.pc_w715             (`PITON_CORE715_PC_W715),


.spc716_inst_done    (`PITON_CORE716_INST_DONE),
.pc_w716             (`PITON_CORE716_PC_W716),


.spc717_inst_done    (`PITON_CORE717_INST_DONE),
.pc_w717             (`PITON_CORE717_PC_W717),


.spc718_inst_done    (`PITON_CORE718_INST_DONE),
.pc_w718             (`PITON_CORE718_PC_W718),


.spc719_inst_done    (`PITON_CORE719_INST_DONE),
.pc_w719             (`PITON_CORE719_PC_W719),


.spc720_inst_done    (`PITON_CORE720_INST_DONE),
.pc_w720             (`PITON_CORE720_PC_W720),


.spc721_inst_done    (`PITON_CORE721_INST_DONE),
.pc_w721             (`PITON_CORE721_PC_W721),


.spc722_inst_done    (`PITON_CORE722_INST_DONE),
.pc_w722             (`PITON_CORE722_PC_W722),


.spc723_inst_done    (`PITON_CORE723_INST_DONE),
.pc_w723             (`PITON_CORE723_PC_W723),


.spc724_inst_done    (`PITON_CORE724_INST_DONE),
.pc_w724             (`PITON_CORE724_PC_W724),


.spc725_inst_done    (`PITON_CORE725_INST_DONE),
.pc_w725             (`PITON_CORE725_PC_W725),


.spc726_inst_done    (`PITON_CORE726_INST_DONE),
.pc_w726             (`PITON_CORE726_PC_W726),


.spc727_inst_done    (`PITON_CORE727_INST_DONE),
.pc_w727             (`PITON_CORE727_PC_W727),


.spc728_inst_done    (`PITON_CORE728_INST_DONE),
.pc_w728             (`PITON_CORE728_PC_W728),


.spc729_inst_done    (`PITON_CORE729_INST_DONE),
.pc_w729             (`PITON_CORE729_PC_W729),


.spc730_inst_done    (`PITON_CORE730_INST_DONE),
.pc_w730             (`PITON_CORE730_PC_W730),


.spc731_inst_done    (`PITON_CORE731_INST_DONE),
.pc_w731             (`PITON_CORE731_PC_W731),


.spc732_inst_done    (`PITON_CORE732_INST_DONE),
.pc_w732             (`PITON_CORE732_PC_W732),


.spc733_inst_done    (`PITON_CORE733_INST_DONE),
.pc_w733             (`PITON_CORE733_PC_W733),


.spc734_inst_done    (`PITON_CORE734_INST_DONE),
.pc_w734             (`PITON_CORE734_PC_W734),


.spc735_inst_done    (`PITON_CORE735_INST_DONE),
.pc_w735             (`PITON_CORE735_PC_W735),


.spc736_inst_done    (`PITON_CORE736_INST_DONE),
.pc_w736             (`PITON_CORE736_PC_W736),


.spc737_inst_done    (`PITON_CORE737_INST_DONE),
.pc_w737             (`PITON_CORE737_PC_W737),


.spc738_inst_done    (`PITON_CORE738_INST_DONE),
.pc_w738             (`PITON_CORE738_PC_W738),


.spc739_inst_done    (`PITON_CORE739_INST_DONE),
.pc_w739             (`PITON_CORE739_PC_W739),


.spc740_inst_done    (`PITON_CORE740_INST_DONE),
.pc_w740             (`PITON_CORE740_PC_W740),


.spc741_inst_done    (`PITON_CORE741_INST_DONE),
.pc_w741             (`PITON_CORE741_PC_W741),


.spc742_inst_done    (`PITON_CORE742_INST_DONE),
.pc_w742             (`PITON_CORE742_PC_W742),


.spc743_inst_done    (`PITON_CORE743_INST_DONE),
.pc_w743             (`PITON_CORE743_PC_W743),


.spc744_inst_done    (`PITON_CORE744_INST_DONE),
.pc_w744             (`PITON_CORE744_PC_W744),


.spc745_inst_done    (`PITON_CORE745_INST_DONE),
.pc_w745             (`PITON_CORE745_PC_W745),


.spc746_inst_done    (`PITON_CORE746_INST_DONE),
.pc_w746             (`PITON_CORE746_PC_W746),


.spc747_inst_done    (`PITON_CORE747_INST_DONE),
.pc_w747             (`PITON_CORE747_PC_W747),


.spc748_inst_done    (`PITON_CORE748_INST_DONE),
.pc_w748             (`PITON_CORE748_PC_W748),


.spc749_inst_done    (`PITON_CORE749_INST_DONE),
.pc_w749             (`PITON_CORE749_PC_W749),


.spc750_inst_done    (`PITON_CORE750_INST_DONE),
.pc_w750             (`PITON_CORE750_PC_W750),


.spc751_inst_done    (`PITON_CORE751_INST_DONE),
.pc_w751             (`PITON_CORE751_PC_W751),


.spc752_inst_done    (`PITON_CORE752_INST_DONE),
.pc_w752             (`PITON_CORE752_PC_W752),


.spc753_inst_done    (`PITON_CORE753_INST_DONE),
.pc_w753             (`PITON_CORE753_PC_W753),


.spc754_inst_done    (`PITON_CORE754_INST_DONE),
.pc_w754             (`PITON_CORE754_PC_W754),


.spc755_inst_done    (`PITON_CORE755_INST_DONE),
.pc_w755             (`PITON_CORE755_PC_W755),


.spc756_inst_done    (`PITON_CORE756_INST_DONE),
.pc_w756             (`PITON_CORE756_PC_W756),


.spc757_inst_done    (`PITON_CORE757_INST_DONE),
.pc_w757             (`PITON_CORE757_PC_W757),


.spc758_inst_done    (`PITON_CORE758_INST_DONE),
.pc_w758             (`PITON_CORE758_PC_W758),


.spc759_inst_done    (`PITON_CORE759_INST_DONE),
.pc_w759             (`PITON_CORE759_PC_W759),


.spc760_inst_done    (`PITON_CORE760_INST_DONE),
.pc_w760             (`PITON_CORE760_PC_W760),


.spc761_inst_done    (`PITON_CORE761_INST_DONE),
.pc_w761             (`PITON_CORE761_PC_W761),


.spc762_inst_done    (`PITON_CORE762_INST_DONE),
.pc_w762             (`PITON_CORE762_PC_W762),


.spc763_inst_done    (`PITON_CORE763_INST_DONE),
.pc_w763             (`PITON_CORE763_PC_W763),


.spc764_inst_done    (`PITON_CORE764_INST_DONE),
.pc_w764             (`PITON_CORE764_PC_W764),


.spc765_inst_done    (`PITON_CORE765_INST_DONE),
.pc_w765             (`PITON_CORE765_PC_W765),


.spc766_inst_done    (`PITON_CORE766_INST_DONE),
.pc_w766             (`PITON_CORE766_PC_W766),


.spc767_inst_done    (`PITON_CORE767_INST_DONE),
.pc_w767             (`PITON_CORE767_PC_W767),


.spc768_inst_done    (`PITON_CORE768_INST_DONE),
.pc_w768             (`PITON_CORE768_PC_W768),


.spc769_inst_done    (`PITON_CORE769_INST_DONE),
.pc_w769             (`PITON_CORE769_PC_W769),


.spc770_inst_done    (`PITON_CORE770_INST_DONE),
.pc_w770             (`PITON_CORE770_PC_W770),


.spc771_inst_done    (`PITON_CORE771_INST_DONE),
.pc_w771             (`PITON_CORE771_PC_W771),


.spc772_inst_done    (`PITON_CORE772_INST_DONE),
.pc_w772             (`PITON_CORE772_PC_W772),


.spc773_inst_done    (`PITON_CORE773_INST_DONE),
.pc_w773             (`PITON_CORE773_PC_W773),


.spc774_inst_done    (`PITON_CORE774_INST_DONE),
.pc_w774             (`PITON_CORE774_PC_W774),


.spc775_inst_done    (`PITON_CORE775_INST_DONE),
.pc_w775             (`PITON_CORE775_PC_W775),


.spc776_inst_done    (`PITON_CORE776_INST_DONE),
.pc_w776             (`PITON_CORE776_PC_W776),


.spc777_inst_done    (`PITON_CORE777_INST_DONE),
.pc_w777             (`PITON_CORE777_PC_W777),


.spc778_inst_done    (`PITON_CORE778_INST_DONE),
.pc_w778             (`PITON_CORE778_PC_W778),


.spc779_inst_done    (`PITON_CORE779_INST_DONE),
.pc_w779             (`PITON_CORE779_PC_W779),


.spc780_inst_done    (`PITON_CORE780_INST_DONE),
.pc_w780             (`PITON_CORE780_PC_W780),


.spc781_inst_done    (`PITON_CORE781_INST_DONE),
.pc_w781             (`PITON_CORE781_PC_W781),


.spc782_inst_done    (`PITON_CORE782_INST_DONE),
.pc_w782             (`PITON_CORE782_PC_W782),


.spc783_inst_done    (`PITON_CORE783_INST_DONE),
.pc_w783             (`PITON_CORE783_PC_W783),


.spc784_inst_done    (`PITON_CORE784_INST_DONE),
.pc_w784             (`PITON_CORE784_PC_W784),


.spc785_inst_done    (`PITON_CORE785_INST_DONE),
.pc_w785             (`PITON_CORE785_PC_W785),


.spc786_inst_done    (`PITON_CORE786_INST_DONE),
.pc_w786             (`PITON_CORE786_PC_W786),


.spc787_inst_done    (`PITON_CORE787_INST_DONE),
.pc_w787             (`PITON_CORE787_PC_W787),


.spc788_inst_done    (`PITON_CORE788_INST_DONE),
.pc_w788             (`PITON_CORE788_PC_W788),


.spc789_inst_done    (`PITON_CORE789_INST_DONE),
.pc_w789             (`PITON_CORE789_PC_W789),


.spc790_inst_done    (`PITON_CORE790_INST_DONE),
.pc_w790             (`PITON_CORE790_PC_W790),


.spc791_inst_done    (`PITON_CORE791_INST_DONE),
.pc_w791             (`PITON_CORE791_PC_W791),


.spc792_inst_done    (`PITON_CORE792_INST_DONE),
.pc_w792             (`PITON_CORE792_PC_W792),


.spc793_inst_done    (`PITON_CORE793_INST_DONE),
.pc_w793             (`PITON_CORE793_PC_W793),


.spc794_inst_done    (`PITON_CORE794_INST_DONE),
.pc_w794             (`PITON_CORE794_PC_W794),


.spc795_inst_done    (`PITON_CORE795_INST_DONE),
.pc_w795             (`PITON_CORE795_PC_W795),


.spc796_inst_done    (`PITON_CORE796_INST_DONE),
.pc_w796             (`PITON_CORE796_PC_W796),


.spc797_inst_done    (`PITON_CORE797_INST_DONE),
.pc_w797             (`PITON_CORE797_PC_W797),


.spc798_inst_done    (`PITON_CORE798_INST_DONE),
.pc_w798             (`PITON_CORE798_PC_W798),


.spc799_inst_done    (`PITON_CORE799_INST_DONE),
.pc_w799             (`PITON_CORE799_PC_W799),


.spc800_inst_done    (`PITON_CORE800_INST_DONE),
.pc_w800             (`PITON_CORE800_PC_W800),


.spc801_inst_done    (`PITON_CORE801_INST_DONE),
.pc_w801             (`PITON_CORE801_PC_W801),


.spc802_inst_done    (`PITON_CORE802_INST_DONE),
.pc_w802             (`PITON_CORE802_PC_W802),


.spc803_inst_done    (`PITON_CORE803_INST_DONE),
.pc_w803             (`PITON_CORE803_PC_W803),


.spc804_inst_done    (`PITON_CORE804_INST_DONE),
.pc_w804             (`PITON_CORE804_PC_W804),


.spc805_inst_done    (`PITON_CORE805_INST_DONE),
.pc_w805             (`PITON_CORE805_PC_W805),


.spc806_inst_done    (`PITON_CORE806_INST_DONE),
.pc_w806             (`PITON_CORE806_PC_W806),


.spc807_inst_done    (`PITON_CORE807_INST_DONE),
.pc_w807             (`PITON_CORE807_PC_W807),


.spc808_inst_done    (`PITON_CORE808_INST_DONE),
.pc_w808             (`PITON_CORE808_PC_W808),


.spc809_inst_done    (`PITON_CORE809_INST_DONE),
.pc_w809             (`PITON_CORE809_PC_W809),


.spc810_inst_done    (`PITON_CORE810_INST_DONE),
.pc_w810             (`PITON_CORE810_PC_W810),


.spc811_inst_done    (`PITON_CORE811_INST_DONE),
.pc_w811             (`PITON_CORE811_PC_W811),


.spc812_inst_done    (`PITON_CORE812_INST_DONE),
.pc_w812             (`PITON_CORE812_PC_W812),


.spc813_inst_done    (`PITON_CORE813_INST_DONE),
.pc_w813             (`PITON_CORE813_PC_W813),


.spc814_inst_done    (`PITON_CORE814_INST_DONE),
.pc_w814             (`PITON_CORE814_PC_W814),


.spc815_inst_done    (`PITON_CORE815_INST_DONE),
.pc_w815             (`PITON_CORE815_PC_W815),


.spc816_inst_done    (`PITON_CORE816_INST_DONE),
.pc_w816             (`PITON_CORE816_PC_W816),


.spc817_inst_done    (`PITON_CORE817_INST_DONE),
.pc_w817             (`PITON_CORE817_PC_W817),


.spc818_inst_done    (`PITON_CORE818_INST_DONE),
.pc_w818             (`PITON_CORE818_PC_W818),


.spc819_inst_done    (`PITON_CORE819_INST_DONE),
.pc_w819             (`PITON_CORE819_PC_W819),


.spc820_inst_done    (`PITON_CORE820_INST_DONE),
.pc_w820             (`PITON_CORE820_PC_W820),


.spc821_inst_done    (`PITON_CORE821_INST_DONE),
.pc_w821             (`PITON_CORE821_PC_W821),


.spc822_inst_done    (`PITON_CORE822_INST_DONE),
.pc_w822             (`PITON_CORE822_PC_W822),


.spc823_inst_done    (`PITON_CORE823_INST_DONE),
.pc_w823             (`PITON_CORE823_PC_W823),


.spc824_inst_done    (`PITON_CORE824_INST_DONE),
.pc_w824             (`PITON_CORE824_PC_W824),


.spc825_inst_done    (`PITON_CORE825_INST_DONE),
.pc_w825             (`PITON_CORE825_PC_W825),


.spc826_inst_done    (`PITON_CORE826_INST_DONE),
.pc_w826             (`PITON_CORE826_PC_W826),


.spc827_inst_done    (`PITON_CORE827_INST_DONE),
.pc_w827             (`PITON_CORE827_PC_W827),


.spc828_inst_done    (`PITON_CORE828_INST_DONE),
.pc_w828             (`PITON_CORE828_PC_W828),


.spc829_inst_done    (`PITON_CORE829_INST_DONE),
.pc_w829             (`PITON_CORE829_PC_W829),


.spc830_inst_done    (`PITON_CORE830_INST_DONE),
.pc_w830             (`PITON_CORE830_PC_W830),


.spc831_inst_done    (`PITON_CORE831_INST_DONE),
.pc_w831             (`PITON_CORE831_PC_W831),


.spc832_inst_done    (`PITON_CORE832_INST_DONE),
.pc_w832             (`PITON_CORE832_PC_W832),


.spc833_inst_done    (`PITON_CORE833_INST_DONE),
.pc_w833             (`PITON_CORE833_PC_W833),


.spc834_inst_done    (`PITON_CORE834_INST_DONE),
.pc_w834             (`PITON_CORE834_PC_W834),


.spc835_inst_done    (`PITON_CORE835_INST_DONE),
.pc_w835             (`PITON_CORE835_PC_W835),


.spc836_inst_done    (`PITON_CORE836_INST_DONE),
.pc_w836             (`PITON_CORE836_PC_W836),


.spc837_inst_done    (`PITON_CORE837_INST_DONE),
.pc_w837             (`PITON_CORE837_PC_W837),


.spc838_inst_done    (`PITON_CORE838_INST_DONE),
.pc_w838             (`PITON_CORE838_PC_W838),


.spc839_inst_done    (`PITON_CORE839_INST_DONE),
.pc_w839             (`PITON_CORE839_PC_W839),


.spc840_inst_done    (`PITON_CORE840_INST_DONE),
.pc_w840             (`PITON_CORE840_PC_W840),


.spc841_inst_done    (`PITON_CORE841_INST_DONE),
.pc_w841             (`PITON_CORE841_PC_W841),


.spc842_inst_done    (`PITON_CORE842_INST_DONE),
.pc_w842             (`PITON_CORE842_PC_W842),


.spc843_inst_done    (`PITON_CORE843_INST_DONE),
.pc_w843             (`PITON_CORE843_PC_W843),


.spc844_inst_done    (`PITON_CORE844_INST_DONE),
.pc_w844             (`PITON_CORE844_PC_W844),


.spc845_inst_done    (`PITON_CORE845_INST_DONE),
.pc_w845             (`PITON_CORE845_PC_W845),


.spc846_inst_done    (`PITON_CORE846_INST_DONE),
.pc_w846             (`PITON_CORE846_PC_W846),


.spc847_inst_done    (`PITON_CORE847_INST_DONE),
.pc_w847             (`PITON_CORE847_PC_W847),


.spc848_inst_done    (`PITON_CORE848_INST_DONE),
.pc_w848             (`PITON_CORE848_PC_W848),


.spc849_inst_done    (`PITON_CORE849_INST_DONE),
.pc_w849             (`PITON_CORE849_PC_W849),


.spc850_inst_done    (`PITON_CORE850_INST_DONE),
.pc_w850             (`PITON_CORE850_PC_W850),


.spc851_inst_done    (`PITON_CORE851_INST_DONE),
.pc_w851             (`PITON_CORE851_PC_W851),


.spc852_inst_done    (`PITON_CORE852_INST_DONE),
.pc_w852             (`PITON_CORE852_PC_W852),


.spc853_inst_done    (`PITON_CORE853_INST_DONE),
.pc_w853             (`PITON_CORE853_PC_W853),


.spc854_inst_done    (`PITON_CORE854_INST_DONE),
.pc_w854             (`PITON_CORE854_PC_W854),


.spc855_inst_done    (`PITON_CORE855_INST_DONE),
.pc_w855             (`PITON_CORE855_PC_W855),


.spc856_inst_done    (`PITON_CORE856_INST_DONE),
.pc_w856             (`PITON_CORE856_PC_W856),


.spc857_inst_done    (`PITON_CORE857_INST_DONE),
.pc_w857             (`PITON_CORE857_PC_W857),


.spc858_inst_done    (`PITON_CORE858_INST_DONE),
.pc_w858             (`PITON_CORE858_PC_W858),


.spc859_inst_done    (`PITON_CORE859_INST_DONE),
.pc_w859             (`PITON_CORE859_PC_W859),


.spc860_inst_done    (`PITON_CORE860_INST_DONE),
.pc_w860             (`PITON_CORE860_PC_W860),


.spc861_inst_done    (`PITON_CORE861_INST_DONE),
.pc_w861             (`PITON_CORE861_PC_W861),


.spc862_inst_done    (`PITON_CORE862_INST_DONE),
.pc_w862             (`PITON_CORE862_PC_W862),


.spc863_inst_done    (`PITON_CORE863_INST_DONE),
.pc_w863             (`PITON_CORE863_PC_W863),


.spc864_inst_done    (`PITON_CORE864_INST_DONE),
.pc_w864             (`PITON_CORE864_PC_W864),


.spc865_inst_done    (`PITON_CORE865_INST_DONE),
.pc_w865             (`PITON_CORE865_PC_W865),


.spc866_inst_done    (`PITON_CORE866_INST_DONE),
.pc_w866             (`PITON_CORE866_PC_W866),


.spc867_inst_done    (`PITON_CORE867_INST_DONE),
.pc_w867             (`PITON_CORE867_PC_W867),


.spc868_inst_done    (`PITON_CORE868_INST_DONE),
.pc_w868             (`PITON_CORE868_PC_W868),


.spc869_inst_done    (`PITON_CORE869_INST_DONE),
.pc_w869             (`PITON_CORE869_PC_W869),


.spc870_inst_done    (`PITON_CORE870_INST_DONE),
.pc_w870             (`PITON_CORE870_PC_W870),


.spc871_inst_done    (`PITON_CORE871_INST_DONE),
.pc_w871             (`PITON_CORE871_PC_W871),


.spc872_inst_done    (`PITON_CORE872_INST_DONE),
.pc_w872             (`PITON_CORE872_PC_W872),


.spc873_inst_done    (`PITON_CORE873_INST_DONE),
.pc_w873             (`PITON_CORE873_PC_W873),


.spc874_inst_done    (`PITON_CORE874_INST_DONE),
.pc_w874             (`PITON_CORE874_PC_W874),


.spc875_inst_done    (`PITON_CORE875_INST_DONE),
.pc_w875             (`PITON_CORE875_PC_W875),


.spc876_inst_done    (`PITON_CORE876_INST_DONE),
.pc_w876             (`PITON_CORE876_PC_W876),


.spc877_inst_done    (`PITON_CORE877_INST_DONE),
.pc_w877             (`PITON_CORE877_PC_W877),


.spc878_inst_done    (`PITON_CORE878_INST_DONE),
.pc_w878             (`PITON_CORE878_PC_W878),


.spc879_inst_done    (`PITON_CORE879_INST_DONE),
.pc_w879             (`PITON_CORE879_PC_W879),


.spc880_inst_done    (`PITON_CORE880_INST_DONE),
.pc_w880             (`PITON_CORE880_PC_W880),


.spc881_inst_done    (`PITON_CORE881_INST_DONE),
.pc_w881             (`PITON_CORE881_PC_W881),


.spc882_inst_done    (`PITON_CORE882_INST_DONE),
.pc_w882             (`PITON_CORE882_PC_W882),


.spc883_inst_done    (`PITON_CORE883_INST_DONE),
.pc_w883             (`PITON_CORE883_PC_W883),


.spc884_inst_done    (`PITON_CORE884_INST_DONE),
.pc_w884             (`PITON_CORE884_PC_W884),


.spc885_inst_done    (`PITON_CORE885_INST_DONE),
.pc_w885             (`PITON_CORE885_PC_W885),


.spc886_inst_done    (`PITON_CORE886_INST_DONE),
.pc_w886             (`PITON_CORE886_PC_W886),


.spc887_inst_done    (`PITON_CORE887_INST_DONE),
.pc_w887             (`PITON_CORE887_PC_W887),


.spc888_inst_done    (`PITON_CORE888_INST_DONE),
.pc_w888             (`PITON_CORE888_PC_W888),


.spc889_inst_done    (`PITON_CORE889_INST_DONE),
.pc_w889             (`PITON_CORE889_PC_W889),


.spc890_inst_done    (`PITON_CORE890_INST_DONE),
.pc_w890             (`PITON_CORE890_PC_W890),


.spc891_inst_done    (`PITON_CORE891_INST_DONE),
.pc_w891             (`PITON_CORE891_PC_W891),


.spc892_inst_done    (`PITON_CORE892_INST_DONE),
.pc_w892             (`PITON_CORE892_PC_W892),


.spc893_inst_done    (`PITON_CORE893_INST_DONE),
.pc_w893             (`PITON_CORE893_PC_W893),


.spc894_inst_done    (`PITON_CORE894_INST_DONE),
.pc_w894             (`PITON_CORE894_PC_W894),


.spc895_inst_done    (`PITON_CORE895_INST_DONE),
.pc_w895             (`PITON_CORE895_PC_W895),


.spc896_inst_done    (`PITON_CORE896_INST_DONE),
.pc_w896             (`PITON_CORE896_PC_W896),


.spc897_inst_done    (`PITON_CORE897_INST_DONE),
.pc_w897             (`PITON_CORE897_PC_W897),


.spc898_inst_done    (`PITON_CORE898_INST_DONE),
.pc_w898             (`PITON_CORE898_PC_W898),


.spc899_inst_done    (`PITON_CORE899_INST_DONE),
.pc_w899             (`PITON_CORE899_PC_W899),


.spc900_inst_done    (`PITON_CORE900_INST_DONE),
.pc_w900             (`PITON_CORE900_PC_W900),


.spc901_inst_done    (`PITON_CORE901_INST_DONE),
.pc_w901             (`PITON_CORE901_PC_W901),


.spc902_inst_done    (`PITON_CORE902_INST_DONE),
.pc_w902             (`PITON_CORE902_PC_W902),


.spc903_inst_done    (`PITON_CORE903_INST_DONE),
.pc_w903             (`PITON_CORE903_PC_W903),


.spc904_inst_done    (`PITON_CORE904_INST_DONE),
.pc_w904             (`PITON_CORE904_PC_W904),


.spc905_inst_done    (`PITON_CORE905_INST_DONE),
.pc_w905             (`PITON_CORE905_PC_W905),


.spc906_inst_done    (`PITON_CORE906_INST_DONE),
.pc_w906             (`PITON_CORE906_PC_W906),


.spc907_inst_done    (`PITON_CORE907_INST_DONE),
.pc_w907             (`PITON_CORE907_PC_W907),


.spc908_inst_done    (`PITON_CORE908_INST_DONE),
.pc_w908             (`PITON_CORE908_PC_W908),


.spc909_inst_done    (`PITON_CORE909_INST_DONE),
.pc_w909             (`PITON_CORE909_PC_W909),


.spc910_inst_done    (`PITON_CORE910_INST_DONE),
.pc_w910             (`PITON_CORE910_PC_W910),


.spc911_inst_done    (`PITON_CORE911_INST_DONE),
.pc_w911             (`PITON_CORE911_PC_W911),


.spc912_inst_done    (`PITON_CORE912_INST_DONE),
.pc_w912             (`PITON_CORE912_PC_W912),


.spc913_inst_done    (`PITON_CORE913_INST_DONE),
.pc_w913             (`PITON_CORE913_PC_W913),


.spc914_inst_done    (`PITON_CORE914_INST_DONE),
.pc_w914             (`PITON_CORE914_PC_W914),


.spc915_inst_done    (`PITON_CORE915_INST_DONE),
.pc_w915             (`PITON_CORE915_PC_W915),


.spc916_inst_done    (`PITON_CORE916_INST_DONE),
.pc_w916             (`PITON_CORE916_PC_W916),


.spc917_inst_done    (`PITON_CORE917_INST_DONE),
.pc_w917             (`PITON_CORE917_PC_W917),


.spc918_inst_done    (`PITON_CORE918_INST_DONE),
.pc_w918             (`PITON_CORE918_PC_W918),


.spc919_inst_done    (`PITON_CORE919_INST_DONE),
.pc_w919             (`PITON_CORE919_PC_W919),


.spc920_inst_done    (`PITON_CORE920_INST_DONE),
.pc_w920             (`PITON_CORE920_PC_W920),


.spc921_inst_done    (`PITON_CORE921_INST_DONE),
.pc_w921             (`PITON_CORE921_PC_W921),


.spc922_inst_done    (`PITON_CORE922_INST_DONE),
.pc_w922             (`PITON_CORE922_PC_W922),


.spc923_inst_done    (`PITON_CORE923_INST_DONE),
.pc_w923             (`PITON_CORE923_PC_W923),


.spc924_inst_done    (`PITON_CORE924_INST_DONE),
.pc_w924             (`PITON_CORE924_PC_W924),


.spc925_inst_done    (`PITON_CORE925_INST_DONE),
.pc_w925             (`PITON_CORE925_PC_W925),


.spc926_inst_done    (`PITON_CORE926_INST_DONE),
.pc_w926             (`PITON_CORE926_PC_W926),


.spc927_inst_done    (`PITON_CORE927_INST_DONE),
.pc_w927             (`PITON_CORE927_PC_W927),


.spc928_inst_done    (`PITON_CORE928_INST_DONE),
.pc_w928             (`PITON_CORE928_PC_W928),


.spc929_inst_done    (`PITON_CORE929_INST_DONE),
.pc_w929             (`PITON_CORE929_PC_W929),


.spc930_inst_done    (`PITON_CORE930_INST_DONE),
.pc_w930             (`PITON_CORE930_PC_W930),


.spc931_inst_done    (`PITON_CORE931_INST_DONE),
.pc_w931             (`PITON_CORE931_PC_W931),


.spc932_inst_done    (`PITON_CORE932_INST_DONE),
.pc_w932             (`PITON_CORE932_PC_W932),


.spc933_inst_done    (`PITON_CORE933_INST_DONE),
.pc_w933             (`PITON_CORE933_PC_W933),


.spc934_inst_done    (`PITON_CORE934_INST_DONE),
.pc_w934             (`PITON_CORE934_PC_W934),


.spc935_inst_done    (`PITON_CORE935_INST_DONE),
.pc_w935             (`PITON_CORE935_PC_W935),


.spc936_inst_done    (`PITON_CORE936_INST_DONE),
.pc_w936             (`PITON_CORE936_PC_W936),


.spc937_inst_done    (`PITON_CORE937_INST_DONE),
.pc_w937             (`PITON_CORE937_PC_W937),


.spc938_inst_done    (`PITON_CORE938_INST_DONE),
.pc_w938             (`PITON_CORE938_PC_W938),


.spc939_inst_done    (`PITON_CORE939_INST_DONE),
.pc_w939             (`PITON_CORE939_PC_W939),


.spc940_inst_done    (`PITON_CORE940_INST_DONE),
.pc_w940             (`PITON_CORE940_PC_W940),


.spc941_inst_done    (`PITON_CORE941_INST_DONE),
.pc_w941             (`PITON_CORE941_PC_W941),


.spc942_inst_done    (`PITON_CORE942_INST_DONE),
.pc_w942             (`PITON_CORE942_PC_W942),


.spc943_inst_done    (`PITON_CORE943_INST_DONE),
.pc_w943             (`PITON_CORE943_PC_W943),


.spc944_inst_done    (`PITON_CORE944_INST_DONE),
.pc_w944             (`PITON_CORE944_PC_W944),


.spc945_inst_done    (`PITON_CORE945_INST_DONE),
.pc_w945             (`PITON_CORE945_PC_W945),


.spc946_inst_done    (`PITON_CORE946_INST_DONE),
.pc_w946             (`PITON_CORE946_PC_W946),


.spc947_inst_done    (`PITON_CORE947_INST_DONE),
.pc_w947             (`PITON_CORE947_PC_W947),


.spc948_inst_done    (`PITON_CORE948_INST_DONE),
.pc_w948             (`PITON_CORE948_PC_W948),


.spc949_inst_done    (`PITON_CORE949_INST_DONE),
.pc_w949             (`PITON_CORE949_PC_W949),


.spc950_inst_done    (`PITON_CORE950_INST_DONE),
.pc_w950             (`PITON_CORE950_PC_W950),


.spc951_inst_done    (`PITON_CORE951_INST_DONE),
.pc_w951             (`PITON_CORE951_PC_W951),


.spc952_inst_done    (`PITON_CORE952_INST_DONE),
.pc_w952             (`PITON_CORE952_PC_W952),


.spc953_inst_done    (`PITON_CORE953_INST_DONE),
.pc_w953             (`PITON_CORE953_PC_W953),


.spc954_inst_done    (`PITON_CORE954_INST_DONE),
.pc_w954             (`PITON_CORE954_PC_W954),


.spc955_inst_done    (`PITON_CORE955_INST_DONE),
.pc_w955             (`PITON_CORE955_PC_W955),


.spc956_inst_done    (`PITON_CORE956_INST_DONE),
.pc_w956             (`PITON_CORE956_PC_W956),


.spc957_inst_done    (`PITON_CORE957_INST_DONE),
.pc_w957             (`PITON_CORE957_PC_W957),


.spc958_inst_done    (`PITON_CORE958_INST_DONE),
.pc_w958             (`PITON_CORE958_PC_W958),


.spc959_inst_done    (`PITON_CORE959_INST_DONE),
.pc_w959             (`PITON_CORE959_PC_W959),


.spc960_inst_done    (`PITON_CORE960_INST_DONE),
.pc_w960             (`PITON_CORE960_PC_W960),


.spc961_inst_done    (`PITON_CORE961_INST_DONE),
.pc_w961             (`PITON_CORE961_PC_W961),


.spc962_inst_done    (`PITON_CORE962_INST_DONE),
.pc_w962             (`PITON_CORE962_PC_W962),


.spc963_inst_done    (`PITON_CORE963_INST_DONE),
.pc_w963             (`PITON_CORE963_PC_W963),


.spc964_inst_done    (`PITON_CORE964_INST_DONE),
.pc_w964             (`PITON_CORE964_PC_W964),


.spc965_inst_done    (`PITON_CORE965_INST_DONE),
.pc_w965             (`PITON_CORE965_PC_W965),


.spc966_inst_done    (`PITON_CORE966_INST_DONE),
.pc_w966             (`PITON_CORE966_PC_W966),


.spc967_inst_done    (`PITON_CORE967_INST_DONE),
.pc_w967             (`PITON_CORE967_PC_W967),


.spc968_inst_done    (`PITON_CORE968_INST_DONE),
.pc_w968             (`PITON_CORE968_PC_W968),


.spc969_inst_done    (`PITON_CORE969_INST_DONE),
.pc_w969             (`PITON_CORE969_PC_W969),


.spc970_inst_done    (`PITON_CORE970_INST_DONE),
.pc_w970             (`PITON_CORE970_PC_W970),


.spc971_inst_done    (`PITON_CORE971_INST_DONE),
.pc_w971             (`PITON_CORE971_PC_W971),


.spc972_inst_done    (`PITON_CORE972_INST_DONE),
.pc_w972             (`PITON_CORE972_PC_W972),


.spc973_inst_done    (`PITON_CORE973_INST_DONE),
.pc_w973             (`PITON_CORE973_PC_W973),


.spc974_inst_done    (`PITON_CORE974_INST_DONE),
.pc_w974             (`PITON_CORE974_PC_W974),


.spc975_inst_done    (`PITON_CORE975_INST_DONE),
.pc_w975             (`PITON_CORE975_PC_W975),


.spc976_inst_done    (`PITON_CORE976_INST_DONE),
.pc_w976             (`PITON_CORE976_PC_W976),


.spc977_inst_done    (`PITON_CORE977_INST_DONE),
.pc_w977             (`PITON_CORE977_PC_W977),


.spc978_inst_done    (`PITON_CORE978_INST_DONE),
.pc_w978             (`PITON_CORE978_PC_W978),


.spc979_inst_done    (`PITON_CORE979_INST_DONE),
.pc_w979             (`PITON_CORE979_PC_W979),


.spc980_inst_done    (`PITON_CORE980_INST_DONE),
.pc_w980             (`PITON_CORE980_PC_W980),


.spc981_inst_done    (`PITON_CORE981_INST_DONE),
.pc_w981             (`PITON_CORE981_PC_W981),


.spc982_inst_done    (`PITON_CORE982_INST_DONE),
.pc_w982             (`PITON_CORE982_PC_W982),


.spc983_inst_done    (`PITON_CORE983_INST_DONE),
.pc_w983             (`PITON_CORE983_PC_W983),


.spc984_inst_done    (`PITON_CORE984_INST_DONE),
.pc_w984             (`PITON_CORE984_PC_W984),


.spc985_inst_done    (`PITON_CORE985_INST_DONE),
.pc_w985             (`PITON_CORE985_PC_W985),


.spc986_inst_done    (`PITON_CORE986_INST_DONE),
.pc_w986             (`PITON_CORE986_PC_W986),


.spc987_inst_done    (`PITON_CORE987_INST_DONE),
.pc_w987             (`PITON_CORE987_PC_W987),


.spc988_inst_done    (`PITON_CORE988_INST_DONE),
.pc_w988             (`PITON_CORE988_PC_W988),


.spc989_inst_done    (`PITON_CORE989_INST_DONE),
.pc_w989             (`PITON_CORE989_PC_W989),


.spc990_inst_done    (`PITON_CORE990_INST_DONE),
.pc_w990             (`PITON_CORE990_PC_W990),


.spc991_inst_done    (`PITON_CORE991_INST_DONE),
.pc_w991             (`PITON_CORE991_PC_W991),


.spc992_inst_done    (`PITON_CORE992_INST_DONE),
.pc_w992             (`PITON_CORE992_PC_W992),


.spc993_inst_done    (`PITON_CORE993_INST_DONE),
.pc_w993             (`PITON_CORE993_PC_W993),


.spc994_inst_done    (`PITON_CORE994_INST_DONE),
.pc_w994             (`PITON_CORE994_PC_W994),


.spc995_inst_done    (`PITON_CORE995_INST_DONE),
.pc_w995             (`PITON_CORE995_PC_W995),


.spc996_inst_done    (`PITON_CORE996_INST_DONE),
.pc_w996             (`PITON_CORE996_PC_W996),


.spc997_inst_done    (`PITON_CORE997_INST_DONE),
.pc_w997             (`PITON_CORE997_PC_W997),


.spc998_inst_done    (`PITON_CORE998_INST_DONE),
.pc_w998             (`PITON_CORE998_PC_W998),


.spc999_inst_done    (`PITON_CORE999_INST_DONE),
.pc_w999             (`PITON_CORE999_PC_W999),


.spc1000_inst_done    (`PITON_CORE1000_INST_DONE),
.pc_w1000             (`PITON_CORE1000_PC_W1000),


.spc1001_inst_done    (`PITON_CORE1001_INST_DONE),
.pc_w1001             (`PITON_CORE1001_PC_W1001),


.spc1002_inst_done    (`PITON_CORE1002_INST_DONE),
.pc_w1002             (`PITON_CORE1002_PC_W1002),


.spc1003_inst_done    (`PITON_CORE1003_INST_DONE),
.pc_w1003             (`PITON_CORE1003_PC_W1003),


.spc1004_inst_done    (`PITON_CORE1004_INST_DONE),
.pc_w1004             (`PITON_CORE1004_PC_W1004),


.spc1005_inst_done    (`PITON_CORE1005_INST_DONE),
.pc_w1005             (`PITON_CORE1005_PC_W1005),


.spc1006_inst_done    (`PITON_CORE1006_INST_DONE),
.pc_w1006             (`PITON_CORE1006_PC_W1006),


.spc1007_inst_done    (`PITON_CORE1007_INST_DONE),
.pc_w1007             (`PITON_CORE1007_PC_W1007),


.spc1008_inst_done    (`PITON_CORE1008_INST_DONE),
.pc_w1008             (`PITON_CORE1008_PC_W1008),


.spc1009_inst_done    (`PITON_CORE1009_INST_DONE),
.pc_w1009             (`PITON_CORE1009_PC_W1009),


.spc1010_inst_done    (`PITON_CORE1010_INST_DONE),
.pc_w1010             (`PITON_CORE1010_PC_W1010),


.spc1011_inst_done    (`PITON_CORE1011_INST_DONE),
.pc_w1011             (`PITON_CORE1011_PC_W1011),


.spc1012_inst_done    (`PITON_CORE1012_INST_DONE),
.pc_w1012             (`PITON_CORE1012_PC_W1012),


.spc1013_inst_done    (`PITON_CORE1013_INST_DONE),
.pc_w1013             (`PITON_CORE1013_PC_W1013),


.spc1014_inst_done    (`PITON_CORE1014_INST_DONE),
.pc_w1014             (`PITON_CORE1014_PC_W1014),


.spc1015_inst_done    (`PITON_CORE1015_INST_DONE),
.pc_w1015             (`PITON_CORE1015_PC_W1015),


.spc1016_inst_done    (`PITON_CORE1016_INST_DONE),
.pc_w1016             (`PITON_CORE1016_PC_W1016),


.spc1017_inst_done    (`PITON_CORE1017_INST_DONE),
.pc_w1017             (`PITON_CORE1017_PC_W1017),


.spc1018_inst_done    (`PITON_CORE1018_INST_DONE),
.pc_w1018             (`PITON_CORE1018_PC_W1018),


.spc1019_inst_done    (`PITON_CORE1019_INST_DONE),
.pc_w1019             (`PITON_CORE1019_PC_W1019),


.spc1020_inst_done    (`PITON_CORE1020_INST_DONE),
.pc_w1020             (`PITON_CORE1020_PC_W1020),


.spc1021_inst_done    (`PITON_CORE1021_INST_DONE),
.pc_w1021             (`PITON_CORE1021_PC_W1021),


.spc1022_inst_done    (`PITON_CORE1022_INST_DONE),
.pc_w1022             (`PITON_CORE1022_PC_W1022),


.spc1023_inst_done    (`PITON_CORE1023_INST_DONE),
.pc_w1023             (`PITON_CORE1023_PC_W1023),


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
