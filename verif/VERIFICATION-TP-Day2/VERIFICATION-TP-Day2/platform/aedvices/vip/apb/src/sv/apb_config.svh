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
// $Id: apb_config.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_config definition
 */



/// \addtogroup packages
/// @{

/// \addtogroup aed_apb_pkg
/// @{

/// \addtogroup Classes
/// @{

`ifndef APB_CONFIG_HEADER
`define APB_CONFIG_HEADER

/// \brief APB Agent Configuration Class
/// \details
/// The configuration can be constructed in a directed way or randomized.\n
/// Default soft constraints therefore needs to be overridden.\n
/// Configuration can be changed dynamically by calling the set_config() of the agent at any time. In this case,
/// the exact behavior during the configuration transition is not defined, until the next item takes the current configuration.
///
class apb_config extends uvm_object;

  /// \brief   Agent Kind: MASTER, SLAVE, MONITOR.
  /// \details
  /// Set by UVM Config DB if set at agent level prior to build phase.\n
  /// If "kind" field is not set by config DB prior to build phase and
  ///
  apb_agent_kind_t kind; ///<  Master or Slave

  /// \brief Defines on which APB Specification revision the Interface is aligned.
  /// \details
  /// Supports for PROT and PSTRB.
  ///
  rand apb_protocol_rev_t apb_revision;

  /// \brief has_coverage: default is TRUE
  /// \details
  /// Is disabled by default for better performance. Will therefore not benefit from coverage data
  ///
  rand bit has_coverage = 1;         ///< Enable the monitor to collect transaction coverage

  rand bit disable_default_slave_sequence = 0; ///< When set, the slave sequencer will not start its default sequence. The user will have to implement and configure its own slave sequence. default==0.
  rand bit slave_shared_bus = 0;       ///< For slaves only. Indicates if PADDR, PENABLE, PWRITE, PWDATA signals are shared with another agent. \n This disable a few checkers at the interface level. \n default=0.

  /// \brief Actual width of PSEL signal.
  /// \details Should be set by the user to specify how many PSEL signals the agent is driving/monitoring.\n
  /// default value = `MAX_PSEL_WIDTH
  rand int unsigned psel_width = `MAX_PSEL_WIDTH;

  // Min/Max Delay Settings
  rand integer unsigned min_intertransfer = 0;  ///< minimum cycles between two transfers \n default=0
  rand integer unsigned max_intertransfer = 100;  ///< minimum cycles between two transfers \n default=100

  // Wait state delay settings for slaves
  rand integer unsigned read_min_waitstates  = 0;  ///< minimum cycles waitstates for slave reads \n default=0
  rand integer unsigned read_max_waitstates  = 20;  ///< minimum cycles between for slave reads \n default=20
  rand integer unsigned write_min_waitstates = 0;  ///< minimum cycles between for slave writes \n default=0
  rand integer unsigned write_max_waitstates = 20;  ///< minimum cycles between for slave writes \n default=20

  rand shortint unsigned default_slverror_weight = 10; ///< Default percentage of generated SLVERROR. Can be overriden by users when needed. \n Min=0, Max=100. \n Default=10%


  `pragma protect begin
  // Hard constraints
  constraint min_max_relation_c {
    min_intertransfer    <= max_intertransfer;
    read_min_waitstates  <= read_max_waitstates;
    write_min_waitstates <= write_max_waitstates;
    default_slverror_weight inside { [0:100] };
  }

  // Soft Constraints for default configuration
  /// \todo allow a soft reset mechanism thru constructor
  constraint default_c {
    soft apb_revision      == IHI0024B;

    soft min_intertransfer == 0;
    soft max_intertransfer == 100;

    soft read_min_waitstates == 0;
    soft read_max_waitstates == 20;

    soft write_min_waitstates == 0;
    soft write_max_waitstates == 20;

    soft disable_default_slave_sequence == 0;
    soft has_coverage == 1;
    soft slave_shared_bus == 0;
    soft psel_width == `MAX_PSEL_WIDTH;

    soft default_slverror_weight == 10;
  }


  extern function new(string name="");

  `uvm_object_utils_begin(apb_config)
    `uvm_field_enum(apb_agent_kind_t , kind                   , UVM_DEFAULT)
    `uvm_field_int (                   has_coverage           , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   min_intertransfer      , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   max_intertransfer      , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   read_min_waitstates    , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   read_max_waitstates    , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   write_min_waitstates   , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   write_max_waitstates   , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   disable_default_slave_sequence , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   slave_shared_bus       , UVM_DEFAULT | UVM_DEC)
    `uvm_field_int (                   psel_width             , UVM_DEFAULT | UVM_DEC)
  `uvm_object_utils_end

  `pragma protect end
endclass

`endif

/// @}
/// @}

/// @}
