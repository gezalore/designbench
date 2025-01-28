
module DifftestArchEvent(
  input         clock,
  input         enable,
  input         io_valid,
  input  [31:0] io_interrupt,
  input  [31:0] io_exception,
  input  [63:0] io_exceptionPC,
  input  [31:0] io_exceptionInst,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestArchFpRegState(
  input         clock,
  input         enable,
  input  [63:0] io_value_0,
  input  [63:0] io_value_1,
  input  [63:0] io_value_2,
  input  [63:0] io_value_3,
  input  [63:0] io_value_4,
  input  [63:0] io_value_5,
  input  [63:0] io_value_6,
  input  [63:0] io_value_7,
  input  [63:0] io_value_8,
  input  [63:0] io_value_9,
  input  [63:0] io_value_10,
  input  [63:0] io_value_11,
  input  [63:0] io_value_12,
  input  [63:0] io_value_13,
  input  [63:0] io_value_14,
  input  [63:0] io_value_15,
  input  [63:0] io_value_16,
  input  [63:0] io_value_17,
  input  [63:0] io_value_18,
  input  [63:0] io_value_19,
  input  [63:0] io_value_20,
  input  [63:0] io_value_21,
  input  [63:0] io_value_22,
  input  [63:0] io_value_23,
  input  [63:0] io_value_24,
  input  [63:0] io_value_25,
  input  [63:0] io_value_26,
  input  [63:0] io_value_27,
  input  [63:0] io_value_28,
  input  [63:0] io_value_29,
  input  [63:0] io_value_30,
  input  [63:0] io_value_31,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestArchIntRegState(
  input         clock,
  input         enable,
  input  [63:0] io_value_0,
  input  [63:0] io_value_1,
  input  [63:0] io_value_2,
  input  [63:0] io_value_3,
  input  [63:0] io_value_4,
  input  [63:0] io_value_5,
  input  [63:0] io_value_6,
  input  [63:0] io_value_7,
  input  [63:0] io_value_8,
  input  [63:0] io_value_9,
  input  [63:0] io_value_10,
  input  [63:0] io_value_11,
  input  [63:0] io_value_12,
  input  [63:0] io_value_13,
  input  [63:0] io_value_14,
  input  [63:0] io_value_15,
  input  [63:0] io_value_16,
  input  [63:0] io_value_17,
  input  [63:0] io_value_18,
  input  [63:0] io_value_19,
  input  [63:0] io_value_20,
  input  [63:0] io_value_21,
  input  [63:0] io_value_22,
  input  [63:0] io_value_23,
  input  [63:0] io_value_24,
  input  [63:0] io_value_25,
  input  [63:0] io_value_26,
  input  [63:0] io_value_27,
  input  [63:0] io_value_28,
  input  [63:0] io_value_29,
  input  [63:0] io_value_30,
  input  [63:0] io_value_31,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestCSRState(
  input         clock,
  input         enable,
  input  [63:0] io_priviledgeMode,
  input  [63:0] io_mstatus,
  input  [63:0] io_sstatus,
  input  [63:0] io_mepc,
  input  [63:0] io_sepc,
  input  [63:0] io_mtval,
  input  [63:0] io_stval,
  input  [63:0] io_mtvec,
  input  [63:0] io_stvec,
  input  [63:0] io_mcause,
  input  [63:0] io_scause,
  input  [63:0] io_satp,
  input  [63:0] io_mip,
  input  [63:0] io_mie,
  input  [63:0] io_mscratch,
  input  [63:0] io_sscratch,
  input  [63:0] io_mideleg,
  input  [63:0] io_medeleg,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestDebugMode(
  input         clock,
  input         enable,
  input         io_debugMode,
  input  [63:0] io_dcsr,
  input  [63:0] io_dpc,
  input  [63:0] io_dscratch0,
  input  [63:0] io_dscratch1,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestFpWriteback(
  input         clock,
  input         enable,
  input         io_valid,
  input  [ 7:0] io_address,
  input  [63:0] io_data,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestInstrCommit(
  input         clock,
  input         enable,
  input         io_valid,
  input         io_skip,
  input         io_isRVC,
  input         io_rfwen,
  input         io_fpwen,
  input         io_vecwen,
  input  [ 7:0] io_wpdest,
  input  [ 7:0] io_wdest,
  input  [63:0] io_pc,
  input  [31:0] io_instr,
  input  [ 9:0] io_robIdx,
  input  [ 6:0] io_lqIdx,
  input  [ 6:0] io_sqIdx,
  input         io_isLoad,
  input         io_isStore,
  input  [ 7:0] io_nFused,
  input  [ 7:0] io_special,
  input  [ 7:0] io_coreid,
  input  [ 7:0] io_index
);
endmodule

module DifftestIntWriteback(
  input         clock,
  input         enable,
  input         io_valid,
  input  [ 7:0] io_address,
  input  [63:0] io_data,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestLrScEvent(
  input         clock,
  input         enable,
  input         io_valid,
  input         io_success,
  input  [ 7:0] io_coreid
);
endmodule

module DifftestTrapEvent(
  input         clock,
  input         enable,
  input         io_hasTrap,
  input  [63:0] io_cycleCnt,
  input  [63:0] io_instrCnt,
  input         io_hasWFI,
  input  [ 2:0] io_code,
  input  [63:0] io_pc,
  input  [ 7:0] io_coreid
);
  always @(posedge clock) begin
    if (enable && io_hasTrap) begin
      if (io_code == 0) begin
        $display("Hit Good Trap");
      end else begin
        $display("Hit Other Trap");
      end
      $finish;
    end
  end
endmodule
