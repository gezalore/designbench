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

module top();

  bit clk = 0;
  always #5 clk = ~clk;

`ifdef ALL_CAPS
  import "DPI-C" function string uppercase(input string s);
`endif

  string str = "Hello World";
  initial begin
    $value$plusargs("greeting=%s", str);
`ifdef ALL_CAPS
    str = uppercase(str);
`endif
  end

  int unsigned cnt = 0;
  always @(posedge clk) begin
    ++cnt;
    if (cnt % 200000 == 0) begin
      $display("%8d - %s!", cnt, str);
    end
    if (cnt == 1000000) begin
      $finish;
    end
  end

`include "__rtlmeter_top_include.vh"

endmodule
