module top();

  bit clk = 0;

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

    #5 clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;
    #5 clk = ~clk;
    $finish;
  end

  always @(posedge clk) begin
    $display("%s", str);
  end

  `include "__designbench_misc_include.vh"
endmodule
