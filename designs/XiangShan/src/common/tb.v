// Copyright 2025 RTLMeter contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

module tb;

  bit        clock = 0;
  bit        reset = 1;
  bit        difftest_uart_out_valid;
  bit [7:0]  difftest_uart_out_ch;

  initial #100 reset = 0;
  always #1 clock = ~clock;

  SimTop top(
    .clock(clock),
    .reset(reset),
    .difftest_step(),
    .difftest_perfCtrl_clean(1'b0),
    .difftest_perfCtrl_dump(1'b0),
    .difftest_logCtrl_begin(64'h0),
    .difftest_logCtrl_end(64'h0),
    .difftest_logCtrl_level(64'h0),
    .difftest_uart_out_valid(difftest_uart_out_valid),
    .difftest_uart_out_ch(difftest_uart_out_ch),
    .difftest_uart_in_valid(),
    .difftest_uart_in_ch(8'hff)
  );

  always @(posedge clock) begin
    if (!reset && difftest_uart_out_valid) begin
      if (difftest_uart_out_ch != 8'h0d) begin
        $write("%c", difftest_uart_out_ch);
        $fflush();
      end
    end
  end

  import "DPI-C" function void ram_write(
    input  longint index,
    input  longint data,
    input  longint mask
  );

  initial begin
    longint iterations;
    if ($value$plusargs("iterations=%d", iterations)) begin
      $display("Iterations: %0d", iterations);
      ram_write(64'h200/8, iterations, 64'hffff_ffff_ffff_ffff);
    end
  end

`include "__rtlmeter_top_include.vh"

endmodule
