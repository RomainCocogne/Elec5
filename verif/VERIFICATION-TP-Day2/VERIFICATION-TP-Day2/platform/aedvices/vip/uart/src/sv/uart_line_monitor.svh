/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_line_monitor.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_line_monitor declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{


/// UART Rx/Tx Line Monitor
class uart_line_monitor extends uvm_monitor;

  uart_agent p_agent = null;               /// < backpointer to agent container
  virtual interface uart_line_if line_vif; /// < Virtual Interface
  uart_monitor_kind_t kind;                /// < TX or RX

  // Analysis port
  uvm_analysis_port #(uart_frame) completed_byte; ///< a Byte has been completely received.

`pragma protect begin

  //---------------------------------
  // General UVM tasks and functions
  extern function new(string name="uart_line_monitor",uvm_component parent=null);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task reset_phase(uvm_phase phase);

  //---------------------------------
  // Uart monitoring task
  extern virtual task monitor_uart_line();
  extern virtual task detect_frame();


  //---------------------------------
  // Private/Protected Field Members
  protected string monitored_string;

  protected semaphore clock_r_sem;
  protected bit retreived_clock_running;
  protected event start_bit_detected_ev;
  extern protected virtual task start_retreived_clock();
  extern protected virtual task stop_retreived_clock();
  extern protected virtual task gen_retreived_clock();

  extern protected virtual function bit compute_parity(uart_parity_t parity, bit[`UART_DATA_MAX_WIDTH-1:0] data, int size);

  /// UVM DB registration
  `uvm_component_utils(uart_line_monitor)

`pragma protect end

endclass



/// @}
/// @}
/// @}
