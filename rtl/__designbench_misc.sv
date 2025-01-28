// Copyright (c) 2025, designbench contributors

module __designbench_misc(
  input bit main_clk
);

`ifdef __DESIGNBENCH_TRACE_VCD
  initial begin
    $display("DESIGNBENCH: enabling VCD waveform tracing");
    $dumpfile("trace.vcd");
    $dumpvars;
  end
`endif

`ifdef __DESIGNBENCH_TRACE_FST
  initial begin
    $display("DESIGNBENCH: enabling FST waveform tracing");
    $dumpfile("trace.fst");
    $dumpvars;
  end
`endif

endmodule
