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
// $Id: apb_config.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_config declaration
 */

`pragma protect begin

/// constructor
function apb_config::new(string name="");
  super.new(name);
endfunction

`pragma protect end
