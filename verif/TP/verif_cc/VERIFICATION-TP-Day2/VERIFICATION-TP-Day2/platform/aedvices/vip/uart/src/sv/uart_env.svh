/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_env.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_env declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// \brief Generic UART Environment
/** \details
  *  UART environment use the following UVM configuration fields during the build_phase:
  *   <table>
  *   <tr><th> UVM Config DB Field </th><th> Type              </th><th>Description</th></tr>
  *   <tr><td> nr_masters          </td><td> int               </td><td> Number of UART Master Agents </td></tr>
  *   <tr><td> nr_slaves           </td><td> int               </td><td> Number of UART Slave  Agents </td></tr>
  *   <tr><td> masterNN.name       </td><td> string            </td><td> Name of the Master Agent NN, default is masterNN </td></tr>
  *   <tr><td> slaveNN.name        </td><td> string            </td><td> Name of the Master Agent NN, default is slaveNN </td></tr>
  *   </table>
  */
class uart_env extends uvm_env;

  // Environment Global Configuration Fields
  integer nr_masters; ///< Number of masters instanciated
  integer nr_slaves;  ///< Number of slaves instanciated

  /// Hash of all sequencer to allow easy access from agent name. Use get_sequencer(name) to retrieve any specific sequencer.
  uart_agent agents[string];

`pragma protect begin
	extern function new(string name="uart_env",uvm_component parent=null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function uart_sequencer get_sequencer(string name="master0");
  extern local virtual function void create_agent(int idx,uart_agent_kind_t kind);

  /// UVM DB registration
  `uvm_component_utils_begin(uart_env)
    `uvm_field_int(nr_masters , UVM_DEFAULT)
    `uvm_field_int(nr_slaves  , UVM_DEFAULT)
  `uvm_component_utils_end

`pragma protect end
endclass



/// @}
/// @}
/// @}
