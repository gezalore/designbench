// Modified by Princeton University on June 9th, 2015
/*
* ========== Copyright Header Begin ==========================================
*
* OpenSPARC T1 Processor File: cross_module.h
* Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
* DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
*
* The above named program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License version 2 as published by the Free Software Foundation.
*
* The above named program is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this work; if not, write to the Free Software
* Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
*
* ========== Copyright Header End ============================================
*/

`ifndef CROSS_MODULE_H
`define CROSS_MODULE_H



`define MONITOR_SIGNAL                 155
`define FLOAT_X                        154
`define FLOAT_I                        153
`define REG_WRITE_BACK                 152
`define PLI_QUIT                1    /* None */
`define PLI_SSTEP               2    /* %1 th id */
`define PLI_READ_TH_REG         3    /* %1 th id, %2 win num, %3 reg num */
`define PLI_READ_TH_CTL_REG     4    /* %1 th id, %2 reg num */
`define PLI_READ_TH_FP_REG_I    5    /* %1 th id, %2 reg num */
`define PLI_READ_TH_FP_REG_X    6    /* %1 th id, %2 reg num */
`define PLI_RTL_DATA            7
`define PLI_RTL_CYCLE           8
`define PLI_WRITE_TH_XCC_REG    9
`define PLI_FORCE_TRAP_TYPE            15
`define PLI_RESET_TLB_ENTRY     16
`define PLI_RETRY               30
`define PLI_WRITE_TH_REG_HI     10
`define PLI_WRITE_TH_REG        11
`define PLI_WRITE_TH_CTL_REG    12    /* %1 th id, %2 reg num, %3-%10 value */
`define CMD_BUFSIZE 10240

//define all cross module

// trin: defines for jtag test bench

`ifdef JTAG_TB_XMODULE
    `define TOP_MOD     jtag_testbench_top.helper
    `define SIM_TOP     jtag_testbench_top.helper
    `define TOP_MOD_INST `TOP_MOD
`else
    `define TOP_MOD     cmp_top
    `define SIM_TOP     cmp_top
    `define TOP_MOD_INST `TOP_MOD.system
// TODO: Alexey: use PITON_PROTO define ?
//`define TOP_MOD      fpga_top.cmp_top
`endif

//`define SIM_TOP fpga_top.cmp_top

    // `define TOP_SHELL    cmp_top_shell
`define CHIP         `TOP_MOD_INST.chip
`define CHIP_INT_CLK `CHIP.clk_muxed
`define TOP_DESIGN   `TOP_MOD.chip
`define FAKE_IOB     `TOP_MOD.system.chipset.chipset_impl.ciop_fake_iob
// `define TOP_MEMORY   `TOP_MOD.cmp

`define JTAG_CTAP    `CHIP.jtag_port.ctap
`define MONITOR_PATH `TOP_MOD.monitor
`define PC_CMP       `TOP_MOD.monitor.pc_cmp
`define SAS_SEND     `TOP_MOD.sas_tasks.send_cmd
`define SAS_DEF      `TOP_MOD.sas_tasks.sas_def
`define SAS_TASKS    `TOP_MOD.sas_tasks
`define CPX_INVALID_TIME 1000

// Note that the belows were generated through the template file and pyhp


    `define TILE0            `CHIP.tile0
    `define ARIANE_CORE0     `TILE0.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP0         `TILE0.l15.l15
    `define L15_PIPE0        `TILE0.l15.l15.pipeline
    `define DMBR0            `TILE0.dmbr_ins
    `define L2_TOP0          `TILE0.l2
    `define PITON_CORE0_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc0_inst_done
    `define PITON_CORE0_PC_W0     `TOP_MOD.monitor.pc_cmp.spc0_phy_pc_w

    


`define ITAG0           `TOP_MOD.monitor.l_cache_mon0
`define IVLD0           `TOP_MOD.monitor.l_cache_mon0
`define SAS_INTER `TOP_MOD.sas_intf
`define MONITOR `TOP_MOD.monitor

`endif
