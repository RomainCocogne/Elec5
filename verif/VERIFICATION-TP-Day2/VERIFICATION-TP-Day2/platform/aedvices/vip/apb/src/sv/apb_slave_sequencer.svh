/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// Copyright (c) 2016 - AEDVICES Consulting
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Usage of this code is subject to license agreement.
// For any querry contact AEDVICES Consulting: contact@aedvices.com
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: apb_slave_sequencer.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_slave_sequencer definition
 */

/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{

/// APB Slave Sequencer
class apb_slave_sequencer extends apb_sequencer;


  /// Import transactions from monitor
  uvm_analysis_export #(apb_transfer) address_phase_transfer_import;

  /// Fifo to store transactions from monitor
  apb_single_transfer_fifo address_phase_transfer_fifo;

  `pragma protect begin
  // UVM Methods
  extern function new(string name="sequencer",uvm_component parent=null);
  extern function void connect_phase(uvm_phase phase);

  // UVM DB Registration
  `uvm_component_utils(apb_slave_sequencer)

  `pragma protect end
endclass

/// @}
/// @}
/// @}

