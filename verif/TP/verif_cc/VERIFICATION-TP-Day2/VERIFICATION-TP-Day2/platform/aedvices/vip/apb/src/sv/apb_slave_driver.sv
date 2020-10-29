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
// $Id: apb_slave_driver.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_slave_driver implementation
 */
`pragma protect begin


/// constructor
function apb_slave_driver::new(string name="driver",uvm_component parent=null);
  super.new(name,parent);
endfunction

function void apb_slave_driver::connect_phase(uvm_phase phase);
endfunction


//-----------------------------------------------------------------------------
/// Run Phase
/// Main Driver Run Loop
task apb_slave_driver::run_phase(uvm_phase phase);
  `uvm_info("DEBUG",$psprintf("phase %s launched",phase.get_name()),UVM_FULL)
  fork
    reset_synchronisation();
    get_and_drive();
  join_any
endtask // run_phase


//-----------------------------------------------------------------------------
/// get_and_drive()
/// Get Sequence Item from the sequencer and drive it.
task apb_slave_driver::get_and_drive();
  bit reset_detected =0;
  bit item_ongoing   =0;

  forever begin
    reset_detected = 0;
    item_ongoing   = 0;

    fork

      //---------
      // Thread 1 : wait for reset events
      begin
        @ ( reset_event );
        `uvm_info("DEBUG","get_and_drive() : reset dropped, stopping sequence",UVM_FULL)
          if ( item_ongoing )
          seq_item_port.item_done();
        reset_signals();
        reset_detected = 1;
      end

      //---------
      // Thread 2 : Run as normal if everything is normal
      begin
        item_ongoing = 0;
        `uvm_info("DEBUG",$psprintf("Getting apb transfer Items"),UVM_FULL)

        if ( ! reset_done )
          wait(reset_done);

        forever begin
          seq_item_port.get_next_item(req);
          item_ongoing = 1;
          drive_transfer(req);
          seq_item_port.item_done();
        end
      end

    join_any

    // if reset has been detected, we need to kill any sub threads that may be sending data
    if ( reset_detected ) begin
      disable fork;
      `uvm_info("DEBUG","get_and_drive() : disable fork, sequence stopped",UVM_FULL)
    end

  end // forever
endtask

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
/// reset_synchronisation()
/// Detect reset event.
task apb_slave_driver::reset_synchronisation();
  fork
    forever begin
      @(posedge vif.PRESETn);
      `uvm_info("APB DRIVER",$psprintf("exiting reset"),UVM_LOW);
      reset_done = 1;
      -> end_of_reset;
    end

    forever begin
      @(negedge vif.PRESETn);
      `uvm_info("APB DRIVER",$psprintf("Getting in reset"),UVM_LOW);
      reset_done = 0;
      -> reset_event;
    end
  join
endtask

//-----------------------------------------------------------------------------
/// \brief drive bus to reset values
// reset_signals
task apb_slave_driver::reset_signals();

  vif.PREADY  <= 'b0;
  vif.PSLVERR  <= 'b0;
  `uvm_info(get_name(),"APB signals have been reset",UVM_FULL)
endtask : reset_signals


/// Drive a single transfer
task apb_slave_driver::drive_transfer(apb_transfer transfer);
  int unsigned local_wait_states =0;
  //apb_transfer transfer;

  `uvm_info(get_name(),"drive apb_transfer response to bus",UVM_FULL)
   void'(begin_tr(transfer, "APB_transfer", "UVM Debug","APB Driven Slave Response"));

  // In non-reactive mode, we need to wait for the SETUP phase
  // In reactive mode, the setup phase has been detected by the the monitor, and by the time we get here,
  // we are out of the clock delta cycle,
  // \todo: additional check that reactive sequence item are pushed at the right time.
  // \todo: default behavior if there is not item and there is an SETUP phase.
  if ( vif.actual_psel === 0 )
    while (vif.actual_psel === 0) begin/// wait for request
      @(posedge vif.PCLK);
    end

  assert(transfer != null) else `uvm_fatal("F_NULL","Unable to get a response transfer. Response Transfer Fifo is empty")

  // START TRANSACTION
  local_wait_states = transfer.waitstates; //keep copy

  /// SETUP PHASE
  transfer.address   = vif.PADDR;               /// APB Address
  transfer.direction = apb_direction_t'(vif.PWRITE);

  ///WAIT STATE
  while (local_wait_states != 0) begin
    vif.PREADY <= 0;
    @(posedge vif.PCLK);
    local_wait_states--;
  end
  vif.PREADY  <= 1;
  vif.PSLVERR <= transfer.slverror;

  if (transfer.direction == WRITE)
    transfer.data = vif.PWDATA;
  else
    vif.PRDATA <= transfer.data;

  @(posedge vif.PCLK);
  `uvm_info("APB_DRIVER", $sformatf("Transfer sent :\n%s", transfer.sprint()), UVM_HIGH)  //print APB transaction
  end_tr(transfer);
  //transfer = resp_trans_fifo.pop_front();

  -> resp_driven_e ;
  vif.PRDATA <= 'hxxxx; // can be random, x or z depending on cfg
  vif.PREADY <= 'bx; // can be random, x or z depending on cfg
  vif.PSLVERR <= 'b0; // can be random, x or z depending on cfg

endtask

`pragma protect end