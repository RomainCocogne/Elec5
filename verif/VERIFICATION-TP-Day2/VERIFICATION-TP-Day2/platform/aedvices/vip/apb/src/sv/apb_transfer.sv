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
// $Id: apb_transfer.sv 1781 2018-08-07 07:37:17Z dung $
// $Author: dung $
// $LastChangedDate: 2018-08-07 09:37:17 +0200 (mar., 07 août 2018) $
// $Revision: 1781 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_transfer implementation
 */

`pragma protect begin

/// constructor
function apb_transfer::new(string name="");
  super.new(name);
endfunction




/// Set the transaction config
function void apb_transfer::set_cfg(apb_config cfg=null);
  if ( cfg == null )
  begin
    uvm_sequencer_base u_sqr;
    apb_sequencer a_sqr;
    u_sqr = get_sequencer();
    if ( ! $cast(a_sqr,u_sqr) )
      `uvm_fatal(get_name(),"Unable to cast transaction sequencer to apb_sequencer");
     
    // In case we are created from outside the Agent / Sequence scope, there is no configuration to fetch. Keep it Null.
    // Default constraints with cfg == null will apply.
    if ( a_sqr != null && a_sqr.p_agent != null)
      cfg = a_sqr.p_agent.cfg;
     
  end
  this.cfg = cfg;
endfunction
`pragma protect end



function void apb_transfer::pre_randomize();
  `pragma protect begin
  // For unknown reasons, I'm not able to protect the entire file, while using pre_randomize()
  super.pre_randomize();
  if ( cfg == null )
    set_cfg();
  `pragma protect end
endfunction
