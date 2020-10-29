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
// $Id: apb_agent.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_agent definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Classes
/// @{


/// \brief Main APB Agent Class.
/** \details
 * All APB Agents are composed of monitor \n
 * Active APB Agents are composed of driver and sequencer. The actual instance of driver and sequencer depends on the agent kind (MASTER or SLAVE).\n
 * Build Phase UVM Configuration Fields :\n
 * - <b>vif</b>  : mandatory. Shall be a "interface apb_if"
 * - <b>cfg</b>  : optional. Default behavior is to generate random configuration fields (except for kind)
 * - <b>name</b> : optional. Default is masterN or slaveN (with N being incremented for each instance).
 */
class apb_agent  extends uvm_agent ;

  /// Agent Kind (is MASTER, SLAVE or MONITOR)
  apb_agent_kind_t kind;

  /// Virtual Interface variable
  virtual interface apb_if vif;

  // Agent Configuration
  apb_config cfg;  ///< apb Agent configuration (mode, min/max delays, ...)

  // Agent components
  apb_driver    driver;     ///< apb Driver of class apb_master_driver OR apb_slave_driver
  apb_sequencer sequencer;  ///< apb Sequencer of class apb_master_sequencer OR apb_slave_sequencer
  apb_monitor   monitor;    ///< apb Sequencer of class apb_master_sequencer OR apb_slave_sequencer

  // Configuration Update Functions
  extern virtual function apb_config get_config();
  extern virtual function void set_config(apb_config cfg);

  `pragma protect begin
  // Methods
	extern function new(string name="agent",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

  /// UVM DB registration
  `uvm_component_utils_begin(apb_agent)
    `uvm_field_enum(apb_agent_kind_t , kind , UVM_DEFAULT)
  `uvm_component_utils_end
  `pragma protect end

endclass

/// @}
/// @}
/// @}
