/**

    COPYRIGHT (C) 2016-2018 - AEDVICES CONSULTING
    INTERNAL_USE_ONLY
**/
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_env.sv 1466 2018-04-21 18:53:18Z francois $
// $Author: francois $
// $LastChangedDate: 2018-04-21 20:53:18 +0200 (sam., 21 avr. 2018) $
// $Revision: 1466 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// \file
/// Generic UART VIP
`pragma protect begin

/// constructor
function uart_env::new(string name="uart_env",uvm_component parent=null);
  super.new(name,parent);

endfunction


/// Build template Environment
/// List of agents, either active or passive, either tx or slave
/// \todo get intemplatered from AXI pattern
function void uart_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

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
    create_agent(ii,MASTER);
  end // for

  // Create Slave Agents
  for (int ii=0;ii<nr_slaves;ii++) begin
    create_agent(ii,SLAVE);
  end // for

endfunction


/// Connect phase. Link components together when needed
function void uart_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction



/// Retrieve a sequencer from the agent name
function uart_sequencer uart_env::get_sequencer(string name="master0");
  if (agents.exists(name)) begin
      return   agents[name].sequencer;
  end
    else
    `uvm_fatal(get_name(),$psprintf("Unknown agent name %s",name))

endfunction



function void uart_env::create_agent(int idx,uart_agent_kind_t kind);
  uart_agent lagent ;

  // Default Name
  string name;
  unique case (kind)
    MASTER : name = $psprintf("master%-0d",idx);
    SLAVE  : name = $psprintf("slave%-0d",idx);
    default : `uvm_fatal("F_SETUP","Something wrong had happened. Contact support@aedvices.com for any help.")
  endcase

  // Unless name is given by configuration DB
  if ( uvm_config_db#(string)::exists(this,name,"name"))
    void'(uvm_config_db#(string)::get(this,name,"name",name));

  if ( agents.exists(name))
    `uvm_fatal("F_CONFIG_NAME","Duplicated agent name in your configuration. Unable to build UART Environment.");

  uvm_config_db#(uart_agent_kind_t)::set(this,name,"kind",kind);

  lagent = uart_agent::type_id::create(name,this);
  agents[name] = lagent;

endfunction

`pragma protect end
