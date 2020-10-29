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
// $Id: apb_slave_sequence.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_slave_sequence definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{
/// Base APB Slave Sequence
/// Extends the default apb_sequence and add slave specific fields.
class apb_slave_sequence extends apb_sequence;

  `pragma protect begin
  /// constructor
  function new(string name="apb_slave_sequence");
    super.new(name);
  endfunction

  `uvm_declare_p_sequencer(apb_slave_sequencer)
  `uvm_object_utils(apb_slave_sequence)

  `pragma protect end
endclass

/// @}
/// @}
/// @}
