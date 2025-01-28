module top();

  bit clk = 0;
  always #5 clk = ~clk;


  string str = "Hello";
  initial begin
    static int say_world = 0;
    if ($value$plusargs("say_world=%d", say_world)) begin
      if (say_world != 0) begin
        str = "World";
      end
    end
`ifdef SHOUT
    str = str.toupper();
`endif
  end

  int unsigned cnt = 0;
  always @(posedge clk) begin
    ++cnt;
    if (cnt % 200000 == 0) begin
      $display("%s @ %0d", str, cnt);
    end
    if (cnt == 1000000) begin
      $finish;
    end
  end

`include "__designbench_top_include.vh"
endmodule
