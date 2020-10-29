/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_sequence_lib.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// \file
/// Generic UART VIP

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg
/// @{
/// \addtogroup seqlib
/// @{



/// \brief Defines Regular Uart Frame
class uart_single_frame_seq extends uart_sequence;

  /// \todo provide all attributes of uart_frame here so that we can drive a single frame from the virtual sequencer
  rand int unsigned delay; ///< interframe delay prior to send the current frame
  rand bit [`UART_DATA_MAX_WIDTH-1:0] data;    ///< data to be transmitted
  rand bit parity_bit;    ///< Frame parity bit

  rand uart_direction_t    direction;  ///< TX or RX. Random by default.
`pragma protect begin

  /// constructor
  function new(string name="uart_single_frame");
    super.new(name);
  endfunction

  /// Sequence Body
  virtual task body();
    /// \todo use uvm_do_with and constrain all fields
    `uvm_do_with(req,
                   {
                      direction == local::direction;
                      data == local::data;
                      parity_bit == local::parity_bit;
                      delay == local::delay;
                      stop_bit_error == 0;
                      parity_bit_error == 0;
                      start_bit_error == 0;
                      baudrate_error == 0;
                   }
                )

  endtask


  `uvm_object_utils(uart_single_frame_seq)
`pragma protect end

endclass


/// Defines Regular Uart Frame, with possible error injection
class uart_single_frame_with_error_injection_seq extends uart_sequence;

  /// \todo provide all attributes of uart_frame here so that we can drive a single frame from the virtual sequencer
  rand int unsigned delay; ///< interframe delay prior to send the current frame
  rand bit [`UART_DATA_MAX_WIDTH-1:0] data;    ///< data to be transmitted
  rand bit parity_bit;    ///< Frame parity bit

  rand uart_direction_t    direction;  ///< TX or RX. Random by default.

  //Packet control
  rand bit[2:0] nb_of_errors; //Defines the possible numbers of errors
  rand bit force_on_error;    //Force the error generation
  rand bit error_on_stop_bit;
  rand bit error_on_parity_bit;
  rand bit error_on_start_bit;
  rand bit error_on_baudrate;

  //Type of errors
  rand bit stop_bit_error;
  rand bit parity_bit_error;
  rand bit start_bit_error;
  rand bit baudrate_error;

  bit[2:0] nb_of_errors_cnt =0; //Provide the number of errors of the current frame
`pragma protect begin

  constraint resp_in_error_c
  {
    ((force_on_error == 0) && (nb_of_errors > 0) && (error_on_stop_bit == 1))  -> stop_bit_error dist { 0:=95, 1:=5 };
    ((force_on_error == 0) && (nb_of_errors == 0) && (error_on_stop_bit == 1)) -> stop_bit_error dist { 0:=100, 1:=0 };
    ((force_on_error == 1)  && (error_on_stop_bit == 1))                       -> stop_bit_error dist { 1:=100, 0:=0 };
    (error_on_stop_bit == 0)                                                   -> stop_bit_error dist { 0:=100, 1:=0 };

    ((force_on_error == 0) && (nb_of_errors > 0) && (error_on_parity_bit == 1))  -> parity_bit_error dist { 0:=95, 1:=5 };
    ((force_on_error == 0) && (nb_of_errors == 0) && (error_on_parity_bit == 1)) -> parity_bit_error dist { 0:=100, 1:=0 };
    ((force_on_error == 1)  && (error_on_parity_bit == 1))                       -> parity_bit_error dist { 1:=100, 0:=0 };
    (error_on_parity_bit == 0)                                                   -> parity_bit_error dist { 0:=100, 1:=0 };

    ((force_on_error == 0) && (nb_of_errors > 0) && (error_on_start_bit == 1))  -> start_bit_error dist { 0:=95, 1:=5 };
    ((force_on_error == 0) && (nb_of_errors == 0) && (error_on_start_bit == 1)) -> start_bit_error dist { 0:=100, 1:=0 };
    ((force_on_error == 1)  && (error_on_start_bit == 1))                       -> start_bit_error dist { 1:=100, 0:=0 };
    (error_on_start_bit == 0)                                                   -> start_bit_error dist { 0:=100, 1:=0 };

    ((force_on_error == 0) && (nb_of_errors > 0) && (error_on_baudrate == 1))  -> baudrate_error dist { 0:=95, 1:=5 };
    ((force_on_error == 0) && (nb_of_errors == 0) && (error_on_baudrate == 1)) -> baudrate_error dist { 0:=100, 1:=0 };
    ((force_on_error == 1)  && (error_on_baudrate == 1))                       -> baudrate_error dist { 1:=100, 0:=0 };
    (error_on_baudrate == 0)                                                   -> baudrate_error dist { 0:=100, 1:=0 };

  }

  /// constructor
  function new(string name="uart_single_frame_with_error_injection");
    super.new(name);
  endfunction

  /// Sequence Body
  virtual task body();
    /// \todo use uvm_do_with and constrain all fields
    `uvm_do_with(req,
                   {
                      direction == local::direction;
                      data == local::data;
                      parity_bit == local::parity_bit;
                      delay == local::delay;
                      stop_bit_error == local::stop_bit_error;
                      parity_bit_error == local::parity_bit_error;
                      start_bit_error == local::start_bit_error;
                      baudrate_error == local::baudrate_error;
                   }
                )
    if ((req.stop_bit_error == 1) || (req.parity_bit_error == 1) || (req.start_bit_error == 1) || (req.baudrate_error == 1))
      nb_of_errors_cnt ++;
    `uvm_info(get_name(),$psprintf("nb_of_errors_cnt ==  %d , stop = %d, parity = %d, start = %d, baudrate = %d ",nb_of_errors_cnt, req.stop_bit_error, req.parity_bit_error, req.start_bit_error, req.baudrate_error),UVM_FULL)

    //Update transaction
    stop_bit_error = req.stop_bit_error;
    parity_bit_error = req.parity_bit_error;
    start_bit_error = req.start_bit_error;
    baudrate_error = req.baudrate_error;

  endtask


  `uvm_object_utils(uart_single_frame_with_error_injection_seq)
`pragma protect end

endclass









/// @}
/// @}
/// @}
