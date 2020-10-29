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
// $Id: apb_sequence.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_sequence definition
 */



/// \addtogroup packages
/// @{
/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{

/// Base APB sequence
class apb_sequence extends uvm_sequence #(apb_transfer);

  `pragma protect begin
  protected apb_config cfg;///< pointer to the agent configuration for configuration based constraints
  `pragma protect end

  /// constructor
  function new(string name="apb_sequence");
    `pragma protect begin
      super.new(name);
    `pragma protect end
  endfunction

  `pragma protect begin
  /// Set the transaction config
  virtual function void set_cfg(apb_config cfg=null);
    if ( cfg == null )
      cfg = p_sequencer.p_agent.cfg;
    this.cfg = cfg;
  endfunction
  `pragma protect end

  function void pre_randomize();
    `pragma protect begin
    // For unknown reasons, I'm not able to protect the entire file, while using pre_randomize()
      super.pre_randomize();
      if ( cfg == null )
        set_cfg();
      `pragma protect end
  endfunction

  `pragma protect begin
  `uvm_declare_p_sequencer(apb_sequencer)
  `uvm_object_utils(apb_sequence)
  `pragma protect end
endclass

/// @}
/// @}
/// @}
