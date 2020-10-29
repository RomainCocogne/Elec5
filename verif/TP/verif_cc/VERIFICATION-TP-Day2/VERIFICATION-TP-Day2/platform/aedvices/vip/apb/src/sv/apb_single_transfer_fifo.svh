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
// $Id: apb_single_transfer_fifo.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_single_transfer_fifo definition
 */



/// \addtogroup packages
/// @{
/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{


/// single transfer APB FIFO used to wait for the next transfer.
/// get() tasks waits for the next transfer to be received.
class apb_single_transfer_fifo extends uvm_component;
  uvm_analysis_imp #(apb_transfer, apb_single_transfer_fifo) analysis_export;

  `pragma protect begin

  local event received_e;
  local apb_transfer received_trans;

  /// Constructor
  function new(string name,uvm_component parent=null);
    super.new(name,parent);
    analysis_export = new("analysis_export", this);
  endfunction

  /// Get the next transfer request
  virtual task get( output apb_transfer t );
    @(received_e);
    t = received_trans;
    //received_trans = null;
  endtask

  /// Called from connected analysis port.
  function void write(input apb_transfer t);
    received_trans = t;
    ->received_e;
  endfunction

  `uvm_component_utils(apb_single_transfer_fifo)
  `pragma protect end
endclass

/// @}
/// @}
/// @}
