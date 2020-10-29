/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_frame.svh 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/** \file
 class uart_frame declaration
 */

/// \addtogroup packages
/// @{
/// \addtogroup aed_uart_pkg aed_uart_pkg
/// @{
/// \addtogroup Classes
/// @{

/// \brief Single UART Frame.
/// \details Random fields are constraints in regards to agent uart_config.
class uart_frame extends uvm_sequence_item;

  uart_agent_kind_t agent_kind;     ///< kind of agent this transaction belongs to. \n Values are MASTER, SLAVE, MONITOR.
  protected uart_config cfg = null; ///< Pointer to the protocol config

  //-------------------------------------
  // Fields declaration
  //-------------------------------------
  rand int unsigned delay; ///< interframe delay prior to send the current frame
  rand bit [`UART_DATA_MAX_WIDTH-1:0] data;    ///< data to be transmitted
  rand bit parity_bit;    ///< Frame parity bit

  rand uart_direction_t    direction;  ///< TX or RX. Random by default.

  //Packet control
  rand bit stop_bit_error;   ///<Define an error on stop bit
  rand bit parity_bit_error; ///<Define an error on parity bit
  rand bit start_bit_error;  ///<Define an error on start bit
  rand bit baudrate_error;   ///<Define an error on baudrate

  /// Additional Status Members sets by drivers and monitors
  time start_time; ///< time when the transaction has been pushed to the driver or observed by the monitor
  time end_time; ///<time when the last transfer has been fully driven or observed by the monitor.
`pragma protect begin

  //-------------------------------------
  // Hard/Structural Constraints
  //-------------------------------------


  //-------------------------------------
  // Soft Constraints (Questa > 10.4)
  //-------------------------------------
  constraint default_parity_val_c {
    soft parity_bit == calc_parity();
    solve data before parity_bit;
    solve parity_bit_error before parity_bit;
  }

  constraint delay_c {
    if ( cfg != null ) {
      soft delay >= cfg.min_interframe;
      soft delay <= cfg.max_interframe;
    } else {
      soft delay >= 0;
      soft delay <= 1000;
    }
  }

  // To ensure no errors when no Illegal frame
  constraint default_packet_ctrl_c {
    if ( cfg != null ) {
      cfg.illegal_frame == 0 -> stop_bit_error == 0;
      cfg.illegal_frame == 0 -> parity_bit_error == 0;
      cfg.illegal_frame == 0 -> start_bit_error == 0;
      cfg.illegal_frame == 0 -> baudrate_error == 0;
    }
  }

  // To ensure Illegal frame is possible
  constraint illegal_packet_ctrl_c {
    if ( cfg != null ) {
      (cfg.illegal_frame == 1) -> stop_bit_error inside {0,1};
      (cfg.illegal_frame == 1) -> parity_bit_error inside {0,1};
      (cfg.illegal_frame == 1) -> start_bit_error inside {0,1};
      (cfg.illegal_frame == 1) -> baudrate_error inside {0,1};
    }
  }


  //-------------------------------------
  // Methods
  //-------------------------------------
  /// Methods
  function new(string name="uart_frame");
    super.new(name);
  endfunction


   /// Set the transaction config
  function void set_cfg(uart_config cfg=null);
    if ( cfg == null )
    begin
      uvm_sequencer_base u_sqr;
      uart_sequencer a_sqr;
      u_sqr = get_sequencer();
      if ( ! $cast(a_sqr,u_sqr) )
        `uvm_fatal(get_name(),"Unable to cast transaction sequencer to uartsequencer.\n\tTransaction item called outside an uart sequence.");
      cfg = a_sqr.p_agent.get_config();
    end
    this.cfg = cfg;
    //agent_kind = cfg.kind;
  endfunction
`pragma protect end

  // Get configuration prior to randomization
  function void pre_randomize();
  `pragma protect begin
    super.pre_randomize();
    if ( cfg == null )
      set_cfg();
  `pragma protect end
  endfunction

`pragma protect begin

function bit calc_parity();
  bit result = 0;
  if ( cfg == null )
    `uvm_fatal("F_NULL_CFG","Configuration is Null")
  for (int ii=0;ii<cfg.size;ii++)
    result += data[ii];
  if (parity_bit_error == 0)
    return (!(cfg.parity == result));// Good parity bit
  else
    return ((cfg.parity == result));//Bad parity bit
endfunction

  /// UVM Database Records
  `uvm_object_utils_begin(uart_frame)
    `uvm_field_enum(uart_direction_t, direction,  UVM_ALL_ON)
    `uvm_field_int(data,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(parity_bit,  UVM_ALL_ON + UVM_HEX)
    `uvm_field_int(delay, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(stop_bit_error, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(parity_bit_error, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(start_bit_error, UVM_ALL_ON + UVM_DEC)
    `uvm_field_int(baudrate_error, UVM_ALL_ON + UVM_DEC)
  `uvm_object_utils_end

`pragma protect end


endclass



/// @}
/// @}
/// @}
