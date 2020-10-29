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
// $Id: apb_master_driver.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_master_driver definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Classes
/// @{

/// APB Master Driver
class apb_master_driver extends apb_driver;
  // Default Publics Methods

  // UVM Methods
	extern function new(string name="driver",uvm_component parent=null);
  extern task run_phase(uvm_phase phase);

  `pragma protect begin
  // Protected Members
  protected bit reset_done = 0;

  // Protected Methods
  extern virtual task get_and_drive();
  extern virtual task drive_trans(apb_transfer trans);
  extern virtual task reset_synchronisation();
  extern virtual protected task reset_signals();


  /// UVM DB registration
  `uvm_component_utils(apb_master_driver)
  `pragma protect end
endclass



/// @}
/// @}
/// @}
