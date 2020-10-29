/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// Copyright (c) 2016 - AEDVICES Consulting
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Use of this code is subject to license agreement.
// For any querry contact AEDVICES Consulting: contact@aedvices.com
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: apb_agent.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_agent declaration
 */

`pragma protect begin

//--------------------------------------------------------------
/// apb Agent constructor
function apb_agent::new(string name="agent",uvm_component parent=null);
  super.new(name,parent);
endfunction

//--------------------------------------------------------------
/// apb Agent Build
function void apb_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  `uvm_info(get_name(),"Agent Build Phase",UVM_NONE)

  // Kind should be set before we go further.
  if ( uvm_config_db#(apb_agent_kind_t)::exists(this,"","kind") )
    void'(uvm_config_db#(apb_agent_kind_t)::get(this,"","kind",kind));
  else
    `uvm_fatal("F_APB_CONFIG","Unable to determine the agent kind")

  // Get Virtual Interface from main DB
  if (!uvm_config_db #(virtual apb_if)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})


  // Get configuration
  if ( !uvm_config_db #(apb_config)::get(this,"","config",cfg))
  begin
    `uvm_warning(get_name(),"No 'config' user settings, creating a default one with random timings")
    cfg = new();
    if ( ! cfg.randomize() )
      `uvm_fatal(get_name(),"Unable to get a random configuration");
    cfg.kind = this.kind;
    cfg.print();
  end
  cfg.kind = this.kind; /// TODO: fix how the default mode is set, thru cfg struct or thu UVM DB. do we set a priority ?

  // Monitor is independent of ACTIVE/PASSIVE and MASTER/SLAVE
  monitor = apb_monitor::type_id::create("monitor",this);
  monitor.p_agent = this;

  // Instantiate Driver and Sequencer for Active Agents
  if ( get_is_active() == UVM_ACTIVE)
  begin
    if ( kind == MASTER )
      begin
        // assign virtual class with actual implementation
        driver    = apb_master_driver   ::type_id::create("driver"   ,this);
        sequencer = apb_master_sequencer::type_id::create("sequencer",this);

      end // kind == MASTER
    else
      begin // kind == SLAVE

        // assign virtual class with actual implementation
        driver    = apb_slave_driver   ::type_id::create("driver"   ,this);
        sequencer = apb_slave_sequencer::type_id::create("sequencer",this);

        // If there is not reactive sequence, use the default one
        if ( ! cfg.disable_default_slave_sequence ) begin
          uvm_config_db#(uvm_object_wrapper)::set(sequencer,
              "run_phase",
              "default_sequence",
              apb_slave_default_reactive_seq::type_id::get());
        end



      end // SLAVE
  end


endfunction


//--------------------------------------------------------------
/// \brief apb Agetn connect phase
/// \details connect the sequencer to the driver
///          connect the virtual interface to the testbench interface
function void apb_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);


  monitor.vif = this.vif;
  vif.psel_width       = cfg.psel_width;
  vif.slave_shared_bus = cfg.slave_shared_bus;

  if ( cfg.apb_revision == IHI0024B )
    vif.assert_write_strobe = 0;

  if ( get_is_active() == UVM_ACTIVE) begin

    driver.p_agent = this;
    sequencer.p_agent = this;

    driver.seq_item_port.connect(sequencer.seq_item_export);



    if ( kind == MASTER ) begin
      // Master active
      driver.vif = this.vif;
    end
    else begin
      // Slave active
      apb_slave_sequencer sqr;
      if ( ! $cast(sqr,sequencer) )
        `uvm_fatal(get_full_name(),$sformatf("Unable to cast %s sequencer as a apb_slave_sequencer",get_name()))

      // SLave active
      driver.vif = this.vif;

      // Link Monitor to Sequencer to provide responsive sequence support
      monitor.address_phase_transfer_port.connect(sqr.address_phase_transfer_import);

    end
  end


endfunction

/// Return the current agent configuration
function apb_config apb_agent::get_config();
  return cfg;
endfunction

/// set/update the current agent configuration
function void apb_agent::set_config(apb_config cfg);
  this.cfg = cfg;
endfunction

`pragma protect end