// ===============================================================================
//                    Copyright (c) 2015 - AEDVICES Consulting
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developped by AEDVICES Consulting for 
// training purposes.  
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================
// Copyright (c) 2016-2017 - AEDVICES Consulting 
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_ip_tb.sv 471 2018-09-17 19:13:50Z francois $
// $Author: francois $
// $LastChangedDate: 2018-09-17 21:13:50 +0200 (lun., 17 sept. 2018) $
// $Revision: 471 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

`include "uart_defines.v"
`include "apb_if.sv"
`include "uart_if.sv"


`ifdef USE_DPI
  `include "terminal_bench.sv"
`endif
`timescale 1ns/100ps

module uart_tb();

  import uvm_pkg::*;
  import aed_apb_pkg::*;
  import uart_ip_verif_pkg::*;
  import apb2wb_pkg::*;

  `ifdef IMPORT_LAB_PKG
    // FIXME: what is this for ? >  import lab_test_pkg::*; // package to find 
  `endif

  // Generic Signals
  reg PCLK;
  reg PRESETn;
  time timeout = 500ms;

  apb_if      apbif0   (PCLK, PRESETn);
  uart_if     uartif0 ();

  // Clock Generation - 40MHz
  initial
  begin
    #7;
    PCLK <= 0;
    forever begin
      #12.5ns;
      PCLK <= ~ PCLK;  
    end
  end

  // Reset Generation
  initial
  begin
    PRESETn <= 'bz;
    #100ns;
    PRESETn <= 'b0;
    repeat (4) @(posedge PCLK);
    PRESETn <= 'b1;

    // Prevent users to wait for ages when there are test issues.
    #timeout;
    `uvm_fatal("TESTBENCH","timeout at 500 ms");
  end
  
  uart_apb uart0 (
      
      .PCLK_i     ( apbif0.PCLK    )   ,
      .PRESETn_i  ( apbif0.PRESETn )   ,
      .PADDR_i    ( apbif0.PADDR   )   ,
      .PPROT_i    ( apbif0.PPROT   )   ,
      .PSEL_i     ( apbif0.PSEL    )   ,
      .PENABLE_i  ( apbif0.PENABLE )   ,
      .PWRITE_i   ( apbif0.PWRITE  )   ,
      .PWDATA_i   ( apbif0.PWDATA  )   ,
      .PSTRB_i    ( apbif0.PSTRB   )   ,
      .PREADY_o   ( apbif0.PREADY  )   ,
      .PRDATA_o   ( apbif0.PRDATA  )   ,
      .PSLVERR_o  ( apbif0.PSLVERR )   ,
      // Serial Signals
      .rx_i      ( uartif0.rx.sig ) ,
      .tx_o      ( uartif0.tx.sig ) ,
      .int_o     ( ) // open 
    );
    assert property (
	@(posedge apbif0.PCLK)   
	! apbif0.PRESETn |=> ! apbif0.PSEL     
    ); 
   assert property (
	@(posedge apbif0.PSEL)   
	apbif0.PSEL |=> apbif0.PENABLE      
    );

  // UVM Setup
  initial
  begin
    
    uvm_config_db#(virtual apb_if )::set(uvm_root::get(), "uvm_test_top.verif_env0.apb_env0.master0"       , "vif", apbif0   );
    uvm_config_db#(virtual uart_if)::set(uvm_root::get(), "uvm_test_top.verif_env0.uart_env0.uart_agent0"  , "vif", uartif0 );
    run_test();
  end

`ifdef USE_DPI
  terminal_bench terminal0(.stim_clk(wbif0.clk));
`endif


endmodule
