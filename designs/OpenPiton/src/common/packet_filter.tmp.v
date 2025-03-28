// Copyright (c) 2018 Princeton University
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

module packet_filter (
    input wire clk,
    input wire rst_n,

    // noc2 to filter wires
    input wire                          noc2_filter_val,
    input wire [`NOC_DATA_WIDTH - 1:0]  noc2_filter_data,
    output reg                         filter_noc2_rdy,

    // filter to noc3 wires
    output wire                         filter_noc3_val,
    output wire [`NOC_DATA_WIDTH - 1:0] filter_noc3_data,
    input wire                          noc3_filter_rdy,

    // filter to xbar wires
    output reg                         filter_xbar_val,
    output reg [`NOC_DATA_WIDTH - 1:0] filter_xbar_data,
    input wire                          xbar_filter_rdy,

    // xbar to filter wires
    input wire                          xbar_filter_val,
    input wire  [`NOC_DATA_WIDTH - 1:0] xbar_filter_data,
    output wire                         filter_xbar_rdy,

    // uart_dmw stuff
    input wire                          uart_boot_en,

    // asserted if we get a packet with an invalid address
    output wire                         invalid_access_o
);
// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml

    localparam IDLE = 3'b000;
    localparam ONLYHEADERFLIT = 3'b001;
    localparam ONEFLIT = 3'b010;
    localparam TWOFLITS = 3'b011;
    localparam SENDING = 3'b100;
    localparam DRAINTWO = 3'b101;
    localparam DRAINONE = 3'b110;

    reg [`NOC_DATA_WIDTH-1:0] flit_buffer_0_reg;
    reg [`NOC_DATA_WIDTH-1:0] flit_buffer_1_reg;
    reg [`NOC_DATA_WIDTH-1:0] flit_buffer_0_next;
    reg [`NOC_DATA_WIDTH-1:0] flit_buffer_1_next;
    reg [`NOC_DATA_WIDTH-1:0] readdressed_flit0;

    reg [`MSG_LENGTH_WIDTH-1:0] num_flits_reg; // total number of flits in packet
    reg [`MSG_LENGTH_WIDTH-1:0] num_flits_next; // total number of flits in packet
    reg [`MSG_LENGTH_WIDTH-1:0] flits_sent_reg; // number of flits sent to xbar
    reg [`MSG_LENGTH_WIDTH-1:0] flits_sent_next; // number of flits sent to xbar

    reg [2:0] state_reg;
    reg [2:0] state_next;

    reg invalid_access, invalid_access_d, invalid_access_q;

    always @* begin
		    invalid_access_d = invalid_access_q;
        case (state_reg)
        IDLE: begin
            filter_xbar_val = 1'b0;
            filter_xbar_data = `NOC_DATA_WIDTH'b0;
            filter_noc2_rdy = 1'b1;
            flit_buffer_0_next = noc2_filter_val ? noc2_filter_data : `NOC_DATA_WIDTH'b0;
            flit_buffer_1_next = `NOC_DATA_WIDTH'b0;
            num_flits_next = noc2_filter_val ? noc2_filter_data[`MSG_LENGTH] : `MSG_LENGTH_WIDTH'b0;
            flits_sent_next = `MSG_LENGTH_WIDTH'b0;

            // If new packet is a one flit packet, try to send it now
            if (noc2_filter_val & (noc2_filter_data[`MSG_LENGTH] == `MSG_LENGTH_WIDTH'b0)) begin
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;

                state_next = xbar_filter_rdy ? IDLE : ONLYHEADERFLIT;
            end
            else begin
                state_next = noc2_filter_val ? ONEFLIT : IDLE;
            end
        end
        ONLYHEADERFLIT: begin
            if (xbar_filter_rdy) begin
                // If we can output this single flit, then this state acts like IDLE
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b1;
                flit_buffer_0_next = noc2_filter_val ? noc2_filter_data : `NOC_DATA_WIDTH'b0;
                flit_buffer_1_next = `NOC_DATA_WIDTH'b0;
                num_flits_next = noc2_filter_val ? noc2_filter_data[`MSG_LENGTH] : `MSG_LENGTH_WIDTH'b0;
                flits_sent_next = `MSG_LENGTH_WIDTH'b0;

                // If new packet is a one flit packet, try to send it now
                if (noc2_filter_val & (noc2_filter_data[`MSG_LENGTH] == `MSG_LENGTH_WIDTH'b0)) begin
                    filter_xbar_val = 1'b1;
                    filter_xbar_data = flit_buffer_0_reg;

                    state_next = xbar_filter_rdy ? IDLE : ONLYHEADERFLIT;
                end
                else begin
                    state_next = noc2_filter_val ? ONEFLIT : IDLE;
                end
            end else begin
                // Otherwise we just store the flit and wait for xbar_filter_rdy
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = flit_buffer_0_reg;
                flit_buffer_1_next = `NOC_DATA_WIDTH'b0;
                num_flits_next = num_flits_reg;
                flits_sent_next = `MSG_LENGTH_WIDTH'b0;

                state_next = ONLYHEADERFLIT;
            end
        end
        ONEFLIT: begin
            filter_xbar_val = 1'b0;
            filter_xbar_data = `NOC_DATA_WIDTH'b0;
            filter_noc2_rdy = 1'b1;
            flit_buffer_0_next = noc2_filter_val ? readdressed_flit0 : flit_buffer_0_reg;
            flit_buffer_1_next = noc2_filter_val ? noc2_filter_data : `NOC_DATA_WIDTH'b0;
            num_flits_next = num_flits_reg;
            flits_sent_next = `MSG_LENGTH_WIDTH'b0;

            state_next = noc2_filter_val ? TWOFLITS : ONEFLIT;

		        invalid_access_d = invalid_access_q | (noc2_filter_val & invalid_access);
		end
        TWOFLITS: begin
            if ((num_flits_reg == `MSG_LENGTH_WIDTH'd1)) begin
                if (xbar_filter_rdy) begin
                    filter_xbar_val = 1'b1;
                    filter_xbar_data = flit_buffer_0_reg;
                    filter_noc2_rdy = 1'b0;
                    flit_buffer_0_next = flit_buffer_1_reg;
                    flit_buffer_1_next = noc2_filter_data;
                    num_flits_next = num_flits_reg;
                    flits_sent_next = `MSG_LENGTH_WIDTH'b1;

                    state_next = DRAINONE;
                end
                else begin
                    filter_xbar_val = 1'b1;
                    filter_xbar_data = flit_buffer_0_reg;
                    filter_noc2_rdy = 1'b0;
                    flit_buffer_0_next = flit_buffer_0_reg;
                    flit_buffer_1_next = flit_buffer_1_reg;
                    num_flits_next = num_flits_reg;
                    flits_sent_next = `MSG_LENGTH_WIDTH'b0;

                    state_next = TWOFLITS;
                end
            end
            else if (xbar_filter_rdy & noc2_filter_val) begin
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b1;
                flit_buffer_0_next = flit_buffer_1_reg;
                flit_buffer_1_next = noc2_filter_data;
                num_flits_next = num_flits_reg;
                flits_sent_next = `MSG_LENGTH_WIDTH'b1;

                state_next = (num_flits_reg == `MSG_LENGTH_WIDTH'd2) ? DRAINTWO : SENDING;
            end
            else begin
                filter_xbar_val = 1'b0;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = flit_buffer_0_reg;
                flit_buffer_1_next = flit_buffer_1_reg;
                num_flits_next = num_flits_reg;
                flits_sent_next = `MSG_LENGTH_WIDTH'b0;

                state_next = TWOFLITS;
            end
        end
        SENDING: begin
            if (xbar_filter_rdy & noc2_filter_val & (flits_sent_reg < (num_flits_reg + 1'b1))) begin
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b1;
                flit_buffer_0_next = flit_buffer_1_reg;
                flit_buffer_1_next = noc2_filter_data;
                num_flits_next = num_flits_reg;
                flits_sent_next = flits_sent_reg + 1'b1; // TODO: This overflows if you send max # of flits because we count the header too

                // If we just took in the last flit of the packet, go to draining states
                state_next = (flits_sent_reg == (num_flits_reg - 2'd2)) ? DRAINTWO : SENDING;
            end else begin
                filter_xbar_val = 1'b0;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = flit_buffer_0_reg;
                flit_buffer_1_next = flit_buffer_1_reg;
                num_flits_next = num_flits_reg;
                flits_sent_next = flits_sent_reg;

                state_next = SENDING;
            end
        end
        DRAINTWO: begin
            if (xbar_filter_rdy) begin
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = flit_buffer_1_reg;
                flit_buffer_1_next = `NOC_DATA_WIDTH'b0;
                num_flits_next = num_flits_reg;
                flits_sent_next = flits_sent_reg + 1'b1; // TODO: This overflows if you send max # of flits because we count the header too

                state_next = DRAINONE;
            end else begin
                filter_xbar_val = 1'b0;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = flit_buffer_0_reg;
                flit_buffer_1_next = flit_buffer_1_reg;
                num_flits_next = num_flits_reg;
                flits_sent_next = flits_sent_reg;

                state_next = DRAINTWO;
            end
        end
        DRAINONE: begin
            if (xbar_filter_rdy) begin
                filter_xbar_val = 1'b1;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = `NOC_DATA_WIDTH'b0;
                flit_buffer_1_next = `NOC_DATA_WIDTH'b0;
                num_flits_next = `MSG_LENGTH_WIDTH'b0;
                flits_sent_next = `MSG_LENGTH_WIDTH'b0; // TODO: This overflows if you send max # of flits because we count the header too

                state_next = IDLE;
            end else begin
                filter_xbar_val = 1'b0;
                filter_xbar_data = flit_buffer_0_reg;
                filter_noc2_rdy = 1'b0;
                flit_buffer_0_next = flit_buffer_0_reg;
                flit_buffer_1_next = flit_buffer_1_reg;
                num_flits_next = num_flits_reg;
                flits_sent_next = flits_sent_reg;

                state_next = DRAINONE;
            end
        end
        default: begin
            filter_xbar_val = 1'bX;
            filter_xbar_data = `NOC_DATA_WIDTH'bX;
            filter_noc2_rdy = 1'bX;
            flit_buffer_0_next = `NOC_DATA_WIDTH'bX;
            flit_buffer_1_next = `NOC_DATA_WIDTH'bX;
            num_flits_next = `MSG_LENGTH_WIDTH'bX;
            flits_sent_next = `MSG_LENGTH_WIDTH'bX;

            state_next = 3'bX;
        end
        endcase
    end

    always @* begin
        readdressed_flit0 = flit_buffer_0_reg;
        invalid_access  = 1'b0;
        if (flit_buffer_0_reg[`MSG_TYPE] == `MSG_TYPE_LOAD_MEM ||
            flit_buffer_0_reg[`MSG_TYPE] == `MSG_TYPE_STORE_MEM ||
            flit_buffer_0_reg[`MSG_TYPE] == `MSG_TYPE_NC_LOAD_REQ ||
            flit_buffer_0_reg[`MSG_TYPE] == `MSG_TYPE_NC_STORE_REQ) begin

                if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'h9f00000000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'h9f00000000 + `PHY_ADDR_WIDTH'h10) & (~uart_boot_en))
                begin
                    readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h2;
                end

                else if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'hfff0c2c000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'hfff0c2c000 + `PHY_ADDR_WIDTH'hd4000) & (~uart_boot_en))
                begin
                    readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h3;
                end

                else if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'hfff1000000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'hfff1000000 + `PHY_ADDR_WIDTH'h1000) & (~uart_boot_en))
                begin
                    readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h4;
                end

                else if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'hfff1010000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'hfff1010000 + `PHY_ADDR_WIDTH'h10000) & (~uart_boot_en))
                begin
                    readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h5;
                end

                else if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'hfff1020000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'hfff1020000 + `PHY_ADDR_WIDTH'hc0000) & (~uart_boot_en))
                begin
                    readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h6;
                end

                else if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'hfff1100000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'hfff1100000 + `PHY_ADDR_WIDTH'h4000000) & (~uart_boot_en))
                begin
                    readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h7;
                end

                else begin
`ifdef MONITOR_INVALID_ACCESSES
                    // route everything else to the memory when uart_boot_en is asserted
                    if ((noc2_filter_data[`MSG_ADDR_] >= `PHY_ADDR_WIDTH'h80000000 && noc2_filter_data[`MSG_ADDR_] < `PHY_ADDR_WIDTH'h80000000 + `PHY_ADDR_WIDTH'h40000000) ||  (uart_boot_en)) begin
                        readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h1;
                    end else begin
                        invalid_access = 1'b1;
                    end
`else // MONITOR_INVALID_ACCESSES
                  // route everything else to the memory in simulation
                  readdressed_flit0[`MSG_DST_X] = `NOC_X_WIDTH'h1;
`endif // MONITOR_INVALID_ACCESSES
                end


        end
    end

    assign invalid_access_o = invalid_access_q;

    always @(posedge clk) begin
        if (!rst_n) begin
            invalid_access_q  <= 1'b0;
            flit_buffer_0_reg <= `NOC_DATA_WIDTH'd0;
            flit_buffer_1_reg <= `NOC_DATA_WIDTH'd0;
            num_flits_reg     <= `MSG_LENGTH_WIDTH'd0;
            flits_sent_reg    <= `MSG_LENGTH_WIDTH'd0;
            state_reg         <= IDLE;
        end
        else
        begin
      			invalid_access_q  <= invalid_access_d;
			      flit_buffer_0_reg <= flit_buffer_0_next;
            flit_buffer_1_reg <= flit_buffer_1_next;
            num_flits_reg     <= num_flits_next;
            flits_sent_reg    <= flits_sent_next;
            state_reg         <= state_next;

`ifndef PITON_FPGA_SYNTH
`ifdef MONITOR_INVALID_ACCESSES
            if (invalid_access_d) begin
              $fatal(1,"Access to invalid address in packet filter: 0x%016X", noc2_filter_data[`MSG_ADDR_]);
            end
`endif
`endif
        end
    end

    // response logic for noc3
    // no modifications are needed for response packets,so just connecting
    // the wires together
    assign filter_xbar_rdy = noc3_filter_rdy;
    assign filter_noc3_val = xbar_filter_val;
    assign filter_noc3_data = xbar_filter_data;



endmodule
