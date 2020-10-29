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
// $Id: apb_sequencer.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_sequencer definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{

`pragma protect begin
// Agent Forward declaration is needed as sequencer is instanciated from Agent and backpointer to agent is provided in sequencer
typedef class apb_agent;

`pragma protect end

/// \brief Generic apb Sequencer
virtual class apb_sequencer extends uvm_sequencer#(apb_transfer);
  extern virtual function apb_config get_config();
  extern virtual function void set_config(apb_config cfg);

  `pragma protect begin
  apb_agent p_agent = null;

  extern function new(string name="sequencer",uvm_component parent=null);

  `pragma protect end

endclass

/// @}
/// @}
/// @}
