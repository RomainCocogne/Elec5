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
// $Id: apb_env.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_env definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Classes
/// @{

/// APB Environment container for any number of APB agents.
/// The Environment takes the configuration DB fields and instantiates the APB agents accordingly.
/// \todo document uvm_config fields here.
class apb_env extends uvm_env;

  // Environment Global Configuration Fields
  integer nr_masters; ///< Number of masters instantiated
  integer nr_slaves;  ///< Number of slaves instantiated

  apb_agent      masters[$]; ///< List of the master agents
  apb_agent      slaves[$];  ///< List of the slave  agents

  apb_agent      agents[string]; /// Keyed List of all agents

  `pragma protect begin
  /// Hash of all sequencer to allow easy access from agent name. Use get_sequencer(name) to retrieve any specific sequencer.

	extern function new(string name="apb_env",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function uvm_sequencer_base get_sequencer(string name="master0");

  /// UVM DB registration
  `uvm_component_utils_begin(apb_env)
    `uvm_field_int(nr_masters , UVM_DEFAULT)
    `uvm_field_int(nr_slaves  , UVM_DEFAULT)
  `uvm_component_utils_end

  `pragma protect end

endclass



/// @}
/// @}
/// @}

