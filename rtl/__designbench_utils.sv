// Copyright 2025 designbench contributors
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

module __designbench_utils;

  initial begin
    if ($test$plusargs("trace")) begin
`ifdef __DESIGNBENCH_TRACE_VCD
      $display("DESIGNBENCH: enabling VCD waveform tracing");
      $dumpfile("trace.vcd");
      $dumpvars;
`elsif __DESIGNBENCH_TRACE_FST
      $display("DESIGNBENCH: enabling FST waveform tracing");
      $dumpfile("trace.fst");
      $dumpvars;
`else
      $display("DESIGNBENCH: ERROR: this simulation was not compiled with tracing enabled");
      $finish;
      $stop;
`endif
    end
  end

  longint unsigned cycles = 0;
  always @(posedge $root.`__DESIGNBENCH_MAIN_CLOCK) ++cycles;

  final begin
    integer fd;
    fd = $fopen("_designbench_cycles.txt");
    $fwrite(fd, "%0d", cycles);
    $fclose(fd);
  end

endmodule
