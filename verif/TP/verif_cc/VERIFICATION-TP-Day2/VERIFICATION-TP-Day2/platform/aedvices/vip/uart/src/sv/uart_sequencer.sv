/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_sequencer.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// \file
/// Generic UART VIP


`pragma protect begin

/// constructor
function uart_sequencer::new(string name="sequencer",uvm_component parent=null);
  super.new(name,parent);
  if ( ! $cast(p_agent,parent))
    `uvm_fatal(get_name(),"Unable to cast parent to p_agent. The parent of uart_driver should be a uart_agent.")

  received_frame_import = new("received_frame_import",this);
  received_frame_fifo   = new("received_frame_fifo",this);
endfunction

/// \brief UVM connect phase
/// \details connect received frame to FIFO for reactive agents
function void uart_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  received_frame_import.connect(received_frame_fifo.analysis_export);
endfunction


`pragma protect end