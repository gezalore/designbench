// Modified by Princeton University on June 9th, 2015
/*
* ========== Copyright Header Begin ==========================================
* 
* OpenSPARC T1 Processor File: ifu.h
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
////////////////////////////////////////////////////////////////////////
/*
//
//  Module Name: ifu.h
//  Description:	
//  All ifu defines
*/

//--------------------------------------------
// Icache Values in IFU::ICD/ICV/ICT/FDP/IFQDP
//--------------------------------------------

// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml
`define IC_SZ 16384
`define IC_SET_IDX_HI 6
`define IC_NUM_WAY 4
`define IC_WAY_MASK 1:0
`define IC_WAY_IDX_WIDTH 2


`define IC_WAY_ARRAY_MASK `IC_NUM_WAY-1:0
// `IC_WAY_MASK

// Set Values
// !!IMPORTANT!! a change to IC_LINE_SZ will mean a change to the code as
//   well.  Unfortunately this has not been properly parametrized.
//   Changing the IC_LINE_SZ param alone is *not* enough.
// `define IC_LINE_SZ  32
`define IC_LINE_SZ 32


// !!IMPORTANT!! a change to IC_TAG_HI will mean a change to the code as
//   well.  Changing the IC_TAG_HI param alone is *not* enough to
//   change the PA range. 
// highest bit of PA
`define IC_TAG_HI    39

// Derived Values
// IC_IDX_HI = log(icache_size/4ways) - 1
// 11
`define IC_IDX_HI  (`IC_SET_IDX_HI + 5)

// 4095
// `define IC_ARR_HI (`IC_SZ/`IC_NUM_WAY - 1)

// number of entries - 1 = 511
`define IC_ENTRY_HI  ((`IC_SZ/`IC_LINE_SZ) - 1)
// 128 - 1
`define IC_SET_COUNT ((`IC_SZ/`IC_LINE_SZ/`IC_NUM_WAY))
// 32
`define IC_VAL_SET_COUNT ((`IC_SZ/`IC_LINE_SZ/`IC_NUM_WAY/4))

// 12
`define IC_TAG_LO    (`IC_IDX_HI + 1)

// 28
`define IC_TAG_SZ    (`IC_TAG_HI - `IC_IDX_HI)
// `define IC_TAG_MASK_ALL ((`IC_TLB_TAG_SZ * `IC_NUM_WAY)-1):0


// 4
`define IC_TAG_UNUSED_SZ (`IC_PHYS_TAG_SZ - `IC_TAG_SZ - 1)
// `define IC_PARITY_PADDING (32 - `IC_TAG_SZ - 1)
`define IC_ASITAG_PADDING (29 - `IC_TAG_SZ)


// 7
`define IC_IDX_SZ  (`IC_IDX_HI - 4)

// tags for all 4 ways + parity
// 116
// `define IC_TAG_ALL   ((`IC_TAG_SZ * `IC_NUM_WAY) + 4)

// 115
// `define IC_TAG_ALL_HI   ((`IC_TAG_SZ * `IC_NUM_WAY) + 3)

// physical implementation defines
`define IC_PHYS_TAG_SZ 33
`define IC_PHYS_TAG_HI 32
`define IC_PHYS_TAG_ALL_HI   ((`IC_TAG_SZ * `IC_NUM_WAY)-1)
`define IC_PHYS_TAG_MASK_ALL `IC_PHYS_TAG_SZ*`IC_NUM_WAY-1 : 0
`define IC_PHYS_TAG_WAY0_MASK `IC_PHYS_TAG_SZ*1-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY1_MASK `IC_PHYS_TAG_SZ*2-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY2_MASK `IC_PHYS_TAG_SZ*3-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY3_MASK `IC_PHYS_TAG_SZ*4-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY4_MASK `IC_PHYS_TAG_SZ*5-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY5_MASK `IC_PHYS_TAG_SZ*6-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY6_MASK `IC_PHYS_TAG_SZ*7-1 -: `IC_PHYS_TAG_SZ
`define IC_PHYS_TAG_WAY7_MASK `IC_PHYS_TAG_SZ*8-1 -: `IC_PHYS_TAG_SZ


// TLB
// `define IC_TLB_TAG_SZ 30
// tag + 1 bit parity
`define IC_TLB_TAG_SZ (`IC_TAG_SZ+1)
`define IC_TLB_TAG_HI (`IC_TLB_TAG_SZ-1)
`define IC_TLB_TAG_MASK_ALL ((`IC_TLB_TAG_SZ * `IC_NUM_WAY)-1):0
`define IC_TLB_TAG_MASK `IC_TLB_TAG_SZ-1:0

`define IC_TLB_PARITY_PADDING (32-`IC_TLB_TAG_SZ)


`define IC_TLB_TAG_WAY0_MASK `IC_TLB_TAG_SZ*1-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY1_MASK `IC_TLB_TAG_SZ*2-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY2_MASK `IC_TLB_TAG_SZ*3-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY3_MASK `IC_TLB_TAG_SZ*4-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY4_MASK `IC_TLB_TAG_SZ*5-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY5_MASK `IC_TLB_TAG_SZ*6-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY6_MASK `IC_TLB_TAG_SZ*7-1 -: `IC_TLB_TAG_SZ
`define IC_TLB_TAG_WAY7_MASK `IC_TLB_TAG_SZ*8-1 -: `IC_TLB_TAG_SZ

`define IC_TLB_TAG_NPARITY_WAY0_MASK `IC_TLB_TAG_SZ*1-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY1_MASK `IC_TLB_TAG_SZ*2-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY2_MASK `IC_TLB_TAG_SZ*3-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY3_MASK `IC_TLB_TAG_SZ*4-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY4_MASK `IC_TLB_TAG_SZ*5-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY5_MASK `IC_TLB_TAG_SZ*6-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY6_MASK `IC_TLB_TAG_SZ*7-2 -: `IC_TAG_SZ
`define IC_TLB_TAG_NPARITY_WAY7_MASK `IC_TLB_TAG_SZ*8-2 -: `IC_TAG_SZ


//----------------------------------------------------------------------
// For thread scheduler in IFU::DTU::SWL
//----------------------------------------------------------------------
// thread states:  (thr_state[4:0])
`define THRFSM_DEAD     5'b00000
`define THRFSM_IDLE     5'b00000
`define THRFSM_HALT     5'b00010
`define THRFSM_RDY      5'b11001
`define THRFSM_SPEC_RDY 5'b10011
`define THRFSM_RUN      5'b00101
`define THRFSM_SPEC_RUN 5'b00111
`define THRFSM_WAIT     5'b00001

// thread configuration register bit fields
`define TCR_READY   4
`define TCR_URDY    3
`define TCR_RUNNING 2
`define TCR_SPEC    1
`define TCR_ACTIVE  0


//----------------------------------------------------------------------
// For MIL fsm in IFU::IFQ
//----------------------------------------------------------------------
`define MILFSM_NULL   4'b0000
`define MILFSM_WAIT   4'b1000
`define MILFSM_REQ    4'b1100
`define MILFSM_FILL0  4'b1001
`define MILFSM_FILL1  4'b1011

`define MIL_V  3
`define MIL_R  2
`define MIL_A  1
`define MIL_F  0

//---------------------------------------------------
// Interrupt Block
//---------------------------------------------------
`define INT_VEC_HI  5
`define INT_VEC_LO  0
`define INT_THR_HI  12
`define INT_THR_LO  8
`define INT_TYPE_HI 17
`define INT_TYPE_LO 16

//-------------------------------------
// IFQ
//-------------------------------------
// valid bit plus ifill
`define CPX_IFILLPKT {1'b1, `IFILL_RET}
`define CPX_INVPKT {1'b1, `INV_RET}
`define CPX_STRPKT {1'b1, `ST_ACK}
`define CPX_STRMACK {1'b1, `STRST_ACK}
`define CPX_EVPKT {1'b1, `EVICT_REQ}
`define CPX_LDPKT {1'b1, `LOAD_RET}
`define CPX_ERRPKT {1'b1, `ERR_RET}
`define CPX_FREQPKT {1'b1, `FWD_RQ_RET}

`define CPX_REQFIELD `CPX_RQ_HI:`CPX_RQ_LO
`define CPX_THRFIELD `CPX_TH_HI:`CPX_TH_LO
`define CPX_RQ_SIZE  (`CPX_RQ_HI - `CPX_RQ_LO + 1)

//`ifdef SPARC_L2_64B
`define BANK_ID_HI 7
`define BANK_ID_LO 6
//`else
//`define BANK_ID_HI 8
//`define BANK_ID_LO 7
//`endif

//`define CPX_INV_PA_HI  116
//`define CPX_INV_PA_LO  112

`define IFU_ASI_VA_HI   17
`define IFU_ASI_DATA_HI 47

`define ICT_FILL_BITS  (32 - `IC_TAG_SZ)
`define ICV_IDX_SZ  (`IC_IDX_HI - 5)

//----------------------------------------
// IFU Traps
//----------------------------------------
// precise
`define INST_ACC_EXC    9'h008
`define INST_ACC_ERR    9'h00a
`define CORR_ECC_ERR    9'h063
`define DATA_ACC_ERR    9'h032
`define DATA_ERR        9'h078
`define ASYN_DATA_ERR   9'h040
`define INST_ACC_MMU_MS 9'h009
`define FAST_MMU_MS     9'h064
`define PRIV_OPC        9'h011
`define ILL_INST        9'h010
`define SIR             9'h004
`define FP_DISABLED     9'h020
`define REAL_TRANS_MS   9'h03e
`define INST_BRK_PT     9'h076

// disrupting
`define SPU_MAINT        9'h074
`define SPU_ENCINT       9'h070
`define HSTICK_CMP       9'h05e
`define RESUMABLE_ERR    9'h07e

`define VER_MANUF      16'h003e
`define VER_IMPL       16'h0023
`define VER_MAXGL      8'h03
`define VER_MAXWIN     8'h07
`define VER_MAXTL      8'h06


