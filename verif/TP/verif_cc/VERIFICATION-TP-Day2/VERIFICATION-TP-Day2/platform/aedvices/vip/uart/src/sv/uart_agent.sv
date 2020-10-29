/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_agent.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/// \file
/// Generic UART VIP

`pragma protect begin
//--------------------------------------------------------------
/// template Agent constructor
function uart_agent::new(string name="agent",uvm_component parent=null);
  super.new(name,parent);
endfunction

//--------------------------------------------------------------
/// template Agent Build
function void uart_agent::build_phase(uvm_phase phase);
  time res_100ps = 100ps;

  super.build_phase(phase);

/// \todo: fix  assert ( res_100ps > 0 ) else `uvm_fatal("F_TIME_PRECISION","Time precision shall be set < 100ps for proper clock generation");

  // Kind should be set before we go further.
  if ( uvm_config_db#(uart_agent_kind_t)::exists(this,"","kind") )
    void'(uvm_config_db#(uart_agent_kind_t)::get(this,"","kind",kind));
  else
    `uvm_fatal("F_UART_CONFIG","Unable to determine the agent kind")

  // Get Virtual Interface from main DB
  vif = get_vif();

  // Get configuration
  if ( !uvm_config_db #(uart_config)::get(this,"","config",cfg))
  begin
    `uvm_warning(get_name(),"No 'config' user settings, creating a default one with random timings")
    cfg = new();
    if ( ! cfg.randomize() )
      `uvm_fatal(get_name(),"Unable to get a random configuration");
  end
  assert (cfg != null) else `uvm_fatal("F_NULL_CFG","Configuration is Null")
  cfg.kind = this.kind; /// TODO: fix how the default mode is set, thru cfg struct or thu UVM DB. do we set a priority ?

  // Monitor is independent of ACTIVE/PASSIVE and tx/SLAVE
  // Build Tx Line Monitor
  tx_monitor = uart_line_monitor::type_id::create("tx_monitor",this);
  tx_monitor.p_agent = this;
  tx_monitor.kind = TXM;

  // Build Rx Line Monitor
  rx_monitor = uart_line_monitor::type_id::create("rx_monitor",this);
  rx_monitor.p_agent = this;
  rx_monitor.kind = RXM;

  // Instantiate Driver and Sequencer for Active Agents
  if ( get_is_active() == UVM_ACTIVE)
  begin
    driver    = uart_driver::type_id::create("driver",this);
    sequencer = uart_sequencer::type_id::create("sequencer",this);
  end

endfunction


//--------------------------------------------------------------
/// \brief Agent connect phase
/// \details connect the sequencer to the driver
///          connect the virtual interface to the testbench interface
function void uart_agent::connect_phase(uvm_phase phase);

  tx_monitor.line_vif = vif.tx;
  rx_monitor.line_vif = vif.rx;


  if ( get_is_active() == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);


    if ( kind == MASTER ) begin
      // Master active - drives TX
      driver.vif = vif.tx;
      // Link Monitor to Sequencer to provide responsive sequence support
      rx_monitor.completed_byte.connect(sequencer.received_frame_import);
    end
    else begin
      // Slave active - drives RX
      driver.vif = vif.rx;
      // Link Monitor to Sequencer to provide responsive sequence support
      tx_monitor.completed_byte.connect(sequencer.received_frame_import);
    end
  end
endfunction


//--------------------------------------------------------------
/// \brief returns the config
function  uart_config uart_agent::get_config();
  return cfg;
endfunction

//--------------------------------------------------------------
/// \brief set/update agent configuration
function void uart_agent::set_config(uart_config cfg);
  this.cfg = cfg;
endfunction

//--------------------------------------------------------------
/// \brief returns the configured interface
function virtual uart_if uart_agent::get_vif();
  virtual uart_if mvif;
  if (!uvm_config_db #(virtual uart_if)::get(this, "", "vif", mvif))
    `uvm_fatal("F_NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
  return mvif;
endfunction

`pragma protect end
