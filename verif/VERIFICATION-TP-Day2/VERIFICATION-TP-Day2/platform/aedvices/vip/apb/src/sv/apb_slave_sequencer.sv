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
// $Id: apb_slave_sequencer.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_slave_driver implementation
 */
`pragma protect begin


/// Constructor
function apb_slave_sequencer::new(string name="sequencer",uvm_component parent=null);
  super.new(name,parent);
  address_phase_transfer_import = new("address_phase_transfer_import",this);
  address_phase_transfer_fifo   = new("address_phase_transfer_fifo",this);
endfunction


/// \brief Connect Phase
/** \details
 * link fifo to monitor port thru the FIFO uvm_analysis_export
 */
function void apb_slave_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  address_phase_transfer_import.connect(address_phase_transfer_fifo.analysis_export);
endfunction


`pragma protect end