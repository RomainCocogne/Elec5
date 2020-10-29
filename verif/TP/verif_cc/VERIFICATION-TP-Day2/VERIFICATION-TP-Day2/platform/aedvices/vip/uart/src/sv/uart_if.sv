/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_if.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// \file
/// Generic UART VIP

`include "uart_defines.svh"
`include "uvm_macros.svh"

/// UART Line Interface
interface uart_line_if();

 // Control flags
  bit                has_parity_checks = 1;     ///< assertions are globally enabled
  bit                has_stop_checks   = 1;     ///< assertions are globally enabled
  bit                has_start_checks  = 1;     ///< assertions are globally enabled

  // UART Interface Line
  logic              sig;               /// sig : data line

  logic internal_clock; ///< Uart Internal Clock, used for driving
  logic retreived_clock;///< Uart Internal Clock, used for monitoring

endinterface


/// UART Rx/Tx Dual Interface
interface uart_if();
  /// Configuration fields .
  /// \todo get it from uart_config
  // Control flags
  bit                has_checks = 1;     ///< <b>has_checks</b>  : assertions are globally enabled
  bit                has_coverage = 1;   ///< <b>has_coverage</b>: when 1, protocol coverage is enabled

  // UVM links
  string name = "uart_interface";
  string agent_path = "";

  // UART Interface - inputs/outputs
  uart_line_if       tx();               /// sig : data line RX/TX
  uart_line_if       rx();               /// sig : data line RX/TX

`pragma protect begin
  // UART Interface - addtionnal inputs/outputs
//  logic              sig_cts;               /// sig_cts: Clear To Send
//  logic              sig_rts;               /// sig_rts: Ready To Send

	// Assertions
	/// \todo: UART assertions
`pragma protect end

endinterface
