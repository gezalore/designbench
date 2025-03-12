// Modified by Princeton University on June 9th, 2015
// ========== Copyright Header Begin ==========================================
//
// OpenSPARC T1 Processor File: ciop_iob.v
// Copyright (c) 2006 Sun Microsystems, Inc.  All Rights Reserved.
// DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
//
// The above named program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License version 2 as published by the Free Software Foundation.
//
// The above named program is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public
// License along with this work; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
//
// ========== Copyright Header End ============================================
`timescale 1ps/1ps
`include "define.tmp.h"
`include "cross_module.tmp.h"

// /home/gl/work/openpiton/piton/verif/env/manycore/devices_ariane.xml


module ciop_fake_iob(
    input clk,
    input rst_n,

    output reg noc_out_val,
    input noc_out_rdy,
    output reg [`NOC_DATA_WIDTH-1:0] noc_out_data
,
   input                spc0_inst_done,
   input [63:0]         pc_w0

,
   input                spc1_inst_done,
   input [63:0]         pc_w1

,
   input                spc2_inst_done,
   input [63:0]         pc_w2

,
   input                spc3_inst_done,
   input [63:0]         pc_w3

,
   input                spc4_inst_done,
   input [63:0]         pc_w4

,
   input                spc5_inst_done,
   input [63:0]         pc_w5

,
   input                spc6_inst_done,
   input [63:0]         pc_w6

,
   input                spc7_inst_done,
   input [63:0]         pc_w7

,
   input                spc8_inst_done,
   input [63:0]         pc_w8

,
   input                spc9_inst_done,
   input [63:0]         pc_w9

,
   input                spc10_inst_done,
   input [63:0]         pc_w10

,
   input                spc11_inst_done,
   input [63:0]         pc_w11

,
   input                spc12_inst_done,
   input [63:0]         pc_w12

,
   input                spc13_inst_done,
   input [63:0]         pc_w13

,
   input                spc14_inst_done,
   input [63:0]         pc_w14

,
   input                spc15_inst_done,
   input [63:0]         pc_w15

,
   input                spc16_inst_done,
   input [63:0]         pc_w16

,
   input                spc17_inst_done,
   input [63:0]         pc_w17

,
   input                spc18_inst_done,
   input [63:0]         pc_w18

,
   input                spc19_inst_done,
   input [63:0]         pc_w19

,
   input                spc20_inst_done,
   input [63:0]         pc_w20

,
   input                spc21_inst_done,
   input [63:0]         pc_w21

,
   input                spc22_inst_done,
   input [63:0]         pc_w22

,
   input                spc23_inst_done,
   input [63:0]         pc_w23

,
   input                spc24_inst_done,
   input [63:0]         pc_w24

,
   input                spc25_inst_done,
   input [63:0]         pc_w25

,
   input                spc26_inst_done,
   input [63:0]         pc_w26

,
   input                spc27_inst_done,
   input [63:0]         pc_w27

,
   input                spc28_inst_done,
   input [63:0]         pc_w28

,
   input                spc29_inst_done,
   input [63:0]         pc_w29

,
   input                spc30_inst_done,
   input [63:0]         pc_w30

,
   input                spc31_inst_done,
   input [63:0]         pc_w31

,
   input                spc32_inst_done,
   input [63:0]         pc_w32

,
   input                spc33_inst_done,
   input [63:0]         pc_w33

,
   input                spc34_inst_done,
   input [63:0]         pc_w34

,
   input                spc35_inst_done,
   input [63:0]         pc_w35

,
   input                spc36_inst_done,
   input [63:0]         pc_w36

,
   input                spc37_inst_done,
   input [63:0]         pc_w37

,
   input                spc38_inst_done,
   input [63:0]         pc_w38

,
   input                spc39_inst_done,
   input [63:0]         pc_w39

,
   input                spc40_inst_done,
   input [63:0]         pc_w40

,
   input                spc41_inst_done,
   input [63:0]         pc_w41

,
   input                spc42_inst_done,
   input [63:0]         pc_w42

,
   input                spc43_inst_done,
   input [63:0]         pc_w43

,
   input                spc44_inst_done,
   input [63:0]         pc_w44

,
   input                spc45_inst_done,
   input [63:0]         pc_w45

,
   input                spc46_inst_done,
   input [63:0]         pc_w46

,
   input                spc47_inst_done,
   input [63:0]         pc_w47

,
   input                spc48_inst_done,
   input [63:0]         pc_w48

,
   input                spc49_inst_done,
   input [63:0]         pc_w49

,
   input                spc50_inst_done,
   input [63:0]         pc_w50

,
   input                spc51_inst_done,
   input [63:0]         pc_w51

,
   input                spc52_inst_done,
   input [63:0]         pc_w52

,
   input                spc53_inst_done,
   input [63:0]         pc_w53

,
   input                spc54_inst_done,
   input [63:0]         pc_w54

,
   input                spc55_inst_done,
   input [63:0]         pc_w55

,
   input                spc56_inst_done,
   input [63:0]         pc_w56

,
   input                spc57_inst_done,
   input [63:0]         pc_w57

,
   input                spc58_inst_done,
   input [63:0]         pc_w58

,
   input                spc59_inst_done,
   input [63:0]         pc_w59

,
   input                spc60_inst_done,
   input [63:0]         pc_w60

,
   input                spc61_inst_done,
   input [63:0]         pc_w61

,
   input                spc62_inst_done,
   input [63:0]         pc_w62

,
   input                spc63_inst_done,
   input [63:0]         pc_w63

,
   input                spc64_inst_done,
   input [63:0]         pc_w64

,
   input                spc65_inst_done,
   input [63:0]         pc_w65

,
   input                spc66_inst_done,
   input [63:0]         pc_w66

,
   input                spc67_inst_done,
   input [63:0]         pc_w67

,
   input                spc68_inst_done,
   input [63:0]         pc_w68

,
   input                spc69_inst_done,
   input [63:0]         pc_w69

,
   input                spc70_inst_done,
   input [63:0]         pc_w70

,
   input                spc71_inst_done,
   input [63:0]         pc_w71

,
   input                spc72_inst_done,
   input [63:0]         pc_w72

,
   input                spc73_inst_done,
   input [63:0]         pc_w73

,
   input                spc74_inst_done,
   input [63:0]         pc_w74

,
   input                spc75_inst_done,
   input [63:0]         pc_w75

,
   input                spc76_inst_done,
   input [63:0]         pc_w76

,
   input                spc77_inst_done,
   input [63:0]         pc_w77

,
   input                spc78_inst_done,
   input [63:0]         pc_w78

,
   input                spc79_inst_done,
   input [63:0]         pc_w79

,
   input                spc80_inst_done,
   input [63:0]         pc_w80

,
   input                spc81_inst_done,
   input [63:0]         pc_w81

,
   input                spc82_inst_done,
   input [63:0]         pc_w82

,
   input                spc83_inst_done,
   input [63:0]         pc_w83

,
   input                spc84_inst_done,
   input [63:0]         pc_w84

,
   input                spc85_inst_done,
   input [63:0]         pc_w85

,
   input                spc86_inst_done,
   input [63:0]         pc_w86

,
   input                spc87_inst_done,
   input [63:0]         pc_w87

,
   input                spc88_inst_done,
   input [63:0]         pc_w88

,
   input                spc89_inst_done,
   input [63:0]         pc_w89

,
   input                spc90_inst_done,
   input [63:0]         pc_w90

,
   input                spc91_inst_done,
   input [63:0]         pc_w91

,
   input                spc92_inst_done,
   input [63:0]         pc_w92

,
   input                spc93_inst_done,
   input [63:0]         pc_w93

,
   input                spc94_inst_done,
   input [63:0]         pc_w94

,
   input                spc95_inst_done,
   input [63:0]         pc_w95

,
   input                spc96_inst_done,
   input [63:0]         pc_w96

,
   input                spc97_inst_done,
   input [63:0]         pc_w97

,
   input                spc98_inst_done,
   input [63:0]         pc_w98

,
   input                spc99_inst_done,
   input [63:0]         pc_w99

,
   input                spc100_inst_done,
   input [63:0]         pc_w100

,
   input                spc101_inst_done,
   input [63:0]         pc_w101

,
   input                spc102_inst_done,
   input [63:0]         pc_w102

,
   input                spc103_inst_done,
   input [63:0]         pc_w103

,
   input                spc104_inst_done,
   input [63:0]         pc_w104

,
   input                spc105_inst_done,
   input [63:0]         pc_w105

,
   input                spc106_inst_done,
   input [63:0]         pc_w106

,
   input                spc107_inst_done,
   input [63:0]         pc_w107

,
   input                spc108_inst_done,
   input [63:0]         pc_w108

,
   input                spc109_inst_done,
   input [63:0]         pc_w109

,
   input                spc110_inst_done,
   input [63:0]         pc_w110

,
   input                spc111_inst_done,
   input [63:0]         pc_w111

,
   input                spc112_inst_done,
   input [63:0]         pc_w112

,
   input                spc113_inst_done,
   input [63:0]         pc_w113

,
   input                spc114_inst_done,
   input [63:0]         pc_w114

,
   input                spc115_inst_done,
   input [63:0]         pc_w115

,
   input                spc116_inst_done,
   input [63:0]         pc_w116

,
   input                spc117_inst_done,
   input [63:0]         pc_w117

,
   input                spc118_inst_done,
   input [63:0]         pc_w118

,
   input                spc119_inst_done,
   input [63:0]         pc_w119

,
   input                spc120_inst_done,
   input [63:0]         pc_w120

,
   input                spc121_inst_done,
   input [63:0]         pc_w121

,
   input                spc122_inst_done,
   input [63:0]         pc_w122

,
   input                spc123_inst_done,
   input [63:0]         pc_w123

,
   input                spc124_inst_done,
   input [63:0]         pc_w124

,
   input                spc125_inst_done,
   input [63:0]         pc_w125

,
   input                spc126_inst_done,
   input [63:0]         pc_w126

,
   input                spc127_inst_done,
   input [63:0]         pc_w127

,
   input                spc128_inst_done,
   input [63:0]         pc_w128

,
   input                spc129_inst_done,
   input [63:0]         pc_w129

,
   input                spc130_inst_done,
   input [63:0]         pc_w130

,
   input                spc131_inst_done,
   input [63:0]         pc_w131

,
   input                spc132_inst_done,
   input [63:0]         pc_w132

,
   input                spc133_inst_done,
   input [63:0]         pc_w133

,
   input                spc134_inst_done,
   input [63:0]         pc_w134

,
   input                spc135_inst_done,
   input [63:0]         pc_w135

,
   input                spc136_inst_done,
   input [63:0]         pc_w136

,
   input                spc137_inst_done,
   input [63:0]         pc_w137

,
   input                spc138_inst_done,
   input [63:0]         pc_w138

,
   input                spc139_inst_done,
   input [63:0]         pc_w139

,
   input                spc140_inst_done,
   input [63:0]         pc_w140

,
   input                spc141_inst_done,
   input [63:0]         pc_w141

,
   input                spc142_inst_done,
   input [63:0]         pc_w142

,
   input                spc143_inst_done,
   input [63:0]         pc_w143

,
   input                spc144_inst_done,
   input [63:0]         pc_w144

,
   input                spc145_inst_done,
   input [63:0]         pc_w145

,
   input                spc146_inst_done,
   input [63:0]         pc_w146

,
   input                spc147_inst_done,
   input [63:0]         pc_w147

,
   input                spc148_inst_done,
   input [63:0]         pc_w148

,
   input                spc149_inst_done,
   input [63:0]         pc_w149

,
   input                spc150_inst_done,
   input [63:0]         pc_w150

,
   input                spc151_inst_done,
   input [63:0]         pc_w151

,
   input                spc152_inst_done,
   input [63:0]         pc_w152

,
   input                spc153_inst_done,
   input [63:0]         pc_w153

,
   input                spc154_inst_done,
   input [63:0]         pc_w154

,
   input                spc155_inst_done,
   input [63:0]         pc_w155

,
   input                spc156_inst_done,
   input [63:0]         pc_w156

,
   input                spc157_inst_done,
   input [63:0]         pc_w157

,
   input                spc158_inst_done,
   input [63:0]         pc_w158

,
   input                spc159_inst_done,
   input [63:0]         pc_w159

,
   input                spc160_inst_done,
   input [63:0]         pc_w160

,
   input                spc161_inst_done,
   input [63:0]         pc_w161

,
   input                spc162_inst_done,
   input [63:0]         pc_w162

,
   input                spc163_inst_done,
   input [63:0]         pc_w163

,
   input                spc164_inst_done,
   input [63:0]         pc_w164

,
   input                spc165_inst_done,
   input [63:0]         pc_w165

,
   input                spc166_inst_done,
   input [63:0]         pc_w166

,
   input                spc167_inst_done,
   input [63:0]         pc_w167

,
   input                spc168_inst_done,
   input [63:0]         pc_w168

,
   input                spc169_inst_done,
   input [63:0]         pc_w169

,
   input                spc170_inst_done,
   input [63:0]         pc_w170

,
   input                spc171_inst_done,
   input [63:0]         pc_w171

,
   input                spc172_inst_done,
   input [63:0]         pc_w172

,
   input                spc173_inst_done,
   input [63:0]         pc_w173

,
   input                spc174_inst_done,
   input [63:0]         pc_w174

,
   input                spc175_inst_done,
   input [63:0]         pc_w175

,
   input                spc176_inst_done,
   input [63:0]         pc_w176

,
   input                spc177_inst_done,
   input [63:0]         pc_w177

,
   input                spc178_inst_done,
   input [63:0]         pc_w178

,
   input                spc179_inst_done,
   input [63:0]         pc_w179

,
   input                spc180_inst_done,
   input [63:0]         pc_w180

,
   input                spc181_inst_done,
   input [63:0]         pc_w181

,
   input                spc182_inst_done,
   input [63:0]         pc_w182

,
   input                spc183_inst_done,
   input [63:0]         pc_w183

,
   input                spc184_inst_done,
   input [63:0]         pc_w184

,
   input                spc185_inst_done,
   input [63:0]         pc_w185

,
   input                spc186_inst_done,
   input [63:0]         pc_w186

,
   input                spc187_inst_done,
   input [63:0]         pc_w187

,
   input                spc188_inst_done,
   input [63:0]         pc_w188

,
   input                spc189_inst_done,
   input [63:0]         pc_w189

,
   input                spc190_inst_done,
   input [63:0]         pc_w190

,
   input                spc191_inst_done,
   input [63:0]         pc_w191

,
   input                spc192_inst_done,
   input [63:0]         pc_w192

,
   input                spc193_inst_done,
   input [63:0]         pc_w193

,
   input                spc194_inst_done,
   input [63:0]         pc_w194

,
   input                spc195_inst_done,
   input [63:0]         pc_w195

,
   input                spc196_inst_done,
   input [63:0]         pc_w196

,
   input                spc197_inst_done,
   input [63:0]         pc_w197

,
   input                spc198_inst_done,
   input [63:0]         pc_w198

,
   input                spc199_inst_done,
   input [63:0]         pc_w199

,
   input                spc200_inst_done,
   input [63:0]         pc_w200

,
   input                spc201_inst_done,
   input [63:0]         pc_w201

,
   input                spc202_inst_done,
   input [63:0]         pc_w202

,
   input                spc203_inst_done,
   input [63:0]         pc_w203

,
   input                spc204_inst_done,
   input [63:0]         pc_w204

,
   input                spc205_inst_done,
   input [63:0]         pc_w205

,
   input                spc206_inst_done,
   input [63:0]         pc_w206

,
   input                spc207_inst_done,
   input [63:0]         pc_w207

,
   input                spc208_inst_done,
   input [63:0]         pc_w208

,
   input                spc209_inst_done,
   input [63:0]         pc_w209

,
   input                spc210_inst_done,
   input [63:0]         pc_w210

,
   input                spc211_inst_done,
   input [63:0]         pc_w211

,
   input                spc212_inst_done,
   input [63:0]         pc_w212

,
   input                spc213_inst_done,
   input [63:0]         pc_w213

,
   input                spc214_inst_done,
   input [63:0]         pc_w214

,
   input                spc215_inst_done,
   input [63:0]         pc_w215

,
   input                spc216_inst_done,
   input [63:0]         pc_w216

,
   input                spc217_inst_done,
   input [63:0]         pc_w217

,
   input                spc218_inst_done,
   input [63:0]         pc_w218

,
   input                spc219_inst_done,
   input [63:0]         pc_w219

,
   input                spc220_inst_done,
   input [63:0]         pc_w220

,
   input                spc221_inst_done,
   input [63:0]         pc_w221

,
   input                spc222_inst_done,
   input [63:0]         pc_w222

,
   input                spc223_inst_done,
   input [63:0]         pc_w223

,
   input                spc224_inst_done,
   input [63:0]         pc_w224

,
   input                spc225_inst_done,
   input [63:0]         pc_w225

,
   input                spc226_inst_done,
   input [63:0]         pc_w226

,
   input                spc227_inst_done,
   input [63:0]         pc_w227

,
   input                spc228_inst_done,
   input [63:0]         pc_w228

,
   input                spc229_inst_done,
   input [63:0]         pc_w229

,
   input                spc230_inst_done,
   input [63:0]         pc_w230

,
   input                spc231_inst_done,
   input [63:0]         pc_w231

,
   input                spc232_inst_done,
   input [63:0]         pc_w232

,
   input                spc233_inst_done,
   input [63:0]         pc_w233

,
   input                spc234_inst_done,
   input [63:0]         pc_w234

,
   input                spc235_inst_done,
   input [63:0]         pc_w235

,
   input                spc236_inst_done,
   input [63:0]         pc_w236

,
   input                spc237_inst_done,
   input [63:0]         pc_w237

,
   input                spc238_inst_done,
   input [63:0]         pc_w238

,
   input                spc239_inst_done,
   input [63:0]         pc_w239

,
   input                spc240_inst_done,
   input [63:0]         pc_w240

,
   input                spc241_inst_done,
   input [63:0]         pc_w241

,
   input                spc242_inst_done,
   input [63:0]         pc_w242

,
   input                spc243_inst_done,
   input [63:0]         pc_w243

,
   input                spc244_inst_done,
   input [63:0]         pc_w244

,
   input                spc245_inst_done,
   input [63:0]         pc_w245

,
   input                spc246_inst_done,
   input [63:0]         pc_w246

,
   input                spc247_inst_done,
   input [63:0]         pc_w247

,
   input                spc248_inst_done,
   input [63:0]         pc_w248

,
   input                spc249_inst_done,
   input [63:0]         pc_w249

,
   input                spc250_inst_done,
   input [63:0]         pc_w250

,
   input                spc251_inst_done,
   input [63:0]         pc_w251

,
   input                spc252_inst_done,
   input [63:0]         pc_w252

,
   input                spc253_inst_done,
   input [63:0]         pc_w253

,
   input                spc254_inst_done,
   input [63:0]         pc_w254

,
   input                spc255_inst_done,
   input [63:0]         pc_w255



);
//temp. memory.
reg [`CPX_WIDTH-1:0] 	    fake_iob_out_data;

wire [`CPX_WIDTH-1:0]       cpx_data = fake_iob_out_data;

// Output buffer
// The output buffer need to be asynchronous and cannot ever be overflowed.
// We will ensure this by having a lot of entries
localparam NUM_ASYNC_ENTRIES = 256;

reg [`NOC_DATA_WIDTH-1:0] out_buffer [NUM_ASYNC_ENTRIES-1:0];
reg [NUM_ASYNC_ENTRIES-1:0] out_buffer_val;

reg iob_buffer_val;
reg [2*`NOC_DATA_WIDTH-1:0] iob_buffer_data;

///////////////////////////////////////////////////////////
// write port of the async fifo; runs at chip frequency
///////////////////////////////////////////////////////////
reg [7:0] out_write_index;
reg [7:0] out_write_index_next;

integer i;

always @ (posedge `CHIP.clk_muxed)
begin
    if (!rst_n)
        out_write_index <= 0;
    else
    begin
        out_write_index <= out_write_index_next;
    end

    // write port
    if (!rst_n)
        for (i = 0; i < NUM_ASYNC_ENTRIES; i = i + 1)
        begin
            out_buffer[i] = 0;
            out_buffer_val[i] = 1'b0;
        end
    else
    begin
        if (iob_buffer_val)
        begin
            // no ready; always accepting packet
            out_buffer[out_write_index + 1] = iob_buffer_data[63:0];
            out_buffer[out_write_index] = iob_buffer_data[127:64];
            out_buffer_val[out_write_index] = 1'b1;
            out_buffer_val[out_write_index + 1] = 1'b1;
        end
    end

end

always @ *
begin
    out_write_index_next = iob_buffer_val ? out_write_index + 2 : out_write_index;
end


///////////////////////////////////////////////////////////
// read port of the async fifo; runs at off-chip frequency
///////////////////////////////////////////////////////////
reg [7:0] out_read_index;
reg [7:0] out_read_index_next;

always @ (posedge clk)
begin
    if (!rst_n)
        out_read_index <= 0;
    else
    begin
        out_read_index <= out_read_index_next;
    end

    if (noc_out_rdy && noc_out_val)
    begin
        out_buffer_val[out_read_index] = 1'b0;
    end
end

always @ *
begin
    noc_out_val = out_buffer_val[out_read_index];
    noc_out_data = 0; // Tri: fixes x when out_buffer_counter == 0
    noc_out_data = out_buffer[out_read_index];

    out_read_index_next = (noc_out_rdy && noc_out_val) ? out_read_index + 1 : out_read_index;
end

///////////////////////////////////////////////////////////
// Make out going packets from IOB out data
///////////////////////////////////////////////////////////
reg [63:0] iob_buffer_flit1;
reg [63:0] iob_buffer_flit2;
reg  [`NOC_X_WIDTH-1:0] dest_x;
reg  [`NOC_Y_WIDTH-1:0] dest_y;
always @ *
begin
   iob_buffer_val = fake_iob_out_data[144];
   iob_buffer_flit1 = {14'b0,5'b0, 3'b0, 8'b0,`NOC_FBITS_L1,8'd1, `MSG_TYPE_INTERRUPT,14'b0};
   iob_buffer_flit2 = {fake_iob_out_data[63:16],7'b0,fake_iob_out_data[8:0]};

   // assuming a 8x8 topo
   iob_buffer_flit1[`MSG_DST_X] = dest_x;
   iob_buffer_flit1[`MSG_DST_Y] = dest_y;

   //if (iob_buffer_val)
   //begin
   //   $display("IOB sending to tile X:%d Y:%d", iob_buffer_flit1[`MSG_DST_X], iob_buffer_flit1[`MSG_DST_Y]);
   //   $display("   raw tileid %x", fake_iob_out_data[49:18]);
   // end

   iob_buffer_data = {iob_buffer_flit1, iob_buffer_flit2};
end

always @*
begin
    case (fake_iob_out_data[49:18])
    
32'd0:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd1:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd2:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd3:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd4:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd5:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd6:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd7:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd8:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd9:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd10:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd11:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd12:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd13:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd14:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd15:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd0;
end

32'd16:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd17:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd18:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd19:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd20:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd21:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd22:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd23:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd24:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd25:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd26:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd27:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd28:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd29:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd30:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd31:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd1;
end

32'd32:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd33:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd34:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd35:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd36:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd37:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd38:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd39:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd40:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd41:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd42:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd43:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd44:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd45:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd46:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd47:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd2;
end

32'd48:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd49:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd50:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd51:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd52:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd53:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd54:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd55:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd56:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd57:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd58:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd59:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd60:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd61:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd62:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd63:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd3;
end

32'd64:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd65:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd66:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd67:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd68:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd69:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd70:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd71:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd72:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd73:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd74:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd75:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd76:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd77:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd78:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd79:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd4;
end

32'd80:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd81:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd82:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd83:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd84:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd85:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd86:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd87:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd88:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd89:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd90:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd91:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd92:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd93:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd94:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd95:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd5;
end

32'd96:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd97:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd98:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd99:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd100:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd101:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd102:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd103:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd104:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd105:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd106:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd107:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd108:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd109:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd110:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd111:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd6;
end

32'd112:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd113:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd114:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd115:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd116:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd117:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd118:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd119:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd120:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd121:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd122:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd123:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd124:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd125:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd126:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd127:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd7;
end

32'd128:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd129:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd130:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd131:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd132:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd133:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd134:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd135:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd136:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd137:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd138:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd139:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd140:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd141:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd142:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd143:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd8;
end

32'd144:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd145:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd146:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd147:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd148:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd149:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd150:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd151:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd152:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd153:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd154:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd155:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd156:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd157:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd158:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd159:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd9;
end

32'd160:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd161:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd162:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd163:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd164:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd165:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd166:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd167:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd168:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd169:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd170:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd171:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd172:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd173:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd174:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd175:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd10;
end

32'd176:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd177:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd178:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd179:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd180:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd181:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd182:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd183:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd184:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd185:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd186:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd187:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd188:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd189:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd190:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd191:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd11;
end

32'd192:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd193:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd194:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd195:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd196:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd197:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd198:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd199:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd200:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd201:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd202:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd203:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd204:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd205:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd206:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd207:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd12;
end

32'd208:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd209:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd210:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd211:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd212:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd213:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd214:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd215:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd216:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd217:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd218:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd219:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd220:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd221:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd222:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd223:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd13;
end

32'd224:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd225:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd226:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd227:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd228:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd229:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd230:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd231:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd232:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd233:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd234:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd235:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd236:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd237:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd238:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd239:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd14;
end

32'd240:
begin
    dest_x = `NOC_X_WIDTH'd0;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd241:
begin
    dest_x = `NOC_X_WIDTH'd1;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd242:
begin
    dest_x = `NOC_X_WIDTH'd2;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd243:
begin
    dest_x = `NOC_X_WIDTH'd3;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd244:
begin
    dest_x = `NOC_X_WIDTH'd4;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd245:
begin
    dest_x = `NOC_X_WIDTH'd5;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd246:
begin
    dest_x = `NOC_X_WIDTH'd6;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd247:
begin
    dest_x = `NOC_X_WIDTH'd7;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd248:
begin
    dest_x = `NOC_X_WIDTH'd8;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd249:
begin
    dest_x = `NOC_X_WIDTH'd9;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd250:
begin
    dest_x = `NOC_X_WIDTH'd10;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd251:
begin
    dest_x = `NOC_X_WIDTH'd11;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd252:
begin
    dest_x = `NOC_X_WIDTH'd12;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd253:
begin
    dest_x = `NOC_X_WIDTH'd13;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd254:
begin
    dest_x = `NOC_X_WIDTH'd14;
    dest_y = `NOC_Y_WIDTH'd15;
end

32'd255:
begin
    dest_x = `NOC_X_WIDTH'd15;
    dest_y = `NOC_Y_WIDTH'd15;
end

    default:
    begin
        dest_x = `NOC_X_WIDTH'dX;
        dest_y = `NOC_Y_WIDTH'dX;
    end
    endcase
end


// input signals

wire                             spc0_inst_done_buf  = spc0_inst_done;
wire [63:0]                      pc_w0_buf           = pc_w0;


wire                             spc1_inst_done_buf  = spc1_inst_done;
wire [63:0]                      pc_w1_buf           = pc_w1;


wire                             spc2_inst_done_buf  = spc2_inst_done;
wire [63:0]                      pc_w2_buf           = pc_w2;


wire                             spc3_inst_done_buf  = spc3_inst_done;
wire [63:0]                      pc_w3_buf           = pc_w3;


wire                             spc4_inst_done_buf  = spc4_inst_done;
wire [63:0]                      pc_w4_buf           = pc_w4;


wire                             spc5_inst_done_buf  = spc5_inst_done;
wire [63:0]                      pc_w5_buf           = pc_w5;


wire                             spc6_inst_done_buf  = spc6_inst_done;
wire [63:0]                      pc_w6_buf           = pc_w6;


wire                             spc7_inst_done_buf  = spc7_inst_done;
wire [63:0]                      pc_w7_buf           = pc_w7;


wire                             spc8_inst_done_buf  = spc8_inst_done;
wire [63:0]                      pc_w8_buf           = pc_w8;


wire                             spc9_inst_done_buf  = spc9_inst_done;
wire [63:0]                      pc_w9_buf           = pc_w9;


wire                             spc10_inst_done_buf  = spc10_inst_done;
wire [63:0]                      pc_w10_buf           = pc_w10;


wire                             spc11_inst_done_buf  = spc11_inst_done;
wire [63:0]                      pc_w11_buf           = pc_w11;


wire                             spc12_inst_done_buf  = spc12_inst_done;
wire [63:0]                      pc_w12_buf           = pc_w12;


wire                             spc13_inst_done_buf  = spc13_inst_done;
wire [63:0]                      pc_w13_buf           = pc_w13;


wire                             spc14_inst_done_buf  = spc14_inst_done;
wire [63:0]                      pc_w14_buf           = pc_w14;


wire                             spc15_inst_done_buf  = spc15_inst_done;
wire [63:0]                      pc_w15_buf           = pc_w15;


wire                             spc16_inst_done_buf  = spc16_inst_done;
wire [63:0]                      pc_w16_buf           = pc_w16;


wire                             spc17_inst_done_buf  = spc17_inst_done;
wire [63:0]                      pc_w17_buf           = pc_w17;


wire                             spc18_inst_done_buf  = spc18_inst_done;
wire [63:0]                      pc_w18_buf           = pc_w18;


wire                             spc19_inst_done_buf  = spc19_inst_done;
wire [63:0]                      pc_w19_buf           = pc_w19;


wire                             spc20_inst_done_buf  = spc20_inst_done;
wire [63:0]                      pc_w20_buf           = pc_w20;


wire                             spc21_inst_done_buf  = spc21_inst_done;
wire [63:0]                      pc_w21_buf           = pc_w21;


wire                             spc22_inst_done_buf  = spc22_inst_done;
wire [63:0]                      pc_w22_buf           = pc_w22;


wire                             spc23_inst_done_buf  = spc23_inst_done;
wire [63:0]                      pc_w23_buf           = pc_w23;


wire                             spc24_inst_done_buf  = spc24_inst_done;
wire [63:0]                      pc_w24_buf           = pc_w24;


wire                             spc25_inst_done_buf  = spc25_inst_done;
wire [63:0]                      pc_w25_buf           = pc_w25;


wire                             spc26_inst_done_buf  = spc26_inst_done;
wire [63:0]                      pc_w26_buf           = pc_w26;


wire                             spc27_inst_done_buf  = spc27_inst_done;
wire [63:0]                      pc_w27_buf           = pc_w27;


wire                             spc28_inst_done_buf  = spc28_inst_done;
wire [63:0]                      pc_w28_buf           = pc_w28;


wire                             spc29_inst_done_buf  = spc29_inst_done;
wire [63:0]                      pc_w29_buf           = pc_w29;


wire                             spc30_inst_done_buf  = spc30_inst_done;
wire [63:0]                      pc_w30_buf           = pc_w30;


wire                             spc31_inst_done_buf  = spc31_inst_done;
wire [63:0]                      pc_w31_buf           = pc_w31;


wire                             spc32_inst_done_buf  = spc32_inst_done;
wire [63:0]                      pc_w32_buf           = pc_w32;


wire                             spc33_inst_done_buf  = spc33_inst_done;
wire [63:0]                      pc_w33_buf           = pc_w33;


wire                             spc34_inst_done_buf  = spc34_inst_done;
wire [63:0]                      pc_w34_buf           = pc_w34;


wire                             spc35_inst_done_buf  = spc35_inst_done;
wire [63:0]                      pc_w35_buf           = pc_w35;


wire                             spc36_inst_done_buf  = spc36_inst_done;
wire [63:0]                      pc_w36_buf           = pc_w36;


wire                             spc37_inst_done_buf  = spc37_inst_done;
wire [63:0]                      pc_w37_buf           = pc_w37;


wire                             spc38_inst_done_buf  = spc38_inst_done;
wire [63:0]                      pc_w38_buf           = pc_w38;


wire                             spc39_inst_done_buf  = spc39_inst_done;
wire [63:0]                      pc_w39_buf           = pc_w39;


wire                             spc40_inst_done_buf  = spc40_inst_done;
wire [63:0]                      pc_w40_buf           = pc_w40;


wire                             spc41_inst_done_buf  = spc41_inst_done;
wire [63:0]                      pc_w41_buf           = pc_w41;


wire                             spc42_inst_done_buf  = spc42_inst_done;
wire [63:0]                      pc_w42_buf           = pc_w42;


wire                             spc43_inst_done_buf  = spc43_inst_done;
wire [63:0]                      pc_w43_buf           = pc_w43;


wire                             spc44_inst_done_buf  = spc44_inst_done;
wire [63:0]                      pc_w44_buf           = pc_w44;


wire                             spc45_inst_done_buf  = spc45_inst_done;
wire [63:0]                      pc_w45_buf           = pc_w45;


wire                             spc46_inst_done_buf  = spc46_inst_done;
wire [63:0]                      pc_w46_buf           = pc_w46;


wire                             spc47_inst_done_buf  = spc47_inst_done;
wire [63:0]                      pc_w47_buf           = pc_w47;


wire                             spc48_inst_done_buf  = spc48_inst_done;
wire [63:0]                      pc_w48_buf           = pc_w48;


wire                             spc49_inst_done_buf  = spc49_inst_done;
wire [63:0]                      pc_w49_buf           = pc_w49;


wire                             spc50_inst_done_buf  = spc50_inst_done;
wire [63:0]                      pc_w50_buf           = pc_w50;


wire                             spc51_inst_done_buf  = spc51_inst_done;
wire [63:0]                      pc_w51_buf           = pc_w51;


wire                             spc52_inst_done_buf  = spc52_inst_done;
wire [63:0]                      pc_w52_buf           = pc_w52;


wire                             spc53_inst_done_buf  = spc53_inst_done;
wire [63:0]                      pc_w53_buf           = pc_w53;


wire                             spc54_inst_done_buf  = spc54_inst_done;
wire [63:0]                      pc_w54_buf           = pc_w54;


wire                             spc55_inst_done_buf  = spc55_inst_done;
wire [63:0]                      pc_w55_buf           = pc_w55;


wire                             spc56_inst_done_buf  = spc56_inst_done;
wire [63:0]                      pc_w56_buf           = pc_w56;


wire                             spc57_inst_done_buf  = spc57_inst_done;
wire [63:0]                      pc_w57_buf           = pc_w57;


wire                             spc58_inst_done_buf  = spc58_inst_done;
wire [63:0]                      pc_w58_buf           = pc_w58;


wire                             spc59_inst_done_buf  = spc59_inst_done;
wire [63:0]                      pc_w59_buf           = pc_w59;


wire                             spc60_inst_done_buf  = spc60_inst_done;
wire [63:0]                      pc_w60_buf           = pc_w60;


wire                             spc61_inst_done_buf  = spc61_inst_done;
wire [63:0]                      pc_w61_buf           = pc_w61;


wire                             spc62_inst_done_buf  = spc62_inst_done;
wire [63:0]                      pc_w62_buf           = pc_w62;


wire                             spc63_inst_done_buf  = spc63_inst_done;
wire [63:0]                      pc_w63_buf           = pc_w63;


wire                             spc64_inst_done_buf  = spc64_inst_done;
wire [63:0]                      pc_w64_buf           = pc_w64;


wire                             spc65_inst_done_buf  = spc65_inst_done;
wire [63:0]                      pc_w65_buf           = pc_w65;


wire                             spc66_inst_done_buf  = spc66_inst_done;
wire [63:0]                      pc_w66_buf           = pc_w66;


wire                             spc67_inst_done_buf  = spc67_inst_done;
wire [63:0]                      pc_w67_buf           = pc_w67;


wire                             spc68_inst_done_buf  = spc68_inst_done;
wire [63:0]                      pc_w68_buf           = pc_w68;


wire                             spc69_inst_done_buf  = spc69_inst_done;
wire [63:0]                      pc_w69_buf           = pc_w69;


wire                             spc70_inst_done_buf  = spc70_inst_done;
wire [63:0]                      pc_w70_buf           = pc_w70;


wire                             spc71_inst_done_buf  = spc71_inst_done;
wire [63:0]                      pc_w71_buf           = pc_w71;


wire                             spc72_inst_done_buf  = spc72_inst_done;
wire [63:0]                      pc_w72_buf           = pc_w72;


wire                             spc73_inst_done_buf  = spc73_inst_done;
wire [63:0]                      pc_w73_buf           = pc_w73;


wire                             spc74_inst_done_buf  = spc74_inst_done;
wire [63:0]                      pc_w74_buf           = pc_w74;


wire                             spc75_inst_done_buf  = spc75_inst_done;
wire [63:0]                      pc_w75_buf           = pc_w75;


wire                             spc76_inst_done_buf  = spc76_inst_done;
wire [63:0]                      pc_w76_buf           = pc_w76;


wire                             spc77_inst_done_buf  = spc77_inst_done;
wire [63:0]                      pc_w77_buf           = pc_w77;


wire                             spc78_inst_done_buf  = spc78_inst_done;
wire [63:0]                      pc_w78_buf           = pc_w78;


wire                             spc79_inst_done_buf  = spc79_inst_done;
wire [63:0]                      pc_w79_buf           = pc_w79;


wire                             spc80_inst_done_buf  = spc80_inst_done;
wire [63:0]                      pc_w80_buf           = pc_w80;


wire                             spc81_inst_done_buf  = spc81_inst_done;
wire [63:0]                      pc_w81_buf           = pc_w81;


wire                             spc82_inst_done_buf  = spc82_inst_done;
wire [63:0]                      pc_w82_buf           = pc_w82;


wire                             spc83_inst_done_buf  = spc83_inst_done;
wire [63:0]                      pc_w83_buf           = pc_w83;


wire                             spc84_inst_done_buf  = spc84_inst_done;
wire [63:0]                      pc_w84_buf           = pc_w84;


wire                             spc85_inst_done_buf  = spc85_inst_done;
wire [63:0]                      pc_w85_buf           = pc_w85;


wire                             spc86_inst_done_buf  = spc86_inst_done;
wire [63:0]                      pc_w86_buf           = pc_w86;


wire                             spc87_inst_done_buf  = spc87_inst_done;
wire [63:0]                      pc_w87_buf           = pc_w87;


wire                             spc88_inst_done_buf  = spc88_inst_done;
wire [63:0]                      pc_w88_buf           = pc_w88;


wire                             spc89_inst_done_buf  = spc89_inst_done;
wire [63:0]                      pc_w89_buf           = pc_w89;


wire                             spc90_inst_done_buf  = spc90_inst_done;
wire [63:0]                      pc_w90_buf           = pc_w90;


wire                             spc91_inst_done_buf  = spc91_inst_done;
wire [63:0]                      pc_w91_buf           = pc_w91;


wire                             spc92_inst_done_buf  = spc92_inst_done;
wire [63:0]                      pc_w92_buf           = pc_w92;


wire                             spc93_inst_done_buf  = spc93_inst_done;
wire [63:0]                      pc_w93_buf           = pc_w93;


wire                             spc94_inst_done_buf  = spc94_inst_done;
wire [63:0]                      pc_w94_buf           = pc_w94;


wire                             spc95_inst_done_buf  = spc95_inst_done;
wire [63:0]                      pc_w95_buf           = pc_w95;


wire                             spc96_inst_done_buf  = spc96_inst_done;
wire [63:0]                      pc_w96_buf           = pc_w96;


wire                             spc97_inst_done_buf  = spc97_inst_done;
wire [63:0]                      pc_w97_buf           = pc_w97;


wire                             spc98_inst_done_buf  = spc98_inst_done;
wire [63:0]                      pc_w98_buf           = pc_w98;


wire                             spc99_inst_done_buf  = spc99_inst_done;
wire [63:0]                      pc_w99_buf           = pc_w99;


wire                             spc100_inst_done_buf  = spc100_inst_done;
wire [63:0]                      pc_w100_buf           = pc_w100;


wire                             spc101_inst_done_buf  = spc101_inst_done;
wire [63:0]                      pc_w101_buf           = pc_w101;


wire                             spc102_inst_done_buf  = spc102_inst_done;
wire [63:0]                      pc_w102_buf           = pc_w102;


wire                             spc103_inst_done_buf  = spc103_inst_done;
wire [63:0]                      pc_w103_buf           = pc_w103;


wire                             spc104_inst_done_buf  = spc104_inst_done;
wire [63:0]                      pc_w104_buf           = pc_w104;


wire                             spc105_inst_done_buf  = spc105_inst_done;
wire [63:0]                      pc_w105_buf           = pc_w105;


wire                             spc106_inst_done_buf  = spc106_inst_done;
wire [63:0]                      pc_w106_buf           = pc_w106;


wire                             spc107_inst_done_buf  = spc107_inst_done;
wire [63:0]                      pc_w107_buf           = pc_w107;


wire                             spc108_inst_done_buf  = spc108_inst_done;
wire [63:0]                      pc_w108_buf           = pc_w108;


wire                             spc109_inst_done_buf  = spc109_inst_done;
wire [63:0]                      pc_w109_buf           = pc_w109;


wire                             spc110_inst_done_buf  = spc110_inst_done;
wire [63:0]                      pc_w110_buf           = pc_w110;


wire                             spc111_inst_done_buf  = spc111_inst_done;
wire [63:0]                      pc_w111_buf           = pc_w111;


wire                             spc112_inst_done_buf  = spc112_inst_done;
wire [63:0]                      pc_w112_buf           = pc_w112;


wire                             spc113_inst_done_buf  = spc113_inst_done;
wire [63:0]                      pc_w113_buf           = pc_w113;


wire                             spc114_inst_done_buf  = spc114_inst_done;
wire [63:0]                      pc_w114_buf           = pc_w114;


wire                             spc115_inst_done_buf  = spc115_inst_done;
wire [63:0]                      pc_w115_buf           = pc_w115;


wire                             spc116_inst_done_buf  = spc116_inst_done;
wire [63:0]                      pc_w116_buf           = pc_w116;


wire                             spc117_inst_done_buf  = spc117_inst_done;
wire [63:0]                      pc_w117_buf           = pc_w117;


wire                             spc118_inst_done_buf  = spc118_inst_done;
wire [63:0]                      pc_w118_buf           = pc_w118;


wire                             spc119_inst_done_buf  = spc119_inst_done;
wire [63:0]                      pc_w119_buf           = pc_w119;


wire                             spc120_inst_done_buf  = spc120_inst_done;
wire [63:0]                      pc_w120_buf           = pc_w120;


wire                             spc121_inst_done_buf  = spc121_inst_done;
wire [63:0]                      pc_w121_buf           = pc_w121;


wire                             spc122_inst_done_buf  = spc122_inst_done;
wire [63:0]                      pc_w122_buf           = pc_w122;


wire                             spc123_inst_done_buf  = spc123_inst_done;
wire [63:0]                      pc_w123_buf           = pc_w123;


wire                             spc124_inst_done_buf  = spc124_inst_done;
wire [63:0]                      pc_w124_buf           = pc_w124;


wire                             spc125_inst_done_buf  = spc125_inst_done;
wire [63:0]                      pc_w125_buf           = pc_w125;


wire                             spc126_inst_done_buf  = spc126_inst_done;
wire [63:0]                      pc_w126_buf           = pc_w126;


wire                             spc127_inst_done_buf  = spc127_inst_done;
wire [63:0]                      pc_w127_buf           = pc_w127;


wire                             spc128_inst_done_buf  = spc128_inst_done;
wire [63:0]                      pc_w128_buf           = pc_w128;


wire                             spc129_inst_done_buf  = spc129_inst_done;
wire [63:0]                      pc_w129_buf           = pc_w129;


wire                             spc130_inst_done_buf  = spc130_inst_done;
wire [63:0]                      pc_w130_buf           = pc_w130;


wire                             spc131_inst_done_buf  = spc131_inst_done;
wire [63:0]                      pc_w131_buf           = pc_w131;


wire                             spc132_inst_done_buf  = spc132_inst_done;
wire [63:0]                      pc_w132_buf           = pc_w132;


wire                             spc133_inst_done_buf  = spc133_inst_done;
wire [63:0]                      pc_w133_buf           = pc_w133;


wire                             spc134_inst_done_buf  = spc134_inst_done;
wire [63:0]                      pc_w134_buf           = pc_w134;


wire                             spc135_inst_done_buf  = spc135_inst_done;
wire [63:0]                      pc_w135_buf           = pc_w135;


wire                             spc136_inst_done_buf  = spc136_inst_done;
wire [63:0]                      pc_w136_buf           = pc_w136;


wire                             spc137_inst_done_buf  = spc137_inst_done;
wire [63:0]                      pc_w137_buf           = pc_w137;


wire                             spc138_inst_done_buf  = spc138_inst_done;
wire [63:0]                      pc_w138_buf           = pc_w138;


wire                             spc139_inst_done_buf  = spc139_inst_done;
wire [63:0]                      pc_w139_buf           = pc_w139;


wire                             spc140_inst_done_buf  = spc140_inst_done;
wire [63:0]                      pc_w140_buf           = pc_w140;


wire                             spc141_inst_done_buf  = spc141_inst_done;
wire [63:0]                      pc_w141_buf           = pc_w141;


wire                             spc142_inst_done_buf  = spc142_inst_done;
wire [63:0]                      pc_w142_buf           = pc_w142;


wire                             spc143_inst_done_buf  = spc143_inst_done;
wire [63:0]                      pc_w143_buf           = pc_w143;


wire                             spc144_inst_done_buf  = spc144_inst_done;
wire [63:0]                      pc_w144_buf           = pc_w144;


wire                             spc145_inst_done_buf  = spc145_inst_done;
wire [63:0]                      pc_w145_buf           = pc_w145;


wire                             spc146_inst_done_buf  = spc146_inst_done;
wire [63:0]                      pc_w146_buf           = pc_w146;


wire                             spc147_inst_done_buf  = spc147_inst_done;
wire [63:0]                      pc_w147_buf           = pc_w147;


wire                             spc148_inst_done_buf  = spc148_inst_done;
wire [63:0]                      pc_w148_buf           = pc_w148;


wire                             spc149_inst_done_buf  = spc149_inst_done;
wire [63:0]                      pc_w149_buf           = pc_w149;


wire                             spc150_inst_done_buf  = spc150_inst_done;
wire [63:0]                      pc_w150_buf           = pc_w150;


wire                             spc151_inst_done_buf  = spc151_inst_done;
wire [63:0]                      pc_w151_buf           = pc_w151;


wire                             spc152_inst_done_buf  = spc152_inst_done;
wire [63:0]                      pc_w152_buf           = pc_w152;


wire                             spc153_inst_done_buf  = spc153_inst_done;
wire [63:0]                      pc_w153_buf           = pc_w153;


wire                             spc154_inst_done_buf  = spc154_inst_done;
wire [63:0]                      pc_w154_buf           = pc_w154;


wire                             spc155_inst_done_buf  = spc155_inst_done;
wire [63:0]                      pc_w155_buf           = pc_w155;


wire                             spc156_inst_done_buf  = spc156_inst_done;
wire [63:0]                      pc_w156_buf           = pc_w156;


wire                             spc157_inst_done_buf  = spc157_inst_done;
wire [63:0]                      pc_w157_buf           = pc_w157;


wire                             spc158_inst_done_buf  = spc158_inst_done;
wire [63:0]                      pc_w158_buf           = pc_w158;


wire                             spc159_inst_done_buf  = spc159_inst_done;
wire [63:0]                      pc_w159_buf           = pc_w159;


wire                             spc160_inst_done_buf  = spc160_inst_done;
wire [63:0]                      pc_w160_buf           = pc_w160;


wire                             spc161_inst_done_buf  = spc161_inst_done;
wire [63:0]                      pc_w161_buf           = pc_w161;


wire                             spc162_inst_done_buf  = spc162_inst_done;
wire [63:0]                      pc_w162_buf           = pc_w162;


wire                             spc163_inst_done_buf  = spc163_inst_done;
wire [63:0]                      pc_w163_buf           = pc_w163;


wire                             spc164_inst_done_buf  = spc164_inst_done;
wire [63:0]                      pc_w164_buf           = pc_w164;


wire                             spc165_inst_done_buf  = spc165_inst_done;
wire [63:0]                      pc_w165_buf           = pc_w165;


wire                             spc166_inst_done_buf  = spc166_inst_done;
wire [63:0]                      pc_w166_buf           = pc_w166;


wire                             spc167_inst_done_buf  = spc167_inst_done;
wire [63:0]                      pc_w167_buf           = pc_w167;


wire                             spc168_inst_done_buf  = spc168_inst_done;
wire [63:0]                      pc_w168_buf           = pc_w168;


wire                             spc169_inst_done_buf  = spc169_inst_done;
wire [63:0]                      pc_w169_buf           = pc_w169;


wire                             spc170_inst_done_buf  = spc170_inst_done;
wire [63:0]                      pc_w170_buf           = pc_w170;


wire                             spc171_inst_done_buf  = spc171_inst_done;
wire [63:0]                      pc_w171_buf           = pc_w171;


wire                             spc172_inst_done_buf  = spc172_inst_done;
wire [63:0]                      pc_w172_buf           = pc_w172;


wire                             spc173_inst_done_buf  = spc173_inst_done;
wire [63:0]                      pc_w173_buf           = pc_w173;


wire                             spc174_inst_done_buf  = spc174_inst_done;
wire [63:0]                      pc_w174_buf           = pc_w174;


wire                             spc175_inst_done_buf  = spc175_inst_done;
wire [63:0]                      pc_w175_buf           = pc_w175;


wire                             spc176_inst_done_buf  = spc176_inst_done;
wire [63:0]                      pc_w176_buf           = pc_w176;


wire                             spc177_inst_done_buf  = spc177_inst_done;
wire [63:0]                      pc_w177_buf           = pc_w177;


wire                             spc178_inst_done_buf  = spc178_inst_done;
wire [63:0]                      pc_w178_buf           = pc_w178;


wire                             spc179_inst_done_buf  = spc179_inst_done;
wire [63:0]                      pc_w179_buf           = pc_w179;


wire                             spc180_inst_done_buf  = spc180_inst_done;
wire [63:0]                      pc_w180_buf           = pc_w180;


wire                             spc181_inst_done_buf  = spc181_inst_done;
wire [63:0]                      pc_w181_buf           = pc_w181;


wire                             spc182_inst_done_buf  = spc182_inst_done;
wire [63:0]                      pc_w182_buf           = pc_w182;


wire                             spc183_inst_done_buf  = spc183_inst_done;
wire [63:0]                      pc_w183_buf           = pc_w183;


wire                             spc184_inst_done_buf  = spc184_inst_done;
wire [63:0]                      pc_w184_buf           = pc_w184;


wire                             spc185_inst_done_buf  = spc185_inst_done;
wire [63:0]                      pc_w185_buf           = pc_w185;


wire                             spc186_inst_done_buf  = spc186_inst_done;
wire [63:0]                      pc_w186_buf           = pc_w186;


wire                             spc187_inst_done_buf  = spc187_inst_done;
wire [63:0]                      pc_w187_buf           = pc_w187;


wire                             spc188_inst_done_buf  = spc188_inst_done;
wire [63:0]                      pc_w188_buf           = pc_w188;


wire                             spc189_inst_done_buf  = spc189_inst_done;
wire [63:0]                      pc_w189_buf           = pc_w189;


wire                             spc190_inst_done_buf  = spc190_inst_done;
wire [63:0]                      pc_w190_buf           = pc_w190;


wire                             spc191_inst_done_buf  = spc191_inst_done;
wire [63:0]                      pc_w191_buf           = pc_w191;


wire                             spc192_inst_done_buf  = spc192_inst_done;
wire [63:0]                      pc_w192_buf           = pc_w192;


wire                             spc193_inst_done_buf  = spc193_inst_done;
wire [63:0]                      pc_w193_buf           = pc_w193;


wire                             spc194_inst_done_buf  = spc194_inst_done;
wire [63:0]                      pc_w194_buf           = pc_w194;


wire                             spc195_inst_done_buf  = spc195_inst_done;
wire [63:0]                      pc_w195_buf           = pc_w195;


wire                             spc196_inst_done_buf  = spc196_inst_done;
wire [63:0]                      pc_w196_buf           = pc_w196;


wire                             spc197_inst_done_buf  = spc197_inst_done;
wire [63:0]                      pc_w197_buf           = pc_w197;


wire                             spc198_inst_done_buf  = spc198_inst_done;
wire [63:0]                      pc_w198_buf           = pc_w198;


wire                             spc199_inst_done_buf  = spc199_inst_done;
wire [63:0]                      pc_w199_buf           = pc_w199;


wire                             spc200_inst_done_buf  = spc200_inst_done;
wire [63:0]                      pc_w200_buf           = pc_w200;


wire                             spc201_inst_done_buf  = spc201_inst_done;
wire [63:0]                      pc_w201_buf           = pc_w201;


wire                             spc202_inst_done_buf  = spc202_inst_done;
wire [63:0]                      pc_w202_buf           = pc_w202;


wire                             spc203_inst_done_buf  = spc203_inst_done;
wire [63:0]                      pc_w203_buf           = pc_w203;


wire                             spc204_inst_done_buf  = spc204_inst_done;
wire [63:0]                      pc_w204_buf           = pc_w204;


wire                             spc205_inst_done_buf  = spc205_inst_done;
wire [63:0]                      pc_w205_buf           = pc_w205;


wire                             spc206_inst_done_buf  = spc206_inst_done;
wire [63:0]                      pc_w206_buf           = pc_w206;


wire                             spc207_inst_done_buf  = spc207_inst_done;
wire [63:0]                      pc_w207_buf           = pc_w207;


wire                             spc208_inst_done_buf  = spc208_inst_done;
wire [63:0]                      pc_w208_buf           = pc_w208;


wire                             spc209_inst_done_buf  = spc209_inst_done;
wire [63:0]                      pc_w209_buf           = pc_w209;


wire                             spc210_inst_done_buf  = spc210_inst_done;
wire [63:0]                      pc_w210_buf           = pc_w210;


wire                             spc211_inst_done_buf  = spc211_inst_done;
wire [63:0]                      pc_w211_buf           = pc_w211;


wire                             spc212_inst_done_buf  = spc212_inst_done;
wire [63:0]                      pc_w212_buf           = pc_w212;


wire                             spc213_inst_done_buf  = spc213_inst_done;
wire [63:0]                      pc_w213_buf           = pc_w213;


wire                             spc214_inst_done_buf  = spc214_inst_done;
wire [63:0]                      pc_w214_buf           = pc_w214;


wire                             spc215_inst_done_buf  = spc215_inst_done;
wire [63:0]                      pc_w215_buf           = pc_w215;


wire                             spc216_inst_done_buf  = spc216_inst_done;
wire [63:0]                      pc_w216_buf           = pc_w216;


wire                             spc217_inst_done_buf  = spc217_inst_done;
wire [63:0]                      pc_w217_buf           = pc_w217;


wire                             spc218_inst_done_buf  = spc218_inst_done;
wire [63:0]                      pc_w218_buf           = pc_w218;


wire                             spc219_inst_done_buf  = spc219_inst_done;
wire [63:0]                      pc_w219_buf           = pc_w219;


wire                             spc220_inst_done_buf  = spc220_inst_done;
wire [63:0]                      pc_w220_buf           = pc_w220;


wire                             spc221_inst_done_buf  = spc221_inst_done;
wire [63:0]                      pc_w221_buf           = pc_w221;


wire                             spc222_inst_done_buf  = spc222_inst_done;
wire [63:0]                      pc_w222_buf           = pc_w222;


wire                             spc223_inst_done_buf  = spc223_inst_done;
wire [63:0]                      pc_w223_buf           = pc_w223;


wire                             spc224_inst_done_buf  = spc224_inst_done;
wire [63:0]                      pc_w224_buf           = pc_w224;


wire                             spc225_inst_done_buf  = spc225_inst_done;
wire [63:0]                      pc_w225_buf           = pc_w225;


wire                             spc226_inst_done_buf  = spc226_inst_done;
wire [63:0]                      pc_w226_buf           = pc_w226;


wire                             spc227_inst_done_buf  = spc227_inst_done;
wire [63:0]                      pc_w227_buf           = pc_w227;


wire                             spc228_inst_done_buf  = spc228_inst_done;
wire [63:0]                      pc_w228_buf           = pc_w228;


wire                             spc229_inst_done_buf  = spc229_inst_done;
wire [63:0]                      pc_w229_buf           = pc_w229;


wire                             spc230_inst_done_buf  = spc230_inst_done;
wire [63:0]                      pc_w230_buf           = pc_w230;


wire                             spc231_inst_done_buf  = spc231_inst_done;
wire [63:0]                      pc_w231_buf           = pc_w231;


wire                             spc232_inst_done_buf  = spc232_inst_done;
wire [63:0]                      pc_w232_buf           = pc_w232;


wire                             spc233_inst_done_buf  = spc233_inst_done;
wire [63:0]                      pc_w233_buf           = pc_w233;


wire                             spc234_inst_done_buf  = spc234_inst_done;
wire [63:0]                      pc_w234_buf           = pc_w234;


wire                             spc235_inst_done_buf  = spc235_inst_done;
wire [63:0]                      pc_w235_buf           = pc_w235;


wire                             spc236_inst_done_buf  = spc236_inst_done;
wire [63:0]                      pc_w236_buf           = pc_w236;


wire                             spc237_inst_done_buf  = spc237_inst_done;
wire [63:0]                      pc_w237_buf           = pc_w237;


wire                             spc238_inst_done_buf  = spc238_inst_done;
wire [63:0]                      pc_w238_buf           = pc_w238;


wire                             spc239_inst_done_buf  = spc239_inst_done;
wire [63:0]                      pc_w239_buf           = pc_w239;


wire                             spc240_inst_done_buf  = spc240_inst_done;
wire [63:0]                      pc_w240_buf           = pc_w240;


wire                             spc241_inst_done_buf  = spc241_inst_done;
wire [63:0]                      pc_w241_buf           = pc_w241;


wire                             spc242_inst_done_buf  = spc242_inst_done;
wire [63:0]                      pc_w242_buf           = pc_w242;


wire                             spc243_inst_done_buf  = spc243_inst_done;
wire [63:0]                      pc_w243_buf           = pc_w243;


wire                             spc244_inst_done_buf  = spc244_inst_done;
wire [63:0]                      pc_w244_buf           = pc_w244;


wire                             spc245_inst_done_buf  = spc245_inst_done;
wire [63:0]                      pc_w245_buf           = pc_w245;


wire                             spc246_inst_done_buf  = spc246_inst_done;
wire [63:0]                      pc_w246_buf           = pc_w246;


wire                             spc247_inst_done_buf  = spc247_inst_done;
wire [63:0]                      pc_w247_buf           = pc_w247;


wire                             spc248_inst_done_buf  = spc248_inst_done;
wire [63:0]                      pc_w248_buf           = pc_w248;


wire                             spc249_inst_done_buf  = spc249_inst_done;
wire [63:0]                      pc_w249_buf           = pc_w249;


wire                             spc250_inst_done_buf  = spc250_inst_done;
wire [63:0]                      pc_w250_buf           = pc_w250;


wire                             spc251_inst_done_buf  = spc251_inst_done;
wire [63:0]                      pc_w251_buf           = pc_w251;


wire                             spc252_inst_done_buf  = spc252_inst_done;
wire [63:0]                      pc_w252_buf           = pc_w252;


wire                             spc253_inst_done_buf  = spc253_inst_done;
wire [63:0]                      pc_w253_buf           = pc_w253;


wire                             spc254_inst_done_buf  = spc254_inst_done;
wire [63:0]                      pc_w254_buf           = pc_w254;


wire                             spc255_inst_done_buf  = spc255_inst_done;
wire [63:0]                      pc_w255_buf           = pc_w255;




reg 	 ok_iob;
initial
begin
    ok_iob    = 0;
    fake_iob_out_data  = 0;
end

integer cpx_driven;

//// cmp clock domain
//// trin bug #65: use reference clock from the chip b/c the fake iob
//// needs to monitor the core PC
//always @(negedge `CHIP.clk_muxed)
//begin
//    if(ok_iob)
//    begin
            
//        cpx_driven = drive_iob();
//        if (cpx_driven) begin
//            fake_iob_out_data[`CPX_WIDTH-1:128] = get_cpx_word(0);
//            fake_iob_out_data[127:96] = get_cpx_word(1);
//            fake_iob_out_data[95:64] = get_cpx_word(2);
//            fake_iob_out_data[63:32] = get_cpx_word(3);
//            fake_iob_out_data[31:0] = get_cpx_word(4);
//            //$display("Doing IOB stuff - got values: %x %x %x %x %x", fake_iob_out_data[159:128], fake_iob_out_data[127:96], fake_iob_out_data[95:64], fake_iob_out_data[63:32], fake_iob_out_data[31:0]);
//        end else begin
//            fake_iob_out_data = {160{1'b0}};
//        end
//
//        // a little error check
//        if (iob_buffer_val && (out_buffer_val[out_write_index] | out_buffer_val[out_write_index + 1] == 1'b1))
//        begin
//            $display("%d : Simulation -> FAIL(%0s)", $time, "ciop_iob.v: IOB out buffer overflowed");
//            repeat(5)@(posedge clk);
//`ifndef DISABLE_ALL_MONITORS
//            `MONITOR_PATH.fail("ciop_iob.v: IOB out buffer overflowed");
//`endif
//        end
//    end // if (ok_iob)
//end // always @ (posedge cmp_gclk)

endmodule
