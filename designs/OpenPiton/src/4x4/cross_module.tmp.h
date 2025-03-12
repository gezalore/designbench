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

    

    `define TILE1            `CHIP.tile1
    `define ARIANE_CORE1     `TILE1.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP1         `TILE1.l15.l15
    `define L15_PIPE1        `TILE1.l15.l15.pipeline
    `define DMBR1            `TILE1.dmbr_ins
    `define L2_TOP1          `TILE1.l2
    `define PITON_CORE1_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc1_inst_done
    `define PITON_CORE1_PC_W1     `TOP_MOD.monitor.pc_cmp.spc1_phy_pc_w

    

    `define TILE2            `CHIP.tile2
    `define ARIANE_CORE2     `TILE2.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP2         `TILE2.l15.l15
    `define L15_PIPE2        `TILE2.l15.l15.pipeline
    `define DMBR2            `TILE2.dmbr_ins
    `define L2_TOP2          `TILE2.l2
    `define PITON_CORE2_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc2_inst_done
    `define PITON_CORE2_PC_W2     `TOP_MOD.monitor.pc_cmp.spc2_phy_pc_w

    

    `define TILE3            `CHIP.tile3
    `define ARIANE_CORE3     `TILE3.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP3         `TILE3.l15.l15
    `define L15_PIPE3        `TILE3.l15.l15.pipeline
    `define DMBR3            `TILE3.dmbr_ins
    `define L2_TOP3          `TILE3.l2
    `define PITON_CORE3_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc3_inst_done
    `define PITON_CORE3_PC_W3     `TOP_MOD.monitor.pc_cmp.spc3_phy_pc_w

    

    `define TILE4            `CHIP.tile4
    `define ARIANE_CORE4     `TILE4.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP4         `TILE4.l15.l15
    `define L15_PIPE4        `TILE4.l15.l15.pipeline
    `define DMBR4            `TILE4.dmbr_ins
    `define L2_TOP4          `TILE4.l2
    `define PITON_CORE4_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc4_inst_done
    `define PITON_CORE4_PC_W4     `TOP_MOD.monitor.pc_cmp.spc4_phy_pc_w

    

    `define TILE5            `CHIP.tile5
    `define ARIANE_CORE5     `TILE5.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP5         `TILE5.l15.l15
    `define L15_PIPE5        `TILE5.l15.l15.pipeline
    `define DMBR5            `TILE5.dmbr_ins
    `define L2_TOP5          `TILE5.l2
    `define PITON_CORE5_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc5_inst_done
    `define PITON_CORE5_PC_W5     `TOP_MOD.monitor.pc_cmp.spc5_phy_pc_w

    

    `define TILE6            `CHIP.tile6
    `define ARIANE_CORE6     `TILE6.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP6         `TILE6.l15.l15
    `define L15_PIPE6        `TILE6.l15.l15.pipeline
    `define DMBR6            `TILE6.dmbr_ins
    `define L2_TOP6          `TILE6.l2
    `define PITON_CORE6_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc6_inst_done
    `define PITON_CORE6_PC_W6     `TOP_MOD.monitor.pc_cmp.spc6_phy_pc_w

    

    `define TILE7            `CHIP.tile7
    `define ARIANE_CORE7     `TILE7.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP7         `TILE7.l15.l15
    `define L15_PIPE7        `TILE7.l15.l15.pipeline
    `define DMBR7            `TILE7.dmbr_ins
    `define L2_TOP7          `TILE7.l2
    `define PITON_CORE7_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc7_inst_done
    `define PITON_CORE7_PC_W7     `TOP_MOD.monitor.pc_cmp.spc7_phy_pc_w

    

    `define TILE8            `CHIP.tile8
    `define ARIANE_CORE8     `TILE8.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP8         `TILE8.l15.l15
    `define L15_PIPE8        `TILE8.l15.l15.pipeline
    `define DMBR8            `TILE8.dmbr_ins
    `define L2_TOP8          `TILE8.l2
    `define PITON_CORE8_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc8_inst_done
    `define PITON_CORE8_PC_W8     `TOP_MOD.monitor.pc_cmp.spc8_phy_pc_w

    

    `define TILE9            `CHIP.tile9
    `define ARIANE_CORE9     `TILE9.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP9         `TILE9.l15.l15
    `define L15_PIPE9        `TILE9.l15.l15.pipeline
    `define DMBR9            `TILE9.dmbr_ins
    `define L2_TOP9          `TILE9.l2
    `define PITON_CORE9_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc9_inst_done
    `define PITON_CORE9_PC_W9     `TOP_MOD.monitor.pc_cmp.spc9_phy_pc_w

    

    `define TILE10            `CHIP.tile10
    `define ARIANE_CORE10     `TILE10.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP10         `TILE10.l15.l15
    `define L15_PIPE10        `TILE10.l15.l15.pipeline
    `define DMBR10            `TILE10.dmbr_ins
    `define L2_TOP10          `TILE10.l2
    `define PITON_CORE10_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc10_inst_done
    `define PITON_CORE10_PC_W10     `TOP_MOD.monitor.pc_cmp.spc10_phy_pc_w

    

    `define TILE11            `CHIP.tile11
    `define ARIANE_CORE11     `TILE11.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP11         `TILE11.l15.l15
    `define L15_PIPE11        `TILE11.l15.l15.pipeline
    `define DMBR11            `TILE11.dmbr_ins
    `define L2_TOP11          `TILE11.l2
    `define PITON_CORE11_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc11_inst_done
    `define PITON_CORE11_PC_W11     `TOP_MOD.monitor.pc_cmp.spc11_phy_pc_w

    

    `define TILE12            `CHIP.tile12
    `define ARIANE_CORE12     `TILE12.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP12         `TILE12.l15.l15
    `define L15_PIPE12        `TILE12.l15.l15.pipeline
    `define DMBR12            `TILE12.dmbr_ins
    `define L2_TOP12          `TILE12.l2
    `define PITON_CORE12_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc12_inst_done
    `define PITON_CORE12_PC_W12     `TOP_MOD.monitor.pc_cmp.spc12_phy_pc_w

    

    `define TILE13            `CHIP.tile13
    `define ARIANE_CORE13     `TILE13.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP13         `TILE13.l15.l15
    `define L15_PIPE13        `TILE13.l15.l15.pipeline
    `define DMBR13            `TILE13.dmbr_ins
    `define L2_TOP13          `TILE13.l2
    `define PITON_CORE13_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc13_inst_done
    `define PITON_CORE13_PC_W13     `TOP_MOD.monitor.pc_cmp.spc13_phy_pc_w

    

    `define TILE14            `CHIP.tile14
    `define ARIANE_CORE14     `TILE14.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP14         `TILE14.l15.l15
    `define L15_PIPE14        `TILE14.l15.l15.pipeline
    `define DMBR14            `TILE14.dmbr_ins
    `define L2_TOP14          `TILE14.l2
    `define PITON_CORE14_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc14_inst_done
    `define PITON_CORE14_PC_W14     `TOP_MOD.monitor.pc_cmp.spc14_phy_pc_w

    

    `define TILE15            `CHIP.tile15
    `define ARIANE_CORE15     `TILE15.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP15         `TILE15.l15.l15
    `define L15_PIPE15        `TILE15.l15.l15.pipeline
    `define DMBR15            `TILE15.dmbr_ins
    `define L2_TOP15          `TILE15.l2
    `define PITON_CORE15_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc15_inst_done
    `define PITON_CORE15_PC_W15     `TOP_MOD.monitor.pc_cmp.spc15_phy_pc_w

    


`define ITAG0           `TOP_MOD.monitor.l_cache_mon0
`define IVLD0           `TOP_MOD.monitor.l_cache_mon0
`define SAS_INTER `TOP_MOD.sas_intf
`define MONITOR `TOP_MOD.monitor

`endif
