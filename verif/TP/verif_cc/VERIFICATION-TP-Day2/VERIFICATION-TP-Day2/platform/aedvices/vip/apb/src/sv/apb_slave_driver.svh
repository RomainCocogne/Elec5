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
// $Id: apb_slave_driver.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_slave_driver definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{

/// APB Slave Driver
class apb_slave_driver extends apb_driver;
  `pragma protect begin

  local event resp_pushed_e;
  local event resp_driven_e;
//  /// Import transactions from monitor
//  uvm_analysis_export #(apb_transfer) address_phase_transfer_import;
//
  //protected apb_transfer resp_trans_fifo[$];

  protected bit reset_done = 0;

  // slave drive methods
  extern virtual task get_and_drive();
  extern virtual task drive_transfer(apb_transfer transfer);
  //extern virtual task push_trans_to_drive(apb_transfer transfer);
  extern virtual protected task reset_signals();
  extern task reset_synchronisation();

  // UVM Phases
  extern function new(string name="driver",uvm_component parent=null);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  /// UVM DB registration
  `uvm_component_utils(apb_slave_driver)

  `pragma protect end
endclass



/// @}
/// @}
/// @}
