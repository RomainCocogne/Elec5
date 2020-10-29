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
// $Id: apb_sequencer.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_sequencer implementation
 */
`pragma protect begin




function apb_sequencer::new(string name="sequencer",uvm_component parent=null);
  super.new(name,parent);
  if ( ! $cast(p_agent,parent))
    `uvm_fatal(get_name(),"Unable to cast parent to p_agent. The parent of apb_driver should be a apb_agent.")
endfunction


/// Return the current agent configuration
function apb_config apb_sequencer::get_config();
  return p_agent.get_config();
endfunction

/// Set/Update the current agent configuration
function void apb_sequencer::set_config(apb_config cfg);
  p_agent.set_config(cfg);
endfunction



`pragma protect end

