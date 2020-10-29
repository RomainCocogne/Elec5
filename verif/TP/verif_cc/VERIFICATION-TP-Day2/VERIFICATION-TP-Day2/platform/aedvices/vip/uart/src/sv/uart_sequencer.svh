/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_sequencer.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_sequencer declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// \brief UART Sequencer
/// \details Master Tx Sequencer or Slave Rx Sequencer
class uart_sequencer extends uvm_sequencer#(uart_frame);

  /// Import transactions from monitor
  uvm_analysis_export #(uart_frame) received_frame_import;

  /// Fifo to store transactions from monitor
  uvm_tlm_analysis_fifo #(uart_frame) received_frame_fifo;

`pragma protect begin
  uart_agent p_agent = null;

  // UVM Methods
  extern function new(string name="sequencer",uvm_component parent=null);
  extern function void connect_phase(uvm_phase phase);

  // UVM DB registration
  `uvm_component_utils_begin(uart_sequencer)
  `uvm_component_utils_end
`pragma protect end
endclass

/// @}
/// @}
/// @}
