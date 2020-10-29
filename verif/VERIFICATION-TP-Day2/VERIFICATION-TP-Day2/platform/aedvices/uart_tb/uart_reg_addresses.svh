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
// $Id: uart_reg_addresses.svh 463 2018-08-07 13:52:02Z dung $
// $Author: dung $
// $LastChangedDate: 2018-08-07 15:52:02 +0200 (mar., 07 août 2018) $
// $Revision: 463 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


// TODO: replace defines with parameters
// Register Addresses
`define UART_BASE                 'h0000              ///< Base Address for all registers at IP level
`define UART_TX_RX_OR_DIVISOR_LSB  (`UART_BASE + 'h0) ///< TX Write Address, Rx Read Address , Divisor Latch LSB address
`define UART_IER_OR_DIVISOR_MSB    (`UART_BASE + 'h1) ///< Divisor Latch MSB address
`define UART_IIR_OR_FCR            (`UART_BASE + 'h2) ///< Write FIFO Control , Read Interrupt Identification Register 
`define UART_LCR                   (`UART_BASE + 'h3) ///< Line Control Register
`define UART_LSR                   (`UART_BASE + 'h5) ///< Line Status Register
/*
 * These are the definitions for the Line Status Register
 */
`define UART_LSR_TEMT   8'h40  /* Transmitter empty */
`define UART_LSR_THRE   8'h20  /* Transmit-hold-register empty */
`define UART_LSR_BI     8'h10  /* Break interrupt indicator */
`define UART_LSR_FE     8'h08  /* Frame error indicator */
`define UART_LSR_PE     8'h04  /* Parity error indicator */
`define UART_LSR_OE     8'h02  /* Overrun error indicator */
`define UART_LSR_DR     8'h01  /* Receiver data ready */

/*
 * These are the definitions for the Line Control Register
 * 
 * Note: if the word length is 5 bits (UART_LCR_WLEN5), then setting 
 * UART_LCR_STOP will select 1.5 stop bits, not 2 stop bits.
 */
`define UART_LCR_DLAB     8'h80  /* Divisor latch access bit */
`define UART_LCR_SBC      8'h40  /* Set break control */
`define UART_LCR_SPAR     8'h20  /* Stick parity (?) */
`define UART_LCR_EPAR     8'h10  /* Even parity select */
`define UART_LCR_PARITY   8'h08  /* Parity Enable */
`define UART_LCR_STOP     8'h04  /* Stop bits: 0=1 stop bit, 1= 2 stop bits */
`define UART_LCR_WLEN5    8'h00  /* Wordlength: 5 bits */
`define UART_LCR_WLEN6    8'h01  /* Wordlength: 6 bits */
`define UART_LCR_WLEN7    8'h02  /* Wordlength: 7 bits */
`define UART_LCR_WLEN8    8'h03  /* Wordlength: 8 bits */
