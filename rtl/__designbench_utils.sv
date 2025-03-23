// Copyright (c) 2025, designbench contributors

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
