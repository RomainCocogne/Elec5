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
// $Id: uart_wb_ip_verif_base_sequence.svh 319 2017-09-30 16:48:03Z francois $
// $Author: francois $
// $LastChangedDate: 2017-09-30 18:48:03 +0200 (sam., 30 sept. 2017) $
// $Revision: 319 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


class uart_wb_ip_verif_base_sequence extends wishbone_base_sequence;
  `uvm_object_utils(uart_wb_ip_verif_base_sequence)

  rand bit test_control;
  constraint test_control_c { soft test_control == 0; }

  /// Constructor
  function new(string name="uart_wb_ip_verif_base_sequence");
    super.new(name);
  endfunction

  /// UVM Sequence Pre Start
  task pre_start();
    // the top level sequence does not have a parent sequence.
    // in this case, we consider this is the main sequence controlling the test execution, so we raise an exception
    if ( ( get_parent_sequence() == null ) || test_control ) 
        starting_phase.raise_objection(this);
    
    super.pre_start();
    
  endtask : pre_start

  /// UVM Sequence Post Start
  task post_start();
    
    if ( ( get_parent_sequence() == null ) || test_control ) 
      starting_phase.drop_objection(this);
    
    super.post_start();
  endtask : post_start



endclass