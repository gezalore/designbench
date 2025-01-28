// Copyright (c) 2025, designbench contributors

module __designbench_utils(
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

  longint unsigned cycles = 0;
  always @(posedge main_clk) ++cycles;

  final begin
    integer fd;
    fd = $fopen("_designbench_cycles.txt");
    $fwrite(fd, "%0d", cycles);
    $fclose(fd);
  end

endmodule
