/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_defines.svh 1433 2018-04-11 16:13:40Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-11 18:13:40 +0200 (mer., 11 avr. 2018) $
// $Revision: 1433 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 UART defines and macros
 */


/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Macros
/// @{



// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/// UART Macros
`ifndef UART_DEFINES_HEADER
`define UART_DEFINES_HEADER


`define AED_UART_VIP_VERSION          1.0.2 ///< VIP Version
`define AED_UART_VIP_VERSION_MAJOR    1     ///< VIP Version - major version number
`define AED_UART_VIP_VERSION_MINOR      0   ///< VIP Version - minor version number
`define AED_UART_VIP_VERSION_UPDATE       2 ///< VIP Version - update revision number


/// \brief define SPI_SS_MAX_WIDTH
/// Defines the maximum width to be used for Slave Select interface signals
`ifndef UART_DATA_MAX_WIDTH
`define UART_DATA_MAX_WIDTH 9
`endif




  // -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
`endif // nothing below this line


/// @}
/// @}
/// @}
