/*
Copyright (c) 2015 Princeton University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//==================================================================================================
//  Filename      : l15_ctl.v
//  Created On    : 2014-01-31 18:24:47
//  Last Modified : 2018-01-17 14:00:15
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

// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml


`ifdef DEFAULT_NETTYPE_NONE
`default_nettype none
`endif
module l15_pipeline(
    input wire clk,
    input wire rst_n,

    // pcx
    input wire [`PCX_REQTYPE_WIDTH-1:0] pcxdecoder_l15_rqtype,
    input wire [`L15_AMO_OP_WIDTH-1:0] pcxdecoder_l15_amo_op,
    input wire pcxdecoder_l15_nc,
    input wire [`PCX_SIZE_FIELD_WIDTH-1:0] pcxdecoder_l15_size,
    // input wire pcxdecoder_l15_invalall,         // unused input from core
    input wire [`L15_THREADID_MASK] pcxdecoder_l15_threadid,
    input wire pcxdecoder_l15_prefetch,
    input wire pcxdecoder_l15_blockstore,
    input wire pcxdecoder_l15_blockinitstore,
    input wire [`L15_WAY_MASK] pcxdecoder_l15_l1rplway,
    input wire pcxdecoder_l15_val,
    input wire [`L15_PADDR_MASK] pcxdecoder_l15_address,
    input wire [`TLB_CSM_WIDTH-1:0] pcxdecoder_l15_csm_data,
    input wire [`L15_UNPARAM_63_0] pcxdecoder_l15_data,
    input wire [`L15_UNPARAM_63_0] pcxdecoder_l15_data_next_entry,
    input wire pcxdecoder_l15_invalidate_cacheline,
    // noc2
    input wire noc2decoder_l15_val,
    input wire [`L15_MSHR_ID_WIDTH-1:0] noc2decoder_l15_mshrid,
    input wire [`L15_THREADID_MASK] noc2decoder_l15_threadid,
    input wire noc2decoder_l15_hmc_fill,
    input wire noc2decoder_l15_l2miss,
    input wire noc2decoder_l15_icache_type,
    input wire noc2decoder_l15_f4b, // tcov: not used by L2, is passed directly from L2 to the core
    input wire [`MSG_TYPE_WIDTH-1:0] noc2decoder_l15_reqtype, // tcov: message type length is dictated by packet format
    input wire [`L15_MESI_STATE_WIDTH-1:0] noc2decoder_l15_ack_state,
    input wire [`L15_UNPARAM_3_0] noc2decoder_l15_fwd_subcacheline_vector,
    input wire [`L15_UNPARAM_63_0] noc2decoder_l15_data_0,
    input wire [`L15_UNPARAM_63_0] noc2decoder_l15_data_1,
    input wire [`L15_UNPARAM_63_0] noc2decoder_l15_data_2,
    input wire [`L15_UNPARAM_63_0] noc2decoder_l15_data_3,
    input wire [`L15_PADDR_MASK] noc2decoder_l15_address,
    input wire [`PACKET_HOME_ID_WIDTH-1:0] noc2decoder_l15_src_homeid,
    input wire [`L15_CSM_NUM_TICKETS_LOG2-1:0] noc2decoder_l15_csm_mshrid,
    // ack from output
    input wire cpxencoder_l15_req_ack,
    // input wire noc1encoder_l15_req_ack,
    input wire noc1encoder_l15_req_sent,
    input wire [`NOC1_BUFFER_ACK_DATA_WIDTH-1:0] noc1encoder_l15_req_data_sent,
    input wire noc3encoder_l15_req_ack,

    // input from config registers to pipeline
    input wire [`L15_UNPARAM_63_0] config_l15_read_res_data_s3,

    // MEMORY BLOCK OUTPUTS
    // data tag
    output reg l15_dtag_val_s1,
    output reg l15_dtag_rw_s1,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_dtag_index_s1,
    output reg [`L15_CACHE_TAG_RAW_WIDTH*4-1:0] l15_dtag_write_data_s1,
    output reg [`L15_CACHE_TAG_RAW_WIDTH*4-1:0] l15_dtag_write_mask_s1,
    input wire [`L15_CACHE_TAG_RAW_WIDTH*4-1:0] dtag_l15_dout_s2,
    // dcache
    output reg l15_dcache_val_s2,
    output reg l15_dcache_rw_s2,
    output reg [(`L15_CACHE_INDEX_WIDTH+`L15_WAY_WIDTH)-1:0] l15_dcache_index_s2,
    output reg [`L15_UNPARAM_127_0] l15_dcache_write_data_s2,
    output reg [`L15_UNPARAM_127_0] l15_dcache_write_mask_s2,
    input wire [`L15_UNPARAM_127_0] dcache_l15_dout_s3,

    // mesi
    output reg l15_mesi_read_val_s1,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_mesi_read_index_s1,
    input wire [`L15_UNPARAM_7_0] mesi_l15_dout_s2,
    output reg l15_mesi_write_val_s2,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_mesi_write_index_s2,
    output reg [`L15_UNPARAM_7_0] l15_mesi_write_mask_s2,
    output reg [`L15_UNPARAM_7_0] l15_mesi_write_data_s2,

    // lrsc_flag
    output reg l15_lrsc_flag_read_val_s1,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_lrsc_flag_read_index_s1,
    input wire [`L15_UNPARAM_3_0] lrsc_flag_l15_dout_s2,
    output reg l15_lrsc_flag_write_val_s2,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_lrsc_flag_write_index_s2,
    output reg [`L15_UNPARAM_3_0] l15_lrsc_flag_write_mask_s2,
    output reg [`L15_UNPARAM_3_0] l15_lrsc_flag_write_data_s2,

    // lruarray
    output reg l15_lruarray_read_val_s1,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_lruarray_read_index_s1,
    input wire [`L15_LRUARRAY_MASK] lruarray_l15_dout_s2,
    output reg l15_lruarray_write_val_s3,
    output reg [`L15_CACHE_INDEX_WIDTH-1:0] l15_lruarray_write_index_s3,
    output reg [`L15_LRUARRAY_MASK] l15_lruarray_write_mask_s3,    // tcov: writemask is designed to always be 1's
    output reg [`L15_LRUARRAY_MASK] l15_lruarray_write_data_s3,

    // hmt
    `ifndef NO_RTL_CSM
    input wire [`L15_CSM_GHID_WIDTH-1:0] hmt_l15_dout_s3,
    output reg [`L15_CSM_GHID_WIDTH-1:0] l15_hmt_write_data_s2,
    output reg [`L15_CSM_GHID_WIDTH-1:0] l15_hmt_write_mask_s2,
    `endif

    // wmt
    output reg l15_wmt_read_val_s2,
    output reg [`L1D_SET_IDX_MASK] l15_wmt_read_index_s2,
    input wire [`L15_WMT_MASK] wmt_l15_data_s3,
    output reg l15_wmt_write_val_s3,
    output reg [`L1D_SET_IDX_MASK] l15_wmt_write_index_s3,
    output reg [`L15_WMT_MASK] l15_wmt_write_mask_s3,
    output reg [`L15_WMT_MASK] l15_wmt_write_data_s3,

    // MSHR
    //s1 (allocating)
    output reg pipe_mshr_writereq_val_s1,
    output reg [`L15_MSHR_WRITE_TYPE_WIDTH-1:0] pipe_mshr_writereq_op_s1,   // tcov: one bit not used for encoding
    output reg [`L15_PADDR_MASK] pipe_mshr_writereq_address_s1,
    output reg [`L15_UNPARAM_127_0] pipe_mshr_writereq_write_buffer_data_s1,
    output reg [`L15_UNPARAM_15_0] pipe_mshr_writereq_write_buffer_byte_mask_s1,
    output reg [`L15_CONTROL_WIDTH-1:0] pipe_mshr_writereq_control_s1,
    output reg [`L15_MSHR_ID_WIDTH-1:0] pipe_mshr_writereq_mshrid_s1,
    output reg [`L15_THREADID_MASK] pipe_mshr_writereq_threadid_s1,
    // s1 (reading mshr)
    output reg [`L15_THREADID_MASK] pipe_mshr_readreq_threadid_s1,
    output reg [`L15_MSHR_ID_WIDTH-1:0] pipe_mshr_readreq_mshrid_s1,
    input wire [`L15_CONTROL_WIDTH-1:0] mshr_pipe_readres_control_s1,
    input wire [`PACKET_HOME_ID_WIDTH-1:0] mshr_pipe_readres_homeid_s1,
    // s1/2/3 (address conflict checking)
        // tcov: 4 mshr per thread but 1 is unused
    input wire [(`L15_NUM_MSHRID_PER_THREAD*`L15_NUM_THREADS)-1:0] mshr_pipe_vals_s1,
    input wire [(`L15_PADDR_WIDTH*`L15_NUM_THREADS)-1:0] mshr_pipe_ld_address,
    input wire [(`L15_PADDR_WIDTH*`L15_NUM_THREADS)-1:0] mshr_pipe_st_address,
    input wire [(2*`L15_NUM_THREADS)-1:0] mshr_pipe_st_way_s1,
    input wire [(`L15_MESI_TRANS_STATE_WIDTH*`L15_NUM_THREADS)-1:0] mshr_pipe_st_state_s1,
    //s2 (loading store buffer)
    output reg pipe_mshr_write_buffer_rd_en_s2,
    output reg [`L15_THREADID_MASK] pipe_mshr_threadid_s2,
    input wire [`L15_UNPARAM_127_0] mshr_pipe_write_buffer_s2,
    input wire [`L15_UNPARAM_15_0] mshr_pipe_write_buffer_byte_mask_s2,
    //s3 (deallocation or updating write states)
    output reg pipe_mshr_val_s3,
    output reg [`L15_MSHR_WRITE_TYPE_WIDTH-1:0] pipe_mshr_op_s3,
    output reg [`L15_MSHR_ID_WIDTH-1:0] pipe_mshr_mshrid_s3,
    output reg [`L15_THREADID_MASK] pipe_mshr_threadid_s3,
    output reg [`L15_MESI_TRANS_STATE_WIDTH-1:0] pipe_mshr_write_update_state_s3,
    output reg [`L15_UNPARAM_1_0] pipe_mshr_write_update_way_s3,

    // PCX,CPX,NOC
    // cpx
    output reg l15_cpxencoder_val,
    output reg [`L15_UNPARAM_3_0] l15_cpxencoder_returntype,
    output reg l15_cpxencoder_l2miss,
    output reg [`L15_UNPARAM_1_0] l15_cpxencoder_error,  // tcov: to core but not utilized
    output reg l15_cpxencoder_noncacheable,
    output reg l15_cpxencoder_atomic,
    output reg [`L15_THREADID_MASK] l15_cpxencoder_threadid,
    output reg l15_cpxencoder_prefetch,
    output reg l15_cpxencoder_f4b,
    output reg [`L15_UNPARAM_63_0] l15_cpxencoder_data_0,
    output reg [`L15_UNPARAM_63_0] l15_cpxencoder_data_1,
    output reg [`L15_UNPARAM_63_0] l15_cpxencoder_data_2,
    output reg [`L15_UNPARAM_63_0] l15_cpxencoder_data_3,
    output reg l15_cpxencoder_inval_icache_all_way,
    output reg l15_cpxencoder_inval_dcache_all_way,         // tcov: to core but not utilized, inval individually
    output reg [15:4] l15_cpxencoder_inval_address_15_4,
    output reg l15_cpxencoder_cross_invalidate,             // tcov: to core but not utilized
    output reg [`L15_UNPARAM_1_0] l15_cpxencoder_cross_invalidate_way,   // tcov: to core but not utilized
    output reg l15_cpxencoder_inval_dcache_inval,
    output reg l15_cpxencoder_inval_icache_inval,           // tcov: to core but not utilized, instead inval all way
    output reg l15_cpxencoder_blockinitstore,
    output reg [`L15_UNPARAM_1_0] l15_cpxencoder_inval_way,
    // noc1
    output reg l15_noc1buffer_req_val,
    output reg [`L15_NOC1_REQTYPE_WIDTH-1:0] l15_noc1buffer_req_type,
    output reg [`L15_THREADID_MASK] l15_noc1buffer_req_threadid,
    output reg [`L15_MSHR_ID_WIDTH-1:0] l15_noc1buffer_req_mshrid,
    output reg [`L15_PADDR_MASK] l15_noc1buffer_req_address,
    output reg l15_noc1buffer_req_non_cacheable,
    output reg [`L15_UNPARAM_2_0] l15_noc1buffer_req_size,
    output reg l15_noc1buffer_req_prefetch,
    output reg [`TLB_CSM_WIDTH-1:0] l15_noc1buffer_req_csm_data,
    output reg [`L15_UNPARAM_63_0] l15_noc1buffer_req_data_0,
    output reg [`L15_UNPARAM_63_0] l15_noc1buffer_req_data_1,
    // output reg l15_noc1buffer_req_blkstore,
    // output reg l15_noc1buffer_req_blkinitstore,
    // noc3
    output reg l15_noc3encoder_req_val,
    output reg [`L15_NOC3_REQTYPE_WIDTH-1:0] l15_noc3encoder_req_type,
    output reg [`L15_UNPARAM_63_0] l15_noc3encoder_req_data_0,
    output reg [`L15_UNPARAM_63_0] l15_noc3encoder_req_data_1,
    output reg [`L15_MSHR_ID_WIDTH-1:0] l15_noc3encoder_req_mshrid,
    output reg [`L15_UNPARAM_1_0] l15_noc3encoder_req_sequenceid,
    output reg [`L15_THREADID_MASK] l15_noc3encoder_req_threadid,
    output reg [`L15_PADDR_MASK] l15_noc3encoder_req_address,
    output reg l15_noc3encoder_req_with_data,
    output reg l15_noc3encoder_req_was_inval,
    output reg [`L15_UNPARAM_3_0] l15_noc3encoder_req_fwdack_vector,
    output reg [`PACKET_HOME_ID_WIDTH-1:0] l15_noc3encoder_req_homeid,
    // ack to inputs
    output reg l15_pcxdecoder_ack,
    output reg l15_noc2decoder_ack,
    output reg l15_pcxdecoder_header_ack,
    output reg l15_noc2decoder_header_ack,

    // CSM
    output reg [`PHY_ADDR_WIDTH-1:0] l15_csm_req_address_s2,
    output reg l15_csm_req_val_s2,
    output reg l15_csm_stall_s3,
    output reg [`L15_CSM_NUM_TICKETS_LOG2-1:0] l15_csm_req_ticket_s2,
    // output reg [`HOME_ID_WIDTH-1:0] l15_csm_clump_tile_count_s2,
    output reg  l15_csm_req_type_s2,     //0 for load, 1 for store
    output reg [`L15_UNPARAM_127_0] l15_csm_req_data_s2, // remember to duplicate this in l15
    output reg [`TLB_CSM_WIDTH-1:0] l15_csm_req_pcx_data_s2, // remember to duplicate this in l15
    input wire csm_l15_res_val_s3,
    input wire [`L15_UNPARAM_63_0] csm_l15_res_data_s3,

    // homeid info to noc1buffer
    output reg [`L15_CSM_NUM_TICKETS_LOG2-1:0] l15_noc1buffer_req_csm_ticket,
    output reg [`PACKET_HOME_ID_WIDTH-1:0] l15_noc1buffer_req_homeid,
    output reg l15_noc1buffer_req_homeid_val,

    // output to config registers to pipeline
    output reg l15_config_req_val_s2,
    output reg l15_config_req_rw_s2,
    output reg [`L15_UNPARAM_63_0] l15_config_write_req_data_s2,
    output reg [`CONFIG_REG_ADDRESS_MASK] l15_config_req_address_s2
    );

// GLOBAL VARIABLES
reg stall_s1;
reg stall_s2;
reg stall_s3;
reg val_s1; // val_s1 is basically predecode_val_s1, so anything that depends on this...
reg val_s2;
reg val_s3;

// ack signals
reg pcx_ack_s1;
reg pcx_ack_s2;
reg pcx_ack_s3;
reg noc2_ack_s1;
reg noc2_ack_s2;
reg noc2_ack_s3;

// fetch state signals
// used in different stages in S1
reg [`L15_FETCH_STATE_WIDTH-1:0] fetch_state_s1;
reg [`L15_FETCH_STATE_WIDTH-1:0] fetch_state_next_s1;

// addresses from s2&s3, used to calculate stall_s1
reg [`L15_CACHE_INDEX_MASK] cache_index_s2;
reg [`L1D_ADDRESS_WIDTH-1:0] cache_index_l1d_s2;
reg [`L15_CACHE_INDEX_MASK] cache_index_s3;
reg [`L1D_ADDRESS_WIDTH-1:0] cache_index_l1d_s3;

// bought early, borrowed to calculate dtag way...
reg [`L15_WAY_MASK] lru_way_s2;

// PCX/NOC2 acks aggregator
always @ *
begin
    l15_pcxdecoder_ack = pcx_ack_s1 || pcx_ack_s2 || pcx_ack_s3;
    l15_noc2decoder_ack = noc2_ack_s1 || noc2_ack_s2 || noc2_ack_s3;
end

//////////////////////////
// STAGE 1
//////////////////////////
// Stage 1 is relatively long, consisting of the (concurrent and sequential) sequences
// * predecode: checks pcx&noc1&noc3 inputs and translates them to internal requests. should depends on nothing
// * creditman: check noc1buffer and stalls the pcx input if no space. depends on predecode
// * fetchstate: keeps track of message fissioning (eg.: an invalidation needs to be splitted to 4 invals to 4 indices)
// * decoder: decodes internal requests -> control bits

//////////////////////////
// PREDECODE
//////////////////////////
// depends on nothing
reg [`L15_CACHE_TAG_WIDTH-1:0] predecode_dtag_write_data_s1;
reg [`L15_CACHE_INDEX_MASK] predecode_cache_index_s1;
// reg [`L15_PADDR_MASK] predecode_mshr_address_s1;
reg [`L15_CONTROL_WIDTH-1:0] predecode_mshr_read_control_s1;
reg [`PACKET_HOME_ID_WIDTH-1:0] predecode_mshr_read_homeid_s1;
reg [`L15_REQTYPE_WIDTH-1:0] predecode_reqtype_s1;
reg [`L15_PADDR_MASK] predecode_address_s1;
reg [`L15_PADDR_MASK] predecode_address_plus0_s1;
reg [`L15_PADDR_MASK] predecode_address_plus1_s1;
reg [`L15_PADDR_MASK] predecode_address_plus2_s1;
reg [`L15_PADDR_MASK] predecode_address_plus3_s1;
reg [`L15_UNPARAM_2_0] predecode_size_s1;
reg [`L15_THREADID_MASK] predecode_threadid_s1;
reg [`L15_WAY_MASK] predecode_l1_replacement_way_s1;
reg predecode_non_cacheable_s1;
reg predecode_is_last_inval_s1;
// reg predecode_icache_do_inval_s1;
reg predecode_blockstore_bit_s1;
reg predecode_blockstore_init_s1;
reg predecode_prefetch_bit_s1;
// reg predecode_invalidate_index_s1;
reg predecode_l2_miss_s1;
reg predecode_f4b_s1;
reg predecode_dcache_load_s1;
reg predecode_atomic_s1;
reg predecode_dcache_noc2_store_im_s1;
reg predecode_dcache_noc2_store_sm_s1;
reg predecode_icache_bit_s1;
reg predecode_noc2_inval_s1;
reg predecode_val_s1;
reg [`L15_PREDECODE_SOURCE_WIDTH-1:0] predecode_source_s1;
reg predecode_interrupt_broadcast_s1;
reg [`L15_UNPARAM_3_0] predecode_fwd_subcacheline_vector_s1;

always @ *
begin
    predecode_source_s1 = 0;

    case (fetch_state_s1)
        `L15_FETCH_STATE_NORMAL:
            predecode_source_s1 = (noc2decoder_l15_val) ? `L15_PREDECODE_SOURCE_NOC2 :
                                    (pcxdecoder_l15_val) ? `L15_PREDECODE_SOURCE_PCX :
                                                            `L15_PREDECODE_SOURCE_INVALID;
        `L15_FETCH_STATE_PCX_WRITEBACK_DONE:
            predecode_source_s1 = `L15_PREDECODE_SOURCE_PCX;
        `L15_FETCH_STATE_NOC2_WRITEBACK_DONE:
            predecode_source_s1 = `L15_PREDECODE_SOURCE_NOC2;
        `L15_FETCH_STATE_INVAL_2,
        `L15_FETCH_STATE_INVAL_3,
        `L15_FETCH_STATE_INVAL_4:
            predecode_source_s1 = `L15_PREDECODE_SOURCE_NOC2;
        `L15_FETCH_STATE_ICACHE_INVAL_2:
            predecode_source_s1 = `L15_PREDECODE_SOURCE_NOC2;
    endcase
end

// retrieve mshr info from mshr module
// and expanding signals
reg [`L15_NUM_MSHRID_PER_THREAD-1:0] mshr_val_array [`L15_THREAD_ARRAY_MASK];
`ifdef PITON_ASIC_RTL
reg [`L15_MESI_TRANS_STATE_WIDTH:0] mshr_st_state_array [`L15_THREAD_ARRAY_MASK];
`else
reg [`L15_MESI_TRANS_STATE_WIDTH-1:0] mshr_st_state_array [`L15_THREAD_ARRAY_MASK];
`endif
reg [`L15_PADDR_MASK] mshr_st_address_array [`L15_THREAD_ARRAY_MASK];
reg [`L15_PADDR_MASK] mshr_ld_address_array [`L15_THREAD_ARRAY_MASK];
reg [`L15_WAY_MASK] mshr_st_way_array [`L15_THREAD_ARRAY_MASK];
always @ *
begin
    pipe_mshr_readreq_mshrid_s1 = noc2decoder_l15_mshrid;
    pipe_mshr_readreq_threadid_s1 = noc2decoder_l15_threadid;

    predecode_mshr_read_control_s1 = mshr_pipe_readres_control_s1;
    // predecode_mshr_read_address_s1 = mshr_pipe_address_s1;
    predecode_mshr_read_homeid_s1 = mshr_pipe_readres_homeid_s1;

    // mshr_val_array
    mshr_val_array[0] = mshr_pipe_vals_s1[`L15_NUM_MSHRID_PER_THREAD*1 - 1 -: `L15_NUM_MSHRID_PER_THREAD];
    mshr_st_state_array[0] = mshr_pipe_st_state_s1[`L15_MESI_TRANS_STATE_WIDTH*1 - 1 -: `L15_MESI_TRANS_STATE_WIDTH];
    mshr_st_address_array[0] = mshr_pipe_st_address[`L15_PADDR_WIDTH*1 - 1 -: `L15_PADDR_WIDTH];
    mshr_ld_address_array[0] = mshr_pipe_ld_address[`L15_PADDR_WIDTH*1 - 1 -: `L15_PADDR_WIDTH];
    mshr_st_way_array[0] = mshr_pipe_st_way_s1[2*1 - 1 -: 2];

    mshr_val_array[1] = mshr_pipe_vals_s1[`L15_NUM_MSHRID_PER_THREAD*2 - 1 -: `L15_NUM_MSHRID_PER_THREAD];
    mshr_st_state_array[1] = mshr_pipe_st_state_s1[`L15_MESI_TRANS_STATE_WIDTH*2 - 1 -: `L15_MESI_TRANS_STATE_WIDTH];
    mshr_st_address_array[1] = mshr_pipe_st_address[`L15_PADDR_WIDTH*2 - 1 -: `L15_PADDR_WIDTH];
    mshr_ld_address_array[1] = mshr_pipe_ld_address[`L15_PADDR_WIDTH*2 - 1 -: `L15_PADDR_WIDTH];
    mshr_st_way_array[1] = mshr_pipe_st_way_s1[2*2 - 1 -: 2];
end

// match pcx address to special accesses
reg [`L15_ADDR_TYPE_WIDTH-1:0] predecode_special_access_s1;
reg predecode_is_pcx_config_asi_s1;
reg predecode_is_pcx_diag_data_access_s1;
reg predecode_is_pcx_diag_line_flush_s1;
reg predecode_is_hmc_diag_access_s1;
reg predecode_is_hmc_flush_s1;
always @ *
begin
    predecode_special_access_s1 = pcxdecoder_l15_address[`L15_ADDR_TYPE];
    predecode_is_pcx_config_asi_s1 = predecode_special_access_s1 == `L15_ADDR_TYPE_CONFIG_REGS;
    predecode_is_pcx_diag_data_access_s1 = predecode_special_access_s1 == `L15_ADDR_TYPE_DATA_ACCESS;
    predecode_is_pcx_diag_line_flush_s1 = predecode_special_access_s1 == `L15_ADDR_TYPE_LINE_FLUSH;
    predecode_is_hmc_diag_access_s1 = predecode_special_access_s1 == `L15_ADDR_TYPE_HMC_ACCESS;
    predecode_is_hmc_flush_s1 = predecode_special_access_s1 == `L15_ADDR_TYPE_HMC_FLUSH;
end

// decode requests to predecode signals
reg predecode_tagcheck_matched_t0ld_s1;
reg predecode_tagcheck_matched_t0st_s1;
reg predecode_tagcheck_matched_t1ld_s1;
reg predecode_tagcheck_matched_t1st_s1;
reg predecode_int_vec_dis_s1;
reg predecode_tagcheck_matched_s1;
reg [19:4] predecode_partial_tag_s1;
reg predecode_hit_stbuf_s1;
reg [`L15_THREADID_MASK] predecode_hit_stbuf_threadid_s1;

wire [`L15_PADDR_MASK] constant_int_vec_dis_address = `L15_INT_VEC_DIS;

always @ *
begin
    predecode_reqtype_s1 = 0;
    predecode_address_s1 = 0;
    predecode_address_plus0_s1 = 0;
    predecode_address_plus1_s1 = 0;
    predecode_address_plus2_s1 = 0;
    predecode_address_plus3_s1 = 0;
    predecode_is_last_inval_s1 = 0;
    // predecode_icache_do_inval_s1 = 0;
    predecode_size_s1 = 0;
    predecode_threadid_s1 = 0;
    predecode_l1_replacement_way_s1 = 0;
    predecode_non_cacheable_s1 = 0;
    predecode_blockstore_bit_s1 = 0;
    predecode_blockstore_init_s1 = 0;
    predecode_prefetch_bit_s1 = 0;
    // predecode_invalidate_index_s1 = 0;
    predecode_l2_miss_s1 = 0;
    predecode_f4b_s1 = 0;
    predecode_icache_bit_s1 = 0;
    predecode_dcache_load_s1 = 0;
    predecode_atomic_s1 = 0;
    predecode_dcache_noc2_store_im_s1 = 0;
    predecode_dcache_noc2_store_sm_s1 = 0;
    predecode_noc2_inval_s1 = 0;
    predecode_fwd_subcacheline_vector_s1 = 0;
    predecode_interrupt_broadcast_s1 = 0;
    case (predecode_source_s1)
        `L15_PREDECODE_SOURCE_NOC2:
        begin
            // predecode_address_s1 = predecode_mshr_address_s1;
            predecode_size_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_SIZE_3B -: 3];
            // predecode_threadid_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_THREADID -: `L15_THREADID_WIDTH];
            predecode_threadid_s1[`L15_THREADID_MASK] = noc2decoder_l15_threadid[`L15_THREADID_MASK];
            predecode_l1_replacement_way_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_L1_REPLACEMENT_WAY_2B -: 2];
            predecode_non_cacheable_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_NC_1B -: 1];
            // 4.16.14: disable blockstores
            predecode_blockstore_bit_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_BLOCKSTORE_1B -: 1];
            predecode_blockstore_init_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_BLOCKSTOREINIT_1B -: 1];
            predecode_prefetch_bit_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_PREFETCH_1B -: 1];
            // predecode_invalidate_index_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_INVALIDATE_INDEX_1B -: 1];
            predecode_l2_miss_s1 = noc2decoder_l15_l2miss;
            predecode_f4b_s1 = noc2decoder_l15_f4b;
            predecode_atomic_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_ATOMIC];
            predecode_dcache_load_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_LOAD];
            predecode_fwd_subcacheline_vector_s1 = noc2decoder_l15_fwd_subcacheline_vector;

            predecode_dcache_noc2_store_im_s1 = mshr_st_state_array[predecode_threadid_s1] == `L15_MESI_TRANSITION_STATE_IM;
            predecode_dcache_noc2_store_sm_s1 = mshr_st_state_array[predecode_threadid_s1] == `L15_MESI_TRANSITION_STATE_SM;


            predecode_address_plus0_s1 = {noc2decoder_l15_address[39:6], 2'b00, noc2decoder_l15_address[`L15_UNPARAM_3_0]};
            predecode_address_plus1_s1 = {noc2decoder_l15_address[39:6], 2'b01, noc2decoder_l15_address[`L15_UNPARAM_3_0]};
            predecode_address_plus2_s1 = {noc2decoder_l15_address[39:6], 2'b10, noc2decoder_l15_address[`L15_UNPARAM_3_0]};
            predecode_address_plus3_s1 = {noc2decoder_l15_address[39:6], 2'b11, noc2decoder_l15_address[`L15_UNPARAM_3_0]};

            if (noc2decoder_l15_icache_type)
                predecode_is_last_inval_s1 = ((fetch_state_s1 == `L15_FETCH_STATE_ICACHE_INVAL_2) && (predecode_fwd_subcacheline_vector_s1[3:2] == 2'b11)) ||
                                             ((fetch_state_s1 == `L15_FETCH_STATE_NORMAL) && (predecode_fwd_subcacheline_vector_s1[`L15_UNPARAM_3_0] == 4'b0011));
                // predecode_is_last_inval_s1 = ((fetch_state_s1 == `L15_FETCH_STATE_ICACHE_INVAL_2));
            else
                predecode_is_last_inval_s1 = ((fetch_state_s1 == `L15_FETCH_STATE_INVAL_4) && (predecode_fwd_subcacheline_vector_s1[3])) ||
                                             ((fetch_state_s1 == `L15_FETCH_STATE_INVAL_3) && (predecode_fwd_subcacheline_vector_s1[3:2] == 2'b01)) ||
                                             ((fetch_state_s1 == `L15_FETCH_STATE_INVAL_2) && (predecode_fwd_subcacheline_vector_s1[3:1] == 3'b001)) ||
                                             ((fetch_state_s1 == `L15_FETCH_STATE_NORMAL) && (predecode_fwd_subcacheline_vector_s1[`L15_UNPARAM_3_0] == 4'b0001));

            // predecode_icache_do_inval_s1 = ((fetch_state_s1 == `L15_FETCH_STATE_ICACHE_INVAL_2) && predecode_fwd_subcacheline_vector_s1[3:2] == 2'b11) ||
            //                                 ((fetch_state_s1 == `L15_FETCH_STATE_NORMAL) && predecode_fwd_subcacheline_vector_s1[`L15_UNPARAM_1_0] == 2'b11);
            // predecode_icache_do_inval_s1 = 1'b1;

            case(noc2decoder_l15_reqtype)
                `MSG_TYPE_STORE_FWD:
                begin
                    predecode_icache_bit_s1 = noc2decoder_l15_icache_type;
                    if (predecode_icache_bit_s1)
                    begin
                        // if (predecode_icache_do_inval_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ICACHE_INVALIDATION;
                        // else
                        //     predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                        predecode_address_s1 = (fetch_state_s1 == `L15_FETCH_STATE_ICACHE_INVAL_2) ? predecode_address_plus2_s1 :
                                                                                                predecode_address_plus0_s1;
                    end
                    else
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_INVALIDATION;
                        predecode_address_s1 = (fetch_state_s1 == `L15_FETCH_STATE_INVAL_2) ? predecode_address_plus1_s1 :
                                                (fetch_state_s1 == `L15_FETCH_STATE_INVAL_3) ? predecode_address_plus2_s1 :
                                                (fetch_state_s1 == `L15_FETCH_STATE_INVAL_4) ? predecode_address_plus3_s1 :
                                                                                                predecode_address_plus0_s1;
                    end
                end
                `MSG_TYPE_INV_FWD:
                begin
                    predecode_icache_bit_s1 = noc2decoder_l15_icache_type;
                    if (predecode_icache_bit_s1)
                    begin
                        // if (predecode_icache_do_inval_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ICACHE_INVALIDATION;
                        // else
                        //     predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                        predecode_address_s1 = (fetch_state_s1 == `L15_FETCH_STATE_ICACHE_INVAL_2) ? predecode_address_plus2_s1 :
                                                                                                predecode_address_plus0_s1;
                    end
                    else
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_INVALIDATION;
                        predecode_noc2_inval_s1 = 1'b1;
                        predecode_address_s1 = (fetch_state_s1 == `L15_FETCH_STATE_INVAL_2) ? predecode_address_plus1_s1 :
                                                (fetch_state_s1 == `L15_FETCH_STATE_INVAL_3) ? predecode_address_plus2_s1 :
                                                (fetch_state_s1 == `L15_FETCH_STATE_INVAL_4) ? predecode_address_plus3_s1 :
                                                                                                predecode_address_plus0_s1;
                    end
                end
                `MSG_TYPE_LOAD_FWD:
                begin
                    predecode_icache_bit_s1 = noc2decoder_l15_icache_type;
                    if (predecode_icache_bit_s1)
                    begin
                        // if (predecode_icache_do_inval_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ICACHE_INVALIDATION;
                        // else
                        //     predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                        predecode_address_s1 = (fetch_state_s1 == `L15_FETCH_STATE_ICACHE_INVAL_2) ? predecode_address_plus2_s1 :
                                                                                                predecode_address_plus0_s1;
                    end
                    else
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_DOWNGRADE;
                        predecode_address_s1 = (fetch_state_s1 == `L15_FETCH_STATE_INVAL_2) ? predecode_address_plus1_s1 :
                                                (fetch_state_s1 == `L15_FETCH_STATE_INVAL_3) ? predecode_address_plus2_s1 :
                                                (fetch_state_s1 == `L15_FETCH_STATE_INVAL_4) ? predecode_address_plus3_s1 :
                                                                                                predecode_address_plus0_s1;
                    end
                end
                `MSG_TYPE_DATA_ACK, `MSG_TYPE_NC_LOAD_MEM_ACK:
                begin
                    predecode_icache_bit_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_ICACHE];

                    if (noc2decoder_l15_mshrid == `L15_MSHR_ID_LD)
                        predecode_address_s1 = mshr_ld_address_array[noc2decoder_l15_threadid];
                    else if (noc2decoder_l15_mshrid == `L15_MSHR_ID_ST)
                        predecode_address_s1 = mshr_st_address_array[noc2decoder_l15_threadid];

                    if (noc2decoder_l15_hmc_fill)
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_HMC_FILL;
                        predecode_address_s1 = 0;   // more bug fix, no mshr entry is associated with this
                    end
                    else
                    if (predecode_non_cacheable_s1)
                    begin
                        if (predecode_icache_bit_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_IFILL;
                        else if (predecode_dcache_load_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_LD_NC;
                        else if (predecode_atomic_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACK_ATOMIC;
                        else
                            predecode_reqtype_s1 = `L15_REQTYPE_IGNORE; // error case
                    end
                    else
                    begin
                        if (predecode_icache_bit_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_IFILL;
                        else if (predecode_atomic_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_LR;
                            // Only Load Reserve is both Cacheable and AMO 
                            // (just store NC=0 to mshr[in MSHR S1 logic], nc bit is still 1 in LR PCX req)
                        else if (predecode_dcache_load_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_LD;
                        else if (predecode_dcache_noc2_store_im_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_ST_IM;
                        else if (predecode_dcache_noc2_store_sm_s1)
                            predecode_reqtype_s1 = `L15_REQTYPE_ACKDT_ST_SM;
                        else
                            predecode_reqtype_s1 = `L15_REQTYPE_IGNORE; // error case
                    end
                end
                `MSG_TYPE_NODATA_ACK, `MSG_TYPE_NC_STORE_MEM_ACK:
                begin
                    predecode_icache_bit_s1 = predecode_mshr_read_control_s1[`L15_CONTROL_ICACHE];
                    predecode_address_s1 = mshr_st_address_array[noc2decoder_l15_threadid];

                    // one way to distinguish prefetch ack from write-through ack is the mshrid
                    if (noc2decoder_l15_mshrid == `L15_MSHR_ID_ST)
                        predecode_reqtype_s1 = `L15_REQTYPE_ACK_WRITETHROUGH;
                    else
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_ACK_PREFETCH;
                        predecode_address_s1 = 0; // bug fix, address cannot be X's
                    end

                end
                `MSG_TYPE_INTERRUPT:
                begin
                    predecode_reqtype_s1 = `L15_REQTYPE_L2_INTERRUPT;
                end
            endcase
        end

        `L15_PREDECODE_SOURCE_PCX:
        begin
            predecode_address_s1 = pcxdecoder_l15_address;
            predecode_size_s1 = pcxdecoder_l15_size;
            predecode_threadid_s1[`L15_THREADID_MASK] = pcxdecoder_l15_threadid[`L15_THREADID_MASK];
            predecode_l1_replacement_way_s1 = pcxdecoder_l15_l1rplway;
            predecode_non_cacheable_s1 = pcxdecoder_l15_nc;
            predecode_blockstore_bit_s1 = pcxdecoder_l15_blockstore;
            predecode_blockstore_init_s1 = pcxdecoder_l15_blockinitstore;
            predecode_prefetch_bit_s1 = pcxdecoder_l15_prefetch;
            // predecode_invalidate_index_s1 = pcxdecoder_l15_invalall;

            case(pcxdecoder_l15_rqtype)
                `PCX_REQTYPE_LOAD:
                begin
                    if (predecode_is_pcx_config_asi_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_LOAD_CONFIG_REG;
                    else if (predecode_is_pcx_diag_data_access_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_DIAG_LOAD;
                    else if (predecode_is_hmc_diag_access_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_HMC_DIAG_LOAD;
                    else if (predecode_prefetch_bit_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_LOAD_PREFETCH;
                    else if (predecode_non_cacheable_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_LOAD_NC;
                    else if (pcxdecoder_l15_invalidate_cacheline)
                        predecode_reqtype_s1 = `L15_REQTYPE_DCACHE_SELF_INVALIDATION;
                    else
                        predecode_reqtype_s1 = `L15_REQTYPE_LOAD;
                    predecode_dcache_load_s1 = 1;
                end
                `PCX_REQTYPE_IFILL:
                begin
                    if (pcxdecoder_l15_invalidate_cacheline)
                        predecode_reqtype_s1 = `L15_REQTYPE_ICACHE_SELF_INVALIDATION;
                    else
                        predecode_reqtype_s1 = `L15_REQTYPE_IFILL;
                    predecode_icache_bit_s1 = 1;
                end
                `PCX_REQTYPE_STORE:
                    if (predecode_is_pcx_config_asi_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_WRITE_CONFIG_REG;
                    else if (predecode_is_pcx_diag_data_access_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_DIAG_STORE;
                    else if (predecode_is_pcx_diag_line_flush_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_LINE_FLUSH;
                    else if (predecode_is_hmc_diag_access_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_HMC_DIAG_STORE;
                    else if (predecode_is_hmc_flush_s1)
                        predecode_reqtype_s1 = `L15_REQTYPE_HMC_FLUSH;
                    else if (predecode_non_cacheable_s1)
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_WRITETHROUGH;
                        // bug 108: clear blocksotre/prefetch bit to distinguish returned prefetch load
                        // predecode_blockstore_bit_s1 = 1'b0;
                        // predecode_blockstore_init_s1 = 1'b0;
                        predecode_prefetch_bit_s1 = 1'b0;
                    end
                    else
                        predecode_reqtype_s1 = `L15_REQTYPE_STORE;
                //`PCX_REQTYPE_CAS1:
                //begin
                //    predecode_reqtype_s1 = `L15_REQTYPE_CAS;
                //    predecode_atomic_s1 = 1;
                //end
                //`PCX_REQTYPE_CAS2:
                //    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                //`PCX_REQTYPE_SWP_LOADSTUB:
                //begin
                //    predecode_reqtype_s1 = `L15_REQTYPE_SWP_LOADSTUB;
                //    predecode_atomic_s1 = 1;
                //end
                `PCX_REQTYPE_AMO:
                begin
                    case (pcxdecoder_l15_amo_op)
                    `L15_AMO_OP_NONE:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                    end
                    `L15_AMO_OP_LR:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_LR;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_SC:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_SC;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_SWAP:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_SWP_LOADSTUB;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_ADD:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_ADD;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_AND:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_AND;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_OR:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_OR;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_XOR:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_XOR;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_MAX:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_MAX;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_MAXU:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_MAXU;
                        predecode_atomic_s1 = 1;

                    end
                    `L15_AMO_OP_MIN:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_MIN;
                        predecode_atomic_s1 = 1;

                    end
                    `L15_AMO_OP_MINU:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_AMO_MINU;
                        predecode_atomic_s1 = 1;

                    end
                    `L15_AMO_OP_CAS1:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_CAS;
                        predecode_atomic_s1 = 1;
                    end
                    `L15_AMO_OP_CAS2:
                    begin
                        predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                    end
                    endcase
                end
                `PCX_REQTYPE_INTERRUPT:
                begin
                    predecode_reqtype_s1 = `L15_REQTYPE_PCX_INTERRUPT;
                    predecode_interrupt_broadcast_s1 = predecode_non_cacheable_s1;
                end
                `PCX_REQTYPE_FP1:
                    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                `PCX_REQTYPE_FP2:
                    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                `PCX_REQTYPE_STREAM_LOAD:
                    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                `PCX_REQTYPE_STREAM_STORE:
                    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                `PCX_REQTYPE_FWD_REQ:
                    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
                `PCX_REQTYPE_FWD_REPLY:
                    predecode_reqtype_s1 = `L15_REQTYPE_IGNORE;
            endcase
        end
    endcase

    predecode_val_s1 = (predecode_source_s1 != `L15_PREDECODE_SOURCE_INVALID);
    val_s1 = predecode_val_s1;

    predecode_cache_index_s1[`L15_CACHE_INDEX_WIDTH-1:0]
         = predecode_address_s1[`L15_IDX_HI:`L15_IDX_LOW]; // index should be 7b (128 indices); // trinn
    predecode_dtag_write_data_s1[`L15_CACHE_TAG_WIDTH-1:0] = predecode_address_s1[`L15_CACHE_TAG_HI:`L15_CACHE_TAG_LOW];

    // GENERATE INTERRUPT
    // `define L15_INT_VEC_DIS 40'h98_0000_0800
    // predecode_int_vec_dis_s1 = (pcxdecoder_l15_address == `L15_INT_VEC_DIS); // 40b compare
    predecode_int_vec_dis_s1 = (pcxdecoder_l15_address[39:32] == constant_int_vec_dis_address[39:32] 
                              && pcxdecoder_l15_address[11:8] == constant_int_vec_dis_address[11:8]); 


    // TAG CHECKING
    predecode_partial_tag_s1[19:4] = pcxdecoder_l15_address[19:4]; // compare partial tag to save energy & timing
    predecode_tagcheck_matched_t0ld_s1 = mshr_val_array[0][`L15_MSHR_ID_LD] 
                                        && (predecode_partial_tag_s1[19:4] == mshr_ld_address_array[0][19:4]);
    predecode_tagcheck_matched_t1ld_s1 = mshr_val_array[1][`L15_MSHR_ID_LD] 
                                        && (predecode_partial_tag_s1[19:4] == mshr_ld_address_array[1][19:4]);
    predecode_tagcheck_matched_t0st_s1 = mshr_val_array[0][`L15_MSHR_ID_ST] 
                                        && (pcxdecoder_l15_address[39:4] == mshr_st_address_array[0][39:4]);
    predecode_tagcheck_matched_t1st_s1 = mshr_val_array[1][`L15_MSHR_ID_ST] 
                                        && (pcxdecoder_l15_address[39:4] == mshr_st_address_array[1][39:4]);

    predecode_tagcheck_matched_s1 = predecode_tagcheck_matched_t0ld_s1 || predecode_tagcheck_matched_t1ld_s1
                                    || predecode_tagcheck_matched_t0st_s1 || predecode_tagcheck_matched_t1st_s1;


    // misc
    predecode_hit_stbuf_s1 = predecode_tagcheck_matched_t0st_s1 || predecode_tagcheck_matched_t1st_s1;
    predecode_hit_stbuf_threadid_s1 = predecode_tagcheck_matched_t1st_s1 ? 1'b1 : 1'b0;
    // note: only work with 2 threads for now; need to change the algo of mshr if need to increase the num of threads
end

//////////////////////////
// NOC1 CREDIT MANAGEMENT
//////////////////////////
// this module is needed to ensure that interaction with Noc1 does not
// deadlock NoC.
// creditman depends on predecode (and stall signal)
// its dependencies are: none

reg [`L15_UNPARAM_3_0] creditman_noc1_avail;
reg [`L15_UNPARAM_3_0] creditman_noc1_data_avail;
reg [`L15_UNPARAM_3_0] creditman_noc1_avail_next;
reg [`L15_UNPARAM_3_0] creditman_noc1_data_avail_next;
reg [`L15_UNPARAM_3_0] creditman_noc1_reserve;
reg [`L15_UNPARAM_3_0] creditman_noc1_reserve_next;

always @ (posedge clk)
begin
    if (!rst_n)
    begin
        creditman_noc1_avail <= `NOC1_BUFFER_NUM_SLOTS;
        creditman_noc1_data_avail <= `NOC1_BUFFER_NUM_DATA_SLOTS;
        creditman_noc1_reserve <= 0;
    end
    else
    begin
        creditman_noc1_avail <= creditman_noc1_avail_next;
        creditman_noc1_data_avail <= creditman_noc1_data_avail_next;
        creditman_noc1_reserve <= creditman_noc1_reserve_next;
    end
end

reg creditman_noc1_data_add1;
reg creditman_noc1_data_add2;
reg creditman_noc1_data_minus1;
reg creditman_noc1_data_minus2;
reg creditman_noc1_add2;
reg creditman_noc1_add1;
reg creditman_noc1_minus1;
reg creditman_noc1_minus2;
reg creditman_noc1_reserve_add1;
reg creditman_noc1_reserve_minus1;

always @ *
begin
    creditman_noc1_avail_next = creditman_noc1_add2 ? creditman_noc1_avail + 2 :
                             creditman_noc1_add1 ? creditman_noc1_avail + 1 :
                             creditman_noc1_minus1 ? creditman_noc1_avail - 1 :
                             creditman_noc1_minus2 ? creditman_noc1_avail - 2 :
                                                creditman_noc1_avail;
    creditman_noc1_data_avail_next = creditman_noc1_data_add1 ? creditman_noc1_data_avail + 1 :
                                    creditman_noc1_data_add2 ? creditman_noc1_data_avail + 2 :
                                    creditman_noc1_data_minus1 ? creditman_noc1_data_avail - 1 :
                                    creditman_noc1_data_minus2 ? creditman_noc1_data_avail - 2 :
                                                            creditman_noc1_data_avail;

    creditman_noc1_reserve_next = creditman_noc1_reserve_add1 ? creditman_noc1_reserve + 1 :
                                  creditman_noc1_reserve_minus1 ? creditman_noc1_reserve - 1 :
                                                                creditman_noc1_reserve;
end

reg creditman_noc1_mispredicted_s3;
reg creditman_noc1_reserve_s3;
reg creditman_noc1_req;

reg creditman_noc1_upX;
reg creditman_noc1_up1;
reg creditman_noc1_up2;
reg creditman_noc1_down1;
reg creditman_noc1_down2;
reg creditman_noc1_data_up1;
reg creditman_noc1_data_up2;
reg creditman_noc1_data_down1;
reg creditman_noc1_data_down2;

reg decoder_creditman_req_8B_s1;
reg decoder_creditman_req_16B_s1;
reg [`L15_UNPARAM_1_0] decoder_creditman_noc1_needed;
reg decoder_creditman_noc1_unreserve_s1;

always @ *
begin
    creditman_noc1_req = val_s1 && !stall_s1 && (decoder_creditman_noc1_needed != 2'd0);

    // misprediction is necessary because we want to allocate buffer at the beginning but not until
    //  tag access will the pipeline know whether a noc1 transaction is needed or not
    creditman_noc1_upX = noc1encoder_l15_req_sent || creditman_noc1_mispredicted_s3;
    creditman_noc1_up1 = noc1encoder_l15_req_sent ^ creditman_noc1_mispredicted_s3;
    creditman_noc1_up2 = noc1encoder_l15_req_sent && creditman_noc1_mispredicted_s3;
    creditman_noc1_down1 = creditman_noc1_req && decoder_creditman_noc1_needed == 2'd1;
    creditman_noc1_down2 = creditman_noc1_req && decoder_creditman_noc1_needed == 2'd2;

    creditman_noc1_add2 = creditman_noc1_up2 && ~creditman_noc1_req;
    creditman_noc1_add1 = (creditman_noc1_up2 && creditman_noc1_down1) || (creditman_noc1_up1 && ~creditman_noc1_req);
    creditman_noc1_minus1 = (creditman_noc1_down2 && creditman_noc1_up1) || (creditman_noc1_down1 && !creditman_noc1_upX);
    creditman_noc1_minus2 = creditman_noc1_down2 && !creditman_noc1_upX;

    creditman_noc1_data_up1 = noc1encoder_l15_req_sent && (noc1encoder_l15_req_data_sent == `NOC1_BUFFER_ACK_DATA_8B);
    // COV: 0 and 1 is impossible here
    creditman_noc1_data_up2 = noc1encoder_l15_req_sent && (noc1encoder_l15_req_data_sent == `NOC1_BUFFER_ACK_DATA_16B);

    creditman_noc1_data_down1 = creditman_noc1_req && decoder_creditman_req_8B_s1;
    creditman_noc1_data_down2 = creditman_noc1_req && decoder_creditman_req_16B_s1;

    creditman_noc1_data_add2 = creditman_noc1_data_up2 && !creditman_noc1_data_down1 && !creditman_noc1_data_down2;
    creditman_noc1_data_add1 = creditman_noc1_data_up1 &&  !creditman_noc1_data_down1 && !creditman_noc1_data_down2 ||
                            creditman_noc1_data_up2 && creditman_noc1_data_down1;
    creditman_noc1_data_minus2 = creditman_noc1_data_down2 && !creditman_noc1_data_up1 && !creditman_noc1_data_up2;
    creditman_noc1_data_minus1 = creditman_noc1_data_down1 &&  !creditman_noc1_data_up1 && !creditman_noc1_data_up2 ||
                            creditman_noc1_data_down2 && creditman_noc1_data_up1;


    creditman_noc1_reserve_add1 = (creditman_noc1_reserve_s3 && !stall_s3 && val_s3) 
                                    && !(val_s1 && !stall_s1 && decoder_creditman_noc1_unreserve_s1);
    creditman_noc1_reserve_minus1 = !(creditman_noc1_reserve_s3 && !stall_s3 && val_s3) 
                                    && (val_s1 && !stall_s1 && decoder_creditman_noc1_unreserve_s1);
end

////////////////////////////////
// Fetch_state stage (s1)
////////////////////////////////
// fetch state comes after predecoding because fetch_state_next needs information from predecoding
//  (as shown in below temp variables)
// Other stages in S1 can use fetch_state because it's a flop
// depends on predecode

// temp variables
reg fetch_is_pcx_atomic_instruction_s1;
// reg fetch_is_pcx_blockstore_instruction_s1;
reg fetch_is_pcx_storenc_instruction_s1;
reg fetch_is_pcx_loadnc_instruction_s1;
reg fetch_is_noc2_data_invalidation_s1;
reg fetch_is_noc2_instruction_invalidation_s1;
reg fetch_is_noc2_ackdt_s1;
reg fetch_is_pcx_flush_s1;

always @ (posedge clk)
begin
    if (!rst_n)
    begin
        fetch_state_s1 <= `L15_FETCH_STATE_NORMAL;
    end
    else
    begin
        fetch_state_s1 <= fetch_state_next_s1;
    end
end

always @ *
begin
    fetch_is_pcx_atomic_instruction_s1 =
        (predecode_reqtype_s1 == `L15_REQTYPE_CAS ||
         predecode_reqtype_s1 == `L15_REQTYPE_SWP_LOADSTUB ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_LR ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_SC ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_ADD ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_AND ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_OR ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_XOR ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_MAX ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_MAXU ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_MIN ||
         predecode_reqtype_s1 == `L15_REQTYPE_AMO_MINU);
    // fetch_is_pcx_blockstore_instruction_s1 = 0;
    fetch_is_pcx_storenc_instruction_s1 = (predecode_reqtype_s1 == `L15_REQTYPE_WRITETHROUGH) && !predecode_int_vec_dis_s1;
    fetch_is_pcx_loadnc_instruction_s1 = (predecode_reqtype_s1 == `L15_REQTYPE_LOAD_NC);
    fetch_is_noc2_data_invalidation_s1 = (predecode_reqtype_s1 == `L15_REQTYPE_INVALIDATION ||
                                    predecode_reqtype_s1 == `L15_REQTYPE_DOWNGRADE);
    fetch_is_noc2_instruction_invalidation_s1 = (predecode_reqtype_s1 == `L15_REQTYPE_ICACHE_INVALIDATION);
    fetch_is_noc2_ackdt_s1 = (predecode_reqtype_s1 == `L15_REQTYPE_ACKDT_LD || predecode_reqtype_s1 == `L15_REQTYPE_ACKDT_ST_IM || predecode_reqtype_s1 == `L15_REQTYPE_ACKDT_LR);
    fetch_state_next_s1 = `L15_FETCH_STATE_NORMAL;
    fetch_is_pcx_flush_s1 = predecode_reqtype_s1 == `L15_REQTYPE_LINE_FLUSH;

    case (fetch_state_s1)
        `L15_FETCH_STATE_NORMAL:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_NORMAL;
            if (!stall_s1)
            begin
                // AMO_SC can be finished within one cycle.
                if ((fetch_is_pcx_atomic_instruction_s1 && (predecode_reqtype_s1 != `L15_REQTYPE_AMO_SC))
                    || fetch_is_pcx_storenc_instruction_s1 || fetch_is_pcx_loadnc_instruction_s1 || fetch_is_pcx_flush_s1)
                    fetch_state_next_s1 = `L15_FETCH_STATE_PCX_WRITEBACK_DONE;
                else if (fetch_is_noc2_data_invalidation_s1)
                    fetch_state_next_s1 = `L15_FETCH_STATE_INVAL_2;
                else if (fetch_is_noc2_instruction_invalidation_s1)
                    fetch_state_next_s1 = `L15_FETCH_STATE_ICACHE_INVAL_2;
                else if (fetch_is_noc2_ackdt_s1)
                    fetch_state_next_s1 = `L15_FETCH_STATE_NOC2_WRITEBACK_DONE;
            end
        end
        `L15_FETCH_STATE_PCX_WRITEBACK_DONE:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_PCX_WRITEBACK_DONE;
            if (!stall_s1)
                fetch_state_next_s1 = `L15_FETCH_STATE_NORMAL;
        end
        `L15_FETCH_STATE_NOC2_WRITEBACK_DONE:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_NOC2_WRITEBACK_DONE;
            if (!stall_s1)
                fetch_state_next_s1 = `L15_FETCH_STATE_NORMAL;
        end
        `L15_FETCH_STATE_INVAL_2:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_INVAL_2;
            if (!stall_s1)
                fetch_state_next_s1 = `L15_FETCH_STATE_INVAL_3;
        end
        `L15_FETCH_STATE_INVAL_3:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_INVAL_3;
            if (!stall_s1)
                fetch_state_next_s1 = `L15_FETCH_STATE_INVAL_4;
        end
        `L15_FETCH_STATE_INVAL_4:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_INVAL_4;
            if (!stall_s1)
                fetch_state_next_s1 = `L15_FETCH_STATE_NORMAL;
        end
        `L15_FETCH_STATE_ICACHE_INVAL_2:
        begin
            fetch_state_next_s1 = `L15_FETCH_STATE_ICACHE_INVAL_2;
            if (!stall_s1)
                fetch_state_next_s1 = `L15_FETCH_STATE_NORMAL;
        end
    endcase
end

////////////////////////////////
// decoder stage (s1)
////////////////////////////////
// generate control bits from instruction
reg [`L15_ACK_STAGE_WIDTH-1:0] decoder_pcx_ack_stage_s1;
reg [`L15_ACK_STAGE_WIDTH-1:0] decoder_noc2_ack_stage_s1;
reg decoder_stall_on_mshr_allocation_s1;
reg [`L15_MSHR_ID_WIDTH-1:0] decoder_mshr_allocation_type_s1;
reg decoder_stall_on_matched_bypassed_index_s1;
// reg decoder_stall_on_ld_mshr_s1;
// reg decoder_stall_on_st_mshr_s1;
reg [`L15_S1_MSHR_OP_WIDTH-1:0]decoder_s1_mshr_operation_s1;
reg [`L15_DTAG_OP_WIDTH-1:0]decoder_dtag_operation_s1;
reg [`L15_S2_MSHR_OP_WIDTH-1:0]decoder_s2_mshr_operation_s1;
reg [`L15_S2_MESI_OP_WIDTH-1:0]decoder_mesi_read_op_s1;
reg [`L15_DCACHE_OP_WIDTH-1:0]decoder_dcache_operation_s1;
reg [`L15_S3_MSHR_OP_WIDTH-1:0]decoder_s3_mshr_operation_s1;
reg [`L15_S3_MESI_OP_WIDTH-1:0]decoder_mesi_write_op_s1;
reg [`L15_WMT_READ_OP_WIDTH-1:0]decoder_wmt_read_op_s1;
reg [`L15_WMT_WRITE_OP_WIDTH-1:0]decoder_wmt_write_op_s1;
reg [`L15_WMT_COMPARE_OP_WIDTH-1:0]decoder_wmt_compare_op_s1;
reg [`L15_LRUARRAY_WRITE_OP_WIDTH-1:0]decoder_lruarray_write_op_s1;
reg [`L15_CPX_OP_WIDTH-1:0]decoder_cpx_operation_s1;
`ifndef NO_RTL_CSM
reg [`L15_HMT_OP_WIDTH-1:0]decoder_hmt_op_s1;
`endif
reg [`L15_NOC1_OP_WIDTH-1:0]decoder_noc1_operation_s1;
reg [`L15_NOC3_OP_WIDTH-1:0]decoder_noc3_operation_s1;
reg [`L15_CSM_OP_WIDTH-1:0]decoder_csm_op_s1;
reg [`L15_CONFIG_OP_WIDTH-1:0]decoder_config_op_s1;
reg decoder_no_free_mshr_s1;
reg decoder_stall_on_matched_mshr_s1;
reg [`L15_MSHR_ID_WIDTH-1:0]decoder_mshrid_s1;
reg decoder_lrsc_flag_read_op_s1;
reg [`L15_LRSC_FLAG_WRITE_OP_WIDTH-1:0] decoder_lrsc_flag_write_op_s1;

always @ *
begin
    decoder_pcx_ack_stage_s1 = 1'b0;
    decoder_noc2_ack_stage_s1 = 1'b0;
    decoder_stall_on_mshr_allocation_s1 = 1'b0;
    decoder_stall_on_matched_bypassed_index_s1 = 1'b0;
    // decoder_stall_on_ld_mshr_s1 = 1'b0;
    // decoder_stall_on_st_mshr_s1 = 1'b0;
    decoder_s1_mshr_operation_s1 = 1'b0;
    decoder_dtag_operation_s1 = 1'b0;
    decoder_s2_mshr_operation_s1 = 1'b0;
    decoder_mesi_read_op_s1 = 1'b0;
    decoder_dcache_operation_s1 = 1'b0;
    decoder_s3_mshr_operation_s1 = 1'b0;
    decoder_mesi_write_op_s1 = 1'b0;
    decoder_wmt_read_op_s1 = 1'b0;
    decoder_wmt_write_op_s1 = 1'b0;
    decoder_wmt_compare_op_s1 = 1'b0;
    decoder_lruarray_write_op_s1 = 1'b0;
    decoder_cpx_operation_s1 = 1'b0;
    decoder_noc1_operation_s1 = 1'b0;
    decoder_noc3_operation_s1 = 1'b0;
    decoder_csm_op_s1 = 1'b0;
    decoder_config_op_s1 = 1'b0;
    decoder_creditman_noc1_needed = 2'b0;
    decoder_creditman_noc1_unreserve_s1 = 1'b0;
    decoder_creditman_req_8B_s1 = 1'b0;
    decoder_creditman_req_16B_s1 = 1'b0;
    decoder_stall_on_matched_mshr_s1 = 1'b0;
    decoder_mshr_allocation_type_s1 = 0; 
    decoder_lrsc_flag_read_op_s1 = 1'b0;
    decoder_lrsc_flag_write_op_s1 = 2'b0;
    decoder_no_free_mshr_s1 = 0;
    `ifndef NO_RTL_CSM
    decoder_hmt_op_s1 = 0;
    `endif
    case (predecode_reqtype_s1)
        `L15_REQTYPE_LOAD_NC:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // write-back for nc loads
                decoder_stall_on_matched_bypassed_index_s1 = 1;
                decoder_stall_on_matched_mshr_s1 = 1;
                decoder_stall_on_mshr_allocation_s1 = 1'b1;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_LD;

                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_mesi_write_op_s1 = `L15_S3_MESI_INVALIDATE_TAGCHECK_WAY_IF_MES;
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_TAGCHECK_WAY_IF_MES;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;

                decoder_dcache_operation_s1 = `L15_DCACHE_READ_TAGCHECK_WAY_IF_M;
                // decoder_hmt_op_s1 = `L15_HMT_READ_TAGCHECK_WAY_IF_M;
                decoder_lruarray_write_op_s1 = `L15_LRU_INVALIDATE_IF_TAGCHECK_WAY_IS_MES;

                decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_TAGCHECK_MES_AND_WAYMAP_VALID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_TAGCHECK_M;
                decoder_creditman_noc1_needed = 2'd2; // this one is for the subsequent load too
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_TAGCHECK_M_FROM_DCACHE;
                decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_M;
            end
            else
            begin // nc load
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_LD;
                decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_LD_REQUEST;
            end
        end

        `L15_REQTYPE_LOAD_PREFETCH:
        begin
            // if (tagcheck_tag_match_s1)
            // begin // prefetch ld hits mshr
            //    decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            //    decoder_stall_on_matched_bypassed_index_s1 = 1;
            //    decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_BOGUS_DATA;
            // end
            // else
            // begin // prefetch ld
            //    decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            //    decoder_stall_on_matched_bypassed_index_s1 = 1;
            //    decoder_stall_on_ld_mshr_s1 = 1;
            //    decoder_stall_on_st_mshr_s1 = 1;
            //    decoder_stall_on_mshr_allocation_s1 = `L15_MSHR_ALLOCATE_TYPE_LD;
            //    decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE_LD;
            //    decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
            //    decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
            //    decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID;
            //    decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION_IF_TAGCHECK_MES;
            //    decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_BOGUS_DATA_IF_TAGCHECK_MES;
            //    decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_LD_REQUEST_IF_TAGCHECK_MISS;
            //    decoder_creditman_noc1_needed = 2'd1;
            // end
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            // decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_BOGUS_DATA;
            // decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_LD_REQUEST;
            // decoder_creditman_noc1_needed = 2'd1;
        end

        `L15_REQTYPE_LOAD:
        begin // a normal ld
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_stall_on_matched_bypassed_index_s1 = 1;
            decoder_stall_on_matched_mshr_s1 = 1;
            decoder_stall_on_mshr_allocation_s1 = 1'b1;
            decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_LD;
            decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
            decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
            decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
            decoder_dcache_operation_s1 = `L15_DCACHE_READ_TAGCHECK_WAY_IF_MES;
            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION_IF_TAGCHECK_MES;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_IF_TAGCHECK_MES_FROM_DCACHE;
            decoder_wmt_read_op_s1 = `L15_WMT_READ;
            decoder_wmt_write_op_s1 = `L15_WMT_UPDATE_TAGCHECK_WAY_AND_DEDUP_ENTRY_IF_TAGCHECK_WAY_IS_MES;
            decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;
            decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID_IF_TAGCHECK_MISS;
            decoder_lruarray_write_op_s1 = `L15_LRU_UPDATE_ACCESS_BITS_IF_TAGCHECK_WAY_IS_MES;
            decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_LD_REQUEST_IF_TAGCHECK_MISS;
            decoder_creditman_noc1_needed = 2'd1;
        end

        `L15_REQTYPE_DIAG_LOAD:
        begin // a diagnostic read
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_dcache_operation_s1 = `L15_DCACHE_DIAG_READ;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_FROM_DCACHE;
        end

        `L15_REQTYPE_IFILL:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;

            decoder_stall_on_mshr_allocation_s1 = 1'b1;
            decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_IFILL;
            decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
            decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID;
            decoder_noc1_operation_s1 = `L15_NOC1_GEN_INSTRUCTION_LD_REQUEST;
            decoder_creditman_noc1_needed = 2'd1;
        end

        `L15_REQTYPE_WRITETHROUGH:
        begin
            if (predecode_int_vec_dis_s1)
            begin
                // is actually an ASI store to generate cross-cpu interrupt
                //`L15_REQTYPE_INT_VEC_DIS:
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S3;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_INTERRUPT_FWD;
                decoder_creditman_req_8B_s1 = 1'b1;
                decoder_creditman_noc1_needed = 2'd1;
            end
            else
            begin
                if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
                begin // write-back for st nc or blockstore
                    decoder_stall_on_matched_bypassed_index_s1 = 1;
                    decoder_stall_on_matched_mshr_s1 = 1;
                    decoder_stall_on_mshr_allocation_s1 = 1'b1;
                    decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_ST;

                    decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

                    decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                    decoder_dcache_operation_s1 = `L15_DCACHE_READ_TAGCHECK_WAY_IF_M;

                    decoder_mesi_write_op_s1 = `L15_S3_MESI_INVALIDATE_TAGCHECK_WAY_IF_MES;
                    decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY;
                    // decoder_wmt_operation_s1 = `L15_WMT_READ_TAGCHECK_WAY_IF_MES_AND_DEMAP_ENTRY;
                    decoder_wmt_read_op_s1 = `L15_WMT_READ;
                    decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_TAGCHECK_WAY_IF_MES;
                    decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;
                    decoder_lruarray_write_op_s1 = `L15_LRU_INVALIDATE_IF_TAGCHECK_WAY_IS_MES;

                    decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_TAGCHECK_MES_AND_WAYMAP_VALID;
                    decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_TAGCHECK_M;
                    // decoder_creditman_noc1_needed = 2'd1;
                    decoder_creditman_noc1_needed = 2'd2; // this one is for the subsequent write too
                    decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_TAGCHECK_M_FROM_DCACHE;
                    // moved for atomicity
                    decoder_creditman_req_8B_s1 = 1'b1;
                    decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_M;
                end
                else
                begin // st nc or blockstore
                    decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S3;
                    decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
                    decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_ST;
                    decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID;
                    decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_WRITETHROUGH_REQUEST_FROM_PCX;
`ifndef PITON_ASIC_RTL
                    decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_UPDATE_ST_MSHR_WAIT_ACK;
`endif                    
                    // decoder_creditman_req_8B_s1 = 1'b1;
                    // decoder_creditman_noc1_needed = 2'd1;
                end
            end
        end

        `L15_REQTYPE_STORE:
        begin
            if (predecode_hit_stbuf_s1)
            begin // st hits st MSHR in IM or SM state
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_stall_on_matched_bypassed_index_s1 = 1'b1;
                decoder_stall_on_mshr_allocation_s1 = 1'b1;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_ST;
                decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_UPDATE_WRITECACHE;
                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_STBUF;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK_WITH_POSSIBLE_INVAL;
            end
            else
            begin // regular st
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_stall_on_matched_bypassed_index_s1 = 1'b1;
                decoder_stall_on_matched_mshr_s1 = 1'b1;
                decoder_stall_on_mshr_allocation_s1 = 1'b1;
                decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_ST;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_s2_mshr_operation_s1 = `L15_S2_MSHR_OP_READ_WRITE_CACHE;
                decoder_dcache_operation_s1 = `L15_DCACHE_WRITE_TAGCHECK_WAY_IF_ME_FROM_MSHR;

                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;

                decoder_lruarray_write_op_s1 = `L15_LRU_UPDATE_ACCESS_BITS_IF_TAGCHECK_WAY_IS_MES;
                decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID_IF_TAGCHECK_SI;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION_IF_TAGCHECK_M_E_ELSE_UPDATE_STATE_STMSHR;
                decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_TAGCHECK_WAY_M_IF_E;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK_IF_TAGCHECK_M_E_WITH_POSSIBLE_INVAL;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_ST_UPGRADE_IF_TAGCHECK_S_ELSE_ST_FILL_IF_TAGCHECK_I;
                decoder_creditman_noc1_needed = 2'd1;
            end
        end

        `L15_REQTYPE_DIAG_STORE:
        begin
            // diag store, is not cache coherent
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S2; // need data until S2
            decoder_dcache_operation_s1 = `L15_DCACHE_DIAG_WRITE;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
        end

        `L15_REQTYPE_LINE_FLUSH:
        begin
            // need to be done in two stages: ack the store, then the actual flush
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // ack store
                decoder_stall_on_matched_bypassed_index_s1 = 1;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
            end
            else
            begin
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;

                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_dcache_operation_s1 = `L15_DCACHE_READ_FLUSH_WAY_IF_M;

                decoder_mesi_write_op_s1 = `L15_S3_MESI_INVALIDATE_FLUSH_WAY_IF_MES;
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_FLUSH_WAY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_FLUSH_WAY_IF_MES;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_FLUSH;
                decoder_lruarray_write_op_s1 = `L15_LRU_INVALIDATE_IF_FLUSH_WAY_IS_MES;

                decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_FLUSH_MES_AND_WAYMAP_VALID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_FLUSH_M;
                decoder_creditman_noc1_needed = 2'd1;
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_FLUSH_M_FROM_DCACHE;
                decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_FLUSH_M;
            end
        end

        `L15_REQTYPE_AMO_SC: 
        begin
            begin 
            // Store Conditional
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_stall_on_matched_bypassed_index_s1 = 1'b1;
                decoder_stall_on_matched_mshr_s1 = 1'b1;
                decoder_stall_on_mshr_allocation_s1 = 1'b1;
                decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_ST;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_lrsc_flag_read_op_s1 = `L15_S1_LRSC_FLAG_READ;

                decoder_s2_mshr_operation_s1 = `L15_S2_MSHR_OP_READ_WRITE_CACHE;
                decoder_dcache_operation_s1 = `L15_DCACHE_WRITE_TAGCHECK_WAY_IF_LRSC_SET_FROM_MSHR;

                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;

                decoder_lruarray_write_op_s1 = `L15_LRU_UPDATE_ACCESS_BITS_IF_TAGCHECK_WAY_LRSC_SET;
                //decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID_IF_TAGCHECK_SI;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;  // deallocate anyway
                //decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_TAGCHECK_WAY_M_IF_LRSC_SET;
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_SC_ACK;
                //decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_ST_UPGRADE_IF_TAGCHECK_S_ELSE_ST_FILL_IF_TAGCHECK_I;
                //decoder_creditman_noc1_needed = 2'd1;
            end
        end

        `L15_REQTYPE_CAS,
        `L15_REQTYPE_SWP_LOADSTUB,
        `L15_REQTYPE_AMO_LR,
        `L15_REQTYPE_AMO_ADD,
        `L15_REQTYPE_AMO_AND,
        `L15_REQTYPE_AMO_OR,
        `L15_REQTYPE_AMO_XOR,
        `L15_REQTYPE_AMO_MAX,
        `L15_REQTYPE_AMO_MAXU,
        `L15_REQTYPE_AMO_MIN,
        `L15_REQTYPE_AMO_MINU:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // writeback for CAS/Atomic
                decoder_stall_on_matched_bypassed_index_s1 = 1;
                decoder_stall_on_matched_mshr_s1 = 1;
                decoder_stall_on_mshr_allocation_s1 = 1'b1;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_LD;

                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_dcache_operation_s1 = `L15_DCACHE_READ_TAGCHECK_WAY_IF_M;

                decoder_mesi_write_op_s1 = `L15_S3_MESI_INVALIDATE_TAGCHECK_WAY_IF_MES;
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY;
                // decoder_wmt_operation_s1 = `L15_WMT_READ_TAGCHECK_WAY_IF_MES_AND_DEMAP_ENTRY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_TAGCHECK_WAY_IF_MES;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;
                decoder_lruarray_write_op_s1 = `L15_LRU_INVALIDATE_IF_TAGCHECK_WAY_IS_MES;

                decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_TAGCHECK_MES_AND_WAYMAP_VALID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_TAGCHECK_M;
                decoder_creditman_noc1_needed = 2'd2;
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_TAGCHECK_M_FROM_DCACHE;
                decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_M;

                // move data request to the first operation to keep atomicity
                if (predecode_reqtype_s1 == `L15_REQTYPE_CAS)
                begin
                    decoder_creditman_req_16B_s1 = 1'b1;
                end
                else if (predecode_reqtype_s1 != `L15_REQTYPE_AMO_LR)
                begin
                    // LR won't sent NOC1 msg with data; other AMO reqs will
                    decoder_creditman_req_8B_s1 = 1'b1;
                end
            end
            else
            begin
                // second packet of CAS
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S3;
                decoder_s1_mshr_operation_s1 = `L15_S1_MSHR_OP_ALLOCATE;
                decoder_mshr_allocation_type_s1 = `L15_MSHR_ID_LD;

                decoder_csm_op_s1 = `L15_CSM_OP_READ_GHID;
                //if (predecode_reqtype_s1 == `L15_REQTYPE_CAS)
                //begin
                //    decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_CAS_REQUEST_FROM_PCX;
                //    // decoder_creditman_req_16B_s1 = 1'b1;
                //end
                //else
                //begin
                //    decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_SWAP_REQUEST_FROM_PCX;
                //    // decoder_creditman_req_8B_s1 = 1'b1;
                //end
                case (predecode_reqtype_s1)
                    `L15_REQTYPE_AMO_LR:
                    begin
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_LR_REQUEST;
                    end
                    `L15_REQTYPE_CAS:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_CAS_REQUEST_FROM_PCX;
                    `L15_REQTYPE_SWP_LOADSTUB:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_SWAP_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_ADD:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_ADD_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_AND:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_AND_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_OR:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_OR_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_XOR:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_XOR_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_MAX:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_MAX_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_MAXU:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_MAXU_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_MIN:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_MIN_REQUEST_FROM_PCX;
                    `L15_REQTYPE_AMO_MINU:
                        decoder_noc1_operation_s1 = `L15_NOC1_GEN_DATA_MINU_REQUEST_FROM_PCX;
                endcase
                // decoder_creditman_noc1_needed = 2'd1;
            end
        end

        `L15_REQTYPE_ICACHE_INVALIDATION:
        begin
            // decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ICACHE_INVALIDATION;
            if (predecode_is_last_inval_s1)
            begin
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_ICACHE_INVAL_ACK;
            end
        end

        `L15_REQTYPE_ICACHE_SELF_INVALIDATION:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ICACHE_INVALIDATION;
        end

        `L15_REQTYPE_DCACHE_SELF_INVALIDATION:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_stall_on_matched_bypassed_index_s1 = 1;
            decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
            decoder_wmt_read_op_s1 = `L15_WMT_READ;
            decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_TAGCHECK_WAY_IF_MES;
            // decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
`ifdef PITON_ASIC_RTL
            decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
`else
            decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK; // bug 3/28/16
`endif            

            decoder_cpx_operation_s1 = `L15_CPX_GEN_DCACHE_INVALIDATION;
        end // todo

        `L15_REQTYPE_INVALIDATION:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // we only stall on the first inval
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_NEVER;
                decoder_stall_on_matched_bypassed_index_s1 = 1;
            end
            else if (fetch_state_s1 == `L15_FETCH_STATE_INVAL_4)
            begin // we only ack on the last inval
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_stall_on_matched_bypassed_index_s1 = 1;
            end
            else
            begin // we do not stall/ack on the 2nd, 3rd
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_NEVER;
                decoder_stall_on_matched_bypassed_index_s1 = 1;
            end

            decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

            decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
            decoder_dcache_operation_s1 = `L15_DCACHE_READ_TAGCHECK_WAY_IF_M;

            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_UPDATE_ST_MSHR_IM_IF_INDEX_TAGCHECK_WAY_MATCHES;
            decoder_mesi_write_op_s1 = `L15_S3_MESI_INVALIDATE_TAGCHECK_WAY_IF_MES;
            decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY;
            // decoder_wmt_operation_s1 = `L15_WMT_READ_TAGCHECK_WAY_IF_MES_AND_DEMAP_ENTRY;
            decoder_wmt_read_op_s1 = `L15_WMT_READ;
            decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_TAGCHECK_WAY_IF_MES;
            decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;

            decoder_lruarray_write_op_s1 = `L15_LRU_INVALIDATE_IF_TAGCHECK_WAY_IS_MES;

            decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_TAGCHECK_MES_AND_WAYMAP_VALID;
            if (predecode_is_last_inval_s1)
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_INVAL_ACK_FROM_DCACHE;
            else
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_INVAL_ACK_IF_TAGCHECK_M_FROM_DCACHE;

            decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_M;
        end

        `L15_REQTYPE_DOWNGRADE:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // we only stall on the first writeback
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_NEVER;
                decoder_stall_on_matched_bypassed_index_s1 = 1;
            end
            else if (fetch_state_s1 == `L15_FETCH_STATE_INVAL_4)
            begin // we only ack on the last writeback
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_stall_on_matched_bypassed_index_s1 = 1;
            end
            else
            begin // we do not stall/ack on the 2nd, 3rd
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_NEVER;
                decoder_stall_on_matched_bypassed_index_s1 = 1;
            end

            decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;

            decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
            decoder_dcache_operation_s1 = `L15_DCACHE_READ_TAGCHECK_WAY_IF_M;

            decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_TAGCHECK_WAY_S_IF_ME;
            decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY;

            if (predecode_is_last_inval_s1)
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_DOWNGRADE_ACK_FROM_DCACHE;
            else
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_DOWNGRADE_ACK_IF_TAGCHECK_M_FROM_DCACHE;
        end

        `L15_REQTYPE_ACKDT_LD:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // eviction for the fill
                decoder_stall_on_matched_bypassed_index_s1 = 1;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_dcache_operation_s1 = `L15_DCACHE_READ_LRU_WAY_IF_M;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_UPDATE_ST_MSHR_IM_IF_INDEX_LRU_WAY_MATCHES;
                // decoder_wmt_operation_s1 = `L15_WMT_READ_LRU_WAY_IF_MES_AND_DEMAP_ENTRY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_LRU_WAY_IF_MES;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
                decoder_lruarray_write_op_s1 = `L15_LRU_EVICTION;
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_LRU_WAY;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_LRU_MES_AND_WAYMAP_VALID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_LRU_M;
                decoder_creditman_noc1_needed = 2'd1;
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_LRU_M_FROM_DCACHE;
                decoder_creditman_noc1_unreserve_s1 = 1'b1;
                decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_LRU_M;
            end
            else // the fill
            begin
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_WRITE;
                decoder_dcache_operation_s1 = `L15_DCACHE_WRITE_LRU_WAY_FROM_NOC2;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
                decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_LRU_WAY_ACK_STATE;
                // decoder_wmt_operation_s1 = `L15_WMT_WRITE_LRU_WAY_L1_REPL_AND_DEMAP_ENTRY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_UPDATE_LRU_WAY_AND_DEDUP_ENTRY;
`ifdef PITON_ASIC_RTL
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;
`else
                // decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK; // bug fix 3/28/16                
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
`endif                
                decoder_lruarray_write_op_s1 = `L15_LRU_REPLACEMENT;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_FROM_NOC2;
                `ifndef NO_RTL_CSM
                decoder_hmt_op_s1 = `L15_HMT_OP_WRITE;
                `endif
            end
        end

        `L15_REQTYPE_ACKDT_LD_NC:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
            decoder_stall_on_matched_bypassed_index_s1 = 1;
            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_FROM_NOC2;
            // decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_M; // trin todo: not sure if should be disabled
        end

        `L15_REQTYPE_ACKDT_IFILL:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_IFILL_RESPONSE_FROM_NOC2;
        end

        `L15_REQTYPE_ACKDT_ST_IM:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // eviction for the fill
                decoder_stall_on_matched_bypassed_index_s1 = 1;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_dcache_operation_s1 = `L15_DCACHE_READ_LRU_WAY_IF_M;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_UPDATE_ST_MSHR_IM_IF_INDEX_LRU_WAY_MATCHES;
                // decoder_wmt_operation_s1 = `L15_WMT_READ_LRU_WAY_IF_MES_AND_DEMAP_ENTRY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_LRU_WAY_IF_MES;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
                decoder_lruarray_write_op_s1 = `L15_LRU_EVICTION;
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_CLEAR_LRU_WAY;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_LRU_MES_AND_WAYMAP_VALID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_LRU_M;
                decoder_creditman_noc1_needed = 2'd1;
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_LRU_M_FROM_DCACHE;
                decoder_creditman_noc1_unreserve_s1 = 1'b1;
                decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_LRU_M;
            end
            else // the fill
            begin
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_WRITE;
                decoder_s2_mshr_operation_s1 = `L15_S2_MSHR_OP_READ_WRITE_CACHE;
                decoder_dcache_operation_s1 = `L15_DCACHE_WRITE_LRU_WAY_FROM_NOC2_AND_MSHR;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
                decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_LRU_WAY_ACK_STATE;
                decoder_lruarray_write_op_s1 = `L15_LRU_REPLACEMENT;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
                `ifndef NO_RTL_CSM
                decoder_hmt_op_s1 = `L15_HMT_OP_WRITE;
                `endif
            end
        end

        `L15_REQTYPE_ACKDT_ST_SM:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_stall_on_matched_bypassed_index_s1 = 1;
            decoder_s2_mshr_operation_s1 = `L15_S2_MSHR_OP_READ_WRITE_CACHE;
            decoder_dcache_operation_s1 = `L15_DCACHE_WRITE_MSHR_WAY_FROM_MSHR;
            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
            decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_MSHR_WAY_ACK_STATE;
            decoder_wmt_read_op_s1 = `L15_WMT_READ;
            decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_STBUF; // wmt todo // WTF
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK_WITH_POSSIBLE_INVAL;
            decoder_creditman_noc1_unreserve_s1 = 1'b1;
        end

        `L15_REQTYPE_ACK_WRITETHROUGH:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_stall_on_matched_bypassed_index_s1 = 1;
            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
        end

        `L15_REQTYPE_ACK_PREFETCH:
        begin
           decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S1;
           // decoder_stall_on_matched_bypassed_index_s1 = 1;
           // decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
           // decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_BOGUS_DATA;
        end

        `L15_REQTYPE_ACK_ATOMIC:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
            decoder_stall_on_matched_bypassed_index_s1 = 1;
            decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ATOMIC_ACK_FROM_NOC2;
        end

        `L15_REQTYPE_ACKDT_LR:
        begin
            if (fetch_state_s1 == `L15_FETCH_STATE_NORMAL)
            begin // eviction for the fill
                decoder_stall_on_matched_bypassed_index_s1 = 1;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_READ;
                decoder_mesi_read_op_s1 = `L15_S2_MESI_READ;
                decoder_dcache_operation_s1 = `L15_DCACHE_READ_LRU_WAY_IF_M;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_UPDATE_ST_MSHR_IM_IF_INDEX_LRU_WAY_MATCHES;
                // decoder_wmt_operation_s1 = `L15_WMT_READ_LRU_WAY_IF_MES_AND_DEMAP_ENTRY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                decoder_wmt_write_op_s1 = `L15_WMT_DEMAP_LRU_WAY_IF_MES;
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
                decoder_lruarray_write_op_s1 = `L15_LRU_EVICTION;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_INVALIDATION_IF_LRU_MES_AND_WAYMAP_VALID;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_WRITEBACK_GUARD_IF_LRU_M;
                decoder_creditman_noc1_needed = 2'd1;
                decoder_noc3_operation_s1 = `L15_NOC3_GEN_WRITEBACK_IF_LRU_M_FROM_DCACHE;
                decoder_creditman_noc1_unreserve_s1 = 1'b1;
                decoder_csm_op_s1 = `L15_CSM_OP_EVICT_IF_LRU_M;
            end
            else // the fill
            begin
                decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
                decoder_dtag_operation_s1 = `L15_DTAG_OP_WRITE;
                decoder_dcache_operation_s1 = `L15_DCACHE_WRITE_LRU_WAY_FROM_NOC2;
                decoder_s3_mshr_operation_s1 = `L15_S3_MSHR_OP_DEALLOCATION;
                decoder_mesi_write_op_s1 = `L15_S3_MESI_WRITE_LRU_WAY_ACK_STATE; // do this for unity, it can be set to M directly.
                decoder_lrsc_flag_write_op_s1 = `L15_S2_LRSC_FLAG_SET_LRU_WAY;
                // decoder_wmt_operation_s1 = `L15_WMT_WRITE_LRU_WAY_L1_REPL_AND_DEMAP_ENTRY;
                decoder_wmt_read_op_s1 = `L15_WMT_READ;
                // L1 won't save the line after an LR, so L15 should not update the wmt
                //decoder_wmt_write_op_s1 = `L15_WMT_UPDATE_LRU_WAY_AND_DEDUP_ENTRY;
`ifdef PITON_ASIC_RTL
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK;   
`else
                // decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_TAGCHECK; // bug fix 3/28/16
                decoder_wmt_compare_op_s1 = `L15_WMT_COMPARE_LRU;
`endif
                decoder_lruarray_write_op_s1 = `L15_LRU_REPLACEMENT;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_ATOMIC_ACK_FROM_NOC2;
                `ifndef NO_RTL_CSM
                decoder_hmt_op_s1 = `L15_HMT_OP_WRITE;
                `endif
            end
        end

        `L15_REQTYPE_L2_INTERRUPT:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S3;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_INTERRUPT;
        end

        `L15_REQTYPE_PCX_INTERRUPT:
        begin
            if (predecode_interrupt_broadcast_s1)
            begin
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
                decoder_cpx_operation_s1 = `L15_CPX_GEN_BROADCAST_ACK;
            end
            else
            begin
                decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S3;
                decoder_noc1_operation_s1 = `L15_NOC1_GEN_INTERRUPT_FWD;
                decoder_creditman_noc1_needed = 2'd1;
                decoder_creditman_req_8B_s1 = 1'b1;
            end
        end

        `L15_REQTYPE_LOAD_CONFIG_REG:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_LOAD_CONFIG_REG_RESPONSE;
            decoder_config_op_s1 = `L15_CONFIG_LOAD;
        end

        `L15_REQTYPE_WRITE_CONFIG_REG:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S2;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
            decoder_config_op_s1 = `L15_CONFIG_WRITE;
        end

        `L15_REQTYPE_HMC_FILL:
        begin
            decoder_noc2_ack_stage_s1 = `L15_ACK_STAGE_S2;
            decoder_csm_op_s1 = `L15_CSM_OP_HMC_FILL;
            // decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
        end

        `L15_REQTYPE_HMC_DIAG_LOAD:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_csm_op_s1 = `L15_CSM_OP_HMC_DIAG_LOAD;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_LD_RESPONSE_FROM_CSM;
        end

        `L15_REQTYPE_HMC_DIAG_STORE:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S2;
            decoder_csm_op_s1 = `L15_CSM_OP_HMC_DIAG_STORE;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
        end

        `L15_REQTYPE_HMC_FLUSH:
        begin
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
            decoder_csm_op_s1 = `L15_CSM_OP_HMC_FLUSH;
            decoder_cpx_operation_s1 = `L15_CPX_GEN_ST_ACK;
        end

        `L15_REQTYPE_IGNORE:
        begin // skip this request
            decoder_pcx_ack_stage_s1 = `L15_ACK_STAGE_S1;
        end
    endcase

    // some stuff we can calculate right after the decoder stage
    decoder_no_free_mshr_s1 = mshr_val_array[predecode_threadid_s1][decoder_mshr_allocation_type_s1];
    decoder_mshrid_s1 =
        (predecode_source_s1 == `L15_PREDECODE_SOURCE_NOC2) ? noc2decoder_l15_mshrid : decoder_mshr_allocation_type_s1;
end

///////////////////////////////////
// STALL LOGIC FOR S1
///////////////////////////////////
// depends on creditman, predecoder, and decoder
// output dependencies: should be none (except for flops)

reg stall_tag_match_stall_s1;
reg stall_index_bypass_match_s1;
reg stall_index_conflict_stall_s1;
reg stall_mshr_allocation_busy_s1;

reg stall_noc1_data_buffer_unavail_s1;
reg stall_noc1_command_buffer_1_unavail_s1;
reg stall_noc1_command_buffer_2_unavail_s1;
reg stall_noc1_command_buffer_unavail_s1;
reg stall_pcx_noc1_buffer_s1;

reg [4:0] stall_tmp_operand1;
reg [4:0] stall_tmp_operand2;
reg [4:0] stall_tmp_result;


always @ *
begin
    // CALCULATE NOC1 DATA BUFFER AVAILABILITY
    stall_noc1_data_buffer_unavail_s1 = decoder_creditman_req_8B_s1  ? creditman_noc1_data_avail == 4'd0 :
                                                    decoder_creditman_req_16B_s1 ? creditman_noc1_data_avail < 4'd2 :
                                                                                            1'b0;
    // CALCULATE NOC1 COMMAND BUFFER AVAILABILITY
    // note: the complicated sequence of calculation below is to determine
    //  creditman_noc1_avail <= creditman_noc1_reserve
    //  a simple expression (creditman_noc1_avail <= creditman_noc1_reserve) might not have the most efficient implementation
    stall_tmp_operand1 = {1'b1, creditman_noc1_avail[`L15_UNPARAM_3_0]};
    stall_tmp_operand2 = {1'b0, creditman_noc1_reserve[`L15_UNPARAM_3_0]};
    stall_tmp_result = stall_tmp_operand1 - stall_tmp_operand2;

    stall_noc1_command_buffer_1_unavail_s1 = (stall_tmp_result[`L15_UNPARAM_3_0] == 4'b0) || stall_tmp_result[4] == 1'b0;
    stall_noc1_command_buffer_2_unavail_s1 = stall_noc1_command_buffer_1_unavail_s1 || (stall_tmp_result[`L15_UNPARAM_3_0] == 4'b1);

    stall_noc1_command_buffer_unavail_s1 = (decoder_creditman_noc1_needed == 2'd1 && stall_noc1_command_buffer_1_unavail_s1)
                                        || (decoder_creditman_noc1_needed == 2'd2 && stall_noc1_command_buffer_2_unavail_s1);
    // only stall if it's an PCX request (noc2 does not stall)
    stall_pcx_noc1_buffer_s1 = (stall_noc1_command_buffer_unavail_s1 || stall_noc1_data_buffer_unavail_s1)
                                            && (predecode_source_s1 == `L15_PREDECODE_SOURCE_PCX)
                                            && (fetch_state_s1 == `L15_FETCH_STATE_NORMAL);

    // stall on tag match mshr
    stall_tag_match_stall_s1 = predecode_tagcheck_matched_s1 && decoder_stall_on_matched_mshr_s1;

    // stall on index conflict
    stall_index_bypass_match_s1 = (val_s2 && (predecode_cache_index_s1 == cache_index_s2))
                                     || (val_s3 && (predecode_cache_index_s1 == cache_index_s3));
    stall_index_conflict_stall_s1 = decoder_stall_on_matched_bypassed_index_s1 && stall_index_bypass_match_s1;
    stall_mshr_allocation_busy_s1 = decoder_no_free_mshr_s1 && decoder_stall_on_mshr_allocation_s1;

    // aggregating all the stalls
    stall_s1 = val_s1 && (stall_tag_match_stall_s1 || stall_index_conflict_stall_s1 || stall_s2 || stall_mshr_allocation_busy_s1
                    || stall_pcx_noc1_buffer_s1);
end

////////////////////////////
// DTAG logics
////////////////////////////
// is SRAM
reg dtag_val_s1;
reg dtag_rw_s1;
reg [`L15_CACHE_INDEX_WIDTH-1:0] dtag_index_s1;
reg [`L15_WAY_MASK] dtag_write_way_s1;
reg [`L15_CACHE_TAG_RAW_WIDTH-1:0] dtag_write_tag_s1;
reg [`L15_UNPARAM_3_0] dtag_write_way_mask;

always @ *
begin
    dtag_val_s1 = 0;
    dtag_rw_s1 = 0;
    dtag_index_s1 = 0;
    dtag_write_way_s1 = 0;
    dtag_write_tag_s1[`L15_CACHE_TAG_RAW_WIDTH-1:0]  = 0;
    dtag_write_way_mask = 0;
    case (decoder_dtag_operation_s1)
        `L15_DTAG_OP_READ:
        begin
            dtag_val_s1 = val_s1;
            dtag_rw_s1 = `L15_DTAG_RW_READ;
            dtag_index_s1 = predecode_cache_index_s1;
        end
        `L15_DTAG_OP_WRITE:
        begin
            dtag_val_s1 = val_s1;
            dtag_rw_s1 = `L15_DTAG_RW_WRITE;
            dtag_index_s1 = predecode_cache_index_s1;
            dtag_write_way_s1 = lru_way_s2; // previous instruction (eviction) is guaranteed to be in s2
            // pad the address to the raw tag space required
            dtag_write_tag_s1[`L15_CACHE_TAG_RAW_WIDTH-1:0]  = {{`L15_CACHE_TAG_RAW_WIDTH-`L15_CACHE_TAG_WIDTH{1'b0}},predecode_dtag_write_data_s1[`L15_CACHE_TAG_WIDTH-1:0]} ;
        end
    endcase

    dtag_write_way_mask = (dtag_write_way_s1 == 2'b00) ? 4'b0_0_0_1 :
                            (dtag_write_way_s1 == 2'b01) ? 4'b0_0_1_0 :
                            (dtag_write_way_s1 == 2'b10) ? 4'b0_1_0_0 :
                                                        4'b1_0_0_0 ;

    // INPUT/OUTPUT TO DTAG
    l15_dtag_val_s1 = dtag_val_s1 && !stall_s1;
    l15_dtag_rw_s1 = dtag_rw_s1;
    l15_dtag_index_s1[`L15_CACHE_INDEX_WIDTH-1:0] = dtag_index_s1;
    l15_dtag_write_data_s1[`L15_CACHE_TAG_RAW_WIDTH*4-1:0] = {4{dtag_write_tag_s1[`L15_CACHE_TAG_RAW_WIDTH-1:0]}} ;
    l15_dtag_write_mask_s1[`L15_CACHE_TAG_RAW_WIDTH*4-1:0] =
                                                                    {{`L15_CACHE_TAG_RAW_WIDTH{dtag_write_way_mask[3]}},
                                                                     {`L15_CACHE_TAG_RAW_WIDTH{dtag_write_way_mask[2]}},
                                                                     {`L15_CACHE_TAG_RAW_WIDTH{dtag_write_way_mask[1]}},
                                                                     {`L15_CACHE_TAG_RAW_WIDTH{dtag_write_way_mask[0]}}};
end

////////////////////////////
// MESI read control logics
////////////////////////////
// is SRAM
reg mesi_read_val_s1;
reg [`L15_CACHE_INDEX_WIDTH-1:0] mesi_read_index_s1;
always @ *
begin
    mesi_read_val_s1 = 0;
    mesi_read_index_s1 = 0;
    case (decoder_mesi_read_op_s1)
        `L15_S2_MESI_READ:
        begin
            mesi_read_val_s1 = 1'b1;
            mesi_read_index_s1 = predecode_cache_index_s1;
        end
    endcase

    l15_mesi_read_val_s1 = mesi_read_val_s1 && val_s1 && !stall_s1;
    l15_mesi_read_index_s1[`L15_CACHE_INDEX_WIDTH-1:0] = mesi_read_index_s1;
end

////////////////////////////
// LRSC FLAG read control logics
////////////////////////////
reg lrsc_flag_read_val_s1;
reg [`L15_CACHE_INDEX_WIDTH-1:0] lrsc_flag_read_index_s1;
always @ *
begin
    lrsc_flag_read_val_s1 = 0;
    lrsc_flag_read_index_s1 = 0;
    case (decoder_lrsc_flag_read_op_s1)
        `L15_S1_LRSC_FLAG_READ:
        begin
            lrsc_flag_read_val_s1 = 1'b1;
            lrsc_flag_read_index_s1 = predecode_cache_index_s1;
        end
    endcase

    l15_lrsc_flag_read_val_s1 = lrsc_flag_read_val_s1 && val_s1 && !stall_s1;
    l15_lrsc_flag_read_index_s1[`L15_CACHE_INDEX_WIDTH-1:0] = lrsc_flag_read_index_s1;
end

////////////////////////////
// MSHR S1 logic
////////////////////////////
// depends on predecode and decode

reg [`L15_CONTROL_WIDTH-1:0] mshr_control_bits_write_s1;
// reg mshr_next_available_mshrid_valid_s1;
always @ *
begin
    // mux betweeen new mshrid and noc2 returned mshrid

    // write
    mshr_control_bits_write_s1 = 0;
    mshr_control_bits_write_s1 [`L15_CONTROL_SIZE_3B -: 3] = predecode_size_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_THREADID -: `L15_THREADID_WIDTH] = predecode_threadid_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_L1_REPLACEMENT_WAY_2B -: `L15_WAY_WIDTH] = predecode_l1_replacement_way_s1;
    // for Load Reserve, we evict and send INVs like a NC req. But when we get the data ack, we reagrd it as a Cacheable req
    mshr_control_bits_write_s1 [`L15_CONTROL_NC_1B -: 1] = (predecode_reqtype_s1 == `L15_REQTYPE_AMO_LR) ? 1'b0 : predecode_non_cacheable_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_BLOCKSTORE_1B -: 1] = predecode_blockstore_bit_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_BLOCKSTOREINIT_1B -: 1] = predecode_blockstore_init_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_PREFETCH_1B -: 1] = predecode_prefetch_bit_s1;
    // mshr_control_bits_write_s1 [`L15_CONTROL_INVALIDATE_INDEX_1B -: 1] = predecode_invalidate_index_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_ICACHE -: 1] = predecode_icache_bit_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_LOAD -: 1] = predecode_dcache_load_s1;
    mshr_control_bits_write_s1 [`L15_CONTROL_ATOMIC -: 1] = predecode_atomic_s1;
end

////////////////////////////
// MSHR allocation logic
////////////////////////////
// is FLOPs
reg s1_mshr_write_val_s1;
reg [`L15_MSHR_WRITE_TYPE_WIDTH-1:0] s1_mshr_write_type_s1;
reg [`L15_PADDR_MASK] s1_mshr_write_address_s1;
reg [`L15_CONTROL_WIDTH-1:0] s1_mshr_write_control_s1;
reg [`L15_MSHR_ID_WIDTH-1:0] s1_mshr_write_mshrid_s1;
reg [`L15_THREADID_MASK] s1_mshr_write_threadid_s1;
reg [`L15_UNPARAM_15_0] unshifted_write_mask_s1;
reg [`L15_UNPARAM_15_0] write_mask_s1;
reg [`L15_UNPARAM_15_0] write_mask_1B_s1;
reg [`L15_UNPARAM_15_0] write_mask_2B_s1;
reg [`L15_UNPARAM_15_0] write_mask_4B_s1;
reg [`L15_UNPARAM_15_0] write_mask_8B_s1;
reg [`L15_UNPARAM_15_0] write_mask_16B_s1;
// reg odd_extended_word_s1;
always @ *
begin
    s1_mshr_write_val_s1 = 0;
    s1_mshr_write_type_s1 = 0;
    s1_mshr_write_address_s1 = 0;
    s1_mshr_write_control_s1 = 0;
    s1_mshr_write_mshrid_s1 = 0;
    // s1_mshr_write_data = 0;
    // s1_mshr_write_byte_mask = 0;
    write_mask_s1 = 0;
    s1_mshr_write_threadid_s1 = 0;

    case (decoder_s1_mshr_operation_s1)
        `L15_S1_MSHR_OP_ALLOCATE:
        begin
            s1_mshr_write_val_s1 = 1'b1; // make request, then see if mshr is busy
            s1_mshr_write_type_s1 = `L15_MSHR_WRITE_TYPE_ALLOCATION;
            s1_mshr_write_address_s1 = pcxdecoder_l15_address;
            s1_mshr_write_control_s1 = mshr_control_bits_write_s1;
            s1_mshr_write_mshrid_s1 = decoder_mshr_allocation_type_s1;
            s1_mshr_write_threadid_s1[`L15_THREADID_MASK] = predecode_threadid_s1[`L15_THREADID_MASK];
        end
        `L15_S1_MSHR_OP_UPDATE_WRITECACHE:
        begin
            s1_mshr_write_val_s1 = 1'b1;
            s1_mshr_write_type_s1 = `L15_MSHR_WRITE_TYPE_UPDATE_WRITE_CACHE;
            // s1_mshr_write_mshrid_s1 = predecode_hit_stbuf_mshrid_s1;
            s1_mshr_write_threadid_s1 = predecode_hit_stbuf_threadid_s1;
        end
    endcase

    unshifted_write_mask_s1 =   (predecode_size_s1 == `MSG_DATA_SIZE_1B) ? 16'b1000_0000_0000_0000 :
                                (predecode_size_s1 == `MSG_DATA_SIZE_2B) ? 16'b1100_0000_0000_0000 :
                                (predecode_size_s1 == `MSG_DATA_SIZE_4B) ? 16'b1111_0000_0000_0000 :
                                                                    16'b1111_1111_0000_0000 ;

    write_mask_1B_s1 = unshifted_write_mask_s1 >> (pcxdecoder_l15_address & 4'b1111);
    write_mask_2B_s1 = unshifted_write_mask_s1 >> (pcxdecoder_l15_address & 4'b1110);
    write_mask_4B_s1 = unshifted_write_mask_s1 >> (pcxdecoder_l15_address & 4'b1100);
    write_mask_8B_s1 = unshifted_write_mask_s1 >> (pcxdecoder_l15_address & 4'b1000);


    write_mask_16B_s1 = {16{1'b1}};

    case(predecode_size_s1)
        `MSG_DATA_SIZE_1B:
        begin
            write_mask_s1 = write_mask_1B_s1;
        end
        `MSG_DATA_SIZE_2B:
        begin
            write_mask_s1 = write_mask_2B_s1;
        end
        `MSG_DATA_SIZE_4B:
        begin
            write_mask_s1 = write_mask_4B_s1;
        end
        `MSG_DATA_SIZE_8B:
        begin
            write_mask_s1 = write_mask_8B_s1;
        end
        `MSG_DATA_SIZE_16B:
        begin
            write_mask_s1 = write_mask_16B_s1;
        end
        default:
        begin
            write_mask_s1 = write_mask_16B_s1;
        end
    endcase


    // s1 write
    pipe_mshr_writereq_val_s1 = s1_mshr_write_val_s1 && !stall_s1 && val_s1;
    pipe_mshr_writereq_op_s1[`L15_MSHR_WRITE_TYPE_WIDTH-1:0] = s1_mshr_write_type_s1[`L15_MSHR_WRITE_TYPE_WIDTH-1:0];
    pipe_mshr_writereq_address_s1[`L15_PADDR_MASK] = s1_mshr_write_address_s1[`L15_PADDR_MASK];
    pipe_mshr_writereq_control_s1[`L15_CONTROL_WIDTH-1:0] = s1_mshr_write_control_s1[`L15_CONTROL_WIDTH-1:0];
    pipe_mshr_writereq_write_buffer_data_s1[`L15_UNPARAM_127_0] = {pcxdecoder_l15_data, pcxdecoder_l15_data};
    pipe_mshr_writereq_write_buffer_byte_mask_s1[`L15_UNPARAM_15_0] = write_mask_s1[`L15_UNPARAM_15_0];
    pipe_mshr_writereq_mshrid_s1[`L15_MSHR_ID_WIDTH-1:0] = s1_mshr_write_mshrid_s1[`L15_MSHR_ID_WIDTH-1:0];
    pipe_mshr_writereq_threadid_s1 = s1_mshr_write_threadid_s1;
end

//////////////////////
// LRU read logic
//////////////////////
always @ *
begin
    l15_lruarray_read_val_s1 = val_s1 && !stall_s1;
    l15_lruarray_read_index_s1 = predecode_cache_index_s1;
end


/*********************************/
/**** PCX & NOC2 S1 ACK LOGIC ****/
/*********************************/
reg acklogic_pcx_s1;
reg acklogic_noc2_s1;
always @ *
begin
    acklogic_pcx_s1 = 0;
    acklogic_noc2_s1 = 0;

    if (decoder_pcx_ack_stage_s1 == `L15_ACK_STAGE_S1)
        acklogic_pcx_s1 = 1;
    if (decoder_noc2_ack_stage_s1 == `L15_ACK_STAGE_S1)
        acklogic_noc2_s1 = 1;

    // ack logics have to be guarded by stalls
    pcx_ack_s1 = val_s1 && !stall_s1 && acklogic_pcx_s1;
    noc2_ack_s1 = val_s1 && !stall_s1 && acklogic_noc2_s1;

    // ack header of pcx and noc2 at s1
    // note: the message data does not have to be acked at s1
    l15_pcxdecoder_header_ack = (predecode_source_s1 == `L15_PREDECODE_SOURCE_PCX) && !stall_s1 && val_s1
                                                && (fetch_state_s1 == `L15_FETCH_STATE_NORMAL);

    // COV: case 1 1 0 1 is impossible
    l15_noc2decoder_header_ack = (predecode_source_s1 == `L15_PREDECODE_SOURCE_NOC2) && !stall_s1 && val_s1
                                                && (fetch_state_s1 == `L15_FETCH_STATE_NORMAL);
end


/***********
 * STAGE 2 *
 ***********/

// propagated variables (flops) from S2

`ifndef NO_RTL_CSM

`else

`endif
reg val_s2_next;

reg [`L15_THREADID_WIDTH-1:0] threadid_s2;
reg [`L15_THREADID_WIDTH-1:0] threadid_s2_next;
reg [`L15_MSHR_ID_WIDTH-1:0] mshrid_s2;
reg [`L15_MSHR_ID_WIDTH-1:0] mshrid_s2_next;
reg [`L15_PADDR_WIDTH-1:0] address_s2;
reg [`L15_PADDR_WIDTH-1:0] address_s2_next;
reg [1-1:0] non_cacheable_s2;
reg [1-1:0] non_cacheable_s2_next;
reg [3-1:0] size_s2;
reg [3-1:0] size_s2_next;
reg [1-1:0] prefetch_s2;
reg [1-1:0] prefetch_s2_next;
reg [2-1:0] l1_replacement_way_s2;
reg [2-1:0] l1_replacement_way_s2_next;
reg [1-1:0] l2_miss_s2;
reg [1-1:0] l2_miss_s2_next;
reg [1-1:0] f4b_s2;
reg [1-1:0] f4b_s2_next;
reg [1-1:0] predecode_noc2_inval_s2;
reg [1-1:0] predecode_noc2_inval_s2_next;
reg [4-1:0] predecode_fwd_subcacheline_vector_s2;
reg [4-1:0] predecode_fwd_subcacheline_vector_s2_next;
reg [`L15_LRSC_FLAG_WRITE_OP_WIDTH-1:0] lrsc_flag_write_op_s2;
reg [`L15_LRSC_FLAG_WRITE_OP_WIDTH-1:0] lrsc_flag_write_op_s2_next;
reg [1-1:0] blockstore_s2;
reg [1-1:0] blockstore_s2_next;
reg [1-1:0] blockstoreinit_s2;
reg [1-1:0] blockstoreinit_s2_next;
reg [`L15_REQTYPE_WIDTH-1:0] predecode_reqtype_s2;
reg [`L15_REQTYPE_WIDTH-1:0] predecode_reqtype_s2_next;
reg [`L15_DTAG_OP_WIDTH-1:0] decoder_dtag_operation_s2;
reg [`L15_DTAG_OP_WIDTH-1:0] decoder_dtag_operation_s2_next;
reg [`L15_WMT_WRITE_OP_WIDTH-1:0] wmt_write_op_s2;
reg [`L15_WMT_WRITE_OP_WIDTH-1:0] wmt_write_op_s2_next;
reg [`L15_WMT_COMPARE_OP_WIDTH-1:0] wmt_compare_op_s2;
reg [`L15_WMT_COMPARE_OP_WIDTH-1:0] wmt_compare_op_s2_next;
reg [`L15_LRUARRAY_WRITE_OP_WIDTH-1:0] lruarray_write_op_s2;
reg [`L15_LRUARRAY_WRITE_OP_WIDTH-1:0] lruarray_write_op_s2_next;
reg [`L15_CSM_OP_WIDTH-1:0] csm_op_s2;
reg [`L15_CSM_OP_WIDTH-1:0] csm_op_s2_next;
reg [`L15_CONFIG_OP_WIDTH-1:0] config_op_s2;
reg [`L15_CONFIG_OP_WIDTH-1:0] config_op_s2_next;
reg [`L15_WMT_READ_OP_WIDTH-1:0] wmt_read_op_s2;
reg [`L15_WMT_READ_OP_WIDTH-1:0] wmt_read_op_s2_next;
reg [`PACKET_HOME_ID_WIDTH-1:0] noc2_src_homeid_s2;
reg [`PACKET_HOME_ID_WIDTH-1:0] noc2_src_homeid_s2_next;
reg [`PACKET_HOME_ID_WIDTH-1:0] hmt_fill_homeid_s2;
reg [`PACKET_HOME_ID_WIDTH-1:0] hmt_fill_homeid_s2_next;
reg [`L15_S3_MSHR_OP_WIDTH-1:0] s3_mshr_operation_s2;
reg [`L15_S3_MSHR_OP_WIDTH-1:0] s3_mshr_operation_s2_next;
reg [`L15_CPX_OP_WIDTH-1:0] cpx_operation_s2;
reg [`L15_CPX_OP_WIDTH-1:0] cpx_operation_s2_next;
reg [`L15_NOC1_OP_WIDTH-1:0] noc1_operation_s2;
reg [`L15_NOC1_OP_WIDTH-1:0] noc1_operation_s2_next;
reg [`L15_NOC3_OP_WIDTH-1:0] noc3_operations_s2;
reg [`L15_NOC3_OP_WIDTH-1:0] noc3_operations_s2_next;
reg [`L15_S2_MESI_OP_WIDTH-1:0] mesi_read_op_s2;
reg [`L15_S2_MESI_OP_WIDTH-1:0] mesi_read_op_s2_next;
reg [`L15_S3_MESI_OP_WIDTH-1:0] mesi_write_op_s2;
reg [`L15_S3_MESI_OP_WIDTH-1:0] mesi_write_op_s2_next;
reg [`L15_DCACHE_OP_WIDTH-1:0] dcache_operation_s2;
reg [`L15_DCACHE_OP_WIDTH-1:0] dcache_operation_s2_next;
reg [`L15_S2_MSHR_OP_WIDTH-1:0] s2_mshr_operation_s2;
reg [`L15_S2_MSHR_OP_WIDTH-1:0] s2_mshr_operation_s2_next;
reg [`L15_ACK_STAGE_WIDTH-1:0] pcx_ack_stage_s2;
reg [`L15_ACK_STAGE_WIDTH-1:0] pcx_ack_stage_s2_next;
reg [`L15_ACK_STAGE_WIDTH-1:0] noc2_ack_stage_s2;
reg [`L15_ACK_STAGE_WIDTH-1:0] noc2_ack_stage_s2_next;
reg [`L15_MESI_STATE_WIDTH-1:0] noc2_ack_state_s2;
reg [`L15_MESI_STATE_WIDTH-1:0] noc2_ack_state_s2_next;
reg [`TLB_CSM_WIDTH-1:0] csm_pcx_data_s2;
reg [`TLB_CSM_WIDTH-1:0] csm_pcx_data_s2_next;
reg [`TLB_CSM_WIDTH-1:0] hmt_op_s2;
reg [`TLB_CSM_WIDTH-1:0] hmt_op_s2_next;


always @ (posedge clk)
begin
    if (!rst_n)
    begin
        val_s2 <= 1'b0;
        threadid_s2 <= 0;
mshrid_s2 <= 0;
address_s2 <= 0;
non_cacheable_s2 <= 0;
size_s2 <= 0;
prefetch_s2 <= 0;
l1_replacement_way_s2 <= 0;
l2_miss_s2 <= 0;
f4b_s2 <= 0;
predecode_noc2_inval_s2 <= 0;
predecode_fwd_subcacheline_vector_s2 <= 0;
lrsc_flag_write_op_s2 <= 0;
blockstore_s2 <= 0;
blockstoreinit_s2 <= 0;
predecode_reqtype_s2 <= 0;
decoder_dtag_operation_s2 <= 0;
wmt_write_op_s2 <= 0;
wmt_compare_op_s2 <= 0;
lruarray_write_op_s2 <= 0;
csm_op_s2 <= 0;
config_op_s2 <= 0;
wmt_read_op_s2 <= 0;
noc2_src_homeid_s2 <= 0;
hmt_fill_homeid_s2 <= 0;
s3_mshr_operation_s2 <= 0;
cpx_operation_s2 <= 0;
noc1_operation_s2 <= 0;
noc3_operations_s2 <= 0;
mesi_read_op_s2 <= 0;
mesi_write_op_s2 <= 0;
dcache_operation_s2 <= 0;
s2_mshr_operation_s2 <= 0;
pcx_ack_stage_s2 <= 0;
noc2_ack_stage_s2 <= 0;
noc2_ack_state_s2 <= 0;
csm_pcx_data_s2 <= 0;
hmt_op_s2 <= 0;

    end
    else
    begin
        val_s2 <= val_s2_next;
        threadid_s2 <= threadid_s2_next;
mshrid_s2 <= mshrid_s2_next;
address_s2 <= address_s2_next;
non_cacheable_s2 <= non_cacheable_s2_next;
size_s2 <= size_s2_next;
prefetch_s2 <= prefetch_s2_next;
l1_replacement_way_s2 <= l1_replacement_way_s2_next;
l2_miss_s2 <= l2_miss_s2_next;
f4b_s2 <= f4b_s2_next;
predecode_noc2_inval_s2 <= predecode_noc2_inval_s2_next;
predecode_fwd_subcacheline_vector_s2 <= predecode_fwd_subcacheline_vector_s2_next;
lrsc_flag_write_op_s2 <= lrsc_flag_write_op_s2_next;
blockstore_s2 <= blockstore_s2_next;
blockstoreinit_s2 <= blockstoreinit_s2_next;
predecode_reqtype_s2 <= predecode_reqtype_s2_next;
decoder_dtag_operation_s2 <= decoder_dtag_operation_s2_next;
wmt_write_op_s2 <= wmt_write_op_s2_next;
wmt_compare_op_s2 <= wmt_compare_op_s2_next;
lruarray_write_op_s2 <= lruarray_write_op_s2_next;
csm_op_s2 <= csm_op_s2_next;
config_op_s2 <= config_op_s2_next;
wmt_read_op_s2 <= wmt_read_op_s2_next;
noc2_src_homeid_s2 <= noc2_src_homeid_s2_next;
hmt_fill_homeid_s2 <= hmt_fill_homeid_s2_next;
s3_mshr_operation_s2 <= s3_mshr_operation_s2_next;
cpx_operation_s2 <= cpx_operation_s2_next;
noc1_operation_s2 <= noc1_operation_s2_next;
noc3_operations_s2 <= noc3_operations_s2_next;
mesi_read_op_s2 <= mesi_read_op_s2_next;
mesi_write_op_s2 <= mesi_write_op_s2_next;
dcache_operation_s2 <= dcache_operation_s2_next;
s2_mshr_operation_s2 <= s2_mshr_operation_s2_next;
pcx_ack_stage_s2 <= pcx_ack_stage_s2_next;
noc2_ack_stage_s2 <= noc2_ack_stage_s2_next;
noc2_ack_state_s2 <= noc2_ack_state_s2_next;
csm_pcx_data_s2 <= csm_pcx_data_s2_next;
hmt_op_s2 <= hmt_op_s2_next;

    end
end

reg [`L15_UNPARAM_1_0] way_mshr_st_s2;
reg [`L15_CACHE_TAG_WIDTH-1:0] address_cache_tag_s2;
always @ *
begin
    cache_index_s2 = address_s2[`L15_IDX_HI:`L15_IDX_LOW];
    cache_index_l1d_s2 = address_s2[`L1D_ADDRESS_HI:`L15_IDX_LOW];
    address_cache_tag_s2 = address_s2[`L15_CACHE_TAG_HI:`L15_CACHE_TAG_LOW];

    way_mshr_st_s2 = mshr_st_way_array[threadid_s2];

    // next signals
    if (stall_s2)
    begin
        val_s2_next = val_s2;
        `ifndef NO_RTL_CSM
        threadid_s2_next = threadid_s2;
mshrid_s2_next = mshrid_s2;
address_s2_next = address_s2;
non_cacheable_s2_next = non_cacheable_s2;
size_s2_next = size_s2;
prefetch_s2_next = prefetch_s2;
l1_replacement_way_s2_next = l1_replacement_way_s2;
l2_miss_s2_next = l2_miss_s2;
f4b_s2_next = f4b_s2;
predecode_noc2_inval_s2_next = predecode_noc2_inval_s2;
predecode_fwd_subcacheline_vector_s2_next = predecode_fwd_subcacheline_vector_s2;
lrsc_flag_write_op_s2_next = lrsc_flag_write_op_s2;
blockstore_s2_next = blockstore_s2;
blockstoreinit_s2_next = blockstoreinit_s2;
predecode_reqtype_s2_next = predecode_reqtype_s2;
decoder_dtag_operation_s2_next = decoder_dtag_operation_s2;
wmt_write_op_s2_next = wmt_write_op_s2;
wmt_compare_op_s2_next = wmt_compare_op_s2;
lruarray_write_op_s2_next = lruarray_write_op_s2;
csm_op_s2_next = csm_op_s2;
config_op_s2_next = config_op_s2;
wmt_read_op_s2_next = wmt_read_op_s2;
noc2_src_homeid_s2_next = noc2_src_homeid_s2;
hmt_fill_homeid_s2_next = hmt_fill_homeid_s2;
s3_mshr_operation_s2_next = s3_mshr_operation_s2;
cpx_operation_s2_next = cpx_operation_s2;
noc1_operation_s2_next = noc1_operation_s2;
noc3_operations_s2_next = noc3_operations_s2;
mesi_read_op_s2_next = mesi_read_op_s2;
mesi_write_op_s2_next = mesi_write_op_s2;
dcache_operation_s2_next = dcache_operation_s2;
s2_mshr_operation_s2_next = s2_mshr_operation_s2;
pcx_ack_stage_s2_next = pcx_ack_stage_s2;
noc2_ack_stage_s2_next = noc2_ack_stage_s2;
noc2_ack_state_s2_next = noc2_ack_state_s2;
csm_pcx_data_s2_next = csm_pcx_data_s2;
hmt_op_s2_next = hmt_op_s2;

        `else
        threadid_s2_next = threadid_s2;
mshrid_s2_next = mshrid_s2;
address_s2_next = address_s2;
non_cacheable_s2_next = non_cacheable_s2;
size_s2_next = size_s2;
prefetch_s2_next = prefetch_s2;
l1_replacement_way_s2_next = l1_replacement_way_s2;
l2_miss_s2_next = l2_miss_s2;
f4b_s2_next = f4b_s2;
lrsc_flag_write_op_s2_next = lrsc_flag_write_op_s2;
predecode_noc2_inval_s2_next = predecode_noc2_inval_s2;
predecode_fwd_subcacheline_vector_s2_next = predecode_fwd_subcacheline_vector_s2;
blockstore_s2_next = blockstore_s2;
blockstoreinit_s2_next = blockstoreinit_s2;
predecode_reqtype_s2_next = predecode_reqtype_s2;
decoder_dtag_operation_s2_next = decoder_dtag_operation_s2;
wmt_write_op_s2_next = wmt_write_op_s2;
wmt_compare_op_s2_next = wmt_compare_op_s2;
lruarray_write_op_s2_next = lruarray_write_op_s2;
csm_op_s2_next = csm_op_s2;
config_op_s2_next = config_op_s2;
wmt_read_op_s2_next = wmt_read_op_s2;
noc2_src_homeid_s2_next = noc2_src_homeid_s2;
s3_mshr_operation_s2_next = s3_mshr_operation_s2;
cpx_operation_s2_next = cpx_operation_s2;
noc1_operation_s2_next = noc1_operation_s2;
noc3_operations_s2_next = noc3_operations_s2;
mesi_read_op_s2_next = mesi_read_op_s2;
mesi_write_op_s2_next = mesi_write_op_s2;
dcache_operation_s2_next = dcache_operation_s2;
s2_mshr_operation_s2_next = s2_mshr_operation_s2;
pcx_ack_stage_s2_next = pcx_ack_stage_s2;
noc2_ack_stage_s2_next = noc2_ack_stage_s2;
noc2_ack_state_s2_next = noc2_ack_state_s2;
csm_pcx_data_s2_next = csm_pcx_data_s2;

        `endif
    end
    else
    begin
        val_s2_next = val_s1 && !stall_s1;
        threadid_s2_next = predecode_threadid_s1;
        mshrid_s2_next = decoder_mshrid_s1;
        address_s2_next = predecode_address_s1;
        non_cacheable_s2_next = predecode_non_cacheable_s1;
        size_s2_next = predecode_size_s1;
        prefetch_s2_next = predecode_prefetch_bit_s1;
        l1_replacement_way_s2_next = predecode_l1_replacement_way_s1;
        l2_miss_s2_next = predecode_l2_miss_s1;
        f4b_s2_next = predecode_f4b_s1;
        // atomic_s2_next = predecode_atomic_s1;
        wmt_write_op_s2_next = decoder_wmt_write_op_s1;
        wmt_compare_op_s2_next = decoder_wmt_compare_op_s1;
        lruarray_write_op_s2_next = decoder_lruarray_write_op_s1;
        csm_op_s2_next = decoder_csm_op_s1;
        config_op_s2_next = decoder_config_op_s1;
        s3_mshr_operation_s2_next = decoder_s3_mshr_operation_s1;
        cpx_operation_s2_next = decoder_cpx_operation_s1;
        noc1_operation_s2_next = decoder_noc1_operation_s1;
        noc3_operations_s2_next = decoder_noc3_operation_s1;
        mesi_read_op_s2_next = decoder_mesi_read_op_s1;
        mesi_write_op_s2_next = decoder_mesi_write_op_s1;
        dcache_operation_s2_next = decoder_dcache_operation_s1;
        s2_mshr_operation_s2_next = decoder_s2_mshr_operation_s1;
        pcx_ack_stage_s2_next = decoder_pcx_ack_stage_s1;
        noc2_ack_stage_s2_next = decoder_noc2_ack_stage_s1;
        noc2_ack_state_s2_next = noc2decoder_l15_ack_state;
        predecode_reqtype_s2_next = predecode_reqtype_s1;
        predecode_fwd_subcacheline_vector_s2_next = predecode_fwd_subcacheline_vector_s1;
        predecode_noc2_inval_s2_next = predecode_noc2_inval_s1;
        blockstore_s2_next = predecode_blockstore_bit_s1;
        blockstoreinit_s2_next = predecode_blockstore_init_s1;
        noc2_src_homeid_s2_next = noc2decoder_l15_src_homeid;
        lrsc_flag_write_op_s2_next = decoder_lrsc_flag_write_op_s1;

        `ifndef NO_RTL_CSM
        hmt_fill_homeid_s2_next = predecode_mshr_read_homeid_s1;
        `endif
        csm_pcx_data_s2_next = pcxdecoder_l15_csm_data;
        decoder_dtag_operation_s2_next = decoder_dtag_operation_s1;
        wmt_read_op_s2_next = decoder_wmt_read_op_s1;
        `ifndef NO_RTL_CSM
        hmt_op_s2_next = decoder_hmt_op_s1;
        `endif
    end
end


always @ *
begin
    // Stalling logics
    // The only reason that S2 can stall is that S3 is stalled
    stall_s2 = val_s2 && stall_s3;
end


always @ *
begin
    // PCX/Noc2 ack logics
    // COV: doesn't seem like anything acks in stage 2
    pcx_ack_s2 = val_s2 && !stall_s2 && (pcx_ack_stage_s2 == `L15_ACK_STAGE_S2);
    noc2_ack_s2 = val_s2 && !stall_s2 && (noc2_ack_stage_s2 == `L15_ACK_STAGE_S2);
end


// tag check logics
reg [`L15_CACHE_TAG_RAW_WIDTH-1:0] dtag_tag_way0_s2;
reg [`L15_CACHE_TAG_RAW_WIDTH-1:0] dtag_tag_way1_s2;
reg [`L15_CACHE_TAG_RAW_WIDTH-1:0] dtag_tag_way2_s2;
reg [`L15_CACHE_TAG_RAW_WIDTH-1:0] dtag_tag_way3_s2;
reg [`L15_MESI_STATE_WIDTH-1:0] mesi_state_way0_s2;
reg [`L15_MESI_STATE_WIDTH-1:0] mesi_state_way1_s2;
reg [`L15_MESI_STATE_WIDTH-1:0] mesi_state_way2_s2;
reg [`L15_MESI_STATE_WIDTH-1:0] mesi_state_way3_s2;
reg [`L15_UNPARAM_7_0] mesi_read_data_s2;
reg tagcheck_way0_equals;
reg tagcheck_way1_equals;
reg tagcheck_way2_equals;
reg tagcheck_way3_equals;

reg [`L15_UNPARAM_1_0] tagcheck_state_s2;
reg tagcheck_state_me_s2;
reg tagcheck_state_mes_s2;
reg tagcheck_state_s_s2;
reg tagcheck_state_m_s2;
reg tagcheck_state_e_s2;
reg [`L15_UNPARAM_1_0] tagcheck_way_s2;
// reg [`L15_UNPARAM_3_0] tagcheck_way_mask_s2;
reg tagcheck_val_s2;
reg tagcheck_lrsc_flag_s2;

reg [`L15_UNPARAM_1_0] lru_state_s2;
reg lru_state_m_s2;
reg lru_state_mes_s2;
reg [`L15_CACHE_TAG_WIDTH-1:0] lru_way_tag_s2;
reg [`L15_PADDR_MASK] lru_way_address_s2;

reg [`L15_UNPARAM_1_0] flush_state_s2;
reg flush_state_m_s2;
reg flush_state_me_s2;
reg flush_state_mes_s2;
reg [`L15_UNPARAM_1_0] flush_way_s2;
// reg [`L15_UNPARAM_3_0] flush_way_mask_s2;
reg [`L15_CACHE_TAG_WIDTH-1:0] flush_way_tag_s2;
reg [`L15_PADDR_MASK] flush_way_address_s2;
always @ *
begin
    // note: dtag has 33b per tag entry way, but we are only using 29b
    dtag_tag_way0_s2 = dtag_l15_dout_s2[0*`L15_CACHE_TAG_RAW_WIDTH +: `L15_CACHE_TAG_RAW_WIDTH];
    dtag_tag_way1_s2 = dtag_l15_dout_s2[1*`L15_CACHE_TAG_RAW_WIDTH +: `L15_CACHE_TAG_RAW_WIDTH];
    dtag_tag_way2_s2 = dtag_l15_dout_s2[2*`L15_CACHE_TAG_RAW_WIDTH +: `L15_CACHE_TAG_RAW_WIDTH];
    dtag_tag_way3_s2 = dtag_l15_dout_s2[3*`L15_CACHE_TAG_RAW_WIDTH +: `L15_CACHE_TAG_RAW_WIDTH];
    mesi_state_way0_s2 = mesi_l15_dout_s2[`L15_UNPARAM_1_0];
    mesi_state_way1_s2 = mesi_l15_dout_s2[3:2];
    mesi_state_way2_s2 = mesi_l15_dout_s2[5:4];
    mesi_state_way3_s2 = mesi_l15_dout_s2[7:6];
    mesi_read_data_s2 = mesi_l15_dout_s2;

    // for lru way check
    lru_state_s2 =   (lru_way_s2 == 0) ? mesi_state_way0_s2 :
                        (lru_way_s2 == 1) ? mesi_state_way1_s2 :
                        (lru_way_s2 == 2) ? mesi_state_way2_s2 :
                                                mesi_state_way3_s2;
    lru_way_tag_s2[`L15_CACHE_TAG_WIDTH-1:0] =
                        (lru_way_s2 == 0) ? dtag_tag_way0_s2[`L15_CACHE_TAG_WIDTH-1:0] :
                        (lru_way_s2 == 1) ? dtag_tag_way1_s2[`L15_CACHE_TAG_WIDTH-1:0] :
                        (lru_way_s2 == 2) ? dtag_tag_way2_s2[`L15_CACHE_TAG_WIDTH-1:0] :
                                                dtag_tag_way3_s2[`L15_CACHE_TAG_WIDTH-1:0];
    lru_way_address_s2 = {lru_way_tag_s2, address_s2[`L15_IDX_HI:`L15_IDX_LOW], 4'b0};


    // DTAG COMPARISON
    // only compare L15_CACHE_TAG_WIDTH (29b), not full raw tag
    tagcheck_way0_equals = (address_cache_tag_s2[`L15_CACHE_TAG_WIDTH-1:0] == dtag_tag_way0_s2[`L15_CACHE_TAG_WIDTH-1:0]);
    tagcheck_way1_equals = (address_cache_tag_s2[`L15_CACHE_TAG_WIDTH-1:0] == dtag_tag_way1_s2[`L15_CACHE_TAG_WIDTH-1:0]);
    tagcheck_way2_equals = (address_cache_tag_s2[`L15_CACHE_TAG_WIDTH-1:0] == dtag_tag_way2_s2[`L15_CACHE_TAG_WIDTH-1:0]);
    tagcheck_way3_equals = (address_cache_tag_s2[`L15_CACHE_TAG_WIDTH-1:0] == dtag_tag_way3_s2[`L15_CACHE_TAG_WIDTH-1:0]);

    {tagcheck_val_s2, tagcheck_way_s2} = tagcheck_way0_equals && (mesi_state_way0_s2 != `L15_MESI_STATE_I) ? {1'b1, 2'd0} :
                                                    tagcheck_way1_equals && (mesi_state_way1_s2 != `L15_MESI_STATE_I) ?  {1'b1, 2'd1} :
                                                    tagcheck_way2_equals && (mesi_state_way2_s2 != `L15_MESI_STATE_I) ?  {1'b1, 2'd2} :
                                                    tagcheck_way3_equals && (mesi_state_way3_s2 != `L15_MESI_STATE_I) ?  {1'b1, 2'd3} : 3'b0;

    // tagcheck_way_mask_s2[`L15_UNPARAM_3_0] = tagcheck_way_s2 == 2'd0 ? 4'b0001 :
    //                                                               2'd1 ? 4'b0010 :
    //                                                               2'd2 ? 4'b0100 :
    //                                                                         4'b1000 ;

    tagcheck_lrsc_flag_s2 = (tagcheck_val_s2 == 1'b0) ? 1'b0 :
                                (tagcheck_way_s2 == 2'd0) ? lrsc_flag_l15_dout_s2[0] :
                                (tagcheck_way_s2 == 2'd1) ? lrsc_flag_l15_dout_s2[1] :
                                (tagcheck_way_s2 == 2'd2) ? lrsc_flag_l15_dout_s2[2] :
                                                            lrsc_flag_l15_dout_s2[3] ;

    tagcheck_state_s2 = (tagcheck_val_s2 == 1'b0) ? `L15_MESI_STATE_I :
                                (tagcheck_way_s2 == 2'd0) ? mesi_state_way0_s2 :
                                (tagcheck_way_s2 == 2'd1) ? mesi_state_way1_s2 :
                                (tagcheck_way_s2 == 2'd2) ? mesi_state_way2_s2 :
                                                                     mesi_state_way3_s2 ;

    flush_way_s2 = address_s2[25:24];
    flush_state_s2 =  (flush_way_s2 == 2'd0) ? mesi_state_way0_s2 :
                            (flush_way_s2 == 2'd1) ? mesi_state_way1_s2 :
                            (flush_way_s2 == 2'd2) ? mesi_state_way2_s2 :
                                                             mesi_state_way3_s2 ;

    flush_way_tag_s2[`L15_CACHE_TAG_WIDTH-1:0] =
                        (flush_way_s2 == 0) ? dtag_tag_way0_s2[`L15_CACHE_TAG_WIDTH-1:0] :
                        (flush_way_s2 == 1) ? dtag_tag_way1_s2[`L15_CACHE_TAG_WIDTH-1:0] :
                        (flush_way_s2 == 2) ? dtag_tag_way2_s2[`L15_CACHE_TAG_WIDTH-1:0] :
                                                        dtag_tag_way3_s2[`L15_CACHE_TAG_WIDTH-1:0];

    flush_way_address_s2 = {flush_way_tag_s2, address_s2[`L15_IDX_HI:`L15_IDX_LOW], 4'b0};

    // expanding some signals
    tagcheck_state_me_s2 = tagcheck_state_s2 == `L15_MESI_STATE_M || tagcheck_state_s2 == `L15_MESI_STATE_E;
    tagcheck_state_mes_s2 = tagcheck_state_s2 == `L15_MESI_STATE_M || tagcheck_state_s2 == `L15_MESI_STATE_E
                                                        || tagcheck_state_s2 == `L15_MESI_STATE_S;
    tagcheck_state_s_s2 = tagcheck_state_s2 == `L15_MESI_STATE_S;
    tagcheck_state_m_s2 = tagcheck_state_s2 == `L15_MESI_STATE_M;
    tagcheck_state_e_s2 = tagcheck_state_s2 == `L15_MESI_STATE_E;

    lru_state_m_s2 = lru_state_s2 == `L15_MESI_STATE_M;
    lru_state_mes_s2 = lru_state_s2 == `L15_MESI_STATE_M || lru_state_s2 == `L15_MESI_STATE_E
                                                        || lru_state_s2 == `L15_MESI_STATE_S;

    flush_state_m_s2 = flush_state_s2 == `L15_MESI_STATE_M;
    flush_state_me_s2 = flush_state_s2 == `L15_MESI_STATE_M || flush_state_s2 == `L15_MESI_STATE_E;
    flush_state_mes_s2 = flush_state_s2 == `L15_MESI_STATE_M || flush_state_s2 == `L15_MESI_STATE_E
                                                        || flush_state_s2 == `L15_MESI_STATE_S;
end


//////////////////////
// LRU logic
//////////////////////
reg [`L15_WAY_ARRAY_MASK] lru_used_bits_s2;
reg [`L15_WAY_MASK] lru_round_robin_turn_s2;
// reg [`L15_WAY_MASK] lru_way_s2; // moved earlier for
always @ *
begin
    lru_used_bits_s2[`L15_WAY_ARRAY_MASK] = lruarray_l15_dout_s2[`L15_LRUARRAY_USED_MASK];
    lru_round_robin_turn_s2[`L15_WAY_MASK] = lruarray_l15_dout_s2[`L15_LRUARRAY_RR_MASK];
    lru_way_s2 = 0;
    if (&lru_used_bits_s2 == 1'b1)
    begin
        // if all were used
        lru_way_s2[`L15_WAY_MASK] = lru_round_robin_turn_s2;
    end
    else
    begin
        case (lru_round_robin_turn_s2)
            `L15_WAYID_WAY0:
            begin
                lru_way_s2[`L15_WAY_MASK] = (lru_used_bits_s2[`L15_WAY_ARRAY_WAY0_MASK] == 1'b0) ? `L15_WAYID_WAY0 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY1_MASK] == 1'b0) ? `L15_WAYID_WAY1 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY2_MASK] == 1'b0) ? `L15_WAYID_WAY2 :
                                                                      `L15_WAYID_WAY3 ;
            end
            `L15_WAYID_WAY1:
            begin
                lru_way_s2[`L15_WAY_MASK] = (lru_used_bits_s2[`L15_WAY_ARRAY_WAY1_MASK] == 1'b0) ? `L15_WAYID_WAY1 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY2_MASK] == 1'b0) ? `L15_WAYID_WAY2 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY3_MASK] == 1'b0) ? `L15_WAYID_WAY3 :
                                                                      `L15_WAYID_WAY0 ;
            end
            `L15_WAYID_WAY2:
            begin
                lru_way_s2[`L15_WAY_MASK] = (lru_used_bits_s2[`L15_WAY_ARRAY_WAY2_MASK] == 1'b0) ? `L15_WAYID_WAY2 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY3_MASK] == 1'b0) ? `L15_WAYID_WAY3 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY0_MASK] == 1'b0) ? `L15_WAYID_WAY0 :
                                                                      `L15_WAYID_WAY1 ;
            end
            `L15_WAYID_WAY3:
            begin
                lru_way_s2[`L15_WAY_MASK] = (lru_used_bits_s2[`L15_WAY_ARRAY_WAY3_MASK] == 1'b0) ? `L15_WAYID_WAY3 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY0_MASK] == 1'b0) ? `L15_WAYID_WAY0 :
                                            (lru_used_bits_s2[`L15_WAY_ARRAY_WAY1_MASK] == 1'b0) ? `L15_WAYID_WAY1 :
                                                                      `L15_WAYID_WAY2 ;
            end
        endcase
    end
end

//////////////////////////////
// S2 MSHR write-buffer read
//////////////////////////////
reg s2_mshr_val_s2;
reg [`L15_MSHR_ID_WIDTH-1:0] s2_mshr_mshrid_s2;
always @ *
begin
    s2_mshr_val_s2 = 0;
    s2_mshr_mshrid_s2 = 0;
    case (s2_mshr_operation_s2)
        `L15_S2_MSHR_OP_READ_WRITE_CACHE:
        begin
            s2_mshr_val_s2 = 1;
            s2_mshr_mshrid_s2 = mshrid_s2;
        end
    endcase

    // 7/16/14 timing fix: Tri: don't need stall signal for read
    // pipe_mshr_write_buffer_rd_en_s2 = s2_mshr_val_s2 && !stall_s2;
    pipe_mshr_write_buffer_rd_en_s2 = s2_mshr_val_s2;
    pipe_mshr_threadid_s2 = threadid_s2;
end

//////////////////////////////
// dcache control logics
//////////////////////////////
reg dcache_val_s2;
reg dcache_rw_s2;
reg [`L15_CACHE_INDEX_MASK] dcache_index_s2;
reg [`L15_UNPARAM_1_0] dcache_way_s2;
reg [`L15_UNPARAM_127_0] dcache_mshr_write_mask_s2;
reg [`L15_UNPARAM_127_0] dcache_write_merge_mshr_noc2_s2;
reg [`L15_DCACHE_SOURCE_WIDTH-1:0] dcache_source_s2;
reg [`L15_UNPARAM_127_0] dcache_write_mask_s2;
reg [`L15_UNPARAM_127_0] dcache_write_data_s2;
// diag accesses
reg [`L15_CACHE_INDEX_MASK] dcache_diag_index_s2;
reg [`L15_UNPARAM_1_0] dcache_diag_way_s2;
reg [0:0] dcache_diag_offset_s2;
reg [`L15_UNPARAM_1_0] lru_way_s3_bypassed;


always @ *
begin
    dcache_val_s2 = 0;
    dcache_rw_s2 = 0;
    dcache_index_s2 = 0;
    dcache_way_s2 = 0;
    dcache_mshr_write_mask_s2 = 0;
    dcache_write_merge_mshr_noc2_s2 = 0;
    dcache_source_s2 = 0;
    dcache_write_mask_s2 = 0;
    dcache_write_data_s2 = 0;

    dcache_diag_way_s2 = address_s2[25:24];
    dcache_diag_index_s2 = address_s2[`L15_IDX_HI:`L15_IDX_LOW];
    dcache_diag_offset_s2 = address_s2[3];

    case (dcache_operation_s2)
        `L15_DCACHE_READ_TAGCHECK_WAY_IF_M:
        begin
            dcache_val_s2 = tagcheck_state_m_s2;
            dcache_rw_s2 = `L15_DTAG_RW_READ;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = tagcheck_way_s2;
        end
        `L15_DCACHE_READ_TAGCHECK_WAY_IF_MES:
        begin
            dcache_val_s2 = tagcheck_state_mes_s2;
            dcache_rw_s2 = `L15_DTAG_RW_READ;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = tagcheck_way_s2;
        end
        `L15_DCACHE_READ_LRU_WAY_IF_M:
        begin
            dcache_val_s2 = lru_state_m_s2;
            dcache_rw_s2 = `L15_DTAG_RW_READ;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = lru_way_s2;
        end
        `L15_DCACHE_READ_FLUSH_WAY_IF_M:
        begin
            dcache_val_s2 = flush_state_m_s2;
            dcache_rw_s2 = `L15_DTAG_RW_READ;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = flush_way_s2;
        end
        `L15_DCACHE_WRITE_TAGCHECK_WAY_IF_ME_FROM_MSHR:
        begin
            dcache_val_s2 = tagcheck_state_me_s2;
            dcache_rw_s2 = `L15_DTAG_RW_WRITE;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = tagcheck_way_s2;
            dcache_source_s2 = `L15_DCACHE_SOURCE_MSHR;
        end
        `L15_DCACHE_WRITE_TAGCHECK_WAY_IF_LRSC_SET_FROM_MSHR:
        begin
            dcache_val_s2 = (tagcheck_state_m_s2 & tagcheck_lrsc_flag_s2); // Check state_m is just redundant, but need to be conservative
            dcache_rw_s2 = `L15_DTAG_RW_WRITE;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = tagcheck_way_s2;
            dcache_source_s2 = `L15_DCACHE_SOURCE_MSHR;
        end
        `L15_DCACHE_WRITE_LRU_WAY_FROM_NOC2:
        begin
            dcache_val_s2 = 1'b1;
            dcache_rw_s2 = `L15_DTAG_RW_WRITE;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = lru_way_s3_bypassed; // need to be from S3, shouldn't change behavior but...
            dcache_source_s2 = `L15_DCACHE_SOURCE_NOC2;
        end
        `L15_DCACHE_WRITE_LRU_WAY_FROM_NOC2_AND_MSHR:
        begin
            dcache_val_s2 = 1'b1;
            dcache_rw_s2 = `L15_DTAG_RW_WRITE;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = lru_way_s3_bypassed; // need to be from S3, shouldn't change behavior but...
            dcache_source_s2 = `L15_DCACHE_SOURCE_NOC2_AND_MSHR;
        end
        `L15_DCACHE_WRITE_MSHR_WAY_FROM_MSHR:
        begin
            // writing to dcache the mshr way stored in st_mshr
            dcache_val_s2 = 1'b1;
            dcache_rw_s2 = `L15_DTAG_RW_WRITE;
            dcache_index_s2 = cache_index_s2;
            dcache_way_s2 = way_mshr_st_s2;
            dcache_source_s2 = `L15_DCACHE_SOURCE_MSHR;
        end
        `L15_DCACHE_DIAG_READ:
        begin
            dcache_val_s2 = 1'b1;
            dcache_rw_s2 = `L15_DTAG_RW_READ;
            dcache_index_s2 = dcache_diag_index_s2;
            dcache_way_s2 = dcache_diag_way_s2;
        end
        `L15_DCACHE_DIAG_WRITE:
        begin
            dcache_val_s2 = 1'b1;
            dcache_rw_s2 = `L15_DTAG_RW_WRITE;
            dcache_index_s2 = dcache_diag_index_s2;
            dcache_way_s2 = dcache_diag_way_s2;
            dcache_source_s2 = `L15_DCACHE_SOURCE_PCX_DIAG;
        end
    endcase

    dcache_mshr_write_mask_s2 = {
        {8{mshr_pipe_write_buffer_byte_mask_s2[15]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[14]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[13]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[12]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[11]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[10]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[9]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[8]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[7]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[6]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[5]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[4]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[3]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[2]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[1]}},
        {8{mshr_pipe_write_buffer_byte_mask_s2[0]}}
    };


    dcache_write_merge_mshr_noc2_s2[`L15_UNPARAM_127_0] =
                    {(~dcache_mshr_write_mask_s2[127:64] & noc2decoder_l15_data_0[`L15_UNPARAM_63_0]),
                    (~dcache_mshr_write_mask_s2[`L15_UNPARAM_63_0] & noc2decoder_l15_data_1[`L15_UNPARAM_63_0])}
                        | (dcache_mshr_write_mask_s2[`L15_UNPARAM_127_0] & mshr_pipe_write_buffer_s2[`L15_UNPARAM_127_0]);

    case (dcache_source_s2)
        `L15_DCACHE_SOURCE_MSHR:
        begin
            dcache_write_mask_s2[`L15_UNPARAM_127_0] = dcache_mshr_write_mask_s2[`L15_UNPARAM_127_0];
            dcache_write_data_s2[`L15_UNPARAM_127_0] = mshr_pipe_write_buffer_s2[`L15_UNPARAM_127_0];
        end
        `L15_DCACHE_SOURCE_NOC2:
        begin
            dcache_write_mask_s2[`L15_UNPARAM_127_0] = {128{1'b1}};
            dcache_write_data_s2[`L15_UNPARAM_127_0] = {noc2decoder_l15_data_0[`L15_UNPARAM_63_0], noc2decoder_l15_data_1[`L15_UNPARAM_63_0]};
        end
        `L15_DCACHE_SOURCE_NOC2_AND_MSHR:
        begin
            dcache_write_mask_s2[`L15_UNPARAM_127_0] = {128{1'b1}};
            dcache_write_data_s2[`L15_UNPARAM_127_0] = dcache_write_merge_mshr_noc2_s2[`L15_UNPARAM_127_0];
        end
        `L15_DCACHE_SOURCE_PCX_DIAG:
        begin
            dcache_write_mask_s2[`L15_UNPARAM_127_0] = dcache_diag_offset_s2 == 1'b0 ? {{64{1'b1}},64'b0} : {64'b0,{64{1'b1}}};
            dcache_write_data_s2[`L15_UNPARAM_127_0] = {pcxdecoder_l15_data[`L15_UNPARAM_63_0],pcxdecoder_l15_data[`L15_UNPARAM_63_0]};
        end
    endcase

    l15_dcache_val_s2 = dcache_val_s2 && val_s2 && !stall_s2;
    l15_dcache_rw_s2 = dcache_rw_s2;
    l15_dcache_index_s2 = {dcache_index_s2, dcache_way_s2};
    l15_dcache_write_mask_s2[`L15_UNPARAM_127_0] = dcache_write_mask_s2;
    l15_dcache_write_data_s2[`L15_UNPARAM_127_0] = dcache_write_data_s2;


    // extra data for CSM homeid table
    // encode packet format to internal format (smaller)

    // if source is MSHR it means a write hi
    // hmt_fill_data_s2 = (dcache_source_s2 == `L15_DCACHE_SOURCE_MSHR) ? 
    `ifndef NO_RTL_CSM
    l15_hmt_write_data_s2[`L15_CSM_GHID_WIDTH-1:0] = 0;
    l15_hmt_write_data_s2[`L15_CSM_GHID_CHIP_MASK] = hmt_fill_homeid_s2[`PACKET_HOME_ID_CHIP_MASK];
    l15_hmt_write_data_s2[`L15_CSM_GHID_XPOS_MASK] = hmt_fill_homeid_s2[`PACKET_HOME_ID_X_MASK];
    l15_hmt_write_data_s2[`L15_CSM_GHID_YPOS_MASK] = hmt_fill_homeid_s2[`PACKET_HOME_ID_Y_MASK];
    // l15_hmt_write_data_s2[`L15_CSM_GHID_CHIP_MASK] = noc2_src_homeid_s2[`PACKET_HOME_ID_CHIP_MASK];
    // l15_hmt_write_data_s2[`L15_CSM_GHID_XPOS_MASK] = noc2_src_homeid_s2[`PACKET_HOME_ID_X_MASK];
    // l15_hmt_write_data_s2[`L15_CSM_GHID_YPOS_MASK] = noc2_src_homeid_s2[`PACKET_HOME_ID_Y_MASK];
    l15_hmt_write_mask_s2 = 0;
    if (hmt_op_s2 == `L15_HMT_OP_WRITE)
      l15_hmt_write_mask_s2[`L15_CSM_GHID_WIDTH-1:0] = {`L15_CSM_GHID_WIDTH{1'b1}};
    `endif
end

////////////////////////
// Home Map Table
////////////////////////
// reg hmt_val_s2;
// reg hmt_rw_s2;
// reg [(`L15_CACHE_INDEX_WIDTH+`L15_PADDR_WIDTH)-1:0] hmt_index_s2;
// reg [31:0] hmt_write_data_s2;
// reg [31:0] hmt_write_mask_s2;

////////////////////////
// MESI write control
////////////////////////
reg mesi_write_val_s2;
reg [`L15_CACHE_INDEX_MASK] mesi_write_index_s2;
reg [`L15_UNPARAM_1_0] mesi_write_way_s2;
reg [`L15_UNPARAM_1_0] mesi_write_state_s2;
always @ *
begin
    mesi_write_val_s2 = 0;
    mesi_write_index_s2 = 0;
    mesi_write_way_s2 = 0;
    mesi_write_state_s2 = 0;
    case (mesi_write_op_s2)
        `L15_S3_MESI_INVALIDATE_TAGCHECK_WAY_IF_MES:
        begin
            mesi_write_val_s2 = tagcheck_state_mes_s2;
            mesi_write_index_s2 = cache_index_s2;
            mesi_write_way_s2 = tagcheck_way_s2;
            mesi_write_state_s2 = `L15_MESI_STATE_I;
        end
        `L15_S3_MESI_INVALIDATE_FLUSH_WAY_IF_MES:
        begin
            mesi_write_val_s2 = flush_state_mes_s2;
            mesi_write_index_s2 = cache_index_s2;
            mesi_write_way_s2 = flush_way_s2;
            mesi_write_state_s2 = `L15_MESI_STATE_I;
        end
        `L15_S3_MESI_WRITE_TAGCHECK_WAY_S_IF_ME:
        begin
            mesi_write_val_s2 = tagcheck_state_me_s2;
            mesi_write_index_s2 = cache_index_s2;
            mesi_write_way_s2 = tagcheck_way_s2;
            mesi_write_state_s2 = `L15_MESI_STATE_S;
        end
        `L15_S3_MESI_WRITE_TAGCHECK_WAY_M_IF_E:
        begin
            mesi_write_val_s2 = tagcheck_state_e_s2;
            mesi_write_index_s2 = cache_index_s2;
            mesi_write_way_s2 = tagcheck_way_s2;
            mesi_write_state_s2 = `L15_MESI_STATE_M;
        end
        `L15_S3_MESI_WRITE_LRU_WAY_ACK_STATE:
        begin
            mesi_write_val_s2 = 1'b1;
            mesi_write_index_s2 = cache_index_s2;
            mesi_write_way_s2 = lru_way_s2;
            mesi_write_state_s2 = noc2_ack_state_s2;
        end
        `L15_S3_MESI_WRITE_MSHR_WAY_ACK_STATE:
        begin
            mesi_write_val_s2 = 1'b1;
            mesi_write_index_s2 = cache_index_s2;
            mesi_write_way_s2 = way_mshr_st_s2;
            mesi_write_state_s2 = noc2_ack_state_s2;
        end
    endcase
    // bugfix (stall signal needs to be here)
    // trin todo: why stall_s2 is needed
    l15_mesi_write_val_s2 = mesi_write_val_s2 && val_s2 && !stall_s2;
    l15_mesi_write_index_s2[`L15_CACHE_INDEX_MASK] = mesi_write_index_s2;
    l15_mesi_write_mask_s2[`L15_UNPARAM_7_0] =  (mesi_write_way_s2 == 0) ? 8'b00_00_00_11 :
                            (mesi_write_way_s2 == 1) ? 8'b00_00_11_00 :
                            (mesi_write_way_s2 == 2) ? 8'b00_11_00_00 :
                                                    8'b11_00_00_00 ;
    l15_mesi_write_data_s2[`L15_UNPARAM_7_0] = {4{mesi_write_state_s2}};
end


////////////////////////
// LRSC flag write control
////////////////////////
reg lrsc_flag_write_val_s2;
reg [`L15_CACHE_INDEX_MASK] lrsc_flag_write_index_s2;
reg [`L15_UNPARAM_1_0] lrsc_flag_write_way_s2;
reg lrsc_flag_write_state_s2;
always @ *
begin
    lrsc_flag_write_val_s2 = 0;
    lrsc_flag_write_index_s2 = 0;
    lrsc_flag_write_way_s2 = 0;
    lrsc_flag_write_state_s2 = 0;
    case (lrsc_flag_write_op_s2)
        `L15_S2_LRSC_FLAG_SET_LRU_WAY:
        begin
            lrsc_flag_write_val_s2 = 1'b1;
            lrsc_flag_write_index_s2 = cache_index_s2;
            lrsc_flag_write_way_s2 = lru_way_s2;
            lrsc_flag_write_state_s2 = 1'b1;
        end
        `L15_S2_LRSC_FLAG_CLEAR_TAGCHECK_WAY:  
        begin
            lrsc_flag_write_val_s2 = tagcheck_state_m_s2;  // can be always 1
            lrsc_flag_write_index_s2 = cache_index_s2;
            lrsc_flag_write_way_s2 = tagcheck_way_s2;
            lrsc_flag_write_state_s2 = 1'b0;
        end
        `L15_S2_LRSC_FLAG_CLEAR_LRU_WAY:  
        begin
            lrsc_flag_write_val_s2 = 1'b1;
            lrsc_flag_write_index_s2 = cache_index_s2;
            lrsc_flag_write_way_s2 = lru_way_s2;
            lrsc_flag_write_state_s2 = 1'b0;
        end
        `L15_S2_LRSC_FLAG_CLEAR_FLUSH_WAY:  
        begin
            lrsc_flag_write_val_s2 = flush_state_m_s2;
            lrsc_flag_write_index_s2 = cache_index_s2;
            lrsc_flag_write_way_s2 = flush_way_s2;
            lrsc_flag_write_state_s2 = 1'b0;
        end
    endcase
    // bugfix (stall signal needs to be here)
    // trin todo: why stall_s2 is needed
    l15_lrsc_flag_write_val_s2 = lrsc_flag_write_val_s2 && val_s2 && !stall_s2;
    l15_lrsc_flag_write_index_s2[`L15_CACHE_INDEX_MASK] = lrsc_flag_write_index_s2;
    l15_lrsc_flag_write_mask_s2[`L15_UNPARAM_3_0] =  (lrsc_flag_write_way_s2 == 0) ? 4'b0001 :
                            (lrsc_flag_write_way_s2 == 1) ? 4'b0010 :
                            (lrsc_flag_write_way_s2 == 2) ? 4'b0100 :
                                                    4'b1000 ;
    l15_lrsc_flag_write_data_s2[`L15_UNPARAM_3_0] = {4{lrsc_flag_write_state_s2}};
end

////////////////////////////
// output to CSM
////////////////////////////

// reg csm_read_ghid_val_s2;
reg [`L15_CSM_NUM_TICKETS_LOG2-1:0] csm_ticket_s2;
// reg [`L15_CSM_NUM_TICKETS_LOG2-1:0] csm_ticket_s2_next;

// always @ (posedge clk)
// begin
//     if (!rst_n)
//     begin
//         csm_ticket_s2 <= 0;
//     end
//     else
//     begin
//         if (csm_read_ghid_val_s2 && !stall_s2 && val_s2)
//             csm_ticket_s2 <= csm_ticket_s2_next;
//     end
// end

reg [`L15_UNPARAM_127_0] csm_fill_data;
reg csm_req_val_s2;
reg csm_req_type_s2;
reg csm_req_lru_address_s2;
reg [`L15_PADDR_MASK] csm_address_s2;
always @ *
begin
    // csm_ticket_s2_next = csm_ticket_s2 + 1;
    // csm_read_ghid_val_s2 = 0;
    csm_fill_data = 0;
    csm_req_val_s2 = 0;
    csm_req_type_s2 = 0;
    csm_req_lru_address_s2 = 0;
    csm_address_s2 = 0;
    // l15_csm_req_ticket_s2 = 0;
    csm_ticket_s2 = {threadid_s2, mshrid_s2};
    l15_csm_req_ticket_s2 = csm_ticket_s2;
    case (csm_op_s2)
        `L15_CSM_OP_READ_GHID:
        begin
            csm_req_val_s2 = 1'b1;
            csm_req_type_s2 = 1'b0;
            // csm_read_ghid_val_s2 = 1'b1;
            csm_address_s2 = address_s2;
            // l15_csm_req_ticket_s2 = csm_ticket_s2;
        end
        `L15_CSM_OP_READ_GHID_IF_TAGCHECK_SI:
        begin
            csm_req_val_s2 = (tagcheck_state_me_s2 == 1'b0);
            csm_req_type_s2 = 1'b0;
            // csm_read_ghid_val_s2 = 1'b1;
            csm_address_s2 = address_s2;
            // l15_csm_req_ticket_s2 = csm_ticket_s2;
        end
        `L15_CSM_OP_READ_GHID_IF_TAGCHECK_MISS:
        begin
            csm_req_val_s2 = (tagcheck_state_mes_s2 == 1'b0);
            csm_req_type_s2 = 1'b0;
            // csm_read_ghid_val_s2 = 1'b1;
            csm_address_s2 = address_s2;
            // l15_csm_req_ticket_s2 = csm_ticket_s2;
        end
        `L15_CSM_OP_HMC_FILL:
        begin
            csm_req_val_s2 = 1'b1;
            csm_req_type_s2 = 1'b1;
            csm_fill_data = {noc2decoder_l15_data_1[`L15_UNPARAM_63_0], noc2decoder_l15_data_0[`L15_UNPARAM_63_0]};
            //the req ticket is embedded in the mshrid of the refill msg
            l15_csm_req_ticket_s2 = noc2decoder_l15_csm_mshrid[`L15_CSM_NUM_TICKETS_LOG2-1:0];
        end
        `L15_CSM_OP_HMC_DIAG_STORE:
        begin
            csm_req_val_s2 = 1'b1;
            csm_req_type_s2 = 1'b1;
            csm_fill_data = {pcxdecoder_l15_data[`L15_UNPARAM_63_0],pcxdecoder_l15_data[`L15_UNPARAM_63_0]};
            // l15_csm_req_ticket_s2 = csm_ticket_s2;
            csm_address_s2 = address_s2;
        end
        `L15_CSM_OP_HMC_DIAG_LOAD:
        begin
            csm_req_val_s2 = 1'b1;
            csm_req_type_s2 = 1'b0;
            // l15_csm_req_ticket_s2 = csm_ticket_s2;
            csm_address_s2 = address_s2;
        end
        `L15_CSM_OP_HMC_FLUSH:
        begin
            csm_req_val_s2 = 1'b1;
            // csm_req_type_s2 = 1'b0; // type is not needed?
            // l15_csm_req_ticket_s2 = csm_ticket_s2;
            csm_address_s2 = address_s2;
        end
        `ifndef NO_RTL_CSM
        `else
        `L15_CSM_OP_EVICT_IF_LRU_M:
        begin
            csm_req_val_s2 = val_s2 & lru_state_m_s2;
            csm_address_s2 = lru_way_address_s2;
        end
        `L15_CSM_OP_EVICT_IF_FLUSH_M:
        begin
            csm_req_val_s2 = val_s2 & flush_state_m_s2;
            csm_address_s2 = flush_way_address_s2;
        end
        `L15_CSM_OP_EVICT_IF_M:
        begin
            csm_req_val_s2 = val_s2 & tagcheck_state_m_s2;
            csm_address_s2 = address_s2;
        end
        `endif
    endcase

    l15_csm_req_address_s2 = csm_address_s2;
    l15_csm_req_val_s2 = csm_req_val_s2 && !stall_s2 && val_s2;
    l15_csm_req_type_s2 = csm_req_type_s2;
    // l15_csm_stall_s2 = stall_s2;
    // l15_csm_clump_tile_count_s2 = 1'b0; // adsfasdf
    l15_csm_req_data_s2 = csm_fill_data[`L15_UNPARAM_127_0];
    l15_csm_req_pcx_data_s2 = csm_pcx_data_s2;
end


///////////////////////
// WMT read op
///////////////////////
reg wmt_read_val_s2;
reg [`L1D_SET_IDX_MASK] wmt_read_index_s2;
always @ *
begin
    wmt_read_val_s2 = 0;
    wmt_read_index_s2 = 0;

    case(wmt_read_op_s2)
        `L15_WMT_READ:
        begin
            wmt_read_val_s2 = 1'b1;
            wmt_read_index_s2 = cache_index_l1d_s2[`L1D_SET_IDX_MASK];
            // assuming l1.5 is bigger or equal to l1d
        end
    endcase

    l15_wmt_read_val_s2 = wmt_read_val_s2 && val_s2 && !stall_s2;
    l15_wmt_read_index_s2 = wmt_read_index_s2;
end

////////////////////////////
// config operation
////////////////////////////

reg config_req_val_s2;
reg config_req_rw_s2;
reg [`L15_UNPARAM_63_0] config_write_req_data_s2;
reg [`L15_PADDR_MASK] config_req_address_s2;

always @ *
begin
    config_req_val_s2 = 0;
    config_req_rw_s2 = 0;
    config_write_req_data_s2 = 0;
    config_req_address_s2 = 0;
    case (config_op_s2)
        `L15_CONFIG_LOAD:
        begin
            config_req_val_s2 = 1'b1;
            config_req_rw_s2 = 1'b0;
            config_req_address_s2 = address_s2;
        end
        `L15_CONFIG_WRITE:
        begin
            config_req_val_s2 = 1'b1;
            config_req_rw_s2 = 1'b1;
            config_req_address_s2 = address_s2;
            config_write_req_data_s2[`L15_UNPARAM_63_0] = pcxdecoder_l15_data[`L15_UNPARAM_63_0];
        end
    endcase

    l15_config_req_val_s2 = config_req_val_s2 && val_s2 && !stall_s2;
    l15_config_req_rw_s2 = config_req_rw_s2;
    l15_config_write_req_data_s2 = config_write_req_data_s2;
    l15_config_req_address_s2 = config_req_address_s2[`CONFIG_REG_ADDRESS_MASK];
end

/************************************************/
/*                 STAGE 3                      */
/************************************************/

// propagated variables (flops) from S2

reg [2-1:0] tagcheck_way_s3;
reg [2-1:0] tagcheck_way_s3_next;
reg [2-1:0] tagcheck_state_s3;
reg [2-1:0] tagcheck_state_s3_next;
reg [1-1:0] tagcheck_lrsc_flag_s3;
reg [1-1:0] tagcheck_lrsc_flag_s3_next;
reg [2-1:0] flush_way_s3;
reg [2-1:0] flush_way_s3_next;
reg [2-1:0] flush_state_s3;
reg [2-1:0] flush_state_s3_next;
reg [2-1:0] lru_way_s3;
reg [2-1:0] lru_way_s3_next;
reg [2-1:0] lru_state_s3;
reg [2-1:0] lru_state_s3_next;
reg [`L15_MSHR_ID_WIDTH-1:0] mshrid_s3;
reg [`L15_MSHR_ID_WIDTH-1:0] mshrid_s3_next;
reg [`L15_PADDR_WIDTH-1:0] address_s3;
reg [`L15_PADDR_WIDTH-1:0] address_s3_next;
reg [`L15_THREADID_WIDTH-1:0] threadid_s3;
reg [`L15_THREADID_WIDTH-1:0] threadid_s3_next;
reg [1-1:0] non_cacheable_s3;
reg [1-1:0] non_cacheable_s3_next;
reg [3-1:0] size_s3;
reg [3-1:0] size_s3_next;
reg [1-1:0] prefetch_s3;
reg [1-1:0] prefetch_s3_next;
reg [2-1:0] l1_replacement_way_s3;
reg [2-1:0] l1_replacement_way_s3_next;
reg [1-1:0] l2_miss_s3;
reg [1-1:0] l2_miss_s3_next;
reg [1-1:0] f4b_s3;
reg [1-1:0] f4b_s3_next;
reg [1-1:0] blockstore_s3;
reg [1-1:0] blockstore_s3_next;
reg [1-1:0] blockstoreinit_s3;
reg [1-1:0] blockstoreinit_s3_next;
reg [`PACKET_HOME_ID_WIDTH-1:0] noc2_src_homeid_s3;
reg [`PACKET_HOME_ID_WIDTH-1:0] noc2_src_homeid_s3_next;
reg [`L15_LRUARRAY_WRITE_OP_WIDTH-1:0] lruarray_write_op_s3;
reg [`L15_LRUARRAY_WRITE_OP_WIDTH-1:0] lruarray_write_op_s3_next;
reg [1-1:0] predecode_noc2_inval_s3;
reg [1-1:0] predecode_noc2_inval_s3_next;
reg [4-1:0] predecode_fwd_subcacheline_vector_s3;
reg [4-1:0] predecode_fwd_subcacheline_vector_s3_next;
reg [`L15_REQTYPE_WIDTH-1:0] predecode_reqtype_s3;
reg [`L15_REQTYPE_WIDTH-1:0] predecode_reqtype_s3_next;
reg [`L15_WMT_WRITE_OP_WIDTH-1:0] wmt_write_op_s3;
reg [`L15_WMT_WRITE_OP_WIDTH-1:0] wmt_write_op_s3_next;
reg [`L15_WMT_COMPARE_OP_WIDTH-1:0] wmt_compare_op_s3;
reg [`L15_WMT_COMPARE_OP_WIDTH-1:0] wmt_compare_op_s3_next;
reg [`L15_CSM_NUM_TICKETS_LOG2-1:0] csm_ticket_s3;
reg [`L15_CSM_NUM_TICKETS_LOG2-1:0] csm_ticket_s3_next;
reg [`L15_S3_MSHR_OP_WIDTH-1:0] s3_mshr_operation_s3;
reg [`L15_S3_MSHR_OP_WIDTH-1:0] s3_mshr_operation_s3_next;
reg [`L15_CPX_OP_WIDTH-1:0] cpx_operation_s3;
reg [`L15_CPX_OP_WIDTH-1:0] cpx_operation_s3_next;
reg [`L15_NOC1_OP_WIDTH-1:0] noc1_operation_s3;
reg [`L15_NOC1_OP_WIDTH-1:0] noc1_operation_s3_next;
reg [`L15_NOC3_OP_WIDTH-1:0] noc3_operations_s3;
reg [`L15_NOC3_OP_WIDTH-1:0] noc3_operations_s3_next;
reg [`L15_ACK_STAGE_WIDTH-1:0] pcx_ack_stage_s3;
reg [`L15_ACK_STAGE_WIDTH-1:0] pcx_ack_stage_s3_next;
reg [`L15_ACK_STAGE_WIDTH-1:0] noc2_ack_stage_s3;
reg [`L15_ACK_STAGE_WIDTH-1:0] noc2_ack_stage_s3_next;
reg [`L15_MESI_STATE_WIDTH-1:0] noc2_ack_state_s3;
reg [`L15_MESI_STATE_WIDTH-1:0] noc2_ack_state_s3_next;
reg [`L15_CACHE_TAG_WIDTH-1:0] lru_way_tag_s3;
reg [`L15_CACHE_TAG_WIDTH-1:0] lru_way_tag_s3_next;
reg [`L15_CACHE_TAG_WIDTH-1:0] flush_way_tag_s3;
reg [`L15_CACHE_TAG_WIDTH-1:0] flush_way_tag_s3_next;
reg [`TLB_CSM_WIDTH-1:0] csm_pcx_data_s3;
reg [`TLB_CSM_WIDTH-1:0] csm_pcx_data_s3_next;

reg val_s3_next;
reg [`L15_LRUARRAY_MASK] lru_data_s3;

// local variables
reg cpxencoder_req_staled_s3;
reg cpxencoder_req_staled_s3_next;
reg noc1encoder_req_staled_s3;
reg noc1encoder_req_staled_s3_next;
reg noc3encoder_req_staled_s3;
reg noc3encoder_req_staled_s3_next;
reg stall_for_cpx_s3;
// reg stall_for_noc1_s3;
reg stall_for_noc3_s3;

reg tagcheck_state_me_s3;
reg tagcheck_state_mes_s3;
reg tagcheck_state_s_s3;
reg tagcheck_state_e_s3;
reg tagcheck_state_m_s3;
reg lru_state_m_s3;
reg lru_state_mes_s3;
reg flush_state_m_s3;
reg flush_state_mes_s3;

reg [`L15_PADDR_MASK] lru_way_address_s3;
reg [`L15_PADDR_MASK] flush_way_address_s3;

always @ (posedge clk)
begin
    if (!rst_n)
    begin
        cpxencoder_req_staled_s3 <= 0;
        noc1encoder_req_staled_s3 <= 0;
        noc3encoder_req_staled_s3 <= 0;
        val_s3 <= 0;
        lru_data_s3 <= 0;
        tagcheck_way_s3 <= 0;
tagcheck_state_s3 <= 0;
tagcheck_lrsc_flag_s3 <= 0;
flush_way_s3 <= 0;
flush_state_s3 <= 0;
lru_way_s3 <= 0;
lru_state_s3 <= 0;
mshrid_s3 <= 0;
address_s3 <= 0;
threadid_s3 <= 0;
non_cacheable_s3 <= 0;
size_s3 <= 0;
prefetch_s3 <= 0;
l1_replacement_way_s3 <= 0;
l2_miss_s3 <= 0;
f4b_s3 <= 0;
blockstore_s3 <= 0;
blockstoreinit_s3 <= 0;
noc2_src_homeid_s3 <= 0;
lruarray_write_op_s3 <= 0;
predecode_noc2_inval_s3 <= 0;
predecode_fwd_subcacheline_vector_s3 <= 0;
predecode_reqtype_s3 <= 0;
wmt_write_op_s3 <= 0;
wmt_compare_op_s3 <= 0;
csm_ticket_s3 <= 0;
s3_mshr_operation_s3 <= 0;
cpx_operation_s3 <= 0;
noc1_operation_s3 <= 0;
noc3_operations_s3 <= 0;
pcx_ack_stage_s3 <= 0;
noc2_ack_stage_s3 <= 0;
noc2_ack_state_s3 <= 0;
lru_way_tag_s3 <= 0;
flush_way_tag_s3 <= 0;
csm_pcx_data_s3 <= 0;

    end
    else
    begin
        cpxencoder_req_staled_s3 <= cpxencoder_req_staled_s3_next;
        noc1encoder_req_staled_s3 <= noc1encoder_req_staled_s3_next;
        noc3encoder_req_staled_s3 <= noc3encoder_req_staled_s3_next;
        val_s3 <= val_s3_next;
        lru_data_s3 <= lruarray_l15_dout_s2;
        tagcheck_way_s3 <= tagcheck_way_s3_next;
tagcheck_state_s3 <= tagcheck_state_s3_next;
tagcheck_lrsc_flag_s3 <= tagcheck_lrsc_flag_s3_next;
flush_way_s3 <= flush_way_s3_next;
flush_state_s3 <= flush_state_s3_next;
lru_way_s3 <= lru_way_s3_next;
lru_state_s3 <= lru_state_s3_next;
mshrid_s3 <= mshrid_s3_next;
address_s3 <= address_s3_next;
threadid_s3 <= threadid_s3_next;
non_cacheable_s3 <= non_cacheable_s3_next;
size_s3 <= size_s3_next;
prefetch_s3 <= prefetch_s3_next;
l1_replacement_way_s3 <= l1_replacement_way_s3_next;
l2_miss_s3 <= l2_miss_s3_next;
f4b_s3 <= f4b_s3_next;
blockstore_s3 <= blockstore_s3_next;
blockstoreinit_s3 <= blockstoreinit_s3_next;
noc2_src_homeid_s3 <= noc2_src_homeid_s3_next;
lruarray_write_op_s3 <= lruarray_write_op_s3_next;
predecode_noc2_inval_s3 <= predecode_noc2_inval_s3_next;
predecode_fwd_subcacheline_vector_s3 <= predecode_fwd_subcacheline_vector_s3_next;
predecode_reqtype_s3 <= predecode_reqtype_s3_next;
wmt_write_op_s3 <= wmt_write_op_s3_next;
wmt_compare_op_s3 <= wmt_compare_op_s3_next;
csm_ticket_s3 <= csm_ticket_s3_next;
s3_mshr_operation_s3 <= s3_mshr_operation_s3_next;
cpx_operation_s3 <= cpx_operation_s3_next;
noc1_operation_s3 <= noc1_operation_s3_next;
noc3_operations_s3 <= noc3_operations_s3_next;
pcx_ack_stage_s3 <= pcx_ack_stage_s3_next;
noc2_ack_stage_s3 <= noc2_ack_stage_s3_next;
noc2_ack_state_s3 <= noc2_ack_state_s3_next;
lru_way_tag_s3 <= lru_way_tag_s3_next;
flush_way_tag_s3 <= flush_way_tag_s3_next;
csm_pcx_data_s3 <= csm_pcx_data_s3_next;

    end
end



// reg [`L15_UNPARAM_2_0] lru_way_wmt_data_s3;
// reg [`L15_UNPARAM_1_0] lru_way_to_l1_s3;
// reg lru_l1waymap_val_s3;

// reg [`L15_UNPARAM_2_0] flush_way_wmt_data_s3;
// reg [`L15_UNPARAM_1_0] flush_way_to_l1_s3;
// reg flush_l1waymap_val_s3;

// reg [`L15_UNPARAM_2_0] tagcheck_way_wmt_data_s3;
// reg [`L15_UNPARAM_1_0] tagcheck_way_to_l1_s3;
// reg tagcheck_l1waymap_val_s3;

// reg [`L15_UNPARAM_2_0] dedup_wmt_way_wmt_data_s3;
// reg [`L15_UNPARAM_1_0] dedup_wmt_way_to_l1_s3;
// reg dedup_wmt_l1waymap_val_s3;

// reg [`L15_UNPARAM_2_0] stbuf_way_wmt_data_s3;
// reg [`L15_UNPARAM_1_0] stbuf_way_to_l1_s3;
// reg stbuf_l1waymap_val_s3;


reg [`L15_THREAD_ARRAY_MASK] stbuf_compare_address_match_s3;
reg [`L15_THREAD_ARRAY_MASK] stbuf_compare_match_s3;
reg [`L15_THREAD_ARRAY_MASK] stbuf_compare_lru_match_s3;
reg [`L15_THREADID_MASK] stbuf_compare_threadid_s3;
reg [`L15_THREADID_MASK] stbuf_compare_lru_threadid_s3;
reg stbuf_compare_match_val_s3;
reg stbuf_compare_lru_match_val_s3;
reg [`L15_UNPARAM_1_0] stbuf_way_s3; // wmt todo: move calculation to s2

// STORE BUFFER STUFF
always @ *
begin
`ifdef PITON_ASIC_RTL
    stbuf_compare_address_match_s3[0] = mshr_st_address_array[0][10:4] == cache_index_s3;
`else
    stbuf_compare_address_match_s3[0] = mshr_st_address_array[0][39:4] == address_s3[39:4];
`endif
    stbuf_compare_match_s3[0] = mshr_val_array[0][`L15_MSHR_ID_ST] 
                                && (mshr_st_state_array[0] == `L15_MESI_TRANSITION_STATE_SM) 
                                && (stbuf_compare_address_match_s3[0] == 1'b1);
    stbuf_compare_lru_match_s3[0] = stbuf_compare_match_s3[0] && (mshr_st_way_array[0] == lru_way_s3);

`ifdef PITON_ASIC_RTL
    stbuf_compare_address_match_s3[1] = mshr_st_address_array[1][10:4] == cache_index_s3;
`else
    stbuf_compare_address_match_s3[1] = mshr_st_address_array[1][39:4] == address_s3[39:4];
`endif
    stbuf_compare_match_s3[1] = mshr_val_array[1][`L15_MSHR_ID_ST] 
                                && (mshr_st_state_array[1] == `L15_MESI_TRANSITION_STATE_SM) 
                                && (stbuf_compare_address_match_s3[1] == 1'b1);
    stbuf_compare_lru_match_s3[1] = stbuf_compare_match_s3[1] && (mshr_st_way_array[1] == lru_way_s3);

    stbuf_compare_threadid_s3 = stbuf_compare_match_s3[1] ? 1'b1 : 1'b0;
    stbuf_compare_lru_threadid_s3 = stbuf_compare_lru_match_s3[1] ? 1'b1 : 1'b0;
    stbuf_compare_match_val_s3 = stbuf_compare_match_s3[0] || stbuf_compare_match_s3[1];
    stbuf_compare_lru_match_val_s3 = stbuf_compare_lru_match_s3[0] || stbuf_compare_lru_match_s3[1];

    stbuf_way_s3 = mshr_st_way_array[stbuf_compare_threadid_s3];
    // stbuf_way_wmt_data_s3 = wmt_data_s3[stbuf_way_s3];
    // stbuf_way_to_l1_s3 = stbuf_way_wmt_data_s3[`L15_UNPARAM_1_0];
    // stbuf_l1waymap_val_s3 = stbuf_way_wmt_data_s3[2];
end

reg [`L15_UNPARAM_3_0] tagcheck_way_mask_s3;
always @ *
begin
    // expanding some signals
    tagcheck_way_mask_s3[`L15_UNPARAM_3_0] = tagcheck_way_s3 == 2'd0 ? 4'b0001 :
                                                  2'd1 ? 4'b0010 :
                                                  2'd2 ? 4'b0100 :
                                                        4'b1000 ;

    tagcheck_state_me_s3 = tagcheck_state_s3 == `L15_MESI_STATE_M || tagcheck_state_s3 == `L15_MESI_STATE_E;
    tagcheck_state_mes_s3 = tagcheck_state_s3 == `L15_MESI_STATE_M || tagcheck_state_s3 == `L15_MESI_STATE_E
                                                        || tagcheck_state_s3 == `L15_MESI_STATE_S;
    tagcheck_state_s_s3 = tagcheck_state_s3 == `L15_MESI_STATE_S;
    tagcheck_state_m_s3 = tagcheck_state_s3 == `L15_MESI_STATE_M;
    tagcheck_state_e_s3 = tagcheck_state_s3 == `L15_MESI_STATE_E;

    lru_state_m_s3 = lru_state_s3 == `L15_MESI_STATE_M;
    lru_state_mes_s3 = lru_state_s3 == `L15_MESI_STATE_M || lru_state_s3 == `L15_MESI_STATE_E
                                                        || lru_state_s3 == `L15_MESI_STATE_S;

    flush_state_m_s3 = flush_state_s3 == `L15_MESI_STATE_M;
    flush_state_mes_s3 = flush_state_s3 == `L15_MESI_STATE_M || flush_state_s3 == `L15_MESI_STATE_E
                                                        || flush_state_s3 == `L15_MESI_STATE_S;

    cache_index_s3 = address_s3[`L15_IDX_HI:`L15_IDX_LOW];
    cache_index_l1d_s3 = address_s3[`L1D_ADDRESS_HI:`L15_IDX_LOW];
    lru_way_address_s3 = {lru_way_tag_s3, cache_index_s3, 4'b0};
    flush_way_address_s3 = {flush_way_tag_s3, cache_index_s3, 4'b0};

end


always @* begin
    // next signals
    if (stall_s3)
    begin
        val_s3_next = val_s3;
        tagcheck_way_s3_next = tagcheck_way_s3;
tagcheck_state_s3_next = tagcheck_state_s3;
tagcheck_lrsc_flag_s3_next = tagcheck_lrsc_flag_s3;
flush_way_s3_next = flush_way_s3;
flush_state_s3_next = flush_state_s3;
lru_way_s3_next = lru_way_s3;
lru_state_s3_next = lru_state_s3;
mshrid_s3_next = mshrid_s3;
address_s3_next = address_s3;
threadid_s3_next = threadid_s3;
non_cacheable_s3_next = non_cacheable_s3;
size_s3_next = size_s3;
prefetch_s3_next = prefetch_s3;
l1_replacement_way_s3_next = l1_replacement_way_s3;
l2_miss_s3_next = l2_miss_s3;
f4b_s3_next = f4b_s3;
blockstore_s3_next = blockstore_s3;
blockstoreinit_s3_next = blockstoreinit_s3;
noc2_src_homeid_s3_next = noc2_src_homeid_s3;
lruarray_write_op_s3_next = lruarray_write_op_s3;
predecode_noc2_inval_s3_next = predecode_noc2_inval_s3;
predecode_fwd_subcacheline_vector_s3_next = predecode_fwd_subcacheline_vector_s3;
predecode_reqtype_s3_next = predecode_reqtype_s3;
wmt_write_op_s3_next = wmt_write_op_s3;
wmt_compare_op_s3_next = wmt_compare_op_s3;
csm_ticket_s3_next = csm_ticket_s3;
s3_mshr_operation_s3_next = s3_mshr_operation_s3;
cpx_operation_s3_next = cpx_operation_s3;
noc1_operation_s3_next = noc1_operation_s3;
noc3_operations_s3_next = noc3_operations_s3;
pcx_ack_stage_s3_next = pcx_ack_stage_s3;
noc2_ack_stage_s3_next = noc2_ack_stage_s3;
noc2_ack_state_s3_next = noc2_ack_state_s3;
lru_way_tag_s3_next = lru_way_tag_s3;
flush_way_tag_s3_next = flush_way_tag_s3;
csm_pcx_data_s3_next = csm_pcx_data_s3;

    end
    else
    begin
        val_s3_next = val_s2 && !stall_s2;
        tagcheck_way_s3_next = tagcheck_way_s2;
tagcheck_state_s3_next = tagcheck_state_s2;
tagcheck_lrsc_flag_s3_next = tagcheck_lrsc_flag_s2;
flush_way_s3_next = flush_way_s2;
flush_state_s3_next = flush_state_s2;
lru_way_s3_next = lru_way_s2;
lru_state_s3_next = lru_state_s2;
mshrid_s3_next = mshrid_s2;
address_s3_next = address_s2;
threadid_s3_next = threadid_s2;
non_cacheable_s3_next = non_cacheable_s2;
size_s3_next = size_s2;
prefetch_s3_next = prefetch_s2;
l1_replacement_way_s3_next = l1_replacement_way_s2;
l2_miss_s3_next = l2_miss_s2;
f4b_s3_next = f4b_s2;
blockstore_s3_next = blockstore_s2;
blockstoreinit_s3_next = blockstoreinit_s2;
noc2_src_homeid_s3_next = noc2_src_homeid_s2;
lruarray_write_op_s3_next = lruarray_write_op_s2;
predecode_noc2_inval_s3_next = predecode_noc2_inval_s2;
predecode_fwd_subcacheline_vector_s3_next = predecode_fwd_subcacheline_vector_s2;
predecode_reqtype_s3_next = predecode_reqtype_s2;
wmt_write_op_s3_next = wmt_write_op_s2;
wmt_compare_op_s3_next = wmt_compare_op_s2;
csm_ticket_s3_next = csm_ticket_s2;
s3_mshr_operation_s3_next = s3_mshr_operation_s2;
cpx_operation_s3_next = cpx_operation_s2;
noc1_operation_s3_next = noc1_operation_s2;
noc3_operations_s3_next = noc3_operations_s2;
pcx_ack_stage_s3_next = pcx_ack_stage_s2;
noc2_ack_stage_s3_next = noc2_ack_stage_s2;
noc2_ack_state_s3_next = noc2_ack_state_s2;
lru_way_tag_s3_next = lru_way_tag_s2;
flush_way_tag_s3_next = flush_way_tag_s2;
csm_pcx_data_s3_next = csm_pcx_data_s2;

    end
end

always @* begin
    // stale logics
    if (!cpxencoder_req_staled_s3)
        cpxencoder_req_staled_s3_next = (!stall_for_cpx_s3 && stall_for_noc3_s3) ? 1'b1 : 1'b0;
    else
        cpxencoder_req_staled_s3_next = stall_s3 ? 1'b1 : 1'b0;
end

always @* begin
    if (!noc1encoder_req_staled_s3)
        noc1encoder_req_staled_s3_next = (stall_for_cpx_s3 || stall_for_noc3_s3) ? 1'b1 : 1'b0;
    else
        noc1encoder_req_staled_s3_next = stall_s3 ? 1'b1 : 1'b0;
end

always @* begin
    if (!noc3encoder_req_staled_s3)
        noc3encoder_req_staled_s3_next = (!stall_for_noc3_s3 && stall_for_cpx_s3) ? 1'b1 : 1'b0;
    else
        noc3encoder_req_staled_s3_next = stall_s3 ? 1'b1 : 1'b0;
end

always @* begin
    //
    // Stalling logics
    // 1. s3 can stall from CPX not completing the request
    // 2. '' from NoC1 not completing the request
    // 3. '' from NoC3 not completing the request
    stall_for_cpx_s3 = !cpxencoder_req_staled_s3 && l15_cpxencoder_val && !cpxencoder_l15_req_ack;
    // stall_for_noc1_s3 = 1'b0;
    stall_for_noc3_s3 = !noc3encoder_req_staled_s3 && l15_noc3encoder_req_val && !noc3encoder_l15_req_ack;
    stall_s3 = val_s3 && (stall_for_cpx_s3 || stall_for_noc3_s3);

    // PCX/Noc2 ack logics
    pcx_ack_s3 = val_s3 && !stall_s3 && (pcx_ack_stage_s3 == `L15_ACK_STAGE_S3);
    noc2_ack_s3 = val_s3 && !stall_s3 && (noc2_ack_stage_s3 == `L15_ACK_STAGE_S3);

    // CSM logics
    l15_csm_stall_s3 = stall_s3;

    // misc
    lru_way_s3_bypassed = lru_way_s3;
end



// L1D tag table check logic
// FLOPPED INPUTS: 
//      wmt_l15_data_s3
//      l1_tagcheck_op_s3
//      lru_way_s3
//      tagcheck_way_s3
//      flush_way_s3
// CALCULATED INPUTS IN S3
//      stbuf_way_s3
// LOCAL VARIABLES
reg [`L15_WMT_DATA_MASK] wmt_compare_data_s3;
reg [`L15_WAY_MASK] wmt_compare_way_s3;
// OUTPUTS
reg [`L15_WMT_ENTRY_MASK] wmt_data_s3 [0:`L1D_WAY_COUNT-1];
reg [`L1D_WAY_COUNT-1:0] wmt_compare_mask_s3;
reg wmt_compare_match_s3;
reg [`L1D_WAY_MASK] wmt_compare_match_way_s3;

always @ *
begin
    // note: [`L15_UNPARAM_2_0] = {valid, way[2]}
    // wmt_data_s3[0] = wmt_l15_data_s3[`L15_WMT_ENTRY_0_MASK];
    // wmt_data_s3[1] = wmt_l15_data_s3[`L15_WMT_ENTRY_1_MASK];
    // wmt_data_s3[2] = wmt_l15_data_s3[`L15_WMT_ENTRY_2_MASK];
    // wmt_data_s3[3] = wmt_l15_data_s3[`L15_WMT_ENTRY_3_MASK];
    
  wmt_data_s3[0] = wmt_l15_data_s3[`L15_WMT_ENTRY_0_MASK];


  wmt_data_s3[1] = wmt_l15_data_s3[`L15_WMT_ENTRY_1_MASK];


  wmt_data_s3[2] = wmt_l15_data_s3[`L15_WMT_ENTRY_2_MASK];


  wmt_data_s3[3] = wmt_l15_data_s3[`L15_WMT_ENTRY_3_MASK];



    wmt_compare_data_s3 = 0;
    wmt_compare_way_s3 = 0;

    case (wmt_compare_op_s3)
        `L15_WMT_COMPARE_LRU:
        begin
            wmt_compare_way_s3 = lru_way_s3;
        end
        `L15_WMT_COMPARE_TAGCHECK:
        begin
            wmt_compare_way_s3 = tagcheck_way_s3;
        end
        `L15_WMT_COMPARE_FLUSH:
        begin
            wmt_compare_way_s3 = flush_way_s3;
        end
        `L15_WMT_COMPARE_STBUF:
        begin
            wmt_compare_way_s3 = stbuf_way_s3;
        end
    endcase

`ifndef L15_WMT_EXTENDED_ALIAS
    wmt_compare_data_s3 = wmt_compare_way_s3;
`else
    wmt_compare_data_s3 = {address_s3[`L15_WMT_ALIAS_MASK], wmt_compare_way_s3};
`endif

    // invalidating entries in way table due to invals, evictions, non cacheable, etc...
    // first, find the mask
    // wmt_compare_mask_s3 = 0;
    // wmt_compare_mask_s3[0] = wmt_data_s3[0][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[0][`L15_WMT_DATA_MASK]);
    // wmt_compare_mask_s3[1] = wmt_data_s3[1][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[1][`L15_WMT_DATA_MASK]);
    // wmt_compare_mask_s3[2] = wmt_data_s3[2][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[2][`L15_WMT_DATA_MASK]);
    // wmt_compare_mask_s3[3] = wmt_data_s3[3][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[3][`L15_WMT_DATA_MASK]);

    
  wmt_compare_mask_s3[0] = wmt_data_s3[0][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[0][`L15_WMT_DATA_MASK]);


  wmt_compare_mask_s3[1] = wmt_data_s3[1][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[1][`L15_WMT_DATA_MASK]);


  wmt_compare_mask_s3[2] = wmt_data_s3[2][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[2][`L15_WMT_DATA_MASK]);


  wmt_compare_mask_s3[3] = wmt_data_s3[3][`L15_WMT_VALID_MASK] && (wmt_compare_data_s3[`L15_WMT_DATA_MASK] == wmt_data_s3[3][`L15_WMT_DATA_MASK]);



    // results used for cpx invalidations
    wmt_compare_match_s3 = |wmt_compare_mask_s3;
    // wmt_compare_match_way_s3 = wmt_compare_mask_s3[0] ? 2'd0 :
                               // wmt_compare_mask_s3[1] ? 2'd1 :
                               // wmt_compare_mask_s3[2] ? 2'd2 :
                                                        // 2'd3 ;
    wmt_compare_match_way_s3 = 0;
if (wmt_compare_mask_s3[0])
   wmt_compare_match_way_s3 = 0;
else if (wmt_compare_mask_s3[1])
   wmt_compare_match_way_s3 = 1;
else if (wmt_compare_mask_s3[2])
   wmt_compare_match_way_s3 = 2;
else if (wmt_compare_mask_s3[3])
   wmt_compare_match_way_s3 = 3;

end

//////////////////////
// LRU write logic
//////////////////////
// note: lru write is moved to s3 from s2 for timing
// correctness should be the same
reg [`L15_LRUARRAY_MASK] lruarray_write_data_s3;
reg lruarray_write_val_s3;
reg [`L15_UNPARAM_3_0] lruarray_lru_mask_s3;
reg [`L15_UNPARAM_3_0] lruarray_tagcheck_mask_s3;
reg [`L15_UNPARAM_3_0] lruarray_flush_mask_s3;
reg [`L15_CACHE_INDEX_WIDTH-1:0] lruarray_write_index_s3;
always @ *
begin
    lruarray_write_data_s3 = 0;
    lruarray_write_val_s3 = 0;
    lruarray_lru_mask_s3 = lru_way_s3[`L15_UNPARAM_1_0] == 2'd0 ? 4'b0001 :
                                  lru_way_s3[`L15_UNPARAM_1_0] == 2'd1 ? 4'b0010 :
                                  lru_way_s3[`L15_UNPARAM_1_0] == 2'd2 ? 4'b0100 :
                                                                     4'b1000 ;
    lruarray_flush_mask_s3 =   flush_way_s3[`L15_UNPARAM_1_0] == 2'd0 ? 4'b0001 :
                                        flush_way_s3[`L15_UNPARAM_1_0] == 2'd1 ? 4'b0010 :
                                        flush_way_s3[`L15_UNPARAM_1_0] == 2'd2 ? 4'b0100 :
                                                                            4'b1000 ;
    lruarray_tagcheck_mask_s3 = tagcheck_way_mask_s3;

    case (lruarray_write_op_s3)
        `L15_LRU_UPDATE_ACCESS_BITS_IF_TAGCHECK_WAY_IS_MES:
        begin
            lruarray_write_val_s3 = tagcheck_state_mes_s3;
            if ((lru_data_s3[`L15_UNPARAM_3_0] | lruarray_tagcheck_mask_s3) == 4'b1111)
                lruarray_write_data_s3[`L15_UNPARAM_3_0] = 4'b0000;
            else
                lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] | lruarray_tagcheck_mask_s3;
            lruarray_write_data_s3[5:4] = lru_data_s3[5:4]; // retain old round robin
        end
        `L15_LRU_UPDATE_ACCESS_BITS_IF_TAGCHECK_WAY_LRSC_SET:
        begin
            lruarray_write_val_s3 = tagcheck_lrsc_flag_s3;
            if ((lru_data_s3[`L15_UNPARAM_3_0] | lruarray_tagcheck_mask_s3) == 4'b1111)
                lruarray_write_data_s3[`L15_UNPARAM_3_0] = 4'b0000;
            else
                lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] | lruarray_tagcheck_mask_s3;
            lruarray_write_data_s3[5:4] = lru_data_s3[5:4]; // retain old round robin
        end
        `L15_LRU_EVICTION:
        begin
            // lruarray_write_val_s3 = 1'b1; // might be an error to change here
            // lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] & ~lruarray_lru_mask_s3;
            //    // retain old access bits and remove the evicted bit
            // lruarray_write_data_s3[5:4] = lru_data_s3[5:4] + 2'b1;
        end
        `L15_LRU_REPLACEMENT:
        begin
            // lruarray_write_val_s3 = 1'b0; // no change for now, only turn on access bit on the second access
            // lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] & ~lruarray_lru_mask_s3;
            //    // retain old access bits and remove the evicted bit
            // lruarray_write_data_s3[5:4] = lru_data_s3[5:4] + 2'b1;
            lruarray_write_val_s3 = 1'b1; // no change for now, only turn on access bit on the second access
            lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] | lruarray_lru_mask_s3;
            lruarray_write_data_s3[5:4] = lru_data_s3[5:4] + 2'b1;
        end
        `L15_LRU_INVALIDATE_IF_TAGCHECK_WAY_IS_MES:
        begin
            lruarray_write_val_s3 = tagcheck_state_mes_s3;
            lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] & ~lruarray_tagcheck_mask_s3;
                // retain old access bits and remove the evicted bit
            lruarray_write_data_s3[5:4] = lru_data_s3[5:4];
        end
        `L15_LRU_INVALIDATE_IF_FLUSH_WAY_IS_MES:
        begin
            lruarray_write_val_s3 = flush_state_mes_s3;
            lruarray_write_data_s3[`L15_UNPARAM_3_0] = lru_data_s3[`L15_UNPARAM_3_0] & ~lruarray_flush_mask_s3;
                // retain old access bits and remove the evicted bit
            lruarray_write_data_s3[5:4] = lru_data_s3[5:4];
        end
    endcase
    lruarray_write_index_s3 = cache_index_s3;

    l15_lruarray_write_val_s3 = lruarray_write_val_s3 && val_s3;
    l15_lruarray_write_data_s3 = lruarray_write_data_s3;
    l15_lruarray_write_mask_s3 = 6'b111111;
    // l15_lruarray_write_mask_s3 = 6'b0;
    l15_lruarray_write_index_s3 = lruarray_write_index_s3;
end

///////////////////////
// WMT write op
///////////////////////

// FLOPPED INPUTS
// CALCULATED INPUTS IN S3
// LOCAL VARIABLES
// OUTPUTS

reg wmt_write_val_s3;
reg [`L1D_SET_IDX_MASK] wmt_write_index_s3;
reg [`L15_WMT_MASK] wmt_write_data_s3;
reg wmt_write_inval_val_s3;
reg wmt_write_update_val_s3;
reg wmt_write_dedup_l1way_val_s3;

reg [`L15_WAY_MASK] wmt_write_update_way_s3;
// reg [`L1D_WAY_MASK] wmt_write_inval_way_s3;
// reg [`L15_UNPARAM_2_0] wmt_write_dedup_l1way_s3;

reg [`L15_WMT_MASK] wmt_write_inval_mask_s3;
reg [`L15_WMT_MASK] wmt_write_update_mask_s3;
reg [`L15_WMT_MASK] wmt_write_dedup_mask_s3;
reg [`L15_WMT_MASK] wmt_write_mask_s3;

// LOCAL VARIABLES
reg [`L15_WMT_DATA_MASK] wmt_write_update_data_s3;
reg [`L15_WMT_ALIAS_WIDTH-1:0] wmt_alias_bits;

// OUTPUTS


// reg [`L15_WMT_ENTRY_MASK] wmt_data_s3 [0:`L1D_WAY_COUNT-1];
// reg [`L1D_WAY_COUNT-1:0] wmt_compare_mask_s3;
// reg wmt_compare_match_s3;
// reg [`L1D_WAY_MASK] wmt_compare_match_way_s3;
// // reg [?:0] dummy;

always @ *
begin
    wmt_write_val_s3 = 0;
    wmt_write_index_s3 = 0;

    wmt_write_inval_val_s3 = 0;
    wmt_write_update_val_s3 = 0;
    wmt_write_dedup_l1way_val_s3 = 0;

    wmt_write_update_way_s3 = 0;
    wmt_write_update_data_s3 = 0;
    // wmt_write_inval_way_s3 = 0;
    // wmt_write_dedup_l1way_s3 = 0;

    wmt_write_inval_mask_s3 = 0;
    wmt_write_update_mask_s3 = 0;
    wmt_write_dedup_mask_s3 = 0;

    case(wmt_write_op_s3)
        `L15_WMT_DEMAP_TAGCHECK_WAY_IF_MES:
        begin
            wmt_write_val_s3 = tagcheck_state_mes_s3;
            wmt_write_index_s3 = cache_index_l1d_s3[`L1D_SET_IDX_MASK];
            wmt_write_inval_val_s3 = 1'b1;
            // wmt_write_inval_way_s3 = tagcheck_way_s3;
        end
        `L15_WMT_DEMAP_LRU_WAY_IF_MES:
        begin
            wmt_write_val_s3 = lru_state_mes_s3;
            wmt_write_index_s3 = cache_index_l1d_s3[`L1D_SET_IDX_MASK];
            wmt_write_inval_val_s3 = 1'b1;
            // wmt_write_inval_way_s3 = lru_way_s3;
        end
        `L15_WMT_DEMAP_FLUSH_WAY_IF_MES:
        begin
            wmt_write_val_s3 = val_s3 && flush_state_mes_s3;
            wmt_write_index_s3 = cache_index_l1d_s3[`L1D_SET_IDX_MASK];
            wmt_write_inval_val_s3 = 1'b1;
            // wmt_write_inval_way_s3 = flush_way_s3;
        end
        `L15_WMT_UPDATE_LRU_WAY_AND_DEDUP_ENTRY: 
        begin
            wmt_write_val_s3 = 1'b1;
            wmt_write_index_s3 = cache_index_l1d_s3[`L1D_SET_IDX_MASK];
            wmt_write_update_val_s3 = 1'b1;
            wmt_write_update_way_s3 = lru_way_s3;
            wmt_write_inval_val_s3 = 1'b1;
        end
        `L15_WMT_UPDATE_TAGCHECK_WAY_AND_DEDUP_ENTRY_IF_TAGCHECK_WAY_IS_MES:
        begin
            wmt_write_val_s3 = tagcheck_state_mes_s3;
            wmt_write_index_s3 = cache_index_l1d_s3[`L1D_SET_IDX_MASK];
            wmt_write_update_val_s3 = 1'b1;
            wmt_write_update_way_s3 = tagcheck_way_s3;
            wmt_write_inval_val_s3 = 1'b1;
        end
    endcase

    // some processings

    // updating way table for filling to l1d:
    // just override l1_replacement_way_s3 with wmt_write_update_way_s3
    // wmt_write_update_mask_s3[`L15_WMT_MASK] =  (wmt_write_update_val_s3 == 1'b0) ? 12'b000_000_000_000 :
    //                                                  (l1_replacement_way_s3 == 2'd0) ? 12'b000_000_000_111 :
    //                                                  (l1_replacement_way_s3 == 2'd1) ? 12'b000_000_111_000 :
    //                                                  (l1_replacement_way_s3 == 2'd2) ? 12'b000_111_000_000 :
    //                                                                                    12'b111_000_000_000;
    wmt_write_update_mask_s3[`L15_WMT_MASK] = 0;
    if (wmt_write_update_val_s3 == 1'b1)
    begin
        // if (l1_replacement_way_s3 == 2'd0)
        //     wmt_write_update_mask_s3[`L15_WMT_ENTRY_0_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};
        // if (l1_replacement_way_s3 == 2'd1)
        //     wmt_write_update_mask_s3[`L15_WMT_ENTRY_1_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};
        // if (l1_replacement_way_s3 == 2'd2)
        //     wmt_write_update_mask_s3[`L15_WMT_ENTRY_2_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};
        // if (l1_replacement_way_s3 == 2'd3)
        //     wmt_write_update_mask_s3[`L15_WMT_ENTRY_3_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};
        
  if (l1_replacement_way_s3 == 0)
      wmt_write_update_mask_s3[`L15_WMT_ENTRY_0_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};


  if (l1_replacement_way_s3 == 1)
      wmt_write_update_mask_s3[`L15_WMT_ENTRY_1_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};


  if (l1_replacement_way_s3 == 2)
      wmt_write_update_mask_s3[`L15_WMT_ENTRY_2_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};


  if (l1_replacement_way_s3 == 3)
      wmt_write_update_mask_s3[`L15_WMT_ENTRY_3_MASK] = {`L15_WMT_ENTRY_WIDTH{1'b1}};


    end

    // wmt_write_inval_mask_s3[`L15_WMT_MASK] = (wmt_write_inval_val_s3 == 1'b0) ? 12'b000_000_000_000 :
                                                        // (wmt_write_inval_way_s3 == 2'd0) ? 12'b000_000_000_111 :
                                                        // (wmt_write_inval_way_s3 == 2'd1) ? 12'b000_000_111_000 :
                                                        // (wmt_write_inval_way_s3 == 2'd2) ? 12'b000_111_000_000 :
    //                                                                                             12'b111_000_000_000;


    // wmt_write_inval_mask_s3[`L15_WMT_MASK] = (wmt_write_inval_val_s3 == 1'b0) ? 12'b000_000_000_000 :
    //                                                     {
    //                                                      {3{wmt_compare_mask_s3[3]}},
    //                                                      {3{wmt_compare_mask_s3[2]}},
    //                                                      {3{wmt_compare_mask_s3[1]}},
    //                                                      {3{wmt_compare_mask_s3[0]}}
    //                                                      };
    wmt_write_inval_mask_s3[`L15_WMT_MASK] = 0;
    if (wmt_write_inval_val_s3 == 1'b1)
    begin
        // wmt_write_inval_mask_s3[`L15_WMT_ENTRY_0_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[0]}};
        // wmt_write_inval_mask_s3[`L15_WMT_ENTRY_1_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[1]}};
        // wmt_write_inval_mask_s3[`L15_WMT_ENTRY_2_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[2]}};
        // wmt_write_inval_mask_s3[`L15_WMT_ENTRY_3_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[3]}};
        
  wmt_write_inval_mask_s3[`L15_WMT_ENTRY_0_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[0]}};


  wmt_write_inval_mask_s3[`L15_WMT_ENTRY_1_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[1]}};


  wmt_write_inval_mask_s3[`L15_WMT_ENTRY_2_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[2]}};


  wmt_write_inval_mask_s3[`L15_WMT_ENTRY_3_MASK] = {`L15_WMT_ENTRY_WIDTH{wmt_compare_mask_s3[3]}};


    end

`ifndef L15_WMT_EXTENDED_ALIAS
    wmt_write_update_data_s3 = wmt_write_update_way_s3;
`else
    wmt_alias_bits = address_s3[`L15_WMT_ALIAS_MASK];
    wmt_write_update_data_s3 = {wmt_alias_bits,wmt_write_update_way_s3};
`endif

    // wmt_write_mask_s3[`L15_WMT_MASK] = wmt_write_inval_mask_s3 | wmt_write_update_mask_s3 | wmt_write_dedup_mask_s3;
    wmt_write_mask_s3[`L15_WMT_MASK] = wmt_write_inval_mask_s3 | wmt_write_update_mask_s3;
    wmt_write_data_s3[`L15_WMT_MASK] = {`L1D_WAY_COUNT{{1'b1,wmt_write_update_data_s3}}} & wmt_write_update_mask_s3;

    // MODULE OUTPUT
    // trin: timing fix: removing guard for wmt writes; should still be correct
    // l15_wmt_write_val_s3 = wmt_write_val_s3 && !stall_s3 && val_s3;
    l15_wmt_write_val_s3 = wmt_write_val_s3 && val_s3;
    l15_wmt_write_index_s3 = wmt_write_index_s3;
    l15_wmt_write_mask_s3 = wmt_write_mask_s3;
    l15_wmt_write_data_s3 = wmt_write_data_s3;
end





/////////////////////////////////////////////////
// S3 MSHR state update & deallocation control
/////////////////////////////////////////////////

reg lru_eviction_matched_st1_s3;
reg lru_eviction_matched_st2_s3;
reg tagcheck_matched_st1_s3;
reg tagcheck_matched_st2_s3;
reg s3_mshr_val_s3;
reg [`L15_MSHR_WRITE_TYPE_WIDTH-1:0] s3_mshr_write_type_s3;
reg [`L15_MESI_TRANS_STATE_WIDTH-1:0] s3_mshr_update_state_s3;
reg [`L15_MSHR_ID_WIDTH-1:0] s3_mshr_write_mshrid_s3;
reg [`L15_UNPARAM_1_0] s3_mshr_update_way_s3;
reg [`L15_THREADID_MASK] s3_mshr_write_threadid_s3;

always @ *
begin
    s3_mshr_val_s3 = 0;
    s3_mshr_write_type_s3 = 0;
    s3_mshr_write_mshrid_s3 = 0;
    s3_mshr_update_state_s3 = 0;
    s3_mshr_update_way_s3 = 0;
    s3_mshr_write_threadid_s3[`L15_THREADID_MASK] = threadid_s3[`L15_THREADID_MASK];

    case (s3_mshr_operation_s3)
        `L15_S3_MSHR_OP_DEALLOCATION:
        begin
            s3_mshr_val_s3 = val_s3;
            s3_mshr_write_type_s3 = `L15_MSHR_WRITE_TYPE_DEALLOCATION;
            s3_mshr_write_mshrid_s3 = mshrid_s3;
        end
        `L15_S3_MSHR_OP_DEALLOCATION_IF_TAGCHECK_MES:
        begin
            s3_mshr_val_s3 = val_s3 && tagcheck_state_mes_s3;
            s3_mshr_write_type_s3 = `L15_MSHR_WRITE_TYPE_DEALLOCATION;
            s3_mshr_write_mshrid_s3 = mshrid_s3;
        end
        `L15_S3_MSHR_OP_DEALLOCATION_IF_TAGCHECK_M_E_ELSE_UPDATE_STATE_STMSHR:
        begin
            s3_mshr_val_s3 = val_s3;
            s3_mshr_write_type_s3 = tagcheck_state_me_s3 ?  `L15_MSHR_WRITE_TYPE_DEALLOCATION :
                                                                            `L15_MSHR_WRITE_TYPE_UPDATE_ST_STATE;
            s3_mshr_write_mshrid_s3 = mshrid_s3;
            s3_mshr_update_state_s3 = tagcheck_state_mes_s3 ?
                                                    `L15_MESI_TRANSITION_STATE_SM : `L15_MESI_TRANSITION_STATE_IM;
            s3_mshr_update_way_s3 = tagcheck_way_s3;
        end
        `L15_S3_MSHR_OP_UPDATE_ST_MSHR_IM_IF_INDEX_TAGCHECK_WAY_MATCHES:
        begin
            s3_mshr_val_s3 = val_s3 && stbuf_compare_match_val_s3;
            s3_mshr_write_type_s3 = `L15_MSHR_WRITE_TYPE_UPDATE_ST_STATE;
            // s3_mshr_write_mshrid_s3 = tagcheck_matched_st1_s3 ? 4'd8 : 4'd9; // doesn't matter to update states
            s3_mshr_update_state_s3 = `L15_MESI_TRANSITION_STATE_IM;
            // s3_mshr_update_way_s3 = tagcheck_way_s3;
            s3_mshr_write_threadid_s3[`L15_THREADID_MASK] = stbuf_compare_threadid_s3[`L15_THREADID_MASK];
        end
        `L15_S3_MSHR_OP_UPDATE_ST_MSHR_IM_IF_INDEX_LRU_WAY_MATCHES:
        begin
            s3_mshr_val_s3 = val_s3 && stbuf_compare_lru_match_val_s3;
            s3_mshr_write_type_s3 = `L15_MSHR_WRITE_TYPE_UPDATE_ST_STATE;
            // s3_mshr_write_mshrid_s3 = lru_eviction_matched_st1_s3 ? 4'd8 : 4'd9; // doesn't matter to update states
            s3_mshr_update_state_s3 = `L15_MESI_TRANSITION_STATE_IM;
            s3_mshr_write_threadid_s3[`L15_THREADID_MASK] = stbuf_compare_lru_threadid_s3[`L15_THREADID_MASK];
            // s3_mshr_update_way_s3 = lru_way_s3;
        end
        `L15_S3_MSHR_OP_UPDATE_ST_MSHR_WAIT_ACK:
        begin
            s3_mshr_val_s3 = val_s3;
            s3_mshr_write_type_s3 = `L15_MSHR_WRITE_TYPE_UPDATE_ST_STATE;
            // s3_mshr_write_mshrid_s3 = lru_eviction_matched_st1_s3 ? 4'd8 : 4'd9; // doesn't matter to update states
            s3_mshr_update_state_s3 = `L15_MESI_TRANSITION_STATE_WAIT_ACK;
            // s3_mshr_write_threadid_s3[`L15_THREADID_MASK] = stbuf_compare_lru_threadid_s3[`L15_T
            // s3_mshr_update_way_s3 = lru_way_s3;
        end
    endcase

    // s3
    pipe_mshr_val_s3 = s3_mshr_val_s3;
    pipe_mshr_op_s3 = s3_mshr_write_type_s3;
    pipe_mshr_mshrid_s3 = s3_mshr_write_mshrid_s3;
    pipe_mshr_threadid_s3[`L15_THREADID_MASK] = s3_mshr_write_threadid_s3[`L15_THREADID_MASK];
    pipe_mshr_write_update_state_s3 = s3_mshr_update_state_s3;
    pipe_mshr_write_update_way_s3 = s3_mshr_update_way_s3;
end

// CPX request logic
reg cpx_req_val_s3;
reg [`CPX_RESTYPE_WIDTH-1:0] cpx_type_s3;
reg cpx_invalidate_l1_s3;
// reg cpx_dcache_inval_all_s3;
reg [`L15_UNPARAM_1_0] cpx_inval_way_s3;
reg [`L15_CPX_SOURCE_WIDTH-1:0] cpx_data_source_s3;
reg cpx_atomic_bit_s3;
reg cpx_icache_inval_s3;
always @ *
begin
    cpx_req_val_s3 = 0;
    cpx_type_s3 = 0;
    cpx_invalidate_l1_s3 = 0;
    // cpx_dcache_inval_all_s3 = 0;
    cpx_inval_way_s3 = 0;
    cpx_data_source_s3 = 0;
    cpx_atomic_bit_s3 = 0;
    cpx_icache_inval_s3 = 0;
    case(cpx_operation_s3)
        `L15_CPX_GEN_ICACHE_INVALIDATION:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_INVAL;
            cpx_icache_inval_s3 = 1;
        end
        `L15_CPX_GEN_DCACHE_INVALIDATION:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_INVAL;
            cpx_invalidate_l1_s3 = 1;
            cpx_inval_way_s3 = wmt_compare_match_way_s3;
        end
        `L15_CPX_GEN_INVALIDATION_IF_TAGCHECK_MES_AND_WAYMAP_VALID:
        begin
            cpx_req_val_s3 = tagcheck_state_mes_s3 && wmt_compare_match_s3;
            cpx_type_s3 = `CPX_RESTYPE_INVAL;
            cpx_invalidate_l1_s3 = 1;
            cpx_inval_way_s3 = wmt_compare_match_way_s3;
        end
        `L15_CPX_GEN_INVALIDATION_IF_LRU_MES_AND_WAYMAP_VALID:
        begin
            cpx_req_val_s3 = lru_state_mes_s3 && wmt_compare_match_s3;
            cpx_type_s3 = `CPX_RESTYPE_INVAL;
            cpx_invalidate_l1_s3 = 1;
            cpx_inval_way_s3 = wmt_compare_match_way_s3;
        end
        `L15_CPX_GEN_INVALIDATION_IF_FLUSH_MES_AND_WAYMAP_VALID:
        begin
            cpx_req_val_s3 = flush_state_mes_s3 && wmt_compare_match_s3;
            cpx_type_s3 = `CPX_RESTYPE_INVAL;
            cpx_invalidate_l1_s3 = 1;
            cpx_inval_way_s3 = wmt_compare_match_way_s3;
        end
        `L15_CPX_GEN_LD_RESPONSE_BOGUS_DATA:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_BOGUS;
        end
        `L15_CPX_GEN_LD_RESPONSE_BOGUS_DATA_IF_TAGCHECK_MES:
        begin
            cpx_req_val_s3 = tagcheck_state_mes_s3;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_BOGUS;
        end
        `L15_CPX_GEN_LD_RESPONSE_IF_TAGCHECK_MES_FROM_DCACHE:
        begin
            cpx_req_val_s3 = tagcheck_state_mes_s3;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_DCACHE;
        end
        `L15_CPX_GEN_LD_RESPONSE_FROM_NOC2:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_NOC2_BUFFER;
        end
        `L15_CPX_GEN_ST_ACK:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_STORE_ACK;
        end
        `L15_CPX_GEN_SC_ACK:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_ATOMIC_RES;
            cpx_data_source_s3 = `L15_CPX_SOURCE_LRSC_FLAG;
            cpx_atomic_bit_s3 = 1;
        end
        `L15_CPX_GEN_ST_ACK_WITH_POSSIBLE_INVAL:
        begin
            // gen st ack if store hits storebuffer or store req is returned
            //  so that the L1 can update its cache with the write data

            // first, the stbuffer's address must match current address
            // then, stbuffer's state must be in SM (otherwise L1.5 does not have a copy and so l1 does not)
            // third, stbuffer's L1-mapped way must be valid

            cpx_req_val_s3 = 1'b1;
            cpx_invalidate_l1_s3 = wmt_compare_match_s3 && stbuf_compare_match_val_s3;
            cpx_type_s3 = `CPX_RESTYPE_STORE_ACK;
            cpx_inval_way_s3 = wmt_compare_match_way_s3;
        end
        `L15_CPX_GEN_ST_ACK_IF_TAGCHECK_M_E_WITH_POSSIBLE_INVAL:
        begin
            cpx_req_val_s3 = tagcheck_state_me_s3;
            cpx_type_s3 = `CPX_RESTYPE_STORE_ACK;
            cpx_invalidate_l1_s3 = wmt_compare_match_s3;
            cpx_inval_way_s3 = wmt_compare_match_way_s3;
        end
        `L15_CPX_GEN_IFILL_RESPONSE_FROM_NOC2:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_IFILL1;
            cpx_data_source_s3 = `L15_CPX_SOURCE_NOC2_BUFFER;
        end
        `L15_CPX_GEN_ATOMIC_ACK_FROM_NOC2:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_ATOMIC_RES;
            cpx_data_source_s3 = `L15_CPX_SOURCE_NOC2_BUFFER;
            cpx_atomic_bit_s3 = 1;
        end
        `L15_CPX_GEN_BROADCAST_ACK:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_INTERRUPT;
            // cpx_flush_bit_s3 = 1'b1;
        end
        `L15_CPX_GEN_INTERRUPT:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_INTERRUPT;
            cpx_data_source_s3 = `L15_CPX_SOURCE_NOC2_BUFFER;
            // cpx_flush_bit_s3 = 1'b1;
        end
        `L15_CPX_GEN_LOAD_CONFIG_REG_RESPONSE:
        begin
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_CONFIG_REGS;
        end
        `L15_CPX_GEN_LD_RESPONSE_FROM_DCACHE:
        begin
            // this is for diag read to dcache
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_DCACHE;
        end
        `L15_CPX_GEN_LD_RESPONSE_FROM_CSM:
        begin
            // return diagnostic read from csm module back to the core
            cpx_req_val_s3 = 1'b1;
            cpx_type_s3 = `CPX_RESTYPE_LOAD;
            cpx_data_source_s3 = `L15_CPX_SOURCE_CSM;
        end
    endcase

    l15_cpxencoder_returntype[`L15_UNPARAM_3_0] = cpx_type_s3; //default
    l15_cpxencoder_val = val_s3 && cpx_req_val_s3 && !cpxencoder_req_staled_s3;

    l15_cpxencoder_l2miss = 0;
    l15_cpxencoder_error[`L15_UNPARAM_1_0] = 0;
    l15_cpxencoder_noncacheable = 0;
    l15_cpxencoder_threadid = 0;
    l15_cpxencoder_prefetch = 0;
    l15_cpxencoder_f4b = 0;
    l15_cpxencoder_atomic = 0;
    l15_cpxencoder_inval_icache_all_way = 0;
    l15_cpxencoder_inval_dcache_all_way = 0;
    l15_cpxencoder_inval_address_15_4[15:4] = 0;
    l15_cpxencoder_cross_invalidate = 0;
    l15_cpxencoder_cross_invalidate_way[`L15_UNPARAM_1_0] = 0;
    l15_cpxencoder_inval_dcache_inval = 0;
    l15_cpxencoder_inval_icache_inval = 0;
    l15_cpxencoder_inval_way[`L15_UNPARAM_1_0] = 0;
    l15_cpxencoder_blockinitstore = 0;
    if (cpx_operation_s3 != `L15_CPX_GEN_INTERRUPT)
    begin
        l15_cpxencoder_l2miss = l2_miss_s3;
        l15_cpxencoder_error[`L15_UNPARAM_1_0] = 2'b00; // no error feed back from L2 or L1 for now
        l15_cpxencoder_noncacheable = non_cacheable_s3;
        l15_cpxencoder_threadid = threadid_s3;
        l15_cpxencoder_prefetch = prefetch_s3;
        l15_cpxencoder_f4b = f4b_s3; // I think this is the instruction fill operation, should get from L2
        l15_cpxencoder_atomic = cpx_atomic_bit_s3;
        l15_cpxencoder_inval_icache_all_way = cpx_icache_inval_s3;
        // l15_cpxencoder_inval_dcache_all_way = cpx_dcache_inval_all_s3;
        l15_cpxencoder_inval_address_15_4[15:4] = address_s3[15:4];
        l15_cpxencoder_cross_invalidate = 0; // Don't think we will be cross invalidating
        l15_cpxencoder_cross_invalidate_way[`L15_UNPARAM_1_0] = 2'b0;
        l15_cpxencoder_inval_dcache_inval = cpx_invalidate_l1_s3; // default
        // l15_cpxencoder_inval_icache_inval = cpx_icache_inval_s3; // default
        l15_cpxencoder_inval_icache_inval = 0; // default
        l15_cpxencoder_inval_way[`L15_UNPARAM_1_0] = cpx_inval_way_s3[`L15_UNPARAM_1_0];
        l15_cpxencoder_blockinitstore = blockstore_s3 || blockstoreinit_s3;
    end

    l15_cpxencoder_data_0[`L15_UNPARAM_63_0] = 0;
    l15_cpxencoder_data_1[`L15_UNPARAM_63_0] = 0;
    l15_cpxencoder_data_2[`L15_UNPARAM_63_0] = 0;
    l15_cpxencoder_data_3[`L15_UNPARAM_63_0] = 0;
    case (cpx_data_source_s3)
        `L15_CPX_SOURCE_LRSC_FLAG:
        begin
            l15_cpxencoder_data_0[`L15_UNPARAM_63_0] = ((size_s3 == `MSG_DATA_SIZE_4B) ?
                {7'b0,(~tagcheck_lrsc_flag_s3),24'b0, 7'b0,(~tagcheck_lrsc_flag_s3),24'b0} :
                {7'b0,(~tagcheck_lrsc_flag_s3),56'b0});
            l15_cpxencoder_data_1[`L15_UNPARAM_63_0] = ((size_s3 == `MSG_DATA_SIZE_4B) ?
                {7'b0,(~tagcheck_lrsc_flag_s3),24'b0, 7'b0,(~tagcheck_lrsc_flag_s3),24'b0} :
                {7'b0,(~tagcheck_lrsc_flag_s3),56'b0}); // write 0 on success
        end
        `L15_CPX_SOURCE_DCACHE:
        begin
            l15_cpxencoder_data_0[`L15_UNPARAM_63_0] = dcache_l15_dout_s3[127:64];
            l15_cpxencoder_data_1[`L15_UNPARAM_63_0] = dcache_l15_dout_s3[`L15_UNPARAM_63_0];
        end
        `L15_CPX_SOURCE_NOC2_BUFFER:
        begin
            l15_cpxencoder_data_0[`L15_UNPARAM_63_0] = noc2decoder_l15_data_0[`L15_UNPARAM_63_0];
            l15_cpxencoder_data_1[`L15_UNPARAM_63_0] = noc2decoder_l15_data_1[`L15_UNPARAM_63_0];
            l15_cpxencoder_data_2[`L15_UNPARAM_63_0] = noc2decoder_l15_data_2[`L15_UNPARAM_63_0];
            l15_cpxencoder_data_3[`L15_UNPARAM_63_0] = noc2decoder_l15_data_3[`L15_UNPARAM_63_0];
        end
        `L15_CPX_SOURCE_CONFIG_REGS:
        begin
            l15_cpxencoder_data_0[`L15_UNPARAM_63_0] = config_l15_read_res_data_s3[`L15_UNPARAM_63_0];
        end
        `L15_CPX_SOURCE_CSM:
        begin
            l15_cpxencoder_data_0[`L15_UNPARAM_63_0] = csm_l15_res_data_s3[`L15_UNPARAM_63_0];
            l15_cpxencoder_data_1[`L15_UNPARAM_63_0] = csm_l15_res_data_s3[`L15_UNPARAM_63_0];
        end
    endcase
end

// helper block for expanding HMT entry to packet homeid for consumption in noc1 & noc3 encoder
`ifndef NO_RTL_CSM
reg [`PACKET_HOME_ID_WIDTH-1:0] expanded_hmt_homeid_s3;
always @ *
begin
    expanded_hmt_homeid_s3 = 0;
    // translater from internal smaller format to standardized packet format
    expanded_hmt_homeid_s3[`PACKET_HOME_ID_CHIP_MASK] = hmt_l15_dout_s3[`L15_CSM_GHID_CHIP_MASK];
    expanded_hmt_homeid_s3[`PACKET_HOME_ID_Y_MASK] = hmt_l15_dout_s3[`L15_CSM_GHID_YPOS_MASK];
    expanded_hmt_homeid_s3[`PACKET_HOME_ID_X_MASK] = hmt_l15_dout_s3[`L15_CSM_GHID_XPOS_MASK];
end
`endif
// NoC1 request logic
reg noc1_req_val_s3;
reg [`L15_NOC1_REQTYPE_WIDTH-1:0] noc1_type_s3;
reg [`L15_NOC1_SOURCE_WIDTH-1:0] noc1_data_source_s3;
reg noc1_homeid_not_required_s3;
reg [`L15_HOMEID_SRC_WIDTH-1:0] noc1_homeid_source_s3;
always @ *
begin
    noc1_req_val_s3 = 0;
    noc1_type_s3 = 0;
    noc1_data_source_s3 = 0;
    noc1_homeid_not_required_s3 = 0;
    creditman_noc1_mispredicted_s3 = 0;
    creditman_noc1_reserve_s3 = 0;
    l15_noc1buffer_req_address = 0;
    noc1_homeid_source_s3 = 0;
    case (noc1_operation_s3)
        `L15_NOC1_GEN_WRITEBACK_GUARD_IF_LRU_M:
        begin
            noc1_req_val_s3 = val_s3 && lru_state_m_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_WRITEBACK_GUARD;
            l15_noc1buffer_req_address = lru_way_address_s3;
            creditman_noc1_mispredicted_s3 = noc1_req_val_s3 ? 0 : val_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_HMT;
        end
        `L15_NOC1_GEN_WRITEBACK_GUARD_IF_FLUSH_M:
        begin
            noc1_req_val_s3 = val_s3 && flush_state_m_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_WRITEBACK_GUARD;
            l15_noc1buffer_req_address = flush_way_address_s3;
            creditman_noc1_mispredicted_s3 = noc1_req_val_s3 ? 0 : val_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_HMT;
        end
        `L15_NOC1_GEN_WRITEBACK_GUARD_IF_TAGCHECK_M:
        begin
            noc1_req_val_s3 = val_s3 && tagcheck_state_m_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_WRITEBACK_GUARD;
            l15_noc1buffer_req_address = address_s3;
            creditman_noc1_mispredicted_s3 = noc1_req_val_s3 ? 0 : val_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_HMT;
        end
        `L15_NOC1_GEN_DATA_LD_REQUEST:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_LD_REQUEST;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
            // creditman_noc1_reserve_s3 = val_s3; // These are actually non-cacheable/prefetch loads
        end
        `L15_NOC1_GEN_DATA_LD_REQUEST_IF_TAGCHECK_MISS:
        begin
            noc1_req_val_s3 = val_s3 && !tagcheck_state_mes_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_LD_REQUEST;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
            creditman_noc1_mispredicted_s3 = noc1_req_val_s3 ? 1'b0 : val_s3;
            creditman_noc1_reserve_s3 = noc1_req_val_s3 ? 1'b1 : 1'b0;
        end
        `L15_NOC1_GEN_INSTRUCTION_LD_REQUEST:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_IFILL_REQUEST;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_WRITETHROUGH_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_WRITETHROUGH_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_ST_UPGRADE_IF_TAGCHECK_S_ELSE_ST_FILL_IF_TAGCHECK_I:
        begin
            noc1_req_val_s3 = val_s3 && ((tagcheck_state_s3 == `L15_MESI_STATE_S) || (tagcheck_state_s3 == `L15_MESI_STATE_I));
            noc1_type_s3 = (tagcheck_state_s3 == `L15_MESI_STATE_S) ? `L15_NOC1_REQTYPE_ST_UPGRADE_REQUEST :
                                                                        `L15_NOC1_REQTYPE_ST_FILL_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
            creditman_noc1_mispredicted_s3 = noc1_req_val_s3 ? 1'b0 : val_s3;
            creditman_noc1_reserve_s3 = noc1_req_val_s3 ? 1'b1 : 1'b0;
        end
        `L15_NOC1_GEN_DATA_LR_REQUEST:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_LR_REQUEST;
            //noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_128B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
            creditman_noc1_reserve_s3 = val_s3;
        end
        `L15_NOC1_GEN_DATA_CAS_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_CAS_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_128B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_SWAP_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_SWAP_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_ADD_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_ADD_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_AND_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_AND_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_OR_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_OR_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_XOR_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_XOR_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_MAX_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_MAX_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_MAXU_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_MAXU_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_MIN_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_MIN_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_DATA_MINU_REQUEST_FROM_PCX:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_AMO_MINU_REQUEST;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            l15_noc1buffer_req_address = address_s3;
            noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
        end
        `L15_NOC1_GEN_INTERRUPT_FWD:
        begin
            noc1_req_val_s3 = val_s3;
            noc1_type_s3 = `L15_NOC1_REQTYPE_INTERRUPT_FWD;
            noc1_data_source_s3 = `L15_NOC1_SOURCE_PCX_64B;
            noc1_homeid_not_required_s3 = 1'b1;
        end
    endcase

    l15_noc1buffer_req_val = noc1_req_val_s3 && !noc1encoder_req_staled_s3;
    l15_noc1buffer_req_type = noc1_type_s3;
    l15_noc1buffer_req_threadid = threadid_s3;
    l15_noc1buffer_req_mshrid = mshrid_s3;
    l15_noc1buffer_req_non_cacheable = non_cacheable_s3;
    l15_noc1buffer_req_size = size_s3;
    l15_noc1buffer_req_prefetch = prefetch_s3;
    // l15_noc1buffer_req_blkstore = 0; // not using block stores
    // l15_noc1buffer_req_blkinitstore = 0; // not using block stores

    l15_noc1buffer_req_data_0[`L15_UNPARAM_63_0] = 0;
    l15_noc1buffer_req_data_1[`L15_UNPARAM_63_0] = 0;
    case (noc1_data_source_s3)
        `L15_NOC1_SOURCE_PCX_64B:
        begin
            l15_noc1buffer_req_data_0[`L15_UNPARAM_63_0] = pcxdecoder_l15_data[`L15_UNPARAM_63_0];
            // l15_noc1buffer_req_data_1[`L15_UNPARAM_63_0] = 64'b0;
        end
        `L15_NOC1_SOURCE_PCX_128B:
        begin
            l15_noc1buffer_req_data_0[`L15_UNPARAM_63_0] = pcxdecoder_l15_data[`L15_UNPARAM_63_0];
            l15_noc1buffer_req_data_1[`L15_UNPARAM_63_0] = pcxdecoder_l15_data_next_entry[`L15_UNPARAM_63_0];
        end
    endcase

    // output homeid info to noc1
    l15_noc1buffer_req_csm_ticket = csm_ticket_s3;

    l15_noc1buffer_req_homeid = 0;
    l15_noc1buffer_req_homeid_val = 0;

`ifdef NO_RTL_CSM
    // overrides homeid source to the static address gen in CSM module
    //  since the homeid cache/table is removed
    noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
`endif

    case (noc1_homeid_source_s3)
        `L15_HOMEID_SRC_CSM_MODULE:
        begin
            l15_noc1buffer_req_homeid = csm_l15_res_data_s3;
            l15_noc1buffer_req_homeid_val = csm_l15_res_val_s3;
        end
`ifndef NO_RTL_CSM
        `L15_HOMEID_SRC_HMT:
        begin
            l15_noc1buffer_req_homeid = expanded_hmt_homeid_s3;
            l15_noc1buffer_req_homeid_val = 1'b1;
        end
`endif
    endcase
    l15_noc1buffer_req_homeid_val = l15_noc1buffer_req_homeid_val || noc1_homeid_not_required_s3;

    l15_noc1buffer_req_csm_data = csm_pcx_data_s3; // extra information for sdid, lsid, hdid, lhid...
end


// NoC3 request logic
reg noc3_req_val_s3;
reg [`L15_NOC3_REQTYPE_WIDTH-1:0] noc3_type_s3;
reg noc3_with_data_s3;
reg [`L15_PADDR_MASK] noc3_address_s3;
reg [`L15_HOMEID_SRC_WIDTH-1:0] noc3_homeid_source_s3;
always @ *
begin
    noc3_req_val_s3 = 0;
    noc3_type_s3 = 0;
    noc3_with_data_s3 = 0;
    noc3_address_s3 = 0;
    noc3_homeid_source_s3 = 0;

    case (noc3_operations_s3)
        `L15_NOC3_GEN_WRITEBACK_IF_TAGCHECK_M_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3 && tagcheck_state_m_s3;
            noc3_type_s3 = `L15_NOC3_REQTYPE_WRITEBACK;
            noc3_with_data_s3 = 1;
            noc3_address_s3 = address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_HMT;
        end
        `L15_NOC3_GEN_WRITEBACK_IF_LRU_M_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3 && lru_state_m_s3;
            noc3_type_s3 = `L15_NOC3_REQTYPE_WRITEBACK;
            noc3_with_data_s3 = 1;
            noc3_address_s3 = lru_way_address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_HMT;
        end
        `L15_NOC3_GEN_WRITEBACK_IF_FLUSH_M_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3 && flush_state_m_s3;
            noc3_type_s3 = `L15_NOC3_REQTYPE_WRITEBACK;
            noc3_with_data_s3 = 1;
            noc3_address_s3 = flush_way_address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_HMT;
        end
        `L15_NOC3_GEN_INVAL_ACK_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3;
            noc3_type_s3 = `L15_NOC3_REQTYPE_INVAL_ACK;
            noc3_with_data_s3 = tagcheck_state_m_s3;
            noc3_address_s3 = address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_NOC2_SOURCE;
        end
        `L15_NOC3_GEN_INVAL_ACK_IF_TAGCHECK_M_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3 && (tagcheck_state_m_s3);
            noc3_type_s3 = `L15_NOC3_REQTYPE_INVAL_ACK;
            noc3_with_data_s3 = 1;
            noc3_address_s3 = address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_NOC2_SOURCE;
        end
        `L15_NOC3_GEN_DOWNGRADE_ACK_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3;
            noc3_type_s3 = `L15_NOC3_REQTYPE_DOWNGRADE_ACK;
            noc3_with_data_s3 = tagcheck_state_m_s3;
            noc3_address_s3 = address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_NOC2_SOURCE;
        end
        `L15_NOC3_GEN_DOWNGRADE_ACK_IF_TAGCHECK_M_FROM_DCACHE:
        begin
            noc3_req_val_s3 = val_s3 && (tagcheck_state_m_s3);
            noc3_type_s3 = `L15_NOC3_REQTYPE_DOWNGRADE_ACK;
            noc3_with_data_s3 = 1;
            noc3_address_s3 = address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_NOC2_SOURCE;
        end
        `L15_NOC3_GEN_ICACHE_INVAL_ACK:
        begin
            noc3_req_val_s3 = val_s3;
            noc3_type_s3 = `L15_NOC3_REQTYPE_ICACHE_INVAL_ACK;
            noc3_address_s3 = address_s3;
            noc3_homeid_source_s3 = `L15_HOMEID_SRC_NOC2_SOURCE;
        end
    endcase
    l15_noc3encoder_req_val = noc3_req_val_s3 && !noc3encoder_req_staled_s3;
    l15_noc3encoder_req_type = noc3_type_s3;
    l15_noc3encoder_req_data_0 = dcache_l15_dout_s3[127:64];
    l15_noc3encoder_req_data_1 = dcache_l15_dout_s3[`L15_UNPARAM_63_0];
    l15_noc3encoder_req_mshrid = mshrid_s3;
    l15_noc3encoder_req_sequenceid = cache_index_s3[`L15_UNPARAM_1_0];
    l15_noc3encoder_req_threadid = threadid_s3[`L15_THREADID_MASK];
    l15_noc3encoder_req_address[`L15_PADDR_MASK] = noc3_address_s3[`L15_PADDR_MASK];
    l15_noc3encoder_req_with_data = noc3_with_data_s3;
    l15_noc3encoder_req_was_inval = predecode_noc2_inval_s3;
    l15_noc3encoder_req_fwdack_vector = predecode_fwd_subcacheline_vector_s3;

    l15_noc3encoder_req_homeid = 0;
    // `ifdef NO_RTL_CSM
    //     noc1_homeid_source_s3 = `L15_HOMEID_SRC_CSM_MODULE;
    // `endif
    case (noc3_homeid_source_s3)
        `L15_HOMEID_SRC_NOC2_SOURCE:
            l15_noc3encoder_req_homeid = noc2_src_homeid_s3[`PACKET_HOME_ID_WIDTH-1:0];
        `L15_HOMEID_SRC_HMT:
            `ifdef NO_RTL_CSM
                // overrides homeid source to the static address gen (still) in CSM module
                //  since the homeid cache/table is removed
                //  csm_l15_res_data_s3 signal is shared with the write-back guard
                l15_noc3encoder_req_homeid = csm_l15_res_data_s3;
            `else
                // otherwise use the homeid table
                l15_noc3encoder_req_homeid = expanded_hmt_homeid_s3;
            `endif
    endcase
end

endmodule
