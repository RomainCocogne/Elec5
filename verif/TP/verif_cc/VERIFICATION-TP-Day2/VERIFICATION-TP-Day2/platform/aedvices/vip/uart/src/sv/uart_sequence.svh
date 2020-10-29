/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_sequence.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_sequence declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// \brief UART Sequence base class.
/// \details  Use a base class to define further sequence and sequence libraries
class uart_sequence extends uvm_sequence #(uart_frame);
`pragma protect begin

  /// constructor
  function new(string name="uart_sequence");
    super.new(name);
  endfunction

`uvm_object_utils(uart_sequence)
`pragma protect end

endclass

/// @}
/// @}
/// @}
