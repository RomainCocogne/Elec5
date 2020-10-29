/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_types.svh 1433 2018-04-11 16:13:40Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-11 18:13:40 +0200 (mer., 11 avr. 2018) $
// $Revision: 1433 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 UAERT type definitions
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Types
/// @{

`ifndef UART_TYPES_SVH
`define UART_TYPES_SVH




/// brief Agent kind ( MASTER or SLAVE )
typedef enum {
  //MONITOR , ///< UART Monitor agent only. No driving.
  MASTER ,      ///< UART MASTER agent.
  SLAVE        ///< UART SLAVE agent.
  } uart_agent_kind_t;

/// \brief Line Monitor kind (TX or RX)
typedef enum {
  TXM ,   ///< Transmitting Monitor identifier value
  RXM     ///< Receiving Monitor identifier value
  } uart_monitor_kind_t;

/// \brief Line Direction
typedef enum {
  TXL,   ///< Transmitting Line identifier value
  RXL    ///< Receiving Line identifier value
  }                  uart_direction_t;

/// \brief Parity
typedef enum {
  EVEN =0, ///< Even Parity Configuration
  ODD  =1, ///< Odd Parity Configuration
  NONE =2  ///< No Parity Configuration
  } uart_parity_t;

/// \brief Type of Uart Frame Size
typedef enum {
  bits_5=5,   ///< 5 bits per character
  bits_6=6,   ///< 6 bits per character
  bits_7=7,   ///< 7 bits per character
  bits_8=8,   ///< 8 bits per character
  bits_9=9    ///< 9 bits per character
  } uart_frame_size_t;

/// \brief Type of Uart Frame Format : Number of stop bits
typedef enum {
  stop_1=1,       ///< number of stop bit set to 1
  stop_2=2,       ///< number of stop bit set to 2
  stop_1_2=0      ///< number of stop bit set to 0.5
  } uart_frame_stop_format_t;


`endif



/// @}
/// @}
/// @}

