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
//  Filename      : l2_pipe2_ctrl.v
//  Created On    : 2014-04-03
//  Revision      :
//  Author        : Yaosheng Fu
//  Company       : Princeton University
//  Email         : yfu@princeton.edu
//
//  Description   : The control unit for pipeline2 in the L2 cache
//
//
//====================================================================================================


`include "l2.tmp.h"
`include "define.tmp.h"

module l2_pipe2_ctrl(

    input wire clk,
    input wire rst_n,
    `ifndef NO_RTL_CSM
    input wire csm_en,
    `endif
    //Inputs to Stage 1   

 
    input wire msg_header_valid_S1,
    input wire [`MSG_TYPE_WIDTH-1:0] msg_type_S1,
    input wire [`MSG_LENGTH_WIDTH-1:0] msg_length_S1,
    input wire [`MSG_DATA_SIZE_WIDTH-1:0] msg_data_size_S1,
    input wire [`MSG_CACHE_TYPE_WIDTH-1:0] msg_cache_type_S1,
    input wire [`MSG_LAST_SUBLINE_WIDTH-1:0] msg_last_subline_S1,
    input wire [`MSG_MESI_BITS-1:0] msg_mesi_S1,

    //input wire mshr_hit_S1,
    input wire [`MSG_TYPE_WIDTH-1:0] mshr_msg_type_S1,
    input wire [`MSG_L2_MISS_BITS-1:0] mshr_l2_miss_S1,
    input wire [`MSG_DATA_SIZE_WIDTH-1:0] mshr_data_size_S1,
    input wire [`MSG_CACHE_TYPE_WIDTH-1:0] mshr_cache_type_S1, 
    `ifndef NO_RTL_CSM
    input wire mshr_smc_miss_S1,
    `endif
    input wire [`L2_MSHR_STATE_BITS-1:0] mshr_state_out_S1,
    input wire mshr_inv_fwd_pending_S1,

    input wire [`PHY_ADDR_WIDTH-1:0] addr_S1,
    input wire is_same_address_S1,

    //Inputs to Stage 2
   
 
    input wire l2_tag_hit_S2,
    input wire [`L2_WAYS_WIDTH-1:0] l2_way_sel_S2,
    input wire l2_wb_S2,
    input wire [`L2_OWNER_BITS-1:0] l2_way_state_owner_S2,
    input wire [`L2_MESI_BITS-1:0] l2_way_state_mesi_S2,
    input wire [`L2_VD_BITS-1:0] l2_way_state_vd_S2,
    input wire [`L2_SUBLINE_BITS-1:0] l2_way_state_subline_S2,
    input wire [`L2_DI_BIT-1:0] l2_way_state_cache_type_S2,
    input wire addr_l2_aligned_S2,
    input wire subline_valid_S2,
    input wire [`MSG_LSID_WIDTH-1:0] lsid_S2,

    `ifndef NO_RTL_CSM
    input wire broadcast_counter_zero_S2,
    input wire broadcast_counter_max_S2,
    input wire [`MSG_SRC_CHIPID_WIDTH-1:0] broadcast_chipid_out_S2,
    input wire [`MSG_SRC_X_WIDTH-1:0] broadcast_x_out_S2,
    input wire [`MSG_SRC_Y_WIDTH-1:0] broadcast_y_out_S2,
    `endif

    input wire msg_data_valid_S2,
    
    input wire [`PHY_ADDR_WIDTH-1:0] addr_S2,


    //Inputs to Stage 3
    input wire [`PHY_ADDR_WIDTH-1:0] addr_S3,

    //Outputs from Stage 1

    output reg valid_S1,  
    output reg stall_S1,
    output reg active_S1, 
    output reg msg_from_mshr_S1, 
 
    output reg mshr_rd_en_S1,
    //output reg mshr_cam_en_S1,

    output reg msg_header_ready_S1,

    output reg tag_clk_en_S1,
    output reg tag_rdw_en_S1,

    output reg state_rd_en_S1,

    //Outputs from Stage 2

    output reg valid_S2,    
    output reg stall_S2,  
    output reg stall_before_S2,
    output reg active_S2, 

    output reg msg_from_mshr_S2,
    output reg [`MSG_TYPE_WIDTH-1:0] msg_type_S2,
    output reg [`MSG_DATA_SIZE_WIDTH-1:0] data_size_S2,
    output reg [`MSG_CACHE_TYPE_WIDTH-1:0] cache_type_S2,

    output reg dir_clk_en_S2,
    output reg dir_rdw_en_S2,
    output reg dir_clr_en_S2,


    output reg data_clk_en_S2,
    output wire data_rdw_en_S2,

    `ifndef NO_RTL_CSM
    output reg [`CS_OP_WIDTH-1:0] broadcast_counter_op_S2,
    output reg broadcast_counter_op_val_S2,
    `endif

    output reg state_owner_en_S2,
    output reg [`CS_OP_WIDTH-1:0] state_owner_op_S2,
    output reg state_subline_en_S2,
    output reg [`CS_OP_WIDTH-1:0] state_subline_op_S2,
    output reg state_di_en_S2,
    output reg state_vd_en_S2,
    output reg [`L2_VD_BITS-1:0] state_vd_S2,
    output reg state_mesi_en_S2,
    output reg [`L2_MESI_BITS-1:0] state_mesi_S2,
    output reg state_lru_en_S2,
    output reg [`L2_LRU_OP_BITS-1:0] state_lru_op_S2,
    output wire state_rb_en_S2,

    output reg l2_load_64B_S2, 
    output reg l2_load_32B_S2, 
    output reg [`L2_DATA_SUBLINE_WIDTH-1:0] l2_load_data_subline_S2,

    output reg msg_data_ready_S2,

    `ifndef NO_RTL_CSM
    output reg smc_wr_en_S2,
    `endif
    //Outputs from Stage 3
    output reg valid_S3,    
    output wire stall_S3,  
    output reg active_S3, 

    output reg [`MSG_TYPE_WIDTH-1:0] msg_type_S3,
    output reg mshr_wr_state_en_S3,
    output wire mshr_wr_data_en_S3,
    output reg [`L2_MSHR_STATE_BITS-1:0] mshr_state_in_S3,
    output reg mshr_inc_counter_en_S3,
    output reg state_wr_en_S3

);


// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml


localparam y = 1'b1;
localparam n = 1'b0;


localparam rd = 1'b1;
localparam wr = 1'b0;


//============================
// Stage 1
//============================

reg stall_pre_S1;
reg [`MSG_DATA_SIZE_WIDTH-1:0] data_size_S1;
reg [`MSG_CACHE_TYPE_WIDTH-1:0] cache_type_S1;
`ifndef NO_RTL_CSM
reg smc_miss_S1;
`endif
reg inv_fwd_pending_S1;

reg stall_hazard_S1;

always @ *
begin
    stall_hazard_S1 = (valid_S2 && (addr_S1[`L2_TAG_INDEX] == addr_S2[`L2_TAG_INDEX])) ||
                      (valid_S3 && (addr_S1[`L2_TAG_INDEX] == addr_S3[`L2_TAG_INDEX]));
end


always @ *
begin
    valid_S1 = msg_header_valid_S1;
end


always @ *
begin
    stall_pre_S1 = stall_S2; 
end


always @ *
begin
    mshr_rd_en_S1 = valid_S1 && (msg_type_S1 != `MSG_TYPE_WB_REQ) && (msg_type_S1 != `MSG_TYPE_STORE_MEM_ACK);
end

/*
always @ *
begin
    mshr_cam_en_S1 = valid_S1 && (msg_type_S1 == `MSG_TYPE_WB_REQ);
end
*/
always @ *
begin
    msg_from_mshr_S1 = mshr_rd_en_S1
                    && (mshr_state_out_S1 != `L2_MSHR_STATE_INVAL); 
end


always @ *
begin
    if (msg_from_mshr_S1)
    begin
        data_size_S1 = mshr_data_size_S1;
    end
    else
    begin
        data_size_S1 = msg_data_size_S1;
    end
end

always @ *
begin
    if (msg_from_mshr_S1)
    begin
        cache_type_S1 = mshr_cache_type_S1;
    end
    else
    begin
        cache_type_S1 = msg_cache_type_S1;
    end
end

always @ *
begin
    if (msg_from_mshr_S1)
    begin
        inv_fwd_pending_S1 = mshr_inv_fwd_pending_S1;
    end
    else
    begin
        inv_fwd_pending_S1 = 1'b0;
    end
end


reg [`CS_SIZE_S1-1:0] cs_S1;

always @ *
begin
    cs_S1 = {`CS_SIZE_S1{1'bx}};
    if (valid_S1)
    begin
        case (msg_type_S1)
        `MSG_TYPE_INV_FWDACK:
        begin
            //       tag_clk_en      tag_rdw_en   state_rd_en
            cs_S1 = {n,              rd,           y};
        end
        `MSG_TYPE_LOAD_FWDACK, `MSG_TYPE_STORE_FWDACK:
        begin
            cs_S1 = {n,              rd,         y};
        end
        `MSG_TYPE_LOAD_MEM_ACK, `MSG_TYPE_NC_LOAD_MEM_ACK:
        begin
            `ifndef NO_RTL_CSM
            if (smc_miss_S1)
            begin
                cs_S1 = {n,              rd,           n};
            end
            else
            `endif
            begin
                cs_S1 = {y,              wr,         n};
            end
        end
        `MSG_TYPE_STORE_MEM_ACK, `MSG_TYPE_NC_STORE_MEM_ACK:
        begin
            cs_S1 = {n,              rd,         n};
        end
        `MSG_TYPE_WB_REQ:
        begin
            cs_S1 = {y,              rd,          y};
        end
        default:
        begin
            cs_S1 = {`CS_SIZE_S1{1'bx}};
        end
        endcase
    end
    else
    begin
        cs_S1 = {`CS_SIZE_S1{1'b0}};
    end
end





always @ *
begin
    stall_S1 = valid_S1 && (stall_pre_S1 || stall_hazard_S1);
end

always @ *
begin
    msg_header_ready_S1 = !stall_S1; 
end


always @ *
begin
    tag_clk_en_S1 = valid_S1 && !stall_S1 && cs_S1[`CS_TAG_CLK_EN_S1];
end

always @ *
begin
    tag_rdw_en_S1 = valid_S1 && !stall_S1 && cs_S1[`CS_TAG_RDW_EN_S1];
end

always @ *
begin
    state_rd_en_S1 =  valid_S1 && !stall_S1 && cs_S1[`CS_STATE_RD_EN_S1];
end

`ifndef NO_RTL_CSM
always @ *
begin
    if (msg_from_mshr_S1)
    begin
        smc_miss_S1 = mshr_smc_miss_S1;
    end
    else
    begin
        smc_miss_S1 = 0;
    end
end
`endif

reg valid_next_S1;

always @ *
begin
    valid_next_S1 = valid_S1 && !stall_S1;
end

always @ *
begin
    active_S1 = valid_S1;
//             || (valid_S1 && msg_type_S1 == `MSG_TYPE_WB_REQ)
//             || (valid_S2 && msg_type_S2_f == `MSG_TYPE_WB_REQ);
end


//============================
// Stage 1 -> Stage 2
//============================

reg valid_S2_f;
reg [`MSG_LENGTH_WIDTH-1:0] msg_length_S2_f;
reg [`MSG_LAST_SUBLINE_WIDTH-1:0] msg_last_subline_S2_f;
reg [`MSG_DATA_SIZE_WIDTH-1:0] data_size_S2_f;
reg [`MSG_CACHE_TYPE_WIDTH-1:0] cache_type_S2_f;
reg msg_from_mshr_S2_f;
reg [`MSG_MESI_BITS-1:0] msg_mesi_S2_f;
`ifndef NO_RTL_CSM
reg smc_miss_S2_f;
`endif
reg [`MSG_TYPE_WIDTH-1:0] msg_type_S2_f;
reg inv_fwd_pending_S2_f;

always @ (posedge clk)
begin
    if (!rst_n)
    begin
        valid_S2_f <= 1'b0;
        msg_type_S2_f <= 0;
        msg_length_S2_f <= 0;
        msg_last_subline_S2_f <= 0;
        data_size_S2_f <= 0;  
        cache_type_S2_f <= 0; 
        msg_from_mshr_S2_f <= 1'b0;
        msg_mesi_S2_f <= 0;
        `ifndef NO_RTL_CSM
        smc_miss_S2_f <= 0;
        `endif
        inv_fwd_pending_S2_f <= 0;
    end
    else if (!stall_S2)
    begin
        valid_S2_f <= valid_next_S1;
        msg_type_S2_f <= msg_type_S1;
        msg_length_S2_f <= msg_length_S1;
        msg_last_subline_S2_f <= msg_last_subline_S1;
        data_size_S2_f <= data_size_S1;
        cache_type_S2_f <= cache_type_S1;
        msg_from_mshr_S2_f <= msg_from_mshr_S1;
        msg_mesi_S2_f <= msg_mesi_S1;
        `ifndef NO_RTL_CSM
        smc_miss_S2_f <= smc_miss_S1;
        `endif
        inv_fwd_pending_S2_f <= inv_fwd_pending_S1;
    end
end

//============================
// Stage 2
//============================

reg stall_real_S2;
reg stall_load_S2;
reg stall_before_S2_f;
reg stall_before_S2_next;
reg state_wr_en_S2;
reg mshr_wr_state_en_S2;
reg [`L2_MSHR_STATE_BITS-1:0] mshr_state_in_S2;

always @ *
begin
    valid_S2 = valid_S2_f;
    msg_type_S2 = msg_type_S2_f;
    msg_from_mshr_S2 = msg_from_mshr_S2_f;
    data_size_S2 = data_size_S2_f;
    cache_type_S2 = cache_type_S2_f;
    stall_before_S2 = stall_before_S2_f;
end

always @ *
begin
    if (!rst_n)
    begin
        stall_before_S2_next = 0;
    end
    else
    begin
        stall_before_S2_next = stall_S2;
    end
end

always @ (posedge clk)
begin
    stall_before_S2_f <= stall_before_S2_next;
end


reg is_last_subline_S2;


always @ *
begin
    is_last_subline_S2 = msg_last_subline_S2_f;
end




reg [`CS_SIZE_P2S2-1:0] cs_S2;

always @ *
begin
    if (valid_S2)
    begin
    case (msg_type_S2_f)
        `MSG_TYPE_LOAD_FWDACK:
        begin
            case (l2_way_state_mesi_S2)
            `L2_MESI_E:
            begin
                if (is_last_subline_S2)
                begin
                    `ifndef NO_RTL_CSM
                    if (csm_en)
                    begin
                        if (lsid_S2 == `L2_PUBLIC_SHARER)
                        begin
                            if (subline_valid_S2)   
                            begin
                                if (msg_length_S2_f != 0)
                                begin
                                    //       data   dir        dir         dir      state      state        state        state       state 
                                    //       clk_en clk_en     rdw_en      clr_en   owner_en   owner_op     subline_en   subline_op  di_en  
                                    cs_S2 = {y,     y,         wr,         y,        y,         `OP_CLR,     n,           `OP_CLR,    n, 
                                    //       state   state          state    state           state   state
                                    //       vd_en   vd             mesi_en  mesi            lru_en  lru
                                             y,      `L2_VD_DIRTY,  y,      `L2_MESI_B,      n,      `L2_LRU_CLR};  
                                end     
                                else
                                begin       
                                    cs_S2 = {n,     y,         wr,         y,        y,         `OP_CLR,     n,           `OP_CLR,    n, 
                                             y,      `L2_VD_DIRTY,  y,      `L2_MESI_B,      n,      `L2_LRU_CLR};  

                                end
                            end
                            else
                            begin
                                cs_S2 = {n,     n,         wr,         n,       y,         `OP_CLR,     n,           `OP_CLR,    n, 
                                         y,      `L2_VD_DIRTY,  y,      `L2_MESI_B,      n,      `L2_LRU_CLR};    
                            end
                        end
                        else
                        begin
                            if (subline_valid_S2)   
                            begin
                                if (msg_length_S2_f != 0)
                                begin
                                    //       data   dir        dir         dir      state      state        state        state       state 
                                    //       clk_en clk_en     rdw_en      clr_en   owner_en   owner_op     subline_en   subline_op  di_en  
                                    cs_S2 = {y,     y,         wr,         n,        y,         `OP_LD,     y,           `OP_LD,    n, 
                                    //       state   state          state    state           state   state
                                    //       vd_en   vd             mesi_en  mesi            lru_en  lru
                                             y,      `L2_VD_DIRTY,  y,      `L2_MESI_S,      n,      `L2_LRU_CLR};  
                                end     
                                else
                                begin       
                                    cs_S2 = {n,     y,         wr,         n,        y,         `OP_LD,     y,           `OP_LD,    n, 
                                             y,      `L2_VD_DIRTY,  y,      `L2_MESI_S,      n,      `L2_LRU_CLR};  

                                end
                            end
                            else
                            begin
                                cs_S2 = {n,     y,         wr,         n,       y,         `OP_LD,     y,           `OP_LD,    n, 
                                         y,      `L2_VD_DIRTY,  y,      `L2_MESI_S,      n,      `L2_LRU_CLR};    
                            end
                        end
                    end
                    else
                    `endif
                    begin
                        if (subline_valid_S2)   
                        begin
                            if (msg_length_S2_f != 0)
                            begin
                                //       data   dir        dir         dir      state      state        state        state       state 
                                //       clk_en clk_en     rdw_en      clr_en   owner_en   owner_op     subline_en   subline_op  di_en  
                                cs_S2 = {y,     y,         wr,         n,        y,         `OP_CLR,     n,           `OP_CLR,    n, 
                                //       state   state          state    state           state   state
                                //       vd_en   vd             mesi_en  mesi            lru_en  lru
                                         y,      `L2_VD_DIRTY,  y,      `L2_MESI_S,      n,      `L2_LRU_CLR};  
                            end     
                            else
                            begin       
                                cs_S2 = {n,     y,         wr,         n,        y,         `OP_CLR,     n,           `OP_CLR,    n, 
                                         y,      `L2_VD_DIRTY,  y,      `L2_MESI_S,      n,      `L2_LRU_CLR};  

                            end
                        end
                        else
                        begin
                            cs_S2 = {n,     y,         wr,         n,       y,         `OP_CLR,     n,           `OP_CLR,    n, 
                                     y,      `L2_VD_DIRTY,  y,      `L2_MESI_S,      n,      `L2_LRU_CLR};    
                        end

                    end
                end
                else
                begin
                    if (subline_valid_S2)   
                    begin
                        if (msg_length_S2_f != 0)
                        begin
                            cs_S2 = {y,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                                     n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
                        end
                        else
                        begin
                            cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                                     n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
                        end
                    end
                    else
                    begin
                        cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                                 n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
                    end
                end  
            end
            `L2_MESI_I:
            begin
                cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,      n,           `OP_CLR,    n,       
                         n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
            end
            default:
            begin
                cs_S2 = {`CS_SIZE_P2S2{1'bx}};
            end
            endcase
        end
        `MSG_TYPE_STORE_FWDACK:
        begin
            case (l2_way_state_mesi_S2)
            `L2_MESI_E:
            begin
                if (is_last_subline_S2)
                begin
                    if (subline_valid_S2)   
                    begin
                        if (msg_length_S2_f != 0)
                        begin
                            cs_S2 = {y,     y,         wr,         y,       y,         `OP_CLR,     y,           `OP_CLR,    n, 
                                     y,      `L2_VD_DIRTY,  y,      `L2_MESI_I,      n,      `L2_LRU_CLR};  
                        end
                        else
                        begin
                            cs_S2 = {n,     y,         wr,         y,       y,         `OP_CLR,     y,           `OP_CLR,    n, 
                                     y,      `L2_VD_DIRTY,  y,      `L2_MESI_I,      n,      `L2_LRU_CLR};  
                        end
                        
                    end
                    else
                    begin
                        cs_S2 = {n,     y,         wr,         y,       y,         `OP_CLR,     y,           `OP_CLR,    n, 
                                 y,      `L2_VD_DIRTY,  y,      `L2_MESI_I,      n,      `L2_LRU_CLR};  
                    end  
                end
                else
                begin
                    if (subline_valid_S2)   
                    begin
                        if (msg_length_S2_f != 0)
                        begin
                            cs_S2 = {y,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                                     n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
                        end
                        else
                        begin
                            cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                                     n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
                        end
                    end
                    else
                    begin
                        cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                                 n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
                    end 
                end 
            end
            `L2_MESI_I:
            begin
                cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                         n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
            end
            default:
            begin
                cs_S2 = {`CS_SIZE_P2S2{1'bx}};
            end
            endcase
        end
        `MSG_TYPE_INV_FWDACK:
        begin
            if (is_last_subline_S2)
            begin
                `ifndef NO_RTL_CSM
                if (l2_way_state_mesi_S2 == `L2_MESI_B)
                begin   
                    if (broadcast_counter_max_S2)
                    begin
                        cs_S2 = {n,     n,         rd,         n,       y,         `OP_CLR,     y,           `OP_CLR,    n, 
                                 n,      `L2_VD_ERROR,  y,      `L2_MESI_I,      n,      `L2_LRU_CLR};    
                    end
                    else
                    begin
                        cs_S2 = {n,     n,         rd,         n,       y,         `OP_SUB,     n,           `OP_CLR,    n, 
                                 n,      `L2_VD_ERROR,  n,      `L2_MESI_I, n,      `L2_LRU_CLR};    
                    end
                end
                else 
                `endif
                begin
                    `ifndef NO_RTL_CSM
                    if ((l2_way_state_owner_S2 == 1) && (~smc_miss_S2_f) && (~inv_fwd_pending_S2_f))
                    `else
                    if ((l2_way_state_owner_S2 == 1) && (~inv_fwd_pending_S2_f))
                    `endif
                    begin
                        cs_S2 = {n,     n,         rd,         n,       y,         `OP_CLR,     y,           `OP_CLR,    n, 
                                 n,      `L2_VD_ERROR,  y,      `L2_MESI_I,      n,      `L2_LRU_CLR};    
                    end
                    else
                    begin
                        cs_S2 = {n,     n,         rd,         n,       y,         `OP_SUB,     n,           `OP_CLR,    n, 
                                 n,      `L2_VD_ERROR,  n,      `L2_MESI_I, n,      `L2_LRU_CLR};    
                    end
                end
            end
            else
            begin
                cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                         n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
            end  
        end

        `MSG_TYPE_LOAD_MEM_ACK:
        begin
            cs_S2 = {y,     y,         wr,         y,       n,         `OP_CLR,     y,           `OP_CLR,    n,       
                     y,      `L2_VD_CLEAN,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
        end
        `MSG_TYPE_NC_LOAD_MEM_ACK:
        begin
            `ifndef NO_RTL_CSM
            if (smc_miss_S2_f)
            begin
                cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                         n,      `L2_VD_CLEAN,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
            end
            else
            `endif
            begin
                cs_S2 = {y,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                         y,      `L2_VD_CLEAN,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
            end
        end
        `MSG_TYPE_STORE_MEM_ACK, `MSG_TYPE_NC_STORE_MEM_ACK:
        begin
            cs_S2 = {n,     n,         rd,         n,       n,         `OP_CLR,     n,           `OP_CLR,    n,       
                     n,      `L2_VD_ERROR,  n,      `L2_MESI_I,  n,      `L2_LRU_CLR};
        end
        `MSG_TYPE_WB_REQ:
        begin
            begin
            //should be the last line
            if (l2_way_state_subline_S2 == ({{(`L2_SUBLINE_BITS-1){1'b0}}, 1'b1} << addr_S2[`L2_DATA_SUBLINE]))
            begin
                cs_S2 = {y,     y,         wr,         y,       n,         `OP_CLR,     y,        `OP_SUB,    n,       
                         y,     `L2_VD_DIRTY,  y,      `L2_MESI_I,     n,      `L2_LRU_CLR};
            end
            else
            begin
                cs_S2 = {y,     n,         rd,         n,       n,         `OP_CLR,     y,        `OP_SUB,    n,       
                         n,      `L2_VD_ERROR,  n,      `L2_MESI_I,     n,      `L2_LRU_CLR};
            end
            end
         end
        default:
        begin
            cs_S2 = {`CS_SIZE_P2S2{1'bx}};
        end
    endcase
    end
    else    
    begin
        cs_S2 = {`CS_SIZE_P2S2{1'b0}};
    end
end




`ifndef NO_RTL_CSM
always @ *
begin
    broadcast_counter_op_val_S2 = !stall_S2 && valid_S2 && is_last_subline_S2 
                               && (msg_type_S2_f == `MSG_TYPE_INV_FWDACK) && (l2_way_state_mesi_S2 == `L2_MESI_B);
end

always @ *
begin
    if (broadcast_counter_max_S2)
    begin
        broadcast_counter_op_S2 = `OP_CLR;
    end
    else
    begin
        broadcast_counter_op_S2 = `OP_ADD;
    end
end
`endif

always @ *
begin
    dir_clk_en_S2 = !stall_S2 && cs_S2[`CS_DIR_CLK_EN_P2S2];
end

always @ *
begin
    dir_rdw_en_S2 = cs_S2[`CS_DIR_RDW_EN_P2S2];
end


always @ *
begin
    dir_clr_en_S2 = cs_S2[`CS_DIR_CLR_EN_P2S2];
end

always @ *
begin
    data_clk_en_S2 = !stall_real_S2 && cs_S2[`CS_DATA_CLK_EN_P2S2];
end
/*
always @ *
begin
    data_rdw_en_S2 = wr;
end
*/
assign data_rdw_en_S2 = wr;


always @ *
begin
    if (msg_type_S2_f == `MSG_TYPE_WB_REQ || msg_type_S2_f == `MSG_TYPE_STORE_MEM_ACK)
    begin
        mshr_wr_state_en_S2 = n;
        mshr_state_in_S2 = `L2_MSHR_STATE_INVAL;
    end
    else if (msg_type_S2_f == `MSG_TYPE_INV_FWDACK 
          || msg_type_S2_f == `MSG_TYPE_LOAD_FWDACK
          || msg_type_S2_f == `MSG_TYPE_STORE_FWDACK)
    begin
        if (is_last_subline_S2)
        begin
            `ifndef NO_RTL_CSM 
            if (msg_type_S2_f == `MSG_TYPE_INV_FWDACK 
            && ((l2_way_state_owner_S2 != 1) || smc_miss_S2_f || inv_fwd_pending_S2_f))
            `else 
            if (msg_type_S2_f == `MSG_TYPE_INV_FWDACK 
            && ((l2_way_state_owner_S2 != 1) || inv_fwd_pending_S2_f))
            `endif
            begin
                mshr_wr_state_en_S2 = n;
                mshr_state_in_S2 = `L2_MSHR_STATE_INVAL;
            end
            else
            begin
                mshr_wr_state_en_S2 = !stall_S2;
                mshr_state_in_S2 = `L2_MSHR_STATE_PENDING;
            end
        end
        else
        begin
            mshr_wr_state_en_S2 = n;
            mshr_state_in_S2 = `L2_MSHR_STATE_INVAL;
        end
    end
    else
    begin
        mshr_wr_state_en_S2 = !stall_S2;
        mshr_state_in_S2 = `L2_MSHR_STATE_PENDING;
    end
end


always @ *
begin
    state_owner_en_S2 = !stall_S2 && cs_S2[`CS_STATE_OWNER_EN_P2S2];
end


always @ *
begin
    state_owner_op_S2 = cs_S2[`CS_STATE_OWNER_OP_P2S2];
end

always @ *
begin
    state_subline_en_S2 = !stall_S2 && cs_S2[`CS_STATE_SL_EN_P2S2];
end

always @ *
begin
    state_subline_op_S2 = cs_S2[`CS_STATE_SL_OP_P2S2];
end

always @ *
begin
    state_di_en_S2 = cs_S2[`CS_STATE_DI_EN_P2S2];
end

always @ *
begin
    state_vd_en_S2 = !stall_S2 && cs_S2[`CS_STATE_VD_EN_P2S2];
end

always @ *
begin
    state_vd_S2 = cs_S2[`CS_STATE_VD_P2S2];
end

always @ *
begin
    state_mesi_en_S2 = !stall_S2 && cs_S2[`CS_STATE_MESI_EN_P2S2];
end

always @ *
begin
    state_mesi_S2 = cs_S2[`CS_STATE_MESI_P2S2];
end

always @ *
begin
    state_lru_en_S2 = !stall_S2 && cs_S2[`CS_STATE_LRU_EN_P2S2];
end

always @ *
begin
    state_lru_op_S2 = cs_S2[`CS_STATE_LRU_OP_P2S2];
end

always @ *
begin
    state_wr_en_S2 = !stall_S2 && (state_owner_en_S2 || state_subline_en_S2 || state_vd_en_S2
                  ||  state_di_en_S2 || state_mesi_en_S2 || state_lru_en_S2 || state_rb_en_S2);
end


`ifndef NO_RTL_CSM
always @ *
begin
    msg_data_ready_S2 = !stall_real_S2 && (data_clk_en_S2 || smc_wr_en_S2);
end
`else
always @ *
begin
    msg_data_ready_S2 = !stall_real_S2 && (data_clk_en_S2);
end
`endif
/*
always @ *
begin
    state_rb_en_S2 = n; 
end
*/
`ifndef NO_RTL_CSM
always @ *
begin
    smc_wr_en_S2 = valid_S2 && smc_miss_S2_f && (msg_type_S2_f == `MSG_TYPE_NC_LOAD_MEM_ACK);
end
`endif


assign state_rb_en_S2 = n;

always @ *
begin
    if (msg_type_S2_f == `MSG_TYPE_LOAD_MEM_ACK)
    begin
        l2_load_64B_S2 = y;
        l2_load_32B_S2 = n;
    end
`ifdef L2_SEND_NC_REQ
    else if (msg_type_S2_f == `MSG_TYPE_NC_LOAD_MEM_ACK && msg_length_S2_f == 4)
    begin
        l2_load_64B_S2 = n;
        l2_load_32B_S2 = y;
    end
`endif
    else    
    begin
        l2_load_64B_S2 = n;
        l2_load_32B_S2 = n;
    end
end

reg [`L2_DATA_SUBLINE_WIDTH-1:0] l2_load_data_subline_S2_f;
reg [`L2_DATA_SUBLINE_WIDTH-1:0] l2_load_data_subline_S2_next;

always @ *
begin
    if (!rst_n)
    begin
        l2_load_data_subline_S2_next = `L2_DATA_SUBLINE_0;
    end
`ifdef L2_SEND_NC_REQ
    else if (valid_S2 && !stall_real_S2 && l2_load_32B_S2 && (l2_load_data_subline_S2_f == `L2_DATA_SUBLINE_1))
    begin
        l2_load_data_subline_S2_next = `L2_DATA_SUBLINE_0;
    end
    else if (valid_S2 && !stall_real_S2 && (l2_load_64B_S2 || l2_load_32B_S2))
    begin
        l2_load_data_subline_S2_next = l2_load_data_subline_S2_f + 1;
    end
`else
    else if (valid_S2 && !stall_real_S2 && l2_load_64B_S2)
    begin
        l2_load_data_subline_S2_next = l2_load_data_subline_S2_f + 1;
    end
`endif
    else
    begin
        l2_load_data_subline_S2_next = l2_load_data_subline_S2_f;
    end
end

always @ (posedge clk)
begin
    l2_load_data_subline_S2_f <= l2_load_data_subline_S2_next;
end


always @ *
begin
    if (l2_load_64B_S2)
    begin
        stall_load_S2 = (l2_load_data_subline_S2_f != `L2_DATA_SUBLINE_3);
    end
`ifdef L2_SEND_NC_REQ
    else if (l2_load_32B_S2)
    begin
        stall_load_S2 = (l2_load_data_subline_S2_f != `L2_DATA_SUBLINE_1);
    end
`endif
    else
    begin
        stall_load_S2 = n;
    end
end


always @ *
begin
    l2_load_data_subline_S2 = l2_load_data_subline_S2_f;
end

`ifndef NO_RTL_CSM
always @ *
begin
    stall_real_S2 = valid_S2 && ((cs_S2[`CS_DATA_CLK_EN_P2S2] || smc_wr_en_S2) && !msg_data_valid_S2);
end
`else
always @ *
begin
    stall_real_S2 = valid_S2 && ((cs_S2[`CS_DATA_CLK_EN_P2S2]) && !msg_data_valid_S2);
end
`endif
always @ *
begin
    stall_S2 = valid_S2 && (stall_real_S2 || stall_load_S2);
end




always @ *
begin
    active_S2 = valid_S2;
end

reg valid_next_S2;

always @ *
begin
    valid_next_S2 = valid_S2 && !stall_S2;
end


//============================
// Stage 2 -> Stage 3
//============================

reg valid_S3_f;
reg state_wr_en_S3_f;
reg mshr_wr_state_en_S3_f;
reg [`L2_MSHR_STATE_BITS-1:0] mshr_state_in_S3_f;
`ifndef NO_RTL_CSM
reg smc_miss_S3_f;
`endif
reg msg_from_mshr_S3_f;
reg [`MSG_TYPE_WIDTH-1:0] msg_type_S3_f;

always @ (posedge clk)
begin
    if (!rst_n)
    begin
        valid_S3_f <= 1'b0;
        state_wr_en_S3_f <= 1'b0;
        mshr_wr_state_en_S3_f <= 0;
        mshr_state_in_S3_f <= 0;
        `ifndef NO_RTL_CSM
        smc_miss_S3_f <= 0;
        `endif
        msg_from_mshr_S3_f <= 0;
        msg_type_S3_f <= 0;
    end
    else if (!stall_S3)
    begin
        valid_S3_f <= valid_next_S2;
        state_wr_en_S3_f <= state_wr_en_S2;
        mshr_wr_state_en_S3_f <= mshr_wr_state_en_S2;
        mshr_state_in_S3_f <= mshr_state_in_S2;
        `ifndef NO_RTL_CSM
        smc_miss_S3_f <= smc_miss_S2_f;
        `endif
        msg_from_mshr_S3_f <= msg_from_mshr_S2_f;
        msg_type_S3_f <= msg_type_S2_f;
    end
end

//============================
// Stage 3
//============================



always @ *
begin
    valid_S3 = valid_S3_f;
    state_wr_en_S3 = !stall_S3 && valid_S3 && state_wr_en_S3_f;
    mshr_wr_state_en_S3 = !stall_S3 && valid_S3 && mshr_wr_state_en_S3_f;
    mshr_state_in_S3 = mshr_state_in_S3_f;
    msg_type_S3 = msg_type_S3_f;
end

assign mshr_wr_data_en_S3 = 1'b0;


always @ *
begin
    mshr_inc_counter_en_S3 = valid_S3 && (msg_type_S3_f == `MSG_TYPE_INV_FWDACK);
end

always @ *
begin
    active_S3 = valid_S3;
end

assign stall_S3 = 1'b0;

/*
//============================
// Debug
//============================

`ifndef SYNTHESIS


wire [15*8-1:0] msg_type_string_S1;
wire [15*8-1:0] msg_type_string_S2;

l2_msg_type_parse msg_type_parse_S1(
    .msg_type (msg_type_S1),
    .msg_type_string (msg_type_string_S1)
);

always @ (posedge clk)
begin
    if (valid_S1 && !stall_S1)
    begin
        $display("-------------------------------------");
        $display($time);
        $display("P2S1 msg type: %s, data_size: %b, cache_type: %b, last_subline: %b", msg_type_string_S1, data_size_S1, cache_type_S1, msg_last_subline_S1);
        $display("P2S1 valid: stall: %b, stall_pre: %b, stall_hazard: %b",
                  stall_S1, stall_pre_S1, stall_hazard_S1);
        $display("Control signals: %b", cs_S1);
        $display("Msg from mshr: %b", msg_from_mshr_S1);
    end
end


l2_msg_type_parse msg_type_parse_S2(
    .msg_type (msg_type_S2_f),
    .msg_type_string (msg_type_string_S2)
);

always @ (posedge clk)
begin
    if (valid_S2 && !stall_S2)
    begin
        $display("-------------------------------------");
        $display($time);
        $display("P2S2 msg type: %s, data_size: %b, cache_type: %b, last_subline: %b", msg_type_string_S2, data_size_S2_f, cache_type_S2_f,msg_last_subline_S2_f);
        $display("P2S2 valid: stall: %b, stall_real: %b, stall_load: %b",
                  stall_S2, stall_real_S2,stall_load_S2);
        $display("Control signals: %b", cs_S2);
        $display("Msg from mshr: %b", msg_from_mshr_S2);
    end
end




`endif
*/
endmodule
