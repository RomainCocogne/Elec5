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
// $Id: apb_monitor.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_monitor definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{
/// \addtogroup Classes
/// @{

`pragma protect begin
// Agent Forward declaration is needed as driver is instanciated from Agent and backpointer to agent is provided in driver
typedef class apb_agent;
`pragma protect end

/// \brief Generic APB Monitor.
/// \details monitor for all kind of APB transactions
class apb_monitor extends uvm_monitor;

  apb_agent p_agent; /// < backpointer to agent container
  virtual interface apb_if vif; /// < Virtual Interface

  // Methods
  extern function new(string name="apb_monitor",uvm_component parent=null);
  extern virtual task run_phase(uvm_phase phase);

  extern virtual task reset_synchronisation; ///< Reset detection and synchronization
  //---------------------------------
  // Analysis port
  uvm_analysis_port #(apb_transfer) address_phase_transfer_port; ///< A transfer has been thru the address phase
  uvm_analysis_port #(apb_transfer) completed_transfer_port;     ///< A transfer has been completly received.

  `pragma protect begin
   //---------------------------------
   // APB monitoring task
    extern virtual task monitor_apb_transfer();  ///< APB monitoring
    extern virtual task monitor_apb_bus();       ///< Master Thread for APB Monitoring
    extern local function shortint unsigned get_sel_val(shortint unsigned psel_sig);


   //---------------------------------
   // Internal states and variables
   protected bit   reset_done; ///< Tells whenever reset has been done and we can do something useful
   protected event reset_event; ///< Tells whether a reset_event has occurred.
   protected bit monitor_is_active = 0;///< Provide information on monitoring activity.

  //---------------------------------
  // Utility tasks and functions
  extern protected virtual function void                   clear_on_reset();

  `uvm_component_utils(apb_monitor)

  `pragma protect end
endclass

/// @}
/// @}
/// @}
