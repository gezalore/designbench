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

    

    `define TILE16            `CHIP.tile16
    `define ARIANE_CORE16     `TILE16.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP16         `TILE16.l15.l15
    `define L15_PIPE16        `TILE16.l15.l15.pipeline
    `define DMBR16            `TILE16.dmbr_ins
    `define L2_TOP16          `TILE16.l2
    `define PITON_CORE16_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc16_inst_done
    `define PITON_CORE16_PC_W16     `TOP_MOD.monitor.pc_cmp.spc16_phy_pc_w

    

    `define TILE17            `CHIP.tile17
    `define ARIANE_CORE17     `TILE17.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP17         `TILE17.l15.l15
    `define L15_PIPE17        `TILE17.l15.l15.pipeline
    `define DMBR17            `TILE17.dmbr_ins
    `define L2_TOP17          `TILE17.l2
    `define PITON_CORE17_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc17_inst_done
    `define PITON_CORE17_PC_W17     `TOP_MOD.monitor.pc_cmp.spc17_phy_pc_w

    

    `define TILE18            `CHIP.tile18
    `define ARIANE_CORE18     `TILE18.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP18         `TILE18.l15.l15
    `define L15_PIPE18        `TILE18.l15.l15.pipeline
    `define DMBR18            `TILE18.dmbr_ins
    `define L2_TOP18          `TILE18.l2
    `define PITON_CORE18_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc18_inst_done
    `define PITON_CORE18_PC_W18     `TOP_MOD.monitor.pc_cmp.spc18_phy_pc_w

    

    `define TILE19            `CHIP.tile19
    `define ARIANE_CORE19     `TILE19.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP19         `TILE19.l15.l15
    `define L15_PIPE19        `TILE19.l15.l15.pipeline
    `define DMBR19            `TILE19.dmbr_ins
    `define L2_TOP19          `TILE19.l2
    `define PITON_CORE19_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc19_inst_done
    `define PITON_CORE19_PC_W19     `TOP_MOD.monitor.pc_cmp.spc19_phy_pc_w

    

    `define TILE20            `CHIP.tile20
    `define ARIANE_CORE20     `TILE20.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP20         `TILE20.l15.l15
    `define L15_PIPE20        `TILE20.l15.l15.pipeline
    `define DMBR20            `TILE20.dmbr_ins
    `define L2_TOP20          `TILE20.l2
    `define PITON_CORE20_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc20_inst_done
    `define PITON_CORE20_PC_W20     `TOP_MOD.monitor.pc_cmp.spc20_phy_pc_w

    

    `define TILE21            `CHIP.tile21
    `define ARIANE_CORE21     `TILE21.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP21         `TILE21.l15.l15
    `define L15_PIPE21        `TILE21.l15.l15.pipeline
    `define DMBR21            `TILE21.dmbr_ins
    `define L2_TOP21          `TILE21.l2
    `define PITON_CORE21_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc21_inst_done
    `define PITON_CORE21_PC_W21     `TOP_MOD.monitor.pc_cmp.spc21_phy_pc_w

    

    `define TILE22            `CHIP.tile22
    `define ARIANE_CORE22     `TILE22.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP22         `TILE22.l15.l15
    `define L15_PIPE22        `TILE22.l15.l15.pipeline
    `define DMBR22            `TILE22.dmbr_ins
    `define L2_TOP22          `TILE22.l2
    `define PITON_CORE22_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc22_inst_done
    `define PITON_CORE22_PC_W22     `TOP_MOD.monitor.pc_cmp.spc22_phy_pc_w

    

    `define TILE23            `CHIP.tile23
    `define ARIANE_CORE23     `TILE23.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP23         `TILE23.l15.l15
    `define L15_PIPE23        `TILE23.l15.l15.pipeline
    `define DMBR23            `TILE23.dmbr_ins
    `define L2_TOP23          `TILE23.l2
    `define PITON_CORE23_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc23_inst_done
    `define PITON_CORE23_PC_W23     `TOP_MOD.monitor.pc_cmp.spc23_phy_pc_w

    

    `define TILE24            `CHIP.tile24
    `define ARIANE_CORE24     `TILE24.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP24         `TILE24.l15.l15
    `define L15_PIPE24        `TILE24.l15.l15.pipeline
    `define DMBR24            `TILE24.dmbr_ins
    `define L2_TOP24          `TILE24.l2
    `define PITON_CORE24_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc24_inst_done
    `define PITON_CORE24_PC_W24     `TOP_MOD.monitor.pc_cmp.spc24_phy_pc_w

    

    `define TILE25            `CHIP.tile25
    `define ARIANE_CORE25     `TILE25.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP25         `TILE25.l15.l15
    `define L15_PIPE25        `TILE25.l15.l15.pipeline
    `define DMBR25            `TILE25.dmbr_ins
    `define L2_TOP25          `TILE25.l2
    `define PITON_CORE25_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc25_inst_done
    `define PITON_CORE25_PC_W25     `TOP_MOD.monitor.pc_cmp.spc25_phy_pc_w

    

    `define TILE26            `CHIP.tile26
    `define ARIANE_CORE26     `TILE26.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP26         `TILE26.l15.l15
    `define L15_PIPE26        `TILE26.l15.l15.pipeline
    `define DMBR26            `TILE26.dmbr_ins
    `define L2_TOP26          `TILE26.l2
    `define PITON_CORE26_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc26_inst_done
    `define PITON_CORE26_PC_W26     `TOP_MOD.monitor.pc_cmp.spc26_phy_pc_w

    

    `define TILE27            `CHIP.tile27
    `define ARIANE_CORE27     `TILE27.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP27         `TILE27.l15.l15
    `define L15_PIPE27        `TILE27.l15.l15.pipeline
    `define DMBR27            `TILE27.dmbr_ins
    `define L2_TOP27          `TILE27.l2
    `define PITON_CORE27_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc27_inst_done
    `define PITON_CORE27_PC_W27     `TOP_MOD.monitor.pc_cmp.spc27_phy_pc_w

    

    `define TILE28            `CHIP.tile28
    `define ARIANE_CORE28     `TILE28.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP28         `TILE28.l15.l15
    `define L15_PIPE28        `TILE28.l15.l15.pipeline
    `define DMBR28            `TILE28.dmbr_ins
    `define L2_TOP28          `TILE28.l2
    `define PITON_CORE28_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc28_inst_done
    `define PITON_CORE28_PC_W28     `TOP_MOD.monitor.pc_cmp.spc28_phy_pc_w

    

    `define TILE29            `CHIP.tile29
    `define ARIANE_CORE29     `TILE29.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP29         `TILE29.l15.l15
    `define L15_PIPE29        `TILE29.l15.l15.pipeline
    `define DMBR29            `TILE29.dmbr_ins
    `define L2_TOP29          `TILE29.l2
    `define PITON_CORE29_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc29_inst_done
    `define PITON_CORE29_PC_W29     `TOP_MOD.monitor.pc_cmp.spc29_phy_pc_w

    

    `define TILE30            `CHIP.tile30
    `define ARIANE_CORE30     `TILE30.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP30         `TILE30.l15.l15
    `define L15_PIPE30        `TILE30.l15.l15.pipeline
    `define DMBR30            `TILE30.dmbr_ins
    `define L2_TOP30          `TILE30.l2
    `define PITON_CORE30_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc30_inst_done
    `define PITON_CORE30_PC_W30     `TOP_MOD.monitor.pc_cmp.spc30_phy_pc_w

    

    `define TILE31            `CHIP.tile31
    `define ARIANE_CORE31     `TILE31.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP31         `TILE31.l15.l15
    `define L15_PIPE31        `TILE31.l15.l15.pipeline
    `define DMBR31            `TILE31.dmbr_ins
    `define L2_TOP31          `TILE31.l2
    `define PITON_CORE31_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc31_inst_done
    `define PITON_CORE31_PC_W31     `TOP_MOD.monitor.pc_cmp.spc31_phy_pc_w

    

    `define TILE32            `CHIP.tile32
    `define ARIANE_CORE32     `TILE32.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP32         `TILE32.l15.l15
    `define L15_PIPE32        `TILE32.l15.l15.pipeline
    `define DMBR32            `TILE32.dmbr_ins
    `define L2_TOP32          `TILE32.l2
    `define PITON_CORE32_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc32_inst_done
    `define PITON_CORE32_PC_W32     `TOP_MOD.monitor.pc_cmp.spc32_phy_pc_w

    

    `define TILE33            `CHIP.tile33
    `define ARIANE_CORE33     `TILE33.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP33         `TILE33.l15.l15
    `define L15_PIPE33        `TILE33.l15.l15.pipeline
    `define DMBR33            `TILE33.dmbr_ins
    `define L2_TOP33          `TILE33.l2
    `define PITON_CORE33_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc33_inst_done
    `define PITON_CORE33_PC_W33     `TOP_MOD.monitor.pc_cmp.spc33_phy_pc_w

    

    `define TILE34            `CHIP.tile34
    `define ARIANE_CORE34     `TILE34.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP34         `TILE34.l15.l15
    `define L15_PIPE34        `TILE34.l15.l15.pipeline
    `define DMBR34            `TILE34.dmbr_ins
    `define L2_TOP34          `TILE34.l2
    `define PITON_CORE34_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc34_inst_done
    `define PITON_CORE34_PC_W34     `TOP_MOD.monitor.pc_cmp.spc34_phy_pc_w

    

    `define TILE35            `CHIP.tile35
    `define ARIANE_CORE35     `TILE35.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP35         `TILE35.l15.l15
    `define L15_PIPE35        `TILE35.l15.l15.pipeline
    `define DMBR35            `TILE35.dmbr_ins
    `define L2_TOP35          `TILE35.l2
    `define PITON_CORE35_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc35_inst_done
    `define PITON_CORE35_PC_W35     `TOP_MOD.monitor.pc_cmp.spc35_phy_pc_w

    

    `define TILE36            `CHIP.tile36
    `define ARIANE_CORE36     `TILE36.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP36         `TILE36.l15.l15
    `define L15_PIPE36        `TILE36.l15.l15.pipeline
    `define DMBR36            `TILE36.dmbr_ins
    `define L2_TOP36          `TILE36.l2
    `define PITON_CORE36_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc36_inst_done
    `define PITON_CORE36_PC_W36     `TOP_MOD.monitor.pc_cmp.spc36_phy_pc_w

    

    `define TILE37            `CHIP.tile37
    `define ARIANE_CORE37     `TILE37.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP37         `TILE37.l15.l15
    `define L15_PIPE37        `TILE37.l15.l15.pipeline
    `define DMBR37            `TILE37.dmbr_ins
    `define L2_TOP37          `TILE37.l2
    `define PITON_CORE37_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc37_inst_done
    `define PITON_CORE37_PC_W37     `TOP_MOD.monitor.pc_cmp.spc37_phy_pc_w

    

    `define TILE38            `CHIP.tile38
    `define ARIANE_CORE38     `TILE38.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP38         `TILE38.l15.l15
    `define L15_PIPE38        `TILE38.l15.l15.pipeline
    `define DMBR38            `TILE38.dmbr_ins
    `define L2_TOP38          `TILE38.l2
    `define PITON_CORE38_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc38_inst_done
    `define PITON_CORE38_PC_W38     `TOP_MOD.monitor.pc_cmp.spc38_phy_pc_w

    

    `define TILE39            `CHIP.tile39
    `define ARIANE_CORE39     `TILE39.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP39         `TILE39.l15.l15
    `define L15_PIPE39        `TILE39.l15.l15.pipeline
    `define DMBR39            `TILE39.dmbr_ins
    `define L2_TOP39          `TILE39.l2
    `define PITON_CORE39_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc39_inst_done
    `define PITON_CORE39_PC_W39     `TOP_MOD.monitor.pc_cmp.spc39_phy_pc_w

    

    `define TILE40            `CHIP.tile40
    `define ARIANE_CORE40     `TILE40.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP40         `TILE40.l15.l15
    `define L15_PIPE40        `TILE40.l15.l15.pipeline
    `define DMBR40            `TILE40.dmbr_ins
    `define L2_TOP40          `TILE40.l2
    `define PITON_CORE40_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc40_inst_done
    `define PITON_CORE40_PC_W40     `TOP_MOD.monitor.pc_cmp.spc40_phy_pc_w

    

    `define TILE41            `CHIP.tile41
    `define ARIANE_CORE41     `TILE41.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP41         `TILE41.l15.l15
    `define L15_PIPE41        `TILE41.l15.l15.pipeline
    `define DMBR41            `TILE41.dmbr_ins
    `define L2_TOP41          `TILE41.l2
    `define PITON_CORE41_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc41_inst_done
    `define PITON_CORE41_PC_W41     `TOP_MOD.monitor.pc_cmp.spc41_phy_pc_w

    

    `define TILE42            `CHIP.tile42
    `define ARIANE_CORE42     `TILE42.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP42         `TILE42.l15.l15
    `define L15_PIPE42        `TILE42.l15.l15.pipeline
    `define DMBR42            `TILE42.dmbr_ins
    `define L2_TOP42          `TILE42.l2
    `define PITON_CORE42_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc42_inst_done
    `define PITON_CORE42_PC_W42     `TOP_MOD.monitor.pc_cmp.spc42_phy_pc_w

    

    `define TILE43            `CHIP.tile43
    `define ARIANE_CORE43     `TILE43.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP43         `TILE43.l15.l15
    `define L15_PIPE43        `TILE43.l15.l15.pipeline
    `define DMBR43            `TILE43.dmbr_ins
    `define L2_TOP43          `TILE43.l2
    `define PITON_CORE43_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc43_inst_done
    `define PITON_CORE43_PC_W43     `TOP_MOD.monitor.pc_cmp.spc43_phy_pc_w

    

    `define TILE44            `CHIP.tile44
    `define ARIANE_CORE44     `TILE44.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP44         `TILE44.l15.l15
    `define L15_PIPE44        `TILE44.l15.l15.pipeline
    `define DMBR44            `TILE44.dmbr_ins
    `define L2_TOP44          `TILE44.l2
    `define PITON_CORE44_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc44_inst_done
    `define PITON_CORE44_PC_W44     `TOP_MOD.monitor.pc_cmp.spc44_phy_pc_w

    

    `define TILE45            `CHIP.tile45
    `define ARIANE_CORE45     `TILE45.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP45         `TILE45.l15.l15
    `define L15_PIPE45        `TILE45.l15.l15.pipeline
    `define DMBR45            `TILE45.dmbr_ins
    `define L2_TOP45          `TILE45.l2
    `define PITON_CORE45_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc45_inst_done
    `define PITON_CORE45_PC_W45     `TOP_MOD.monitor.pc_cmp.spc45_phy_pc_w

    

    `define TILE46            `CHIP.tile46
    `define ARIANE_CORE46     `TILE46.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP46         `TILE46.l15.l15
    `define L15_PIPE46        `TILE46.l15.l15.pipeline
    `define DMBR46            `TILE46.dmbr_ins
    `define L2_TOP46          `TILE46.l2
    `define PITON_CORE46_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc46_inst_done
    `define PITON_CORE46_PC_W46     `TOP_MOD.monitor.pc_cmp.spc46_phy_pc_w

    

    `define TILE47            `CHIP.tile47
    `define ARIANE_CORE47     `TILE47.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP47         `TILE47.l15.l15
    `define L15_PIPE47        `TILE47.l15.l15.pipeline
    `define DMBR47            `TILE47.dmbr_ins
    `define L2_TOP47          `TILE47.l2
    `define PITON_CORE47_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc47_inst_done
    `define PITON_CORE47_PC_W47     `TOP_MOD.monitor.pc_cmp.spc47_phy_pc_w

    

    `define TILE48            `CHIP.tile48
    `define ARIANE_CORE48     `TILE48.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP48         `TILE48.l15.l15
    `define L15_PIPE48        `TILE48.l15.l15.pipeline
    `define DMBR48            `TILE48.dmbr_ins
    `define L2_TOP48          `TILE48.l2
    `define PITON_CORE48_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc48_inst_done
    `define PITON_CORE48_PC_W48     `TOP_MOD.monitor.pc_cmp.spc48_phy_pc_w

    

    `define TILE49            `CHIP.tile49
    `define ARIANE_CORE49     `TILE49.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP49         `TILE49.l15.l15
    `define L15_PIPE49        `TILE49.l15.l15.pipeline
    `define DMBR49            `TILE49.dmbr_ins
    `define L2_TOP49          `TILE49.l2
    `define PITON_CORE49_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc49_inst_done
    `define PITON_CORE49_PC_W49     `TOP_MOD.monitor.pc_cmp.spc49_phy_pc_w

    

    `define TILE50            `CHIP.tile50
    `define ARIANE_CORE50     `TILE50.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP50         `TILE50.l15.l15
    `define L15_PIPE50        `TILE50.l15.l15.pipeline
    `define DMBR50            `TILE50.dmbr_ins
    `define L2_TOP50          `TILE50.l2
    `define PITON_CORE50_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc50_inst_done
    `define PITON_CORE50_PC_W50     `TOP_MOD.monitor.pc_cmp.spc50_phy_pc_w

    

    `define TILE51            `CHIP.tile51
    `define ARIANE_CORE51     `TILE51.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP51         `TILE51.l15.l15
    `define L15_PIPE51        `TILE51.l15.l15.pipeline
    `define DMBR51            `TILE51.dmbr_ins
    `define L2_TOP51          `TILE51.l2
    `define PITON_CORE51_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc51_inst_done
    `define PITON_CORE51_PC_W51     `TOP_MOD.monitor.pc_cmp.spc51_phy_pc_w

    

    `define TILE52            `CHIP.tile52
    `define ARIANE_CORE52     `TILE52.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP52         `TILE52.l15.l15
    `define L15_PIPE52        `TILE52.l15.l15.pipeline
    `define DMBR52            `TILE52.dmbr_ins
    `define L2_TOP52          `TILE52.l2
    `define PITON_CORE52_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc52_inst_done
    `define PITON_CORE52_PC_W52     `TOP_MOD.monitor.pc_cmp.spc52_phy_pc_w

    

    `define TILE53            `CHIP.tile53
    `define ARIANE_CORE53     `TILE53.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP53         `TILE53.l15.l15
    `define L15_PIPE53        `TILE53.l15.l15.pipeline
    `define DMBR53            `TILE53.dmbr_ins
    `define L2_TOP53          `TILE53.l2
    `define PITON_CORE53_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc53_inst_done
    `define PITON_CORE53_PC_W53     `TOP_MOD.monitor.pc_cmp.spc53_phy_pc_w

    

    `define TILE54            `CHIP.tile54
    `define ARIANE_CORE54     `TILE54.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP54         `TILE54.l15.l15
    `define L15_PIPE54        `TILE54.l15.l15.pipeline
    `define DMBR54            `TILE54.dmbr_ins
    `define L2_TOP54          `TILE54.l2
    `define PITON_CORE54_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc54_inst_done
    `define PITON_CORE54_PC_W54     `TOP_MOD.monitor.pc_cmp.spc54_phy_pc_w

    

    `define TILE55            `CHIP.tile55
    `define ARIANE_CORE55     `TILE55.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP55         `TILE55.l15.l15
    `define L15_PIPE55        `TILE55.l15.l15.pipeline
    `define DMBR55            `TILE55.dmbr_ins
    `define L2_TOP55          `TILE55.l2
    `define PITON_CORE55_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc55_inst_done
    `define PITON_CORE55_PC_W55     `TOP_MOD.monitor.pc_cmp.spc55_phy_pc_w

    

    `define TILE56            `CHIP.tile56
    `define ARIANE_CORE56     `TILE56.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP56         `TILE56.l15.l15
    `define L15_PIPE56        `TILE56.l15.l15.pipeline
    `define DMBR56            `TILE56.dmbr_ins
    `define L2_TOP56          `TILE56.l2
    `define PITON_CORE56_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc56_inst_done
    `define PITON_CORE56_PC_W56     `TOP_MOD.monitor.pc_cmp.spc56_phy_pc_w

    

    `define TILE57            `CHIP.tile57
    `define ARIANE_CORE57     `TILE57.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP57         `TILE57.l15.l15
    `define L15_PIPE57        `TILE57.l15.l15.pipeline
    `define DMBR57            `TILE57.dmbr_ins
    `define L2_TOP57          `TILE57.l2
    `define PITON_CORE57_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc57_inst_done
    `define PITON_CORE57_PC_W57     `TOP_MOD.monitor.pc_cmp.spc57_phy_pc_w

    

    `define TILE58            `CHIP.tile58
    `define ARIANE_CORE58     `TILE58.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP58         `TILE58.l15.l15
    `define L15_PIPE58        `TILE58.l15.l15.pipeline
    `define DMBR58            `TILE58.dmbr_ins
    `define L2_TOP58          `TILE58.l2
    `define PITON_CORE58_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc58_inst_done
    `define PITON_CORE58_PC_W58     `TOP_MOD.monitor.pc_cmp.spc58_phy_pc_w

    

    `define TILE59            `CHIP.tile59
    `define ARIANE_CORE59     `TILE59.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP59         `TILE59.l15.l15
    `define L15_PIPE59        `TILE59.l15.l15.pipeline
    `define DMBR59            `TILE59.dmbr_ins
    `define L2_TOP59          `TILE59.l2
    `define PITON_CORE59_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc59_inst_done
    `define PITON_CORE59_PC_W59     `TOP_MOD.monitor.pc_cmp.spc59_phy_pc_w

    

    `define TILE60            `CHIP.tile60
    `define ARIANE_CORE60     `TILE60.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP60         `TILE60.l15.l15
    `define L15_PIPE60        `TILE60.l15.l15.pipeline
    `define DMBR60            `TILE60.dmbr_ins
    `define L2_TOP60          `TILE60.l2
    `define PITON_CORE60_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc60_inst_done
    `define PITON_CORE60_PC_W60     `TOP_MOD.monitor.pc_cmp.spc60_phy_pc_w

    

    `define TILE61            `CHIP.tile61
    `define ARIANE_CORE61     `TILE61.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP61         `TILE61.l15.l15
    `define L15_PIPE61        `TILE61.l15.l15.pipeline
    `define DMBR61            `TILE61.dmbr_ins
    `define L2_TOP61          `TILE61.l2
    `define PITON_CORE61_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc61_inst_done
    `define PITON_CORE61_PC_W61     `TOP_MOD.monitor.pc_cmp.spc61_phy_pc_w

    

    `define TILE62            `CHIP.tile62
    `define ARIANE_CORE62     `TILE62.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP62         `TILE62.l15.l15
    `define L15_PIPE62        `TILE62.l15.l15.pipeline
    `define DMBR62            `TILE62.dmbr_ins
    `define L2_TOP62          `TILE62.l2
    `define PITON_CORE62_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc62_inst_done
    `define PITON_CORE62_PC_W62     `TOP_MOD.monitor.pc_cmp.spc62_phy_pc_w

    

    `define TILE63            `CHIP.tile63
    `define ARIANE_CORE63     `TILE63.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP63         `TILE63.l15.l15
    `define L15_PIPE63        `TILE63.l15.l15.pipeline
    `define DMBR63            `TILE63.dmbr_ins
    `define L2_TOP63          `TILE63.l2
    `define PITON_CORE63_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc63_inst_done
    `define PITON_CORE63_PC_W63     `TOP_MOD.monitor.pc_cmp.spc63_phy_pc_w

    

    `define TILE64            `CHIP.tile64
    `define ARIANE_CORE64     `TILE64.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP64         `TILE64.l15.l15
    `define L15_PIPE64        `TILE64.l15.l15.pipeline
    `define DMBR64            `TILE64.dmbr_ins
    `define L2_TOP64          `TILE64.l2
    `define PITON_CORE64_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc64_inst_done
    `define PITON_CORE64_PC_W64     `TOP_MOD.monitor.pc_cmp.spc64_phy_pc_w

    

    `define TILE65            `CHIP.tile65
    `define ARIANE_CORE65     `TILE65.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP65         `TILE65.l15.l15
    `define L15_PIPE65        `TILE65.l15.l15.pipeline
    `define DMBR65            `TILE65.dmbr_ins
    `define L2_TOP65          `TILE65.l2
    `define PITON_CORE65_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc65_inst_done
    `define PITON_CORE65_PC_W65     `TOP_MOD.monitor.pc_cmp.spc65_phy_pc_w

    

    `define TILE66            `CHIP.tile66
    `define ARIANE_CORE66     `TILE66.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP66         `TILE66.l15.l15
    `define L15_PIPE66        `TILE66.l15.l15.pipeline
    `define DMBR66            `TILE66.dmbr_ins
    `define L2_TOP66          `TILE66.l2
    `define PITON_CORE66_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc66_inst_done
    `define PITON_CORE66_PC_W66     `TOP_MOD.monitor.pc_cmp.spc66_phy_pc_w

    

    `define TILE67            `CHIP.tile67
    `define ARIANE_CORE67     `TILE67.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP67         `TILE67.l15.l15
    `define L15_PIPE67        `TILE67.l15.l15.pipeline
    `define DMBR67            `TILE67.dmbr_ins
    `define L2_TOP67          `TILE67.l2
    `define PITON_CORE67_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc67_inst_done
    `define PITON_CORE67_PC_W67     `TOP_MOD.monitor.pc_cmp.spc67_phy_pc_w

    

    `define TILE68            `CHIP.tile68
    `define ARIANE_CORE68     `TILE68.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP68         `TILE68.l15.l15
    `define L15_PIPE68        `TILE68.l15.l15.pipeline
    `define DMBR68            `TILE68.dmbr_ins
    `define L2_TOP68          `TILE68.l2
    `define PITON_CORE68_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc68_inst_done
    `define PITON_CORE68_PC_W68     `TOP_MOD.monitor.pc_cmp.spc68_phy_pc_w

    

    `define TILE69            `CHIP.tile69
    `define ARIANE_CORE69     `TILE69.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP69         `TILE69.l15.l15
    `define L15_PIPE69        `TILE69.l15.l15.pipeline
    `define DMBR69            `TILE69.dmbr_ins
    `define L2_TOP69          `TILE69.l2
    `define PITON_CORE69_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc69_inst_done
    `define PITON_CORE69_PC_W69     `TOP_MOD.monitor.pc_cmp.spc69_phy_pc_w

    

    `define TILE70            `CHIP.tile70
    `define ARIANE_CORE70     `TILE70.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP70         `TILE70.l15.l15
    `define L15_PIPE70        `TILE70.l15.l15.pipeline
    `define DMBR70            `TILE70.dmbr_ins
    `define L2_TOP70          `TILE70.l2
    `define PITON_CORE70_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc70_inst_done
    `define PITON_CORE70_PC_W70     `TOP_MOD.monitor.pc_cmp.spc70_phy_pc_w

    

    `define TILE71            `CHIP.tile71
    `define ARIANE_CORE71     `TILE71.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP71         `TILE71.l15.l15
    `define L15_PIPE71        `TILE71.l15.l15.pipeline
    `define DMBR71            `TILE71.dmbr_ins
    `define L2_TOP71          `TILE71.l2
    `define PITON_CORE71_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc71_inst_done
    `define PITON_CORE71_PC_W71     `TOP_MOD.monitor.pc_cmp.spc71_phy_pc_w

    

    `define TILE72            `CHIP.tile72
    `define ARIANE_CORE72     `TILE72.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP72         `TILE72.l15.l15
    `define L15_PIPE72        `TILE72.l15.l15.pipeline
    `define DMBR72            `TILE72.dmbr_ins
    `define L2_TOP72          `TILE72.l2
    `define PITON_CORE72_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc72_inst_done
    `define PITON_CORE72_PC_W72     `TOP_MOD.monitor.pc_cmp.spc72_phy_pc_w

    

    `define TILE73            `CHIP.tile73
    `define ARIANE_CORE73     `TILE73.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP73         `TILE73.l15.l15
    `define L15_PIPE73        `TILE73.l15.l15.pipeline
    `define DMBR73            `TILE73.dmbr_ins
    `define L2_TOP73          `TILE73.l2
    `define PITON_CORE73_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc73_inst_done
    `define PITON_CORE73_PC_W73     `TOP_MOD.monitor.pc_cmp.spc73_phy_pc_w

    

    `define TILE74            `CHIP.tile74
    `define ARIANE_CORE74     `TILE74.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP74         `TILE74.l15.l15
    `define L15_PIPE74        `TILE74.l15.l15.pipeline
    `define DMBR74            `TILE74.dmbr_ins
    `define L2_TOP74          `TILE74.l2
    `define PITON_CORE74_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc74_inst_done
    `define PITON_CORE74_PC_W74     `TOP_MOD.monitor.pc_cmp.spc74_phy_pc_w

    

    `define TILE75            `CHIP.tile75
    `define ARIANE_CORE75     `TILE75.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP75         `TILE75.l15.l15
    `define L15_PIPE75        `TILE75.l15.l15.pipeline
    `define DMBR75            `TILE75.dmbr_ins
    `define L2_TOP75          `TILE75.l2
    `define PITON_CORE75_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc75_inst_done
    `define PITON_CORE75_PC_W75     `TOP_MOD.monitor.pc_cmp.spc75_phy_pc_w

    

    `define TILE76            `CHIP.tile76
    `define ARIANE_CORE76     `TILE76.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP76         `TILE76.l15.l15
    `define L15_PIPE76        `TILE76.l15.l15.pipeline
    `define DMBR76            `TILE76.dmbr_ins
    `define L2_TOP76          `TILE76.l2
    `define PITON_CORE76_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc76_inst_done
    `define PITON_CORE76_PC_W76     `TOP_MOD.monitor.pc_cmp.spc76_phy_pc_w

    

    `define TILE77            `CHIP.tile77
    `define ARIANE_CORE77     `TILE77.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP77         `TILE77.l15.l15
    `define L15_PIPE77        `TILE77.l15.l15.pipeline
    `define DMBR77            `TILE77.dmbr_ins
    `define L2_TOP77          `TILE77.l2
    `define PITON_CORE77_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc77_inst_done
    `define PITON_CORE77_PC_W77     `TOP_MOD.monitor.pc_cmp.spc77_phy_pc_w

    

    `define TILE78            `CHIP.tile78
    `define ARIANE_CORE78     `TILE78.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP78         `TILE78.l15.l15
    `define L15_PIPE78        `TILE78.l15.l15.pipeline
    `define DMBR78            `TILE78.dmbr_ins
    `define L2_TOP78          `TILE78.l2
    `define PITON_CORE78_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc78_inst_done
    `define PITON_CORE78_PC_W78     `TOP_MOD.monitor.pc_cmp.spc78_phy_pc_w

    

    `define TILE79            `CHIP.tile79
    `define ARIANE_CORE79     `TILE79.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP79         `TILE79.l15.l15
    `define L15_PIPE79        `TILE79.l15.l15.pipeline
    `define DMBR79            `TILE79.dmbr_ins
    `define L2_TOP79          `TILE79.l2
    `define PITON_CORE79_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc79_inst_done
    `define PITON_CORE79_PC_W79     `TOP_MOD.monitor.pc_cmp.spc79_phy_pc_w

    

    `define TILE80            `CHIP.tile80
    `define ARIANE_CORE80     `TILE80.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP80         `TILE80.l15.l15
    `define L15_PIPE80        `TILE80.l15.l15.pipeline
    `define DMBR80            `TILE80.dmbr_ins
    `define L2_TOP80          `TILE80.l2
    `define PITON_CORE80_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc80_inst_done
    `define PITON_CORE80_PC_W80     `TOP_MOD.monitor.pc_cmp.spc80_phy_pc_w

    

    `define TILE81            `CHIP.tile81
    `define ARIANE_CORE81     `TILE81.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP81         `TILE81.l15.l15
    `define L15_PIPE81        `TILE81.l15.l15.pipeline
    `define DMBR81            `TILE81.dmbr_ins
    `define L2_TOP81          `TILE81.l2
    `define PITON_CORE81_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc81_inst_done
    `define PITON_CORE81_PC_W81     `TOP_MOD.monitor.pc_cmp.spc81_phy_pc_w

    

    `define TILE82            `CHIP.tile82
    `define ARIANE_CORE82     `TILE82.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP82         `TILE82.l15.l15
    `define L15_PIPE82        `TILE82.l15.l15.pipeline
    `define DMBR82            `TILE82.dmbr_ins
    `define L2_TOP82          `TILE82.l2
    `define PITON_CORE82_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc82_inst_done
    `define PITON_CORE82_PC_W82     `TOP_MOD.monitor.pc_cmp.spc82_phy_pc_w

    

    `define TILE83            `CHIP.tile83
    `define ARIANE_CORE83     `TILE83.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP83         `TILE83.l15.l15
    `define L15_PIPE83        `TILE83.l15.l15.pipeline
    `define DMBR83            `TILE83.dmbr_ins
    `define L2_TOP83          `TILE83.l2
    `define PITON_CORE83_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc83_inst_done
    `define PITON_CORE83_PC_W83     `TOP_MOD.monitor.pc_cmp.spc83_phy_pc_w

    

    `define TILE84            `CHIP.tile84
    `define ARIANE_CORE84     `TILE84.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP84         `TILE84.l15.l15
    `define L15_PIPE84        `TILE84.l15.l15.pipeline
    `define DMBR84            `TILE84.dmbr_ins
    `define L2_TOP84          `TILE84.l2
    `define PITON_CORE84_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc84_inst_done
    `define PITON_CORE84_PC_W84     `TOP_MOD.monitor.pc_cmp.spc84_phy_pc_w

    

    `define TILE85            `CHIP.tile85
    `define ARIANE_CORE85     `TILE85.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP85         `TILE85.l15.l15
    `define L15_PIPE85        `TILE85.l15.l15.pipeline
    `define DMBR85            `TILE85.dmbr_ins
    `define L2_TOP85          `TILE85.l2
    `define PITON_CORE85_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc85_inst_done
    `define PITON_CORE85_PC_W85     `TOP_MOD.monitor.pc_cmp.spc85_phy_pc_w

    

    `define TILE86            `CHIP.tile86
    `define ARIANE_CORE86     `TILE86.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP86         `TILE86.l15.l15
    `define L15_PIPE86        `TILE86.l15.l15.pipeline
    `define DMBR86            `TILE86.dmbr_ins
    `define L2_TOP86          `TILE86.l2
    `define PITON_CORE86_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc86_inst_done
    `define PITON_CORE86_PC_W86     `TOP_MOD.monitor.pc_cmp.spc86_phy_pc_w

    

    `define TILE87            `CHIP.tile87
    `define ARIANE_CORE87     `TILE87.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP87         `TILE87.l15.l15
    `define L15_PIPE87        `TILE87.l15.l15.pipeline
    `define DMBR87            `TILE87.dmbr_ins
    `define L2_TOP87          `TILE87.l2
    `define PITON_CORE87_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc87_inst_done
    `define PITON_CORE87_PC_W87     `TOP_MOD.monitor.pc_cmp.spc87_phy_pc_w

    

    `define TILE88            `CHIP.tile88
    `define ARIANE_CORE88     `TILE88.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP88         `TILE88.l15.l15
    `define L15_PIPE88        `TILE88.l15.l15.pipeline
    `define DMBR88            `TILE88.dmbr_ins
    `define L2_TOP88          `TILE88.l2
    `define PITON_CORE88_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc88_inst_done
    `define PITON_CORE88_PC_W88     `TOP_MOD.monitor.pc_cmp.spc88_phy_pc_w

    

    `define TILE89            `CHIP.tile89
    `define ARIANE_CORE89     `TILE89.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP89         `TILE89.l15.l15
    `define L15_PIPE89        `TILE89.l15.l15.pipeline
    `define DMBR89            `TILE89.dmbr_ins
    `define L2_TOP89          `TILE89.l2
    `define PITON_CORE89_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc89_inst_done
    `define PITON_CORE89_PC_W89     `TOP_MOD.monitor.pc_cmp.spc89_phy_pc_w

    

    `define TILE90            `CHIP.tile90
    `define ARIANE_CORE90     `TILE90.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP90         `TILE90.l15.l15
    `define L15_PIPE90        `TILE90.l15.l15.pipeline
    `define DMBR90            `TILE90.dmbr_ins
    `define L2_TOP90          `TILE90.l2
    `define PITON_CORE90_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc90_inst_done
    `define PITON_CORE90_PC_W90     `TOP_MOD.monitor.pc_cmp.spc90_phy_pc_w

    

    `define TILE91            `CHIP.tile91
    `define ARIANE_CORE91     `TILE91.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP91         `TILE91.l15.l15
    `define L15_PIPE91        `TILE91.l15.l15.pipeline
    `define DMBR91            `TILE91.dmbr_ins
    `define L2_TOP91          `TILE91.l2
    `define PITON_CORE91_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc91_inst_done
    `define PITON_CORE91_PC_W91     `TOP_MOD.monitor.pc_cmp.spc91_phy_pc_w

    

    `define TILE92            `CHIP.tile92
    `define ARIANE_CORE92     `TILE92.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP92         `TILE92.l15.l15
    `define L15_PIPE92        `TILE92.l15.l15.pipeline
    `define DMBR92            `TILE92.dmbr_ins
    `define L2_TOP92          `TILE92.l2
    `define PITON_CORE92_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc92_inst_done
    `define PITON_CORE92_PC_W92     `TOP_MOD.monitor.pc_cmp.spc92_phy_pc_w

    

    `define TILE93            `CHIP.tile93
    `define ARIANE_CORE93     `TILE93.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP93         `TILE93.l15.l15
    `define L15_PIPE93        `TILE93.l15.l15.pipeline
    `define DMBR93            `TILE93.dmbr_ins
    `define L2_TOP93          `TILE93.l2
    `define PITON_CORE93_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc93_inst_done
    `define PITON_CORE93_PC_W93     `TOP_MOD.monitor.pc_cmp.spc93_phy_pc_w

    

    `define TILE94            `CHIP.tile94
    `define ARIANE_CORE94     `TILE94.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP94         `TILE94.l15.l15
    `define L15_PIPE94        `TILE94.l15.l15.pipeline
    `define DMBR94            `TILE94.dmbr_ins
    `define L2_TOP94          `TILE94.l2
    `define PITON_CORE94_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc94_inst_done
    `define PITON_CORE94_PC_W94     `TOP_MOD.monitor.pc_cmp.spc94_phy_pc_w

    

    `define TILE95            `CHIP.tile95
    `define ARIANE_CORE95     `TILE95.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP95         `TILE95.l15.l15
    `define L15_PIPE95        `TILE95.l15.l15.pipeline
    `define DMBR95            `TILE95.dmbr_ins
    `define L2_TOP95          `TILE95.l2
    `define PITON_CORE95_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc95_inst_done
    `define PITON_CORE95_PC_W95     `TOP_MOD.monitor.pc_cmp.spc95_phy_pc_w

    

    `define TILE96            `CHIP.tile96
    `define ARIANE_CORE96     `TILE96.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP96         `TILE96.l15.l15
    `define L15_PIPE96        `TILE96.l15.l15.pipeline
    `define DMBR96            `TILE96.dmbr_ins
    `define L2_TOP96          `TILE96.l2
    `define PITON_CORE96_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc96_inst_done
    `define PITON_CORE96_PC_W96     `TOP_MOD.monitor.pc_cmp.spc96_phy_pc_w

    

    `define TILE97            `CHIP.tile97
    `define ARIANE_CORE97     `TILE97.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP97         `TILE97.l15.l15
    `define L15_PIPE97        `TILE97.l15.l15.pipeline
    `define DMBR97            `TILE97.dmbr_ins
    `define L2_TOP97          `TILE97.l2
    `define PITON_CORE97_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc97_inst_done
    `define PITON_CORE97_PC_W97     `TOP_MOD.monitor.pc_cmp.spc97_phy_pc_w

    

    `define TILE98            `CHIP.tile98
    `define ARIANE_CORE98     `TILE98.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP98         `TILE98.l15.l15
    `define L15_PIPE98        `TILE98.l15.l15.pipeline
    `define DMBR98            `TILE98.dmbr_ins
    `define L2_TOP98          `TILE98.l2
    `define PITON_CORE98_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc98_inst_done
    `define PITON_CORE98_PC_W98     `TOP_MOD.monitor.pc_cmp.spc98_phy_pc_w

    

    `define TILE99            `CHIP.tile99
    `define ARIANE_CORE99     `TILE99.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP99         `TILE99.l15.l15
    `define L15_PIPE99        `TILE99.l15.l15.pipeline
    `define DMBR99            `TILE99.dmbr_ins
    `define L2_TOP99          `TILE99.l2
    `define PITON_CORE99_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc99_inst_done
    `define PITON_CORE99_PC_W99     `TOP_MOD.monitor.pc_cmp.spc99_phy_pc_w

    

    `define TILE100            `CHIP.tile100
    `define ARIANE_CORE100     `TILE100.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP100         `TILE100.l15.l15
    `define L15_PIPE100        `TILE100.l15.l15.pipeline
    `define DMBR100            `TILE100.dmbr_ins
    `define L2_TOP100          `TILE100.l2
    `define PITON_CORE100_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc100_inst_done
    `define PITON_CORE100_PC_W100     `TOP_MOD.monitor.pc_cmp.spc100_phy_pc_w

    

    `define TILE101            `CHIP.tile101
    `define ARIANE_CORE101     `TILE101.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP101         `TILE101.l15.l15
    `define L15_PIPE101        `TILE101.l15.l15.pipeline
    `define DMBR101            `TILE101.dmbr_ins
    `define L2_TOP101          `TILE101.l2
    `define PITON_CORE101_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc101_inst_done
    `define PITON_CORE101_PC_W101     `TOP_MOD.monitor.pc_cmp.spc101_phy_pc_w

    

    `define TILE102            `CHIP.tile102
    `define ARIANE_CORE102     `TILE102.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP102         `TILE102.l15.l15
    `define L15_PIPE102        `TILE102.l15.l15.pipeline
    `define DMBR102            `TILE102.dmbr_ins
    `define L2_TOP102          `TILE102.l2
    `define PITON_CORE102_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc102_inst_done
    `define PITON_CORE102_PC_W102     `TOP_MOD.monitor.pc_cmp.spc102_phy_pc_w

    

    `define TILE103            `CHIP.tile103
    `define ARIANE_CORE103     `TILE103.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP103         `TILE103.l15.l15
    `define L15_PIPE103        `TILE103.l15.l15.pipeline
    `define DMBR103            `TILE103.dmbr_ins
    `define L2_TOP103          `TILE103.l2
    `define PITON_CORE103_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc103_inst_done
    `define PITON_CORE103_PC_W103     `TOP_MOD.monitor.pc_cmp.spc103_phy_pc_w

    

    `define TILE104            `CHIP.tile104
    `define ARIANE_CORE104     `TILE104.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP104         `TILE104.l15.l15
    `define L15_PIPE104        `TILE104.l15.l15.pipeline
    `define DMBR104            `TILE104.dmbr_ins
    `define L2_TOP104          `TILE104.l2
    `define PITON_CORE104_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc104_inst_done
    `define PITON_CORE104_PC_W104     `TOP_MOD.monitor.pc_cmp.spc104_phy_pc_w

    

    `define TILE105            `CHIP.tile105
    `define ARIANE_CORE105     `TILE105.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP105         `TILE105.l15.l15
    `define L15_PIPE105        `TILE105.l15.l15.pipeline
    `define DMBR105            `TILE105.dmbr_ins
    `define L2_TOP105          `TILE105.l2
    `define PITON_CORE105_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc105_inst_done
    `define PITON_CORE105_PC_W105     `TOP_MOD.monitor.pc_cmp.spc105_phy_pc_w

    

    `define TILE106            `CHIP.tile106
    `define ARIANE_CORE106     `TILE106.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP106         `TILE106.l15.l15
    `define L15_PIPE106        `TILE106.l15.l15.pipeline
    `define DMBR106            `TILE106.dmbr_ins
    `define L2_TOP106          `TILE106.l2
    `define PITON_CORE106_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc106_inst_done
    `define PITON_CORE106_PC_W106     `TOP_MOD.monitor.pc_cmp.spc106_phy_pc_w

    

    `define TILE107            `CHIP.tile107
    `define ARIANE_CORE107     `TILE107.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP107         `TILE107.l15.l15
    `define L15_PIPE107        `TILE107.l15.l15.pipeline
    `define DMBR107            `TILE107.dmbr_ins
    `define L2_TOP107          `TILE107.l2
    `define PITON_CORE107_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc107_inst_done
    `define PITON_CORE107_PC_W107     `TOP_MOD.monitor.pc_cmp.spc107_phy_pc_w

    

    `define TILE108            `CHIP.tile108
    `define ARIANE_CORE108     `TILE108.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP108         `TILE108.l15.l15
    `define L15_PIPE108        `TILE108.l15.l15.pipeline
    `define DMBR108            `TILE108.dmbr_ins
    `define L2_TOP108          `TILE108.l2
    `define PITON_CORE108_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc108_inst_done
    `define PITON_CORE108_PC_W108     `TOP_MOD.monitor.pc_cmp.spc108_phy_pc_w

    

    `define TILE109            `CHIP.tile109
    `define ARIANE_CORE109     `TILE109.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP109         `TILE109.l15.l15
    `define L15_PIPE109        `TILE109.l15.l15.pipeline
    `define DMBR109            `TILE109.dmbr_ins
    `define L2_TOP109          `TILE109.l2
    `define PITON_CORE109_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc109_inst_done
    `define PITON_CORE109_PC_W109     `TOP_MOD.monitor.pc_cmp.spc109_phy_pc_w

    

    `define TILE110            `CHIP.tile110
    `define ARIANE_CORE110     `TILE110.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP110         `TILE110.l15.l15
    `define L15_PIPE110        `TILE110.l15.l15.pipeline
    `define DMBR110            `TILE110.dmbr_ins
    `define L2_TOP110          `TILE110.l2
    `define PITON_CORE110_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc110_inst_done
    `define PITON_CORE110_PC_W110     `TOP_MOD.monitor.pc_cmp.spc110_phy_pc_w

    

    `define TILE111            `CHIP.tile111
    `define ARIANE_CORE111     `TILE111.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP111         `TILE111.l15.l15
    `define L15_PIPE111        `TILE111.l15.l15.pipeline
    `define DMBR111            `TILE111.dmbr_ins
    `define L2_TOP111          `TILE111.l2
    `define PITON_CORE111_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc111_inst_done
    `define PITON_CORE111_PC_W111     `TOP_MOD.monitor.pc_cmp.spc111_phy_pc_w

    

    `define TILE112            `CHIP.tile112
    `define ARIANE_CORE112     `TILE112.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP112         `TILE112.l15.l15
    `define L15_PIPE112        `TILE112.l15.l15.pipeline
    `define DMBR112            `TILE112.dmbr_ins
    `define L2_TOP112          `TILE112.l2
    `define PITON_CORE112_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc112_inst_done
    `define PITON_CORE112_PC_W112     `TOP_MOD.monitor.pc_cmp.spc112_phy_pc_w

    

    `define TILE113            `CHIP.tile113
    `define ARIANE_CORE113     `TILE113.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP113         `TILE113.l15.l15
    `define L15_PIPE113        `TILE113.l15.l15.pipeline
    `define DMBR113            `TILE113.dmbr_ins
    `define L2_TOP113          `TILE113.l2
    `define PITON_CORE113_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc113_inst_done
    `define PITON_CORE113_PC_W113     `TOP_MOD.monitor.pc_cmp.spc113_phy_pc_w

    

    `define TILE114            `CHIP.tile114
    `define ARIANE_CORE114     `TILE114.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP114         `TILE114.l15.l15
    `define L15_PIPE114        `TILE114.l15.l15.pipeline
    `define DMBR114            `TILE114.dmbr_ins
    `define L2_TOP114          `TILE114.l2
    `define PITON_CORE114_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc114_inst_done
    `define PITON_CORE114_PC_W114     `TOP_MOD.monitor.pc_cmp.spc114_phy_pc_w

    

    `define TILE115            `CHIP.tile115
    `define ARIANE_CORE115     `TILE115.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP115         `TILE115.l15.l15
    `define L15_PIPE115        `TILE115.l15.l15.pipeline
    `define DMBR115            `TILE115.dmbr_ins
    `define L2_TOP115          `TILE115.l2
    `define PITON_CORE115_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc115_inst_done
    `define PITON_CORE115_PC_W115     `TOP_MOD.monitor.pc_cmp.spc115_phy_pc_w

    

    `define TILE116            `CHIP.tile116
    `define ARIANE_CORE116     `TILE116.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP116         `TILE116.l15.l15
    `define L15_PIPE116        `TILE116.l15.l15.pipeline
    `define DMBR116            `TILE116.dmbr_ins
    `define L2_TOP116          `TILE116.l2
    `define PITON_CORE116_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc116_inst_done
    `define PITON_CORE116_PC_W116     `TOP_MOD.monitor.pc_cmp.spc116_phy_pc_w

    

    `define TILE117            `CHIP.tile117
    `define ARIANE_CORE117     `TILE117.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP117         `TILE117.l15.l15
    `define L15_PIPE117        `TILE117.l15.l15.pipeline
    `define DMBR117            `TILE117.dmbr_ins
    `define L2_TOP117          `TILE117.l2
    `define PITON_CORE117_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc117_inst_done
    `define PITON_CORE117_PC_W117     `TOP_MOD.monitor.pc_cmp.spc117_phy_pc_w

    

    `define TILE118            `CHIP.tile118
    `define ARIANE_CORE118     `TILE118.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP118         `TILE118.l15.l15
    `define L15_PIPE118        `TILE118.l15.l15.pipeline
    `define DMBR118            `TILE118.dmbr_ins
    `define L2_TOP118          `TILE118.l2
    `define PITON_CORE118_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc118_inst_done
    `define PITON_CORE118_PC_W118     `TOP_MOD.monitor.pc_cmp.spc118_phy_pc_w

    

    `define TILE119            `CHIP.tile119
    `define ARIANE_CORE119     `TILE119.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP119         `TILE119.l15.l15
    `define L15_PIPE119        `TILE119.l15.l15.pipeline
    `define DMBR119            `TILE119.dmbr_ins
    `define L2_TOP119          `TILE119.l2
    `define PITON_CORE119_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc119_inst_done
    `define PITON_CORE119_PC_W119     `TOP_MOD.monitor.pc_cmp.spc119_phy_pc_w

    

    `define TILE120            `CHIP.tile120
    `define ARIANE_CORE120     `TILE120.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP120         `TILE120.l15.l15
    `define L15_PIPE120        `TILE120.l15.l15.pipeline
    `define DMBR120            `TILE120.dmbr_ins
    `define L2_TOP120          `TILE120.l2
    `define PITON_CORE120_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc120_inst_done
    `define PITON_CORE120_PC_W120     `TOP_MOD.monitor.pc_cmp.spc120_phy_pc_w

    

    `define TILE121            `CHIP.tile121
    `define ARIANE_CORE121     `TILE121.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP121         `TILE121.l15.l15
    `define L15_PIPE121        `TILE121.l15.l15.pipeline
    `define DMBR121            `TILE121.dmbr_ins
    `define L2_TOP121          `TILE121.l2
    `define PITON_CORE121_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc121_inst_done
    `define PITON_CORE121_PC_W121     `TOP_MOD.monitor.pc_cmp.spc121_phy_pc_w

    

    `define TILE122            `CHIP.tile122
    `define ARIANE_CORE122     `TILE122.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP122         `TILE122.l15.l15
    `define L15_PIPE122        `TILE122.l15.l15.pipeline
    `define DMBR122            `TILE122.dmbr_ins
    `define L2_TOP122          `TILE122.l2
    `define PITON_CORE122_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc122_inst_done
    `define PITON_CORE122_PC_W122     `TOP_MOD.monitor.pc_cmp.spc122_phy_pc_w

    

    `define TILE123            `CHIP.tile123
    `define ARIANE_CORE123     `TILE123.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP123         `TILE123.l15.l15
    `define L15_PIPE123        `TILE123.l15.l15.pipeline
    `define DMBR123            `TILE123.dmbr_ins
    `define L2_TOP123          `TILE123.l2
    `define PITON_CORE123_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc123_inst_done
    `define PITON_CORE123_PC_W123     `TOP_MOD.monitor.pc_cmp.spc123_phy_pc_w

    

    `define TILE124            `CHIP.tile124
    `define ARIANE_CORE124     `TILE124.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP124         `TILE124.l15.l15
    `define L15_PIPE124        `TILE124.l15.l15.pipeline
    `define DMBR124            `TILE124.dmbr_ins
    `define L2_TOP124          `TILE124.l2
    `define PITON_CORE124_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc124_inst_done
    `define PITON_CORE124_PC_W124     `TOP_MOD.monitor.pc_cmp.spc124_phy_pc_w

    

    `define TILE125            `CHIP.tile125
    `define ARIANE_CORE125     `TILE125.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP125         `TILE125.l15.l15
    `define L15_PIPE125        `TILE125.l15.l15.pipeline
    `define DMBR125            `TILE125.dmbr_ins
    `define L2_TOP125          `TILE125.l2
    `define PITON_CORE125_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc125_inst_done
    `define PITON_CORE125_PC_W125     `TOP_MOD.monitor.pc_cmp.spc125_phy_pc_w

    

    `define TILE126            `CHIP.tile126
    `define ARIANE_CORE126     `TILE126.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP126         `TILE126.l15.l15
    `define L15_PIPE126        `TILE126.l15.l15.pipeline
    `define DMBR126            `TILE126.dmbr_ins
    `define L2_TOP126          `TILE126.l2
    `define PITON_CORE126_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc126_inst_done
    `define PITON_CORE126_PC_W126     `TOP_MOD.monitor.pc_cmp.spc126_phy_pc_w

    

    `define TILE127            `CHIP.tile127
    `define ARIANE_CORE127     `TILE127.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP127         `TILE127.l15.l15
    `define L15_PIPE127        `TILE127.l15.l15.pipeline
    `define DMBR127            `TILE127.dmbr_ins
    `define L2_TOP127          `TILE127.l2
    `define PITON_CORE127_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc127_inst_done
    `define PITON_CORE127_PC_W127     `TOP_MOD.monitor.pc_cmp.spc127_phy_pc_w

    

    `define TILE128            `CHIP.tile128
    `define ARIANE_CORE128     `TILE128.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP128         `TILE128.l15.l15
    `define L15_PIPE128        `TILE128.l15.l15.pipeline
    `define DMBR128            `TILE128.dmbr_ins
    `define L2_TOP128          `TILE128.l2
    `define PITON_CORE128_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc128_inst_done
    `define PITON_CORE128_PC_W128     `TOP_MOD.monitor.pc_cmp.spc128_phy_pc_w

    

    `define TILE129            `CHIP.tile129
    `define ARIANE_CORE129     `TILE129.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP129         `TILE129.l15.l15
    `define L15_PIPE129        `TILE129.l15.l15.pipeline
    `define DMBR129            `TILE129.dmbr_ins
    `define L2_TOP129          `TILE129.l2
    `define PITON_CORE129_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc129_inst_done
    `define PITON_CORE129_PC_W129     `TOP_MOD.monitor.pc_cmp.spc129_phy_pc_w

    

    `define TILE130            `CHIP.tile130
    `define ARIANE_CORE130     `TILE130.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP130         `TILE130.l15.l15
    `define L15_PIPE130        `TILE130.l15.l15.pipeline
    `define DMBR130            `TILE130.dmbr_ins
    `define L2_TOP130          `TILE130.l2
    `define PITON_CORE130_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc130_inst_done
    `define PITON_CORE130_PC_W130     `TOP_MOD.monitor.pc_cmp.spc130_phy_pc_w

    

    `define TILE131            `CHIP.tile131
    `define ARIANE_CORE131     `TILE131.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP131         `TILE131.l15.l15
    `define L15_PIPE131        `TILE131.l15.l15.pipeline
    `define DMBR131            `TILE131.dmbr_ins
    `define L2_TOP131          `TILE131.l2
    `define PITON_CORE131_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc131_inst_done
    `define PITON_CORE131_PC_W131     `TOP_MOD.monitor.pc_cmp.spc131_phy_pc_w

    

    `define TILE132            `CHIP.tile132
    `define ARIANE_CORE132     `TILE132.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP132         `TILE132.l15.l15
    `define L15_PIPE132        `TILE132.l15.l15.pipeline
    `define DMBR132            `TILE132.dmbr_ins
    `define L2_TOP132          `TILE132.l2
    `define PITON_CORE132_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc132_inst_done
    `define PITON_CORE132_PC_W132     `TOP_MOD.monitor.pc_cmp.spc132_phy_pc_w

    

    `define TILE133            `CHIP.tile133
    `define ARIANE_CORE133     `TILE133.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP133         `TILE133.l15.l15
    `define L15_PIPE133        `TILE133.l15.l15.pipeline
    `define DMBR133            `TILE133.dmbr_ins
    `define L2_TOP133          `TILE133.l2
    `define PITON_CORE133_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc133_inst_done
    `define PITON_CORE133_PC_W133     `TOP_MOD.monitor.pc_cmp.spc133_phy_pc_w

    

    `define TILE134            `CHIP.tile134
    `define ARIANE_CORE134     `TILE134.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP134         `TILE134.l15.l15
    `define L15_PIPE134        `TILE134.l15.l15.pipeline
    `define DMBR134            `TILE134.dmbr_ins
    `define L2_TOP134          `TILE134.l2
    `define PITON_CORE134_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc134_inst_done
    `define PITON_CORE134_PC_W134     `TOP_MOD.monitor.pc_cmp.spc134_phy_pc_w

    

    `define TILE135            `CHIP.tile135
    `define ARIANE_CORE135     `TILE135.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP135         `TILE135.l15.l15
    `define L15_PIPE135        `TILE135.l15.l15.pipeline
    `define DMBR135            `TILE135.dmbr_ins
    `define L2_TOP135          `TILE135.l2
    `define PITON_CORE135_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc135_inst_done
    `define PITON_CORE135_PC_W135     `TOP_MOD.monitor.pc_cmp.spc135_phy_pc_w

    

    `define TILE136            `CHIP.tile136
    `define ARIANE_CORE136     `TILE136.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP136         `TILE136.l15.l15
    `define L15_PIPE136        `TILE136.l15.l15.pipeline
    `define DMBR136            `TILE136.dmbr_ins
    `define L2_TOP136          `TILE136.l2
    `define PITON_CORE136_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc136_inst_done
    `define PITON_CORE136_PC_W136     `TOP_MOD.monitor.pc_cmp.spc136_phy_pc_w

    

    `define TILE137            `CHIP.tile137
    `define ARIANE_CORE137     `TILE137.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP137         `TILE137.l15.l15
    `define L15_PIPE137        `TILE137.l15.l15.pipeline
    `define DMBR137            `TILE137.dmbr_ins
    `define L2_TOP137          `TILE137.l2
    `define PITON_CORE137_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc137_inst_done
    `define PITON_CORE137_PC_W137     `TOP_MOD.monitor.pc_cmp.spc137_phy_pc_w

    

    `define TILE138            `CHIP.tile138
    `define ARIANE_CORE138     `TILE138.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP138         `TILE138.l15.l15
    `define L15_PIPE138        `TILE138.l15.l15.pipeline
    `define DMBR138            `TILE138.dmbr_ins
    `define L2_TOP138          `TILE138.l2
    `define PITON_CORE138_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc138_inst_done
    `define PITON_CORE138_PC_W138     `TOP_MOD.monitor.pc_cmp.spc138_phy_pc_w

    

    `define TILE139            `CHIP.tile139
    `define ARIANE_CORE139     `TILE139.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP139         `TILE139.l15.l15
    `define L15_PIPE139        `TILE139.l15.l15.pipeline
    `define DMBR139            `TILE139.dmbr_ins
    `define L2_TOP139          `TILE139.l2
    `define PITON_CORE139_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc139_inst_done
    `define PITON_CORE139_PC_W139     `TOP_MOD.monitor.pc_cmp.spc139_phy_pc_w

    

    `define TILE140            `CHIP.tile140
    `define ARIANE_CORE140     `TILE140.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP140         `TILE140.l15.l15
    `define L15_PIPE140        `TILE140.l15.l15.pipeline
    `define DMBR140            `TILE140.dmbr_ins
    `define L2_TOP140          `TILE140.l2
    `define PITON_CORE140_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc140_inst_done
    `define PITON_CORE140_PC_W140     `TOP_MOD.monitor.pc_cmp.spc140_phy_pc_w

    

    `define TILE141            `CHIP.tile141
    `define ARIANE_CORE141     `TILE141.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP141         `TILE141.l15.l15
    `define L15_PIPE141        `TILE141.l15.l15.pipeline
    `define DMBR141            `TILE141.dmbr_ins
    `define L2_TOP141          `TILE141.l2
    `define PITON_CORE141_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc141_inst_done
    `define PITON_CORE141_PC_W141     `TOP_MOD.monitor.pc_cmp.spc141_phy_pc_w

    

    `define TILE142            `CHIP.tile142
    `define ARIANE_CORE142     `TILE142.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP142         `TILE142.l15.l15
    `define L15_PIPE142        `TILE142.l15.l15.pipeline
    `define DMBR142            `TILE142.dmbr_ins
    `define L2_TOP142          `TILE142.l2
    `define PITON_CORE142_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc142_inst_done
    `define PITON_CORE142_PC_W142     `TOP_MOD.monitor.pc_cmp.spc142_phy_pc_w

    

    `define TILE143            `CHIP.tile143
    `define ARIANE_CORE143     `TILE143.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP143         `TILE143.l15.l15
    `define L15_PIPE143        `TILE143.l15.l15.pipeline
    `define DMBR143            `TILE143.dmbr_ins
    `define L2_TOP143          `TILE143.l2
    `define PITON_CORE143_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc143_inst_done
    `define PITON_CORE143_PC_W143     `TOP_MOD.monitor.pc_cmp.spc143_phy_pc_w

    

    `define TILE144            `CHIP.tile144
    `define ARIANE_CORE144     `TILE144.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP144         `TILE144.l15.l15
    `define L15_PIPE144        `TILE144.l15.l15.pipeline
    `define DMBR144            `TILE144.dmbr_ins
    `define L2_TOP144          `TILE144.l2
    `define PITON_CORE144_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc144_inst_done
    `define PITON_CORE144_PC_W144     `TOP_MOD.monitor.pc_cmp.spc144_phy_pc_w

    

    `define TILE145            `CHIP.tile145
    `define ARIANE_CORE145     `TILE145.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP145         `TILE145.l15.l15
    `define L15_PIPE145        `TILE145.l15.l15.pipeline
    `define DMBR145            `TILE145.dmbr_ins
    `define L2_TOP145          `TILE145.l2
    `define PITON_CORE145_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc145_inst_done
    `define PITON_CORE145_PC_W145     `TOP_MOD.monitor.pc_cmp.spc145_phy_pc_w

    

    `define TILE146            `CHIP.tile146
    `define ARIANE_CORE146     `TILE146.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP146         `TILE146.l15.l15
    `define L15_PIPE146        `TILE146.l15.l15.pipeline
    `define DMBR146            `TILE146.dmbr_ins
    `define L2_TOP146          `TILE146.l2
    `define PITON_CORE146_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc146_inst_done
    `define PITON_CORE146_PC_W146     `TOP_MOD.monitor.pc_cmp.spc146_phy_pc_w

    

    `define TILE147            `CHIP.tile147
    `define ARIANE_CORE147     `TILE147.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP147         `TILE147.l15.l15
    `define L15_PIPE147        `TILE147.l15.l15.pipeline
    `define DMBR147            `TILE147.dmbr_ins
    `define L2_TOP147          `TILE147.l2
    `define PITON_CORE147_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc147_inst_done
    `define PITON_CORE147_PC_W147     `TOP_MOD.monitor.pc_cmp.spc147_phy_pc_w

    

    `define TILE148            `CHIP.tile148
    `define ARIANE_CORE148     `TILE148.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP148         `TILE148.l15.l15
    `define L15_PIPE148        `TILE148.l15.l15.pipeline
    `define DMBR148            `TILE148.dmbr_ins
    `define L2_TOP148          `TILE148.l2
    `define PITON_CORE148_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc148_inst_done
    `define PITON_CORE148_PC_W148     `TOP_MOD.monitor.pc_cmp.spc148_phy_pc_w

    

    `define TILE149            `CHIP.tile149
    `define ARIANE_CORE149     `TILE149.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP149         `TILE149.l15.l15
    `define L15_PIPE149        `TILE149.l15.l15.pipeline
    `define DMBR149            `TILE149.dmbr_ins
    `define L2_TOP149          `TILE149.l2
    `define PITON_CORE149_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc149_inst_done
    `define PITON_CORE149_PC_W149     `TOP_MOD.monitor.pc_cmp.spc149_phy_pc_w

    

    `define TILE150            `CHIP.tile150
    `define ARIANE_CORE150     `TILE150.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP150         `TILE150.l15.l15
    `define L15_PIPE150        `TILE150.l15.l15.pipeline
    `define DMBR150            `TILE150.dmbr_ins
    `define L2_TOP150          `TILE150.l2
    `define PITON_CORE150_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc150_inst_done
    `define PITON_CORE150_PC_W150     `TOP_MOD.monitor.pc_cmp.spc150_phy_pc_w

    

    `define TILE151            `CHIP.tile151
    `define ARIANE_CORE151     `TILE151.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP151         `TILE151.l15.l15
    `define L15_PIPE151        `TILE151.l15.l15.pipeline
    `define DMBR151            `TILE151.dmbr_ins
    `define L2_TOP151          `TILE151.l2
    `define PITON_CORE151_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc151_inst_done
    `define PITON_CORE151_PC_W151     `TOP_MOD.monitor.pc_cmp.spc151_phy_pc_w

    

    `define TILE152            `CHIP.tile152
    `define ARIANE_CORE152     `TILE152.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP152         `TILE152.l15.l15
    `define L15_PIPE152        `TILE152.l15.l15.pipeline
    `define DMBR152            `TILE152.dmbr_ins
    `define L2_TOP152          `TILE152.l2
    `define PITON_CORE152_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc152_inst_done
    `define PITON_CORE152_PC_W152     `TOP_MOD.monitor.pc_cmp.spc152_phy_pc_w

    

    `define TILE153            `CHIP.tile153
    `define ARIANE_CORE153     `TILE153.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP153         `TILE153.l15.l15
    `define L15_PIPE153        `TILE153.l15.l15.pipeline
    `define DMBR153            `TILE153.dmbr_ins
    `define L2_TOP153          `TILE153.l2
    `define PITON_CORE153_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc153_inst_done
    `define PITON_CORE153_PC_W153     `TOP_MOD.monitor.pc_cmp.spc153_phy_pc_w

    

    `define TILE154            `CHIP.tile154
    `define ARIANE_CORE154     `TILE154.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP154         `TILE154.l15.l15
    `define L15_PIPE154        `TILE154.l15.l15.pipeline
    `define DMBR154            `TILE154.dmbr_ins
    `define L2_TOP154          `TILE154.l2
    `define PITON_CORE154_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc154_inst_done
    `define PITON_CORE154_PC_W154     `TOP_MOD.monitor.pc_cmp.spc154_phy_pc_w

    

    `define TILE155            `CHIP.tile155
    `define ARIANE_CORE155     `TILE155.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP155         `TILE155.l15.l15
    `define L15_PIPE155        `TILE155.l15.l15.pipeline
    `define DMBR155            `TILE155.dmbr_ins
    `define L2_TOP155          `TILE155.l2
    `define PITON_CORE155_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc155_inst_done
    `define PITON_CORE155_PC_W155     `TOP_MOD.monitor.pc_cmp.spc155_phy_pc_w

    

    `define TILE156            `CHIP.tile156
    `define ARIANE_CORE156     `TILE156.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP156         `TILE156.l15.l15
    `define L15_PIPE156        `TILE156.l15.l15.pipeline
    `define DMBR156            `TILE156.dmbr_ins
    `define L2_TOP156          `TILE156.l2
    `define PITON_CORE156_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc156_inst_done
    `define PITON_CORE156_PC_W156     `TOP_MOD.monitor.pc_cmp.spc156_phy_pc_w

    

    `define TILE157            `CHIP.tile157
    `define ARIANE_CORE157     `TILE157.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP157         `TILE157.l15.l15
    `define L15_PIPE157        `TILE157.l15.l15.pipeline
    `define DMBR157            `TILE157.dmbr_ins
    `define L2_TOP157          `TILE157.l2
    `define PITON_CORE157_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc157_inst_done
    `define PITON_CORE157_PC_W157     `TOP_MOD.monitor.pc_cmp.spc157_phy_pc_w

    

    `define TILE158            `CHIP.tile158
    `define ARIANE_CORE158     `TILE158.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP158         `TILE158.l15.l15
    `define L15_PIPE158        `TILE158.l15.l15.pipeline
    `define DMBR158            `TILE158.dmbr_ins
    `define L2_TOP158          `TILE158.l2
    `define PITON_CORE158_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc158_inst_done
    `define PITON_CORE158_PC_W158     `TOP_MOD.monitor.pc_cmp.spc158_phy_pc_w

    

    `define TILE159            `CHIP.tile159
    `define ARIANE_CORE159     `TILE159.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP159         `TILE159.l15.l15
    `define L15_PIPE159        `TILE159.l15.l15.pipeline
    `define DMBR159            `TILE159.dmbr_ins
    `define L2_TOP159          `TILE159.l2
    `define PITON_CORE159_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc159_inst_done
    `define PITON_CORE159_PC_W159     `TOP_MOD.monitor.pc_cmp.spc159_phy_pc_w

    

    `define TILE160            `CHIP.tile160
    `define ARIANE_CORE160     `TILE160.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP160         `TILE160.l15.l15
    `define L15_PIPE160        `TILE160.l15.l15.pipeline
    `define DMBR160            `TILE160.dmbr_ins
    `define L2_TOP160          `TILE160.l2
    `define PITON_CORE160_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc160_inst_done
    `define PITON_CORE160_PC_W160     `TOP_MOD.monitor.pc_cmp.spc160_phy_pc_w

    

    `define TILE161            `CHIP.tile161
    `define ARIANE_CORE161     `TILE161.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP161         `TILE161.l15.l15
    `define L15_PIPE161        `TILE161.l15.l15.pipeline
    `define DMBR161            `TILE161.dmbr_ins
    `define L2_TOP161          `TILE161.l2
    `define PITON_CORE161_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc161_inst_done
    `define PITON_CORE161_PC_W161     `TOP_MOD.monitor.pc_cmp.spc161_phy_pc_w

    

    `define TILE162            `CHIP.tile162
    `define ARIANE_CORE162     `TILE162.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP162         `TILE162.l15.l15
    `define L15_PIPE162        `TILE162.l15.l15.pipeline
    `define DMBR162            `TILE162.dmbr_ins
    `define L2_TOP162          `TILE162.l2
    `define PITON_CORE162_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc162_inst_done
    `define PITON_CORE162_PC_W162     `TOP_MOD.monitor.pc_cmp.spc162_phy_pc_w

    

    `define TILE163            `CHIP.tile163
    `define ARIANE_CORE163     `TILE163.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP163         `TILE163.l15.l15
    `define L15_PIPE163        `TILE163.l15.l15.pipeline
    `define DMBR163            `TILE163.dmbr_ins
    `define L2_TOP163          `TILE163.l2
    `define PITON_CORE163_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc163_inst_done
    `define PITON_CORE163_PC_W163     `TOP_MOD.monitor.pc_cmp.spc163_phy_pc_w

    

    `define TILE164            `CHIP.tile164
    `define ARIANE_CORE164     `TILE164.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP164         `TILE164.l15.l15
    `define L15_PIPE164        `TILE164.l15.l15.pipeline
    `define DMBR164            `TILE164.dmbr_ins
    `define L2_TOP164          `TILE164.l2
    `define PITON_CORE164_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc164_inst_done
    `define PITON_CORE164_PC_W164     `TOP_MOD.monitor.pc_cmp.spc164_phy_pc_w

    

    `define TILE165            `CHIP.tile165
    `define ARIANE_CORE165     `TILE165.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP165         `TILE165.l15.l15
    `define L15_PIPE165        `TILE165.l15.l15.pipeline
    `define DMBR165            `TILE165.dmbr_ins
    `define L2_TOP165          `TILE165.l2
    `define PITON_CORE165_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc165_inst_done
    `define PITON_CORE165_PC_W165     `TOP_MOD.monitor.pc_cmp.spc165_phy_pc_w

    

    `define TILE166            `CHIP.tile166
    `define ARIANE_CORE166     `TILE166.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP166         `TILE166.l15.l15
    `define L15_PIPE166        `TILE166.l15.l15.pipeline
    `define DMBR166            `TILE166.dmbr_ins
    `define L2_TOP166          `TILE166.l2
    `define PITON_CORE166_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc166_inst_done
    `define PITON_CORE166_PC_W166     `TOP_MOD.monitor.pc_cmp.spc166_phy_pc_w

    

    `define TILE167            `CHIP.tile167
    `define ARIANE_CORE167     `TILE167.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP167         `TILE167.l15.l15
    `define L15_PIPE167        `TILE167.l15.l15.pipeline
    `define DMBR167            `TILE167.dmbr_ins
    `define L2_TOP167          `TILE167.l2
    `define PITON_CORE167_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc167_inst_done
    `define PITON_CORE167_PC_W167     `TOP_MOD.monitor.pc_cmp.spc167_phy_pc_w

    

    `define TILE168            `CHIP.tile168
    `define ARIANE_CORE168     `TILE168.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP168         `TILE168.l15.l15
    `define L15_PIPE168        `TILE168.l15.l15.pipeline
    `define DMBR168            `TILE168.dmbr_ins
    `define L2_TOP168          `TILE168.l2
    `define PITON_CORE168_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc168_inst_done
    `define PITON_CORE168_PC_W168     `TOP_MOD.monitor.pc_cmp.spc168_phy_pc_w

    

    `define TILE169            `CHIP.tile169
    `define ARIANE_CORE169     `TILE169.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP169         `TILE169.l15.l15
    `define L15_PIPE169        `TILE169.l15.l15.pipeline
    `define DMBR169            `TILE169.dmbr_ins
    `define L2_TOP169          `TILE169.l2
    `define PITON_CORE169_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc169_inst_done
    `define PITON_CORE169_PC_W169     `TOP_MOD.monitor.pc_cmp.spc169_phy_pc_w

    

    `define TILE170            `CHIP.tile170
    `define ARIANE_CORE170     `TILE170.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP170         `TILE170.l15.l15
    `define L15_PIPE170        `TILE170.l15.l15.pipeline
    `define DMBR170            `TILE170.dmbr_ins
    `define L2_TOP170          `TILE170.l2
    `define PITON_CORE170_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc170_inst_done
    `define PITON_CORE170_PC_W170     `TOP_MOD.monitor.pc_cmp.spc170_phy_pc_w

    

    `define TILE171            `CHIP.tile171
    `define ARIANE_CORE171     `TILE171.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP171         `TILE171.l15.l15
    `define L15_PIPE171        `TILE171.l15.l15.pipeline
    `define DMBR171            `TILE171.dmbr_ins
    `define L2_TOP171          `TILE171.l2
    `define PITON_CORE171_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc171_inst_done
    `define PITON_CORE171_PC_W171     `TOP_MOD.monitor.pc_cmp.spc171_phy_pc_w

    

    `define TILE172            `CHIP.tile172
    `define ARIANE_CORE172     `TILE172.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP172         `TILE172.l15.l15
    `define L15_PIPE172        `TILE172.l15.l15.pipeline
    `define DMBR172            `TILE172.dmbr_ins
    `define L2_TOP172          `TILE172.l2
    `define PITON_CORE172_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc172_inst_done
    `define PITON_CORE172_PC_W172     `TOP_MOD.monitor.pc_cmp.spc172_phy_pc_w

    

    `define TILE173            `CHIP.tile173
    `define ARIANE_CORE173     `TILE173.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP173         `TILE173.l15.l15
    `define L15_PIPE173        `TILE173.l15.l15.pipeline
    `define DMBR173            `TILE173.dmbr_ins
    `define L2_TOP173          `TILE173.l2
    `define PITON_CORE173_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc173_inst_done
    `define PITON_CORE173_PC_W173     `TOP_MOD.monitor.pc_cmp.spc173_phy_pc_w

    

    `define TILE174            `CHIP.tile174
    `define ARIANE_CORE174     `TILE174.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP174         `TILE174.l15.l15
    `define L15_PIPE174        `TILE174.l15.l15.pipeline
    `define DMBR174            `TILE174.dmbr_ins
    `define L2_TOP174          `TILE174.l2
    `define PITON_CORE174_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc174_inst_done
    `define PITON_CORE174_PC_W174     `TOP_MOD.monitor.pc_cmp.spc174_phy_pc_w

    

    `define TILE175            `CHIP.tile175
    `define ARIANE_CORE175     `TILE175.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP175         `TILE175.l15.l15
    `define L15_PIPE175        `TILE175.l15.l15.pipeline
    `define DMBR175            `TILE175.dmbr_ins
    `define L2_TOP175          `TILE175.l2
    `define PITON_CORE175_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc175_inst_done
    `define PITON_CORE175_PC_W175     `TOP_MOD.monitor.pc_cmp.spc175_phy_pc_w

    

    `define TILE176            `CHIP.tile176
    `define ARIANE_CORE176     `TILE176.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP176         `TILE176.l15.l15
    `define L15_PIPE176        `TILE176.l15.l15.pipeline
    `define DMBR176            `TILE176.dmbr_ins
    `define L2_TOP176          `TILE176.l2
    `define PITON_CORE176_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc176_inst_done
    `define PITON_CORE176_PC_W176     `TOP_MOD.monitor.pc_cmp.spc176_phy_pc_w

    

    `define TILE177            `CHIP.tile177
    `define ARIANE_CORE177     `TILE177.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP177         `TILE177.l15.l15
    `define L15_PIPE177        `TILE177.l15.l15.pipeline
    `define DMBR177            `TILE177.dmbr_ins
    `define L2_TOP177          `TILE177.l2
    `define PITON_CORE177_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc177_inst_done
    `define PITON_CORE177_PC_W177     `TOP_MOD.monitor.pc_cmp.spc177_phy_pc_w

    

    `define TILE178            `CHIP.tile178
    `define ARIANE_CORE178     `TILE178.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP178         `TILE178.l15.l15
    `define L15_PIPE178        `TILE178.l15.l15.pipeline
    `define DMBR178            `TILE178.dmbr_ins
    `define L2_TOP178          `TILE178.l2
    `define PITON_CORE178_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc178_inst_done
    `define PITON_CORE178_PC_W178     `TOP_MOD.monitor.pc_cmp.spc178_phy_pc_w

    

    `define TILE179            `CHIP.tile179
    `define ARIANE_CORE179     `TILE179.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP179         `TILE179.l15.l15
    `define L15_PIPE179        `TILE179.l15.l15.pipeline
    `define DMBR179            `TILE179.dmbr_ins
    `define L2_TOP179          `TILE179.l2
    `define PITON_CORE179_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc179_inst_done
    `define PITON_CORE179_PC_W179     `TOP_MOD.monitor.pc_cmp.spc179_phy_pc_w

    

    `define TILE180            `CHIP.tile180
    `define ARIANE_CORE180     `TILE180.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP180         `TILE180.l15.l15
    `define L15_PIPE180        `TILE180.l15.l15.pipeline
    `define DMBR180            `TILE180.dmbr_ins
    `define L2_TOP180          `TILE180.l2
    `define PITON_CORE180_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc180_inst_done
    `define PITON_CORE180_PC_W180     `TOP_MOD.monitor.pc_cmp.spc180_phy_pc_w

    

    `define TILE181            `CHIP.tile181
    `define ARIANE_CORE181     `TILE181.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP181         `TILE181.l15.l15
    `define L15_PIPE181        `TILE181.l15.l15.pipeline
    `define DMBR181            `TILE181.dmbr_ins
    `define L2_TOP181          `TILE181.l2
    `define PITON_CORE181_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc181_inst_done
    `define PITON_CORE181_PC_W181     `TOP_MOD.monitor.pc_cmp.spc181_phy_pc_w

    

    `define TILE182            `CHIP.tile182
    `define ARIANE_CORE182     `TILE182.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP182         `TILE182.l15.l15
    `define L15_PIPE182        `TILE182.l15.l15.pipeline
    `define DMBR182            `TILE182.dmbr_ins
    `define L2_TOP182          `TILE182.l2
    `define PITON_CORE182_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc182_inst_done
    `define PITON_CORE182_PC_W182     `TOP_MOD.monitor.pc_cmp.spc182_phy_pc_w

    

    `define TILE183            `CHIP.tile183
    `define ARIANE_CORE183     `TILE183.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP183         `TILE183.l15.l15
    `define L15_PIPE183        `TILE183.l15.l15.pipeline
    `define DMBR183            `TILE183.dmbr_ins
    `define L2_TOP183          `TILE183.l2
    `define PITON_CORE183_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc183_inst_done
    `define PITON_CORE183_PC_W183     `TOP_MOD.monitor.pc_cmp.spc183_phy_pc_w

    

    `define TILE184            `CHIP.tile184
    `define ARIANE_CORE184     `TILE184.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP184         `TILE184.l15.l15
    `define L15_PIPE184        `TILE184.l15.l15.pipeline
    `define DMBR184            `TILE184.dmbr_ins
    `define L2_TOP184          `TILE184.l2
    `define PITON_CORE184_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc184_inst_done
    `define PITON_CORE184_PC_W184     `TOP_MOD.monitor.pc_cmp.spc184_phy_pc_w

    

    `define TILE185            `CHIP.tile185
    `define ARIANE_CORE185     `TILE185.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP185         `TILE185.l15.l15
    `define L15_PIPE185        `TILE185.l15.l15.pipeline
    `define DMBR185            `TILE185.dmbr_ins
    `define L2_TOP185          `TILE185.l2
    `define PITON_CORE185_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc185_inst_done
    `define PITON_CORE185_PC_W185     `TOP_MOD.monitor.pc_cmp.spc185_phy_pc_w

    

    `define TILE186            `CHIP.tile186
    `define ARIANE_CORE186     `TILE186.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP186         `TILE186.l15.l15
    `define L15_PIPE186        `TILE186.l15.l15.pipeline
    `define DMBR186            `TILE186.dmbr_ins
    `define L2_TOP186          `TILE186.l2
    `define PITON_CORE186_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc186_inst_done
    `define PITON_CORE186_PC_W186     `TOP_MOD.monitor.pc_cmp.spc186_phy_pc_w

    

    `define TILE187            `CHIP.tile187
    `define ARIANE_CORE187     `TILE187.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP187         `TILE187.l15.l15
    `define L15_PIPE187        `TILE187.l15.l15.pipeline
    `define DMBR187            `TILE187.dmbr_ins
    `define L2_TOP187          `TILE187.l2
    `define PITON_CORE187_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc187_inst_done
    `define PITON_CORE187_PC_W187     `TOP_MOD.monitor.pc_cmp.spc187_phy_pc_w

    

    `define TILE188            `CHIP.tile188
    `define ARIANE_CORE188     `TILE188.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP188         `TILE188.l15.l15
    `define L15_PIPE188        `TILE188.l15.l15.pipeline
    `define DMBR188            `TILE188.dmbr_ins
    `define L2_TOP188          `TILE188.l2
    `define PITON_CORE188_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc188_inst_done
    `define PITON_CORE188_PC_W188     `TOP_MOD.monitor.pc_cmp.spc188_phy_pc_w

    

    `define TILE189            `CHIP.tile189
    `define ARIANE_CORE189     `TILE189.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP189         `TILE189.l15.l15
    `define L15_PIPE189        `TILE189.l15.l15.pipeline
    `define DMBR189            `TILE189.dmbr_ins
    `define L2_TOP189          `TILE189.l2
    `define PITON_CORE189_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc189_inst_done
    `define PITON_CORE189_PC_W189     `TOP_MOD.monitor.pc_cmp.spc189_phy_pc_w

    

    `define TILE190            `CHIP.tile190
    `define ARIANE_CORE190     `TILE190.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP190         `TILE190.l15.l15
    `define L15_PIPE190        `TILE190.l15.l15.pipeline
    `define DMBR190            `TILE190.dmbr_ins
    `define L2_TOP190          `TILE190.l2
    `define PITON_CORE190_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc190_inst_done
    `define PITON_CORE190_PC_W190     `TOP_MOD.monitor.pc_cmp.spc190_phy_pc_w

    

    `define TILE191            `CHIP.tile191
    `define ARIANE_CORE191     `TILE191.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP191         `TILE191.l15.l15
    `define L15_PIPE191        `TILE191.l15.l15.pipeline
    `define DMBR191            `TILE191.dmbr_ins
    `define L2_TOP191          `TILE191.l2
    `define PITON_CORE191_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc191_inst_done
    `define PITON_CORE191_PC_W191     `TOP_MOD.monitor.pc_cmp.spc191_phy_pc_w

    

    `define TILE192            `CHIP.tile192
    `define ARIANE_CORE192     `TILE192.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP192         `TILE192.l15.l15
    `define L15_PIPE192        `TILE192.l15.l15.pipeline
    `define DMBR192            `TILE192.dmbr_ins
    `define L2_TOP192          `TILE192.l2
    `define PITON_CORE192_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc192_inst_done
    `define PITON_CORE192_PC_W192     `TOP_MOD.monitor.pc_cmp.spc192_phy_pc_w

    

    `define TILE193            `CHIP.tile193
    `define ARIANE_CORE193     `TILE193.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP193         `TILE193.l15.l15
    `define L15_PIPE193        `TILE193.l15.l15.pipeline
    `define DMBR193            `TILE193.dmbr_ins
    `define L2_TOP193          `TILE193.l2
    `define PITON_CORE193_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc193_inst_done
    `define PITON_CORE193_PC_W193     `TOP_MOD.monitor.pc_cmp.spc193_phy_pc_w

    

    `define TILE194            `CHIP.tile194
    `define ARIANE_CORE194     `TILE194.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP194         `TILE194.l15.l15
    `define L15_PIPE194        `TILE194.l15.l15.pipeline
    `define DMBR194            `TILE194.dmbr_ins
    `define L2_TOP194          `TILE194.l2
    `define PITON_CORE194_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc194_inst_done
    `define PITON_CORE194_PC_W194     `TOP_MOD.monitor.pc_cmp.spc194_phy_pc_w

    

    `define TILE195            `CHIP.tile195
    `define ARIANE_CORE195     `TILE195.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP195         `TILE195.l15.l15
    `define L15_PIPE195        `TILE195.l15.l15.pipeline
    `define DMBR195            `TILE195.dmbr_ins
    `define L2_TOP195          `TILE195.l2
    `define PITON_CORE195_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc195_inst_done
    `define PITON_CORE195_PC_W195     `TOP_MOD.monitor.pc_cmp.spc195_phy_pc_w

    

    `define TILE196            `CHIP.tile196
    `define ARIANE_CORE196     `TILE196.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP196         `TILE196.l15.l15
    `define L15_PIPE196        `TILE196.l15.l15.pipeline
    `define DMBR196            `TILE196.dmbr_ins
    `define L2_TOP196          `TILE196.l2
    `define PITON_CORE196_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc196_inst_done
    `define PITON_CORE196_PC_W196     `TOP_MOD.monitor.pc_cmp.spc196_phy_pc_w

    

    `define TILE197            `CHIP.tile197
    `define ARIANE_CORE197     `TILE197.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP197         `TILE197.l15.l15
    `define L15_PIPE197        `TILE197.l15.l15.pipeline
    `define DMBR197            `TILE197.dmbr_ins
    `define L2_TOP197          `TILE197.l2
    `define PITON_CORE197_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc197_inst_done
    `define PITON_CORE197_PC_W197     `TOP_MOD.monitor.pc_cmp.spc197_phy_pc_w

    

    `define TILE198            `CHIP.tile198
    `define ARIANE_CORE198     `TILE198.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP198         `TILE198.l15.l15
    `define L15_PIPE198        `TILE198.l15.l15.pipeline
    `define DMBR198            `TILE198.dmbr_ins
    `define L2_TOP198          `TILE198.l2
    `define PITON_CORE198_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc198_inst_done
    `define PITON_CORE198_PC_W198     `TOP_MOD.monitor.pc_cmp.spc198_phy_pc_w

    

    `define TILE199            `CHIP.tile199
    `define ARIANE_CORE199     `TILE199.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP199         `TILE199.l15.l15
    `define L15_PIPE199        `TILE199.l15.l15.pipeline
    `define DMBR199            `TILE199.dmbr_ins
    `define L2_TOP199          `TILE199.l2
    `define PITON_CORE199_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc199_inst_done
    `define PITON_CORE199_PC_W199     `TOP_MOD.monitor.pc_cmp.spc199_phy_pc_w

    

    `define TILE200            `CHIP.tile200
    `define ARIANE_CORE200     `TILE200.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP200         `TILE200.l15.l15
    `define L15_PIPE200        `TILE200.l15.l15.pipeline
    `define DMBR200            `TILE200.dmbr_ins
    `define L2_TOP200          `TILE200.l2
    `define PITON_CORE200_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc200_inst_done
    `define PITON_CORE200_PC_W200     `TOP_MOD.monitor.pc_cmp.spc200_phy_pc_w

    

    `define TILE201            `CHIP.tile201
    `define ARIANE_CORE201     `TILE201.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP201         `TILE201.l15.l15
    `define L15_PIPE201        `TILE201.l15.l15.pipeline
    `define DMBR201            `TILE201.dmbr_ins
    `define L2_TOP201          `TILE201.l2
    `define PITON_CORE201_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc201_inst_done
    `define PITON_CORE201_PC_W201     `TOP_MOD.monitor.pc_cmp.spc201_phy_pc_w

    

    `define TILE202            `CHIP.tile202
    `define ARIANE_CORE202     `TILE202.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP202         `TILE202.l15.l15
    `define L15_PIPE202        `TILE202.l15.l15.pipeline
    `define DMBR202            `TILE202.dmbr_ins
    `define L2_TOP202          `TILE202.l2
    `define PITON_CORE202_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc202_inst_done
    `define PITON_CORE202_PC_W202     `TOP_MOD.monitor.pc_cmp.spc202_phy_pc_w

    

    `define TILE203            `CHIP.tile203
    `define ARIANE_CORE203     `TILE203.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP203         `TILE203.l15.l15
    `define L15_PIPE203        `TILE203.l15.l15.pipeline
    `define DMBR203            `TILE203.dmbr_ins
    `define L2_TOP203          `TILE203.l2
    `define PITON_CORE203_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc203_inst_done
    `define PITON_CORE203_PC_W203     `TOP_MOD.monitor.pc_cmp.spc203_phy_pc_w

    

    `define TILE204            `CHIP.tile204
    `define ARIANE_CORE204     `TILE204.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP204         `TILE204.l15.l15
    `define L15_PIPE204        `TILE204.l15.l15.pipeline
    `define DMBR204            `TILE204.dmbr_ins
    `define L2_TOP204          `TILE204.l2
    `define PITON_CORE204_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc204_inst_done
    `define PITON_CORE204_PC_W204     `TOP_MOD.monitor.pc_cmp.spc204_phy_pc_w

    

    `define TILE205            `CHIP.tile205
    `define ARIANE_CORE205     `TILE205.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP205         `TILE205.l15.l15
    `define L15_PIPE205        `TILE205.l15.l15.pipeline
    `define DMBR205            `TILE205.dmbr_ins
    `define L2_TOP205          `TILE205.l2
    `define PITON_CORE205_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc205_inst_done
    `define PITON_CORE205_PC_W205     `TOP_MOD.monitor.pc_cmp.spc205_phy_pc_w

    

    `define TILE206            `CHIP.tile206
    `define ARIANE_CORE206     `TILE206.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP206         `TILE206.l15.l15
    `define L15_PIPE206        `TILE206.l15.l15.pipeline
    `define DMBR206            `TILE206.dmbr_ins
    `define L2_TOP206          `TILE206.l2
    `define PITON_CORE206_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc206_inst_done
    `define PITON_CORE206_PC_W206     `TOP_MOD.monitor.pc_cmp.spc206_phy_pc_w

    

    `define TILE207            `CHIP.tile207
    `define ARIANE_CORE207     `TILE207.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP207         `TILE207.l15.l15
    `define L15_PIPE207        `TILE207.l15.l15.pipeline
    `define DMBR207            `TILE207.dmbr_ins
    `define L2_TOP207          `TILE207.l2
    `define PITON_CORE207_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc207_inst_done
    `define PITON_CORE207_PC_W207     `TOP_MOD.monitor.pc_cmp.spc207_phy_pc_w

    

    `define TILE208            `CHIP.tile208
    `define ARIANE_CORE208     `TILE208.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP208         `TILE208.l15.l15
    `define L15_PIPE208        `TILE208.l15.l15.pipeline
    `define DMBR208            `TILE208.dmbr_ins
    `define L2_TOP208          `TILE208.l2
    `define PITON_CORE208_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc208_inst_done
    `define PITON_CORE208_PC_W208     `TOP_MOD.monitor.pc_cmp.spc208_phy_pc_w

    

    `define TILE209            `CHIP.tile209
    `define ARIANE_CORE209     `TILE209.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP209         `TILE209.l15.l15
    `define L15_PIPE209        `TILE209.l15.l15.pipeline
    `define DMBR209            `TILE209.dmbr_ins
    `define L2_TOP209          `TILE209.l2
    `define PITON_CORE209_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc209_inst_done
    `define PITON_CORE209_PC_W209     `TOP_MOD.monitor.pc_cmp.spc209_phy_pc_w

    

    `define TILE210            `CHIP.tile210
    `define ARIANE_CORE210     `TILE210.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP210         `TILE210.l15.l15
    `define L15_PIPE210        `TILE210.l15.l15.pipeline
    `define DMBR210            `TILE210.dmbr_ins
    `define L2_TOP210          `TILE210.l2
    `define PITON_CORE210_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc210_inst_done
    `define PITON_CORE210_PC_W210     `TOP_MOD.monitor.pc_cmp.spc210_phy_pc_w

    

    `define TILE211            `CHIP.tile211
    `define ARIANE_CORE211     `TILE211.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP211         `TILE211.l15.l15
    `define L15_PIPE211        `TILE211.l15.l15.pipeline
    `define DMBR211            `TILE211.dmbr_ins
    `define L2_TOP211          `TILE211.l2
    `define PITON_CORE211_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc211_inst_done
    `define PITON_CORE211_PC_W211     `TOP_MOD.monitor.pc_cmp.spc211_phy_pc_w

    

    `define TILE212            `CHIP.tile212
    `define ARIANE_CORE212     `TILE212.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP212         `TILE212.l15.l15
    `define L15_PIPE212        `TILE212.l15.l15.pipeline
    `define DMBR212            `TILE212.dmbr_ins
    `define L2_TOP212          `TILE212.l2
    `define PITON_CORE212_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc212_inst_done
    `define PITON_CORE212_PC_W212     `TOP_MOD.monitor.pc_cmp.spc212_phy_pc_w

    

    `define TILE213            `CHIP.tile213
    `define ARIANE_CORE213     `TILE213.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP213         `TILE213.l15.l15
    `define L15_PIPE213        `TILE213.l15.l15.pipeline
    `define DMBR213            `TILE213.dmbr_ins
    `define L2_TOP213          `TILE213.l2
    `define PITON_CORE213_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc213_inst_done
    `define PITON_CORE213_PC_W213     `TOP_MOD.monitor.pc_cmp.spc213_phy_pc_w

    

    `define TILE214            `CHIP.tile214
    `define ARIANE_CORE214     `TILE214.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP214         `TILE214.l15.l15
    `define L15_PIPE214        `TILE214.l15.l15.pipeline
    `define DMBR214            `TILE214.dmbr_ins
    `define L2_TOP214          `TILE214.l2
    `define PITON_CORE214_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc214_inst_done
    `define PITON_CORE214_PC_W214     `TOP_MOD.monitor.pc_cmp.spc214_phy_pc_w

    

    `define TILE215            `CHIP.tile215
    `define ARIANE_CORE215     `TILE215.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP215         `TILE215.l15.l15
    `define L15_PIPE215        `TILE215.l15.l15.pipeline
    `define DMBR215            `TILE215.dmbr_ins
    `define L2_TOP215          `TILE215.l2
    `define PITON_CORE215_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc215_inst_done
    `define PITON_CORE215_PC_W215     `TOP_MOD.monitor.pc_cmp.spc215_phy_pc_w

    

    `define TILE216            `CHIP.tile216
    `define ARIANE_CORE216     `TILE216.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP216         `TILE216.l15.l15
    `define L15_PIPE216        `TILE216.l15.l15.pipeline
    `define DMBR216            `TILE216.dmbr_ins
    `define L2_TOP216          `TILE216.l2
    `define PITON_CORE216_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc216_inst_done
    `define PITON_CORE216_PC_W216     `TOP_MOD.monitor.pc_cmp.spc216_phy_pc_w

    

    `define TILE217            `CHIP.tile217
    `define ARIANE_CORE217     `TILE217.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP217         `TILE217.l15.l15
    `define L15_PIPE217        `TILE217.l15.l15.pipeline
    `define DMBR217            `TILE217.dmbr_ins
    `define L2_TOP217          `TILE217.l2
    `define PITON_CORE217_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc217_inst_done
    `define PITON_CORE217_PC_W217     `TOP_MOD.monitor.pc_cmp.spc217_phy_pc_w

    

    `define TILE218            `CHIP.tile218
    `define ARIANE_CORE218     `TILE218.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP218         `TILE218.l15.l15
    `define L15_PIPE218        `TILE218.l15.l15.pipeline
    `define DMBR218            `TILE218.dmbr_ins
    `define L2_TOP218          `TILE218.l2
    `define PITON_CORE218_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc218_inst_done
    `define PITON_CORE218_PC_W218     `TOP_MOD.monitor.pc_cmp.spc218_phy_pc_w

    

    `define TILE219            `CHIP.tile219
    `define ARIANE_CORE219     `TILE219.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP219         `TILE219.l15.l15
    `define L15_PIPE219        `TILE219.l15.l15.pipeline
    `define DMBR219            `TILE219.dmbr_ins
    `define L2_TOP219          `TILE219.l2
    `define PITON_CORE219_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc219_inst_done
    `define PITON_CORE219_PC_W219     `TOP_MOD.monitor.pc_cmp.spc219_phy_pc_w

    

    `define TILE220            `CHIP.tile220
    `define ARIANE_CORE220     `TILE220.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP220         `TILE220.l15.l15
    `define L15_PIPE220        `TILE220.l15.l15.pipeline
    `define DMBR220            `TILE220.dmbr_ins
    `define L2_TOP220          `TILE220.l2
    `define PITON_CORE220_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc220_inst_done
    `define PITON_CORE220_PC_W220     `TOP_MOD.monitor.pc_cmp.spc220_phy_pc_w

    

    `define TILE221            `CHIP.tile221
    `define ARIANE_CORE221     `TILE221.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP221         `TILE221.l15.l15
    `define L15_PIPE221        `TILE221.l15.l15.pipeline
    `define DMBR221            `TILE221.dmbr_ins
    `define L2_TOP221          `TILE221.l2
    `define PITON_CORE221_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc221_inst_done
    `define PITON_CORE221_PC_W221     `TOP_MOD.monitor.pc_cmp.spc221_phy_pc_w

    

    `define TILE222            `CHIP.tile222
    `define ARIANE_CORE222     `TILE222.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP222         `TILE222.l15.l15
    `define L15_PIPE222        `TILE222.l15.l15.pipeline
    `define DMBR222            `TILE222.dmbr_ins
    `define L2_TOP222          `TILE222.l2
    `define PITON_CORE222_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc222_inst_done
    `define PITON_CORE222_PC_W222     `TOP_MOD.monitor.pc_cmp.spc222_phy_pc_w

    

    `define TILE223            `CHIP.tile223
    `define ARIANE_CORE223     `TILE223.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP223         `TILE223.l15.l15
    `define L15_PIPE223        `TILE223.l15.l15.pipeline
    `define DMBR223            `TILE223.dmbr_ins
    `define L2_TOP223          `TILE223.l2
    `define PITON_CORE223_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc223_inst_done
    `define PITON_CORE223_PC_W223     `TOP_MOD.monitor.pc_cmp.spc223_phy_pc_w

    

    `define TILE224            `CHIP.tile224
    `define ARIANE_CORE224     `TILE224.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP224         `TILE224.l15.l15
    `define L15_PIPE224        `TILE224.l15.l15.pipeline
    `define DMBR224            `TILE224.dmbr_ins
    `define L2_TOP224          `TILE224.l2
    `define PITON_CORE224_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc224_inst_done
    `define PITON_CORE224_PC_W224     `TOP_MOD.monitor.pc_cmp.spc224_phy_pc_w

    

    `define TILE225            `CHIP.tile225
    `define ARIANE_CORE225     `TILE225.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP225         `TILE225.l15.l15
    `define L15_PIPE225        `TILE225.l15.l15.pipeline
    `define DMBR225            `TILE225.dmbr_ins
    `define L2_TOP225          `TILE225.l2
    `define PITON_CORE225_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc225_inst_done
    `define PITON_CORE225_PC_W225     `TOP_MOD.monitor.pc_cmp.spc225_phy_pc_w

    

    `define TILE226            `CHIP.tile226
    `define ARIANE_CORE226     `TILE226.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP226         `TILE226.l15.l15
    `define L15_PIPE226        `TILE226.l15.l15.pipeline
    `define DMBR226            `TILE226.dmbr_ins
    `define L2_TOP226          `TILE226.l2
    `define PITON_CORE226_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc226_inst_done
    `define PITON_CORE226_PC_W226     `TOP_MOD.monitor.pc_cmp.spc226_phy_pc_w

    

    `define TILE227            `CHIP.tile227
    `define ARIANE_CORE227     `TILE227.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP227         `TILE227.l15.l15
    `define L15_PIPE227        `TILE227.l15.l15.pipeline
    `define DMBR227            `TILE227.dmbr_ins
    `define L2_TOP227          `TILE227.l2
    `define PITON_CORE227_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc227_inst_done
    `define PITON_CORE227_PC_W227     `TOP_MOD.monitor.pc_cmp.spc227_phy_pc_w

    

    `define TILE228            `CHIP.tile228
    `define ARIANE_CORE228     `TILE228.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP228         `TILE228.l15.l15
    `define L15_PIPE228        `TILE228.l15.l15.pipeline
    `define DMBR228            `TILE228.dmbr_ins
    `define L2_TOP228          `TILE228.l2
    `define PITON_CORE228_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc228_inst_done
    `define PITON_CORE228_PC_W228     `TOP_MOD.monitor.pc_cmp.spc228_phy_pc_w

    

    `define TILE229            `CHIP.tile229
    `define ARIANE_CORE229     `TILE229.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP229         `TILE229.l15.l15
    `define L15_PIPE229        `TILE229.l15.l15.pipeline
    `define DMBR229            `TILE229.dmbr_ins
    `define L2_TOP229          `TILE229.l2
    `define PITON_CORE229_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc229_inst_done
    `define PITON_CORE229_PC_W229     `TOP_MOD.monitor.pc_cmp.spc229_phy_pc_w

    

    `define TILE230            `CHIP.tile230
    `define ARIANE_CORE230     `TILE230.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP230         `TILE230.l15.l15
    `define L15_PIPE230        `TILE230.l15.l15.pipeline
    `define DMBR230            `TILE230.dmbr_ins
    `define L2_TOP230          `TILE230.l2
    `define PITON_CORE230_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc230_inst_done
    `define PITON_CORE230_PC_W230     `TOP_MOD.monitor.pc_cmp.spc230_phy_pc_w

    

    `define TILE231            `CHIP.tile231
    `define ARIANE_CORE231     `TILE231.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP231         `TILE231.l15.l15
    `define L15_PIPE231        `TILE231.l15.l15.pipeline
    `define DMBR231            `TILE231.dmbr_ins
    `define L2_TOP231          `TILE231.l2
    `define PITON_CORE231_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc231_inst_done
    `define PITON_CORE231_PC_W231     `TOP_MOD.monitor.pc_cmp.spc231_phy_pc_w

    

    `define TILE232            `CHIP.tile232
    `define ARIANE_CORE232     `TILE232.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP232         `TILE232.l15.l15
    `define L15_PIPE232        `TILE232.l15.l15.pipeline
    `define DMBR232            `TILE232.dmbr_ins
    `define L2_TOP232          `TILE232.l2
    `define PITON_CORE232_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc232_inst_done
    `define PITON_CORE232_PC_W232     `TOP_MOD.monitor.pc_cmp.spc232_phy_pc_w

    

    `define TILE233            `CHIP.tile233
    `define ARIANE_CORE233     `TILE233.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP233         `TILE233.l15.l15
    `define L15_PIPE233        `TILE233.l15.l15.pipeline
    `define DMBR233            `TILE233.dmbr_ins
    `define L2_TOP233          `TILE233.l2
    `define PITON_CORE233_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc233_inst_done
    `define PITON_CORE233_PC_W233     `TOP_MOD.monitor.pc_cmp.spc233_phy_pc_w

    

    `define TILE234            `CHIP.tile234
    `define ARIANE_CORE234     `TILE234.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP234         `TILE234.l15.l15
    `define L15_PIPE234        `TILE234.l15.l15.pipeline
    `define DMBR234            `TILE234.dmbr_ins
    `define L2_TOP234          `TILE234.l2
    `define PITON_CORE234_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc234_inst_done
    `define PITON_CORE234_PC_W234     `TOP_MOD.monitor.pc_cmp.spc234_phy_pc_w

    

    `define TILE235            `CHIP.tile235
    `define ARIANE_CORE235     `TILE235.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP235         `TILE235.l15.l15
    `define L15_PIPE235        `TILE235.l15.l15.pipeline
    `define DMBR235            `TILE235.dmbr_ins
    `define L2_TOP235          `TILE235.l2
    `define PITON_CORE235_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc235_inst_done
    `define PITON_CORE235_PC_W235     `TOP_MOD.monitor.pc_cmp.spc235_phy_pc_w

    

    `define TILE236            `CHIP.tile236
    `define ARIANE_CORE236     `TILE236.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP236         `TILE236.l15.l15
    `define L15_PIPE236        `TILE236.l15.l15.pipeline
    `define DMBR236            `TILE236.dmbr_ins
    `define L2_TOP236          `TILE236.l2
    `define PITON_CORE236_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc236_inst_done
    `define PITON_CORE236_PC_W236     `TOP_MOD.monitor.pc_cmp.spc236_phy_pc_w

    

    `define TILE237            `CHIP.tile237
    `define ARIANE_CORE237     `TILE237.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP237         `TILE237.l15.l15
    `define L15_PIPE237        `TILE237.l15.l15.pipeline
    `define DMBR237            `TILE237.dmbr_ins
    `define L2_TOP237          `TILE237.l2
    `define PITON_CORE237_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc237_inst_done
    `define PITON_CORE237_PC_W237     `TOP_MOD.monitor.pc_cmp.spc237_phy_pc_w

    

    `define TILE238            `CHIP.tile238
    `define ARIANE_CORE238     `TILE238.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP238         `TILE238.l15.l15
    `define L15_PIPE238        `TILE238.l15.l15.pipeline
    `define DMBR238            `TILE238.dmbr_ins
    `define L2_TOP238          `TILE238.l2
    `define PITON_CORE238_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc238_inst_done
    `define PITON_CORE238_PC_W238     `TOP_MOD.monitor.pc_cmp.spc238_phy_pc_w

    

    `define TILE239            `CHIP.tile239
    `define ARIANE_CORE239     `TILE239.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP239         `TILE239.l15.l15
    `define L15_PIPE239        `TILE239.l15.l15.pipeline
    `define DMBR239            `TILE239.dmbr_ins
    `define L2_TOP239          `TILE239.l2
    `define PITON_CORE239_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc239_inst_done
    `define PITON_CORE239_PC_W239     `TOP_MOD.monitor.pc_cmp.spc239_phy_pc_w

    

    `define TILE240            `CHIP.tile240
    `define ARIANE_CORE240     `TILE240.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP240         `TILE240.l15.l15
    `define L15_PIPE240        `TILE240.l15.l15.pipeline
    `define DMBR240            `TILE240.dmbr_ins
    `define L2_TOP240          `TILE240.l2
    `define PITON_CORE240_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc240_inst_done
    `define PITON_CORE240_PC_W240     `TOP_MOD.monitor.pc_cmp.spc240_phy_pc_w

    

    `define TILE241            `CHIP.tile241
    `define ARIANE_CORE241     `TILE241.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP241         `TILE241.l15.l15
    `define L15_PIPE241        `TILE241.l15.l15.pipeline
    `define DMBR241            `TILE241.dmbr_ins
    `define L2_TOP241          `TILE241.l2
    `define PITON_CORE241_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc241_inst_done
    `define PITON_CORE241_PC_W241     `TOP_MOD.monitor.pc_cmp.spc241_phy_pc_w

    

    `define TILE242            `CHIP.tile242
    `define ARIANE_CORE242     `TILE242.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP242         `TILE242.l15.l15
    `define L15_PIPE242        `TILE242.l15.l15.pipeline
    `define DMBR242            `TILE242.dmbr_ins
    `define L2_TOP242          `TILE242.l2
    `define PITON_CORE242_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc242_inst_done
    `define PITON_CORE242_PC_W242     `TOP_MOD.monitor.pc_cmp.spc242_phy_pc_w

    

    `define TILE243            `CHIP.tile243
    `define ARIANE_CORE243     `TILE243.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP243         `TILE243.l15.l15
    `define L15_PIPE243        `TILE243.l15.l15.pipeline
    `define DMBR243            `TILE243.dmbr_ins
    `define L2_TOP243          `TILE243.l2
    `define PITON_CORE243_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc243_inst_done
    `define PITON_CORE243_PC_W243     `TOP_MOD.monitor.pc_cmp.spc243_phy_pc_w

    

    `define TILE244            `CHIP.tile244
    `define ARIANE_CORE244     `TILE244.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP244         `TILE244.l15.l15
    `define L15_PIPE244        `TILE244.l15.l15.pipeline
    `define DMBR244            `TILE244.dmbr_ins
    `define L2_TOP244          `TILE244.l2
    `define PITON_CORE244_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc244_inst_done
    `define PITON_CORE244_PC_W244     `TOP_MOD.monitor.pc_cmp.spc244_phy_pc_w

    

    `define TILE245            `CHIP.tile245
    `define ARIANE_CORE245     `TILE245.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP245         `TILE245.l15.l15
    `define L15_PIPE245        `TILE245.l15.l15.pipeline
    `define DMBR245            `TILE245.dmbr_ins
    `define L2_TOP245          `TILE245.l2
    `define PITON_CORE245_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc245_inst_done
    `define PITON_CORE245_PC_W245     `TOP_MOD.monitor.pc_cmp.spc245_phy_pc_w

    

    `define TILE246            `CHIP.tile246
    `define ARIANE_CORE246     `TILE246.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP246         `TILE246.l15.l15
    `define L15_PIPE246        `TILE246.l15.l15.pipeline
    `define DMBR246            `TILE246.dmbr_ins
    `define L2_TOP246          `TILE246.l2
    `define PITON_CORE246_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc246_inst_done
    `define PITON_CORE246_PC_W246     `TOP_MOD.monitor.pc_cmp.spc246_phy_pc_w

    

    `define TILE247            `CHIP.tile247
    `define ARIANE_CORE247     `TILE247.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP247         `TILE247.l15.l15
    `define L15_PIPE247        `TILE247.l15.l15.pipeline
    `define DMBR247            `TILE247.dmbr_ins
    `define L2_TOP247          `TILE247.l2
    `define PITON_CORE247_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc247_inst_done
    `define PITON_CORE247_PC_W247     `TOP_MOD.monitor.pc_cmp.spc247_phy_pc_w

    

    `define TILE248            `CHIP.tile248
    `define ARIANE_CORE248     `TILE248.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP248         `TILE248.l15.l15
    `define L15_PIPE248        `TILE248.l15.l15.pipeline
    `define DMBR248            `TILE248.dmbr_ins
    `define L2_TOP248          `TILE248.l2
    `define PITON_CORE248_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc248_inst_done
    `define PITON_CORE248_PC_W248     `TOP_MOD.monitor.pc_cmp.spc248_phy_pc_w

    

    `define TILE249            `CHIP.tile249
    `define ARIANE_CORE249     `TILE249.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP249         `TILE249.l15.l15
    `define L15_PIPE249        `TILE249.l15.l15.pipeline
    `define DMBR249            `TILE249.dmbr_ins
    `define L2_TOP249          `TILE249.l2
    `define PITON_CORE249_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc249_inst_done
    `define PITON_CORE249_PC_W249     `TOP_MOD.monitor.pc_cmp.spc249_phy_pc_w

    

    `define TILE250            `CHIP.tile250
    `define ARIANE_CORE250     `TILE250.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP250         `TILE250.l15.l15
    `define L15_PIPE250        `TILE250.l15.l15.pipeline
    `define DMBR250            `TILE250.dmbr_ins
    `define L2_TOP250          `TILE250.l2
    `define PITON_CORE250_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc250_inst_done
    `define PITON_CORE250_PC_W250     `TOP_MOD.monitor.pc_cmp.spc250_phy_pc_w

    

    `define TILE251            `CHIP.tile251
    `define ARIANE_CORE251     `TILE251.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP251         `TILE251.l15.l15
    `define L15_PIPE251        `TILE251.l15.l15.pipeline
    `define DMBR251            `TILE251.dmbr_ins
    `define L2_TOP251          `TILE251.l2
    `define PITON_CORE251_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc251_inst_done
    `define PITON_CORE251_PC_W251     `TOP_MOD.monitor.pc_cmp.spc251_phy_pc_w

    

    `define TILE252            `CHIP.tile252
    `define ARIANE_CORE252     `TILE252.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP252         `TILE252.l15.l15
    `define L15_PIPE252        `TILE252.l15.l15.pipeline
    `define DMBR252            `TILE252.dmbr_ins
    `define L2_TOP252          `TILE252.l2
    `define PITON_CORE252_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc252_inst_done
    `define PITON_CORE252_PC_W252     `TOP_MOD.monitor.pc_cmp.spc252_phy_pc_w

    

    `define TILE253            `CHIP.tile253
    `define ARIANE_CORE253     `TILE253.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP253         `TILE253.l15.l15
    `define L15_PIPE253        `TILE253.l15.l15.pipeline
    `define DMBR253            `TILE253.dmbr_ins
    `define L2_TOP253          `TILE253.l2
    `define PITON_CORE253_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc253_inst_done
    `define PITON_CORE253_PC_W253     `TOP_MOD.monitor.pc_cmp.spc253_phy_pc_w

    

    `define TILE254            `CHIP.tile254
    `define ARIANE_CORE254     `TILE254.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP254         `TILE254.l15.l15
    `define L15_PIPE254        `TILE254.l15.l15.pipeline
    `define DMBR254            `TILE254.dmbr_ins
    `define L2_TOP254          `TILE254.l2
    `define PITON_CORE254_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc254_inst_done
    `define PITON_CORE254_PC_W254     `TOP_MOD.monitor.pc_cmp.spc254_phy_pc_w

    

    `define TILE255            `CHIP.tile255
    `define ARIANE_CORE255     `TILE255.g_ariane_core.core.ariane.i_cva6
    `define L15_TOP255         `TILE255.l15.l15
    `define L15_PIPE255        `TILE255.l15.l15.pipeline
    `define DMBR255            `TILE255.dmbr_ins
    `define L2_TOP255          `TILE255.l2
    `define PITON_CORE255_INST_DONE  `TOP_MOD.monitor.pc_cmp.spc255_inst_done
    `define PITON_CORE255_PC_W255     `TOP_MOD.monitor.pc_cmp.spc255_phy_pc_w

    


`define ITAG0           `TOP_MOD.monitor.l_cache_mon0
`define IVLD0           `TOP_MOD.monitor.l_cache_mon0
`define SAS_INTER `TOP_MOD.sas_intf
`define MONITOR `TOP_MOD.monitor

`endif
