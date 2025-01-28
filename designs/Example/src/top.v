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

`include "__designbench_top_include.vh"
endmodule
