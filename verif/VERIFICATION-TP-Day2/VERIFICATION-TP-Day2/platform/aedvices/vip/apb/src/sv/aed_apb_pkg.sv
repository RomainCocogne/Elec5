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
// $Id: aed_apb_pkg.sv 1515 2018-05-08 16:00:10Z francois $
// $Author: francois $
// $LastChangedDate: 2018-05-08 18:00:10 +0200 (mar., 08 mai 2018) $
// $Revision: 1515 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 package aed_apb_pkg main file.
 */

/// \addtogroup packages
/// @{

/// \defgroup aed_apb_pkg aed_apb_pkg

/// \brief APB Verification IP main Package
/** \details
 * The aed_apb_pkg contains the class definitions and implementations for the APB Verification IP.<br>
 * User shall instantiate the main environment apb_env as a container for the master and slave agents.<br>
 * The environment is configured using the UVM configuration database and are set using uvm_config_db#(*)::set() methods. <br>
 * Each agent is configured using the configuration class apb_config, which is set using uvm_config_db#(apb_config)::set(), during the build phase. <br>
 * This configuration can then be updated at anytime during simulation, except for the static fields ( agent_kind , name, bus widths ) which are only set during the build_phase().
 */


package aed_apb_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // Types and Macros
  `include "apb_defines.svh"
  `include "apb_types.svh"

`pragma protect begin
  // Forward declarations
  typedef class apb_slave_default_reactive_seq;

  // Class declarations
  `include "apb_config.svh"
  `include "apb_transfer.svh"
  `include "apb_single_transfer_fifo.svh"
  `include "apb_sequencer.svh"
  `include "apb_driver.svh"
  `include "apb_master_sequencer.svh"
  `include "apb_master_driver.svh"
  `include "apb_slave_sequencer.svh"
  `include "apb_slave_driver.svh"
  `include "apb_monitor.svh"
  `include "apb_agent.svh"
  `include "apb_env.svh"
  `include "apb_monitored_transfer.svh"

  // Methods Implementation
  `include "apb_env.sv"
  `include "apb_agent.sv"
  `include "apb_sequencer.sv"
  `include "apb_master_sequencer.sv"
  `include "apb_master_driver.sv"
  `include "apb_slave_sequencer.sv"
  `include "apb_slave_driver.sv"
  `include "apb_monitor.sv"
  `include "apb_driver.sv"
  `include "apb_transfer.sv"
  `include "apb_config.sv"

  // Base Sequence and Default Sequence Library
  `include "apb_sequence.svh"
  `include "apb_slave_sequence.svh"
  `include "apb_sequence_lib.svh"

`pragma protect end

endpackage

/// @}
