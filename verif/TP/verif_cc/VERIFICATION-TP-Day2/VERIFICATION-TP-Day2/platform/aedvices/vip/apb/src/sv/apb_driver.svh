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
// $Id: apb_driver.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_driver definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Classes
/// @{

/// \brief Base virtual class for apb_master_driver and apb_slave_driver
/// \details Virtual class which cannot be instanciated.
virtual class apb_driver extends uvm_driver #(apb_transfer);

  apb_agent p_agent = null; /// < backpointer to agent container
  virtual interface apb_if vif; /// < Virtual Interface

  `pragma protect begin
  extern function new(string name="driver",uvm_component parent=null);

  // Protected members and functions
  //protected static bit reset_done = 0;
  protected event reset_event;
  protected event end_of_reset;

  `pragma protect end


endclass



/// @}
/// @}
/// @}
