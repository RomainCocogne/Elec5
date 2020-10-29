// ===============================================================================
//                    Copyright (c) 2015 - AEDVICES Consulting
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developped by AEDVICES Consulting for 
// training purposes.  
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================
// Copyright (c) 2016-2017 - AEDVICES Consulting 
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_wb_ip_verif_base_test.svh 319 2017-09-30 16:48:03Z francois $
// $Author: francois $
// $LastChangedDate: 2017-09-30 18:48:03 +0200 (Sat, 30 Sep 2017) $
// $Revision: 319 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

//===============================================================================
// Class Declaration
//===============================================================================
/// UART IP Verifi Base Test Class
/// Instantiates all required verification IPs
class uart_wb_ip_verif_base_test extends uvm_test;
  // Register the Class within UVM Factory
  `uvm_component_utils(uart_wb_ip_verif_base_test)

  // Main Class Parameters
  rand bit recording_detail_enable; ///< Switch to enable transaction recording. Default soft constrained to 0. 
  constraint recording_detail_enable_c {
    soft recording_detail_enable == 0;
  }

  /// The main UART Verification Environment, which instantiates the Wishbone and the UART VIPs
  uart_wb_ip_verif_env verif_env0;

  // --------------------
  // Methods Declaration
  // --------------------
  // Constructor and UVM Phases
  extern function new(string name,uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

//===============================================================================
// Class Methods Implementation
//===============================================================================

/// Constructor
function uart_wb_ip_verif_base_test::new(string name,uvm_component parent);
    super.new(name,parent);
endfunction

/// UVM Build Phase
/// launched by UVM component construction flow.
function void uart_wb_ip_verif_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Enable Transaction Recording when switch is set
  if ( recording_detail_enable )
    uvm_config_db#(int)::set(null, "*", "recording_detail", 1);

  
  verif_env0 = uart_wb_ip_verif_env::type_id::create("verif_env0",this);


endfunction



/// UVM Run Phase
/// launched by UVM component construction flow.
task uart_wb_ip_verif_base_test::run_phase(uvm_phase phase);
  // allow some time after the main sequence so that the UART can send data
  phase.phase_done.set_drain_time(this, 5000);
endtask : run_phase
