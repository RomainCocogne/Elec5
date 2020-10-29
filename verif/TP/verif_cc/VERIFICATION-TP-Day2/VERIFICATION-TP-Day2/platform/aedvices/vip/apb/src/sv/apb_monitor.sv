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
// $Id: apb_monitor.sv 1540 2018-05-15 09:46:09Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-05-15 11:46:09 +0200 (mar., 15 mai 2018) $
// $Revision: 1540 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_monitor implementation
 */
`pragma protect begin


/// constructor
function apb_monitor::new(string name="apb_monitor",uvm_component parent=null);
  super.new(name,parent);

  completed_transfer_port     = new("completed_transfer_port"     , this);
  address_phase_transfer_port = new("address_phase_transfer_port" , this);
endfunction



/// Run phase
task apb_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_name(),"Monitor Starting...",UVM_MEDIUM)
  fork
    reset_synchronisation();
    monitor_apb_bus();
  join_none
endtask

//------------------------------------------------------------------
/// APB Bus Monitoring
task apb_monitor::monitor_apb_bus();
  bit reset_detected =0;
  bit item_ongoing   =0;

  forever begin
    reset_detected = 0;
    item_ongoing   =0;

    fork

      //---------
      // Thread 1 : wait for reset events
      begin
        @ ( reset_event );
        `uvm_info(get_name(),"monitor_apb_bus() : reset asserted, stopping monitoring",UVM_MEDIUM)
          reset_detected = 1;
      end

      //---------
      // Thread 2 : Run as normal if everything is normal
      begin

        if ( ! reset_done )
          wait(reset_done);

        `uvm_info(get_name(),"Ready to Monitor APB transfers",UVM_MEDIUM)
         monitor_is_active = 1;// Notify activity
         // Really monitor APB here
         forever
           monitor_apb_transfer();
      end
    join_any

    // if reset has been detected, we need to kill any sub threads that may be sending data
    if ( reset_detected )
    begin
      disable fork;
      `uvm_info("DEBUG","monitor_apb_bus() : disable fork, monitoring stopped",UVM_MEDIUM)
        monitor_is_active = 0;// Notify absence of activity
    end

  end // forever
endtask

/// Returns which psel is activated.
/// Assumes it's called only when the signal is onehot
function shortint unsigned apb_monitor::get_sel_val(shortint unsigned psel_sig);
  shortint idx = 0;
  assert ($onehot(psel_sig)) else `uvm_fatal("F_APB_MONITOR",$psprintf("PSEL is expected to be onehot. Current value 0x%02x",psel_sig));
  while ( psel_sig != 0 && psel_sig[0] == 0 )
    begin
      psel_sig >>= 1;
      idx += 1;
    end
  return idx;
endfunction



/// APB transfers monitoring
task apb_monitor::monitor_apb_transfer();

  apb_monitored_transfer curr_trans = new(.has_coverage(p_agent.cfg.has_coverage));

  curr_trans.waitstates = 0;

 // Wait for SETUP operating state
  while (vif.actual_psel === 0 && (vif.PENABLE === 0 || p_agent.cfg.slave_shared_bus))
    @(posedge vif.PCLK);

  // Ensure the operating state goes from IDLE to SETUP
  void'(begin_tr(curr_trans, "APB_transfer", "UVM Debug","APB Received Character"));

  // Sample PADDR and PWRITE
  curr_trans.address   = vif.PADDR;
  curr_trans.direction = (vif.PWRITE === 1) ? WRITE : READ;
  curr_trans.sel       = get_sel_val(vif.actual_psel);

  `uvm_info("DEBUG",
      { "Pushing Address Phase\n",
        $psprintf("PSEL = %d , PENABLE = %d",vif.actual_psel === 1,vif.PENABLE) }
      ,UVM_FULL)
  address_phase_transfer_port.write(curr_trans);

  if ( vif.PENABLE !== 0 )
    begin
   	  `uvm_error("AED_VIP_APB_MONITOR_SETUP_ERROR", $psprintf("Expected SETUP state, PSEL='onehot' and PENABLE=0, actual values are PSEL=%d PENABLE=%d",vif.actual_psel, vif.PENABLE))
    end
  else if ($onehot(vif.actual_psel))
    begin
      // Wait for ACCESS operating state

      if ( vif.PWRITE === 1)
        curr_trans.data = vif.PWDATA;

      //while (vif.PENABLE === 0)
        @(posedge vif.PCLK);
  end

  if ( !$onehot(vif.actual_psel))
    begin
      `uvm_error("AED_VIP_APB_MONITOR_IDLE_ERROR", $psprintf("Cannot exit from SETUP state to IDLE state, PSEL='onehot' and PENABLE=0, actual values are PSEL=%d PENABLE=%d",vif.actual_psel, vif.PENABLE))
    end
  else if ( vif.PENABLE === 1)
    begin
      // Wait for PREADY assertion
      while (vif.PREADY === 0)
        begin
          @(posedge vif.PCLK);
          curr_trans.waitstates++;
        end
    end

  if ( !$onehot(vif.actual_psel) || vif.PENABLE !== 1 )
    `uvm_error("AED_VIP_APB_MONITOR_ACCESS_ERROR", $psprintf("Cannot exit from ACCESS state if transfer is not completed, PSEL='onehot' and PENABLE=1, actual values are PSEL=%d PENABLE=%d",vif.actual_psel, vif.PENABLE))

  // Sample DATA and PSLVERR and PSTRB
  if ( vif.PWRITE === 0) begin
   curr_trans.data = vif.PRDATA;
  end
  curr_trans.slverror = vif.PSLVERR;
  curr_trans.strobe = vif.PSTRB;

  completed_transfer_port.write(curr_trans);

  if ( p_agent.cfg.has_coverage ) begin
    curr_trans.sample();
  end

  // move to next cycle
  @(posedge vif.PCLK);

  end_tr(curr_trans);

endtask

/// Reset Synchronisation
task apb_monitor::reset_synchronisation();
  //`uvm_info("DEBUG","starting reset sync",UVM_NONE)
  fork
    forever begin
      @(posedge vif.PRESETn);
      `uvm_info(get_name(),$psprintf("Exiting reset"),UVM_MEDIUM);
      reset_done = 1;
    end

    forever begin
      @(negedge vif.PRESETn);
       `uvm_info(get_name(),$psprintf("Getting in reset"),UVM_MEDIUM);
      clear_on_reset();
      reset_done = 0;
      -> reset_event;
      end
  join
endtask

//-----------------------------------------------------------------------------
/// \brief clears lists and reset variables on resetevent
function void apb_monitor::clear_on_reset();
//  pending_write_transactions.delete();
//  pending_read_transactions.delete();
//  orphan_write_transfers.delete();
endfunction

`pragma protect end