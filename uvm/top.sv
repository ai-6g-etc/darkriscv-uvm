import uvm_pkg::*;
`include "uvm_macros.svh"
`include "./darksocv_if.sv"
`include "../rtl/darksocv.v"
`include "../rtl/darkriscv.v"
`include "../rtl/darkpll.v"
`include "../rtl/darkuart.v"
`include "../rtl/config.vh"
`include "./packet_darksocv.sv"
`include "./sequence_in.sv"
`include "./sequencer.sv"
`include "./driver.sv"
`include "./driver_out.sv"
`include "./monitor.sv"
`include "./monitor_out.sv"
`include "./agent.sv"
`include "./agent_out.sv"
`include "./refmod.sv"
`include "./comparator.sv"
`include "./env.sv"
`include "./simple_test.sv"

module top;
  logic XCLK;
  logic XRES;
  
  initial begin
    XCLK = 0;
    XRES = 1;
    #22 XRES = 0;
  end
  
  always #5 XCLK = !XCLK;
  
  darksocv_if dut(XCLK, XRES);
  
  darksocv u_darksocv(
    .XCLK(dut.XCLK),
    .XRES(dut.XRES),
    .UART_RXD(dut.UART_RXD),
    .UART_TXD(dut.UART_TXD),
    .LED(dut.LED),
    .DEBUG(dut.DEBUG)
  );

    initial begin
		$fsdbDumpfile("top.fsdb");
		$fsdbDumpvars();
		$fsdbDumpMDA();
		$dumpvars();
		#200000 $finish;
    end

  initial begin
    
    uvm_config_db#(virtual darksocv_if)::set(uvm_root::get(), "*", "darksocv_vif", dut);
    
    run_test("simple_test");
  end
endmodule
