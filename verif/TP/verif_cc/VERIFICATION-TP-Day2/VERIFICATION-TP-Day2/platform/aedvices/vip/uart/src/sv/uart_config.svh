/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_config.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_config declaration
 */

`ifndef UART_CONFIG_HEADER
`define UART_CONFIG_HEADER

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// Generic UART Agent Configuration Class
class uart_config extends uvm_object;

  rand bit                 has_coverage; ///< Enable the monitor to collect frame coverage \n Default = 1 \n \todo coverage implementation

  rand uart_parity_t       parity;     ///< Define the parity configuration
  rand uart_frame_size_t   size;       ///< Define the size of each frame
  rand uart_frame_stop_format_t stop_format;     ///< Define the format of the current frame


  /// Min/Max Delay Settings
  rand int unsigned min_interframe; ///< minimum cycles between two frames
  rand int unsigned max_interframe; ///< minimum cycles between two frames

  rand int unsigned min_baud_rate; ///< Min baud rate Uart Transmission (in bit-per-second).
  rand int unsigned max_baud_rate; ///< Max baud rate Uart Transmission (in bit-per-second).
  rand int unsigned baud_rate;     ///< Theoritical baud rate Uart Transmission (in bit-per-second).

  //Packet control
  rand bit illegal_frame;     ///< Defines the Frame corruptions.

  // Debug/Display Settings
  rand bit print_tx_char;   ///< Enable printing of tx char from monitor (default: disabled)
  rand bit print_rx_char;   ///< Enable printing of rx char from monitor (default: disabled)
  rand bit print_tx_string; ///< Enable printing of tx string ending with '\n' from monitor (default: disabled)
  rand bit print_rx_string; ///< Enable printing of rx string ending with '\n' from monitor (default: disabled)

`pragma protect begin

  uart_agent_kind_t        kind; ///< Agent Kind: TX, RX, MONITOR. \todo check if used and needed

//  rand bit stop_bit_error;  ///< Defines the Stop Bit corruption.
//  rand bit parity_bit_error;///< Defines the Parity Bit corruption.
//  rand bit start_bit_error; ///< Defines the Start Bit corruption.
//  rand bit baudrate_error;  ///< Defines the BaudRate corruption.

  /// Hard constraints
  constraint min_max_relation_c {
    min_interframe <= max_interframe;
    min_baud_rate  <= max_baud_rate;
    min_baud_rate  <= baud_rate;
    baud_rate      <= max_baud_rate;
  }

  // Soft Constraints for default configuration
  /// \todo allow a soft reset mechanism thru constructor
  constraint uart_config_default_c {
    soft min_interframe inside {[0:10]};
    soft max_interframe inside {[0:100]};

    soft min_baud_rate == 2000; // 2MBps
    soft max_baud_rate == 400000; // 400Mps
    soft baud_rate     == min_baud_rate; // 2MBps

    soft parity == ODD;
    soft size == bits_8;
    soft stop_format == stop_2;


    soft print_tx_char   == 0; // disable debug by default
    soft print_rx_char   == 0; // disable debug by default
    soft print_tx_string == 0; // disable debug by default
    soft print_rx_string == 0; // disable debug by default

  }

  // Soft Constraints regarding Packet control for default configuration
  constraint default_packet_ctrl_c {
    soft illegal_frame == 0;
    soft has_coverage == 1;
//    soft stop_bit_error == 0;
//    soft parity_bit_error == 0;
//    soft start_bit_error == 0;
//    soft baudrate_error == 0;
  }

/*  constraint default_illegal_packet_ctrl_c {
    illegal_frame == 1 -> stop_bit_error inside {0,1};
    illegal_frame == 1 -> parity_bit_error inside {0,1};
    illegal_frame == 1 -> start_bit_error inside {0,1};
    illegal_frame == 1 -> baudrate_error inside {0,1};
  }
*/
  extern function new(string name="");

  `uvm_object_utils_begin(uart_config)
    `uvm_field_enum(uart_parity_t,       parity,  UVM_ALL_ON)
    `uvm_field_enum(uart_frame_size_t,     size,  UVM_ALL_ON)
    `uvm_field_enum(uart_frame_stop_format_t, stop_format,  UVM_ALL_ON)
    `uvm_field_int(min_baud_rate,        UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(max_baud_rate,        UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(baud_rate,            UVM_ALL_ON | UVM_UNSIGNED)
    `uvm_field_int(min_interframe,        UVM_ALL_ON)
    `uvm_field_int(max_interframe,        UVM_ALL_ON)
    `uvm_field_int(illegal_frame, UVM_ALL_ON + UVM_DEC)
//    `uvm_field_int(stop_bit_error, UVM_ALL_ON + UVM_DEC)
//    `uvm_field_int(parity_bit_error, UVM_ALL_ON + UVM_DEC)
//    `uvm_field_int(start_bit_error, UVM_ALL_ON + UVM_DEC)
//    `uvm_field_int(baudrate_error, UVM_ALL_ON + UVM_DEC)
  `uvm_object_utils_end

`pragma protect end

endclass



/// @}
/// @}
/// @}


`endif
