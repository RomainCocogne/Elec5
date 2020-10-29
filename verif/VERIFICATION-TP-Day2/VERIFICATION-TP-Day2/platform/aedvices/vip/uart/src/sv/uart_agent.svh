/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_agent.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_agent declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// \brief Generic UART Agent
/// \details
/// Main Agent containing:
/// - Tx and Rx line monitors
/// - Driver and Sequencer if active. \n
/// uvm_agent uses the following uvm_config_db fields during build_phase:
/// <table>
/// <tr><th> UVM Config DB Field </th><th> Type                    </th><th>Description</th></tr>
/// <tr><td> kind                </td><td> uart_agent_kind_t       </td><td> MASTER or SLAVE. Automatically set from instantiating uvm_env </td></tr>
/// <tr><td> config              </td><td> uart_config             </td><td> Initial Agent Configuration. Use set_config to update after build phase </td></tr>
/// <tr><td> vif                 </td><td> interface uart_if       </td><td> Mandatory <br> Set the virtual Interface. </td></tr>
/// <tr><td> is_active           </td><td> uvm_active_passive_enum </td><td> UVM_ACTIVE or UVM_PASSIVE. <br> default = UVM_ACTIVE. </td></tr>
/// </table>
class uart_agent extends uvm_agent ;

  /// Agent Kind (is tx, SLAVE or MONITOR)
  uart_agent_kind_t kind;

  // Agent Configuration
  uart_config cfg;  ///< template Agent configuration (mode, min/max delays, ...)

  /// Uart Interface
  virtual uart_if vif;

  // Agent components
  uart_driver    driver;     ///< template Driver of class uart_tx_driver OR uart_slave_driver
  uart_sequencer sequencer;  ///< template Sequencer of class uart_tx_sequencer OR uart_slave_sequencer
  uart_line_monitor rx_monitor;///< Rx Line Monitor
  uart_line_monitor tx_monitor;///< Tx Line Monitor

`pragma protect begin
  // Methods
  extern function new(string name="agent",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function  uart_config get_config();
  extern virtual function  void set_config(uart_config cfg);
  extern virtual function virtual uart_if get_vif();

  /// UVM DB registration
  `uvm_component_utils_begin(uart_agent)
    `uvm_field_enum(uart_agent_kind_t , kind , UVM_DEFAULT)
  `uvm_component_utils_end
`pragma protect end

endclass


/// @}
/// @}
/// @}
