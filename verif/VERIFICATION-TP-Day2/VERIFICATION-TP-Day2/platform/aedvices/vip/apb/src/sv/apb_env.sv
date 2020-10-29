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
// $Id: apb_env.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
/** \file
 class apb_env implementation
 */
`pragma protect begin


/// constructor
function apb_env::new(string name="apb_env",uvm_component parent=null);
  super.new(name,parent);

endfunction


/// Build apb Environment
/// List of agents, either active or passive, either master or slave
function void apb_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
 `uvm_info("DEBUG","APB env build_phase",UVM_NONE)


  // Check configuration
  if ( uvm_config_db#(integer)::exists(this,"","nr_masters"))
    void'(uvm_config_db#(integer)::get(this,"","nr_masters",nr_masters));
  else
    begin
      `uvm_warning(get_name(),"nr_masters not configured. Default is 0")
      nr_masters = 0;
    end

  if ( uvm_config_db#(integer)::exists(this,"","nr_slaves"))
    void'(uvm_config_db#(integer)::get(this,"","nr_slaves",nr_slaves));
  else
    begin
      `uvm_warning(get_name(),"nr_slaves not configured. Default is 0")
      nr_slaves = 0;
    end

  // Create Master Agents
  for (int ii=0;ii<nr_masters;ii++) begin
    apb_agent m ;

    // Default Name
    string master_name = $psprintf("master%-0d",ii);


    // Unless name is given by configuration DB
    if ( uvm_config_db#(string)::exists(this,master_name,"name"))
      void'(uvm_config_db#(string)::get(this,master_name,"name",master_name));

    if ( agents.exists(master_name) )
      `uvm_fatal("F_DUPLICATED_NAMES",$psprintf("configuration error, duplicated agent name: %s",master_name))

    uvm_config_db#(apb_agent_kind_t)::set(this,master_name,"kind",MASTER);

    m = apb_agent::type_id::create(master_name,this);
    masters.push_back(m);
    agents[master_name] = m;
    //agents.push_back(m);  end
  end // for

  // Create Slave Agents
  for (int ii=0;ii<nr_slaves;ii++) begin
    apb_agent s ;

    // Default Name
    string slave_name = $psprintf("slave%-0d",ii);

    // Unless name is given by configuration DB
    if ( uvm_config_db#(string)::exists(this,slave_name,"name"))
      void'(uvm_config_db#(string)::get(this,slave_name,"name",slave_name));

    uvm_config_db#(apb_agent_kind_t)::set(this,slave_name,"kind",SLAVE);

    if ( agents.exists(slave_name) )
      `uvm_fatal("F_DUPLICATED_NAMES",$psprintf("configuration error, duplicated agent name: %s",slave_name))

    s = apb_agent::type_id::create(slave_name,this);
    slaves.push_back(s);
    agents[slave_name] = s;
  end // for

endfunction


/// Connect phase. Link components together when needed
function void apb_env::connect_phase(uvm_phase phase);

endfunction



/// Retrieve a sequencer from the agent name
function uvm_sequencer_base apb_env::get_sequencer(string name="master0");
  if (agents.exists(name)) begin
      return   agents[name].sequencer;
  end
    else
    `uvm_fatal(get_name(),$psprintf("Unknown agent name %s",name))

endfunction



`pragma protect end