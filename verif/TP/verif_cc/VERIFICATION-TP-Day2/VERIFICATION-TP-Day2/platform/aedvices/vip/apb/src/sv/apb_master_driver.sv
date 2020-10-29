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
// $Id: apb_master_driver.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_master_driver implementation
 */
`pragma protect begin


/// constructor
function apb_master_driver::new(string name="driver",uvm_component parent=null);
  super.new(name,parent);
endfunction



//-----------------------------------------------------------------------------
/// Run Phase
/// Main Driver Run Loop
task apb_master_driver::run_phase(uvm_phase phase);
  `uvm_info("DEBUG",$psprintf("phase %s launched",phase.get_name()),UVM_FULL)
  fork
    reset_synchronisation();
    get_and_drive();
  join_any
endtask // run_phase


//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
/// get_and_drive()
/// Get Sequence Item from the sequencer and drive it.
task apb_master_driver::get_and_drive();
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
        begin
          wait(reset_done);

          @(posedge vif.PCLK); // First transaction cannot start on the same cycle as RESETn is deasserted.
        end

        forever begin
          seq_item_port.get_next_item(req);
          item_ongoing = 1;
          drive_trans(req);
          seq_item_port.item_done();
          item_ongoing = 0;
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
/// reset_synchronisation()
/// Detect reset event.
task apb_master_driver::reset_synchronisation();
  fork
    forever begin
      @(posedge vif.PRESETn);
      `uvm_info(get_name(),$psprintf("Exiting reset"),UVM_HIGH);
      reset_done = 1;
      -> end_of_reset;
    end

    forever begin
      @(negedge vif.PRESETn);
      `uvm_info(get_name(),$psprintf("Getting in reset"),UVM_HIGH);
      reset_done = 0;
      -> reset_event;
      end
  join
endtask

//-----------------------------------------------------------------------------
/// \brief drive bus to reset values
task apb_master_driver::reset_signals();

  vif.PSEL     <= 0;
  vif.PENABLE  <= 0;
  `uvm_info(get_name(),"APB signals have been reset",UVM_FULL)
endtask : reset_signals


//-----------------------------------------------------------------------------
/// Drive a single transfer
task apb_master_driver::drive_trans(apb_transfer trans);
  int unsigned local_wait_states =0;

  void'(begin_tr(trans, "APB_transfer", "UVM Debug","APB Driven Character"));

  ///Some Wait cycles
  if (trans.delay != 0)
    repeat (trans.delay) @(posedge vif.PCLK);


  //START TRANSACTION
  //SETUP PHASE
  vif.PSEL    <= (1 << trans.sel);
  vif.PENABLE <= 0;
  vif.PADDR   <= trans.address;    // APB Address
  vif.PWRITE  <= trans.direction;
  vif.PPROT   <= trans.prot;
  if (trans.direction == WRITE)
    begin
      vif.PWDATA <= trans.data;
      vif.PSTRB  <= trans.strobe;
    end
  else
    vif.PSTRB  <= 0;

  @(posedge vif.PCLK);  //ACCESS PHASE
  vif.PENABLE <= 1;

  @(posedge vif.PCLK);  //check for TRANSFER END
  while (vif.PREADY == 0) begin//WAIT STATE
    @(posedge vif.PCLK);
    local_wait_states++;
  end

  vif.PENABLE <= 0;   //TRANSFER END
  vif.PSEL    <= 0;
  vif.PPROT   <= 0;
  vif.PSTRB   <= 0;

  if (trans.direction == READ)
    trans.data     = vif.PRDATA;
  trans.slverror   = vif.PSLVERR;
  trans.waitstates = local_wait_states;
  `uvm_info("APB_DRIVER", $sformatf("Transfer sent :\n%s", trans.sprint()), UVM_HIGH)  //print APB transaction

   end_tr(trans);


endtask

`pragma protect end