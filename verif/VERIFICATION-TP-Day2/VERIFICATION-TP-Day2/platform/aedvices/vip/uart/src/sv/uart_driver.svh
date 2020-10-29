/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_driver.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_driver declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// \brief UART Serial Line Driver
/// \details MAster Tx Driver or Slave Rx Driver
class uart_driver extends uvm_driver #(uart_frame);

  virtual uart_line_if vif; ///< UART Interface
  uart_agent      p_agent;  ///< backpointer to agent

  extern function new(string name="driver",uvm_component parent=null);
  extern protected virtual function bit compute_parity(uart_parity_t parity, bit[`UART_DATA_MAX_WIDTH-1:0] data, int size, bit error);

`pragma protect begin

  extern task run_phase(uvm_phase phase);
  extern task get_and_drive();
  extern task drive_frame(uart_frame frame);
  extern protected virtual task drive_bit(bit val);

  //---------------------------------
  // Private/Protected Field Members
  protected semaphore clock_sem;
  protected bit internal_clock_running;
  protected event stop_clock_ev;
  extern protected virtual task start_internal_clock();
  extern protected virtual task stop_internal_clock();
  extern protected virtual task gen_internal_clock();
  protected bit prev_data = 0;

  /// UVM DB registration
  `uvm_component_utils(uart_driver)
`pragma protect end

endclass



/// @}
/// @}
/// @}
