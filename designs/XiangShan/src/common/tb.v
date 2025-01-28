
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

`include "__designbench_top_include.vh"

endmodule
