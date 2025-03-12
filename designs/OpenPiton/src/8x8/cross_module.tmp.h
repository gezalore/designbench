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

    


`define ITAG0           `TOP_MOD.monitor.l_cache_mon0
`define IVLD0           `TOP_MOD.monitor.l_cache_mon0
`define SAS_INTER `TOP_MOD.sas_intf
`define MONITOR `TOP_MOD.monitor

`endif
