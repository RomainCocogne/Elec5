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
// $Id: uart_ip_verif_pkg.sv 445 2018-05-15 09:05:58Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-05-15 11:05:58 +0200 (Tue, 15 May 2018) $
// $Revision: 445 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


/// UART IP Verif Main Package
/// Declare all base classes
package uart_wb_ip_verif_pkg;

  `include "uvm_macros.svh"


  import uvm_pkg::*;
  import aed_uart_pkg::*;
  import aed_wishbone_pkg::*;

  

`include "uart_defines.v"
`include "uart_reg_addresses.svh"
`include "uart_wb_ip_verif_base_sequence.svh"
`include "uart_wb_ip_verif_default_sequence.svh"  
`include "uart_wb_ip_verif_config_monitor.svh"
`include "uart_wb_ip_verif_env.svh"               
`include "uart_wb_ip_verif_base_test.svh"      
`include "my_uart_scoreboard.svh"


`ifdef USE_DPI
  `include "uart_dpi_stub.svh"
  `include "uart_dpi_test.sv"
`endif

endpackage : uart_wb_ip_verif_pkg