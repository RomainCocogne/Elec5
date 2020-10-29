/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: aed_uart_pkg.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// \file
/// Generic UART VIP


/// \addtogroup packages
/// @{
/// \brief Packages

/// \defgroup aed_uart_pkg aed_uart_pkg
/// \brief Generic UART VIP Package
/** \details
  * The aed_uart_pkg contains the class definitions and implementations for a generic UART Verifcation IP.<br>
  * User shall instantiate the main environment uart_env as a container for the master and slave agents.<br>
  * Master Agents:<br>
  *   - Drives data on Tx
  *   - Receives data on Rx
  * Slave Agents: <br>
  *   - Receives data on Tx.
  *   - Drives data on Rx.
  * The environment is configured using the UVM configuration database and are set using uvm_config_db#(*)::set() methods. <br>
  * Each agent is configured using the configuration class apb_config, which is set using uvm_config_db#(apb_config)::set(), during the build phase. <br>
  * This configuration can then be updated at anytime during simulation, except for the static fields ( agent_kind , name, bus widths ) which are only set during the build_phase().
  */

/// \addtogroup aed_uart_pkg
/// @{

/// \defgroup Classes
/// \brief List of Classes

/// \defgroup seqlib Sequence Library
/// \brief List of template basic sequences

/// \defgroup Types
/// \brief Type definitions

/// \defgroup Macros
/// \brief Macros and Defines


package aed_uart_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;

`pragma protect begin
  // Forward declarations to resolve dependencies
  typedef class uart_agent;
  typedef class uart_sequencer;

  // Types and Macros
  `include "uart_defines.svh"
  `include "uart_types.svh"

  // Class declarations
  `include "uart_config.svh"
  `include "uart_frame.svh"
  `include "uart_line_monitor.svh"
  `include "uart_sequencer.svh"
  `include "uart_driver.svh"
  `include "uart_agent.svh"
  `include "uart_env.svh"

  // Implementation
  `include "uart_env.sv"
  `include "uart_agent.sv"
  `include "uart_sequencer.sv"
  `include "uart_driver.sv"
  `include "uart_config.sv"
  `include "uart_line_monitor.sv"

  // Base Sequence and Default Sequence Library
  `include "uart_sequence.svh"
  `include "uart_sequence_lib.svh"

`pragma protect end


endpackage



/// @}
/// @}
