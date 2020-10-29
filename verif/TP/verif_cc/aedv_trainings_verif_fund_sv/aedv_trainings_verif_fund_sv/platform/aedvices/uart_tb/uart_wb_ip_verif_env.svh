// ===============================================================================
//                    Copyright (c) 2015 - AEDVICES Consulting
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developped by AEDVICES Consulting for 
// training purposes.  
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================
// Copyright (c) 2016-2017 - AEDVICES Consulting 
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: uart_wb_ip_verif_env.svh 415 2018-02-08 10:43:22Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-02-08 11:43:22 +0100 (jeu., 08 févr. 2018) $
// $Revision: 415 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


class uart_wb_ip_verif_env extends uvm_env;
  `uvm_component_utils(uart_wb_ip_verif_env)
  //--------------------------------------------------
  // Member Objects
  //--------------------------------------------------
  wishbone_env wishbone_env0; ///< Wishbone VIP environment
  uart_env uart_env0;         ///< UART Rx/Tx VIP environment
  uart_wb_ip_verif_config_monitor config_monitor0; /// Uart config monitor
  //--------------------------------------------------
  // Functions Declaration
  //--------------------------------------------------

  // Constructor and UVM Phases
  extern function new(string name,uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass 



//--------------------------------------------------
// Functions Implementation
//--------------------------------------------------

/// Constructor
function uart_wb_ip_verif_env::new(string name,uvm_component parent);
  super.new(name,parent);
endfunction 


// UVM Build Phase
function void uart_wb_ip_verif_env::build_phase(uvm_phase phase);
  uart_config cfg = new();
  
  

  

  // Configure the Wishbone VIP  
  uvm_config_db#(integer)::set(this, "wishbone_env0", "nr_masters", 1);
  uvm_config_db#(integer)::set(this, "wishbone_env0", "nr_slaves", 0);
      
  uvm_config_db#(uvm_active_passive_enum)::set(this,"wishbone_env0.master0","is_active" , UVM_PASSIVE);
  uvm_config_db#(integer)                ::set(this,"wishbone_env0.master0","addr_width", `UART_ADDR_WIDTH);
  uvm_config_db#(integer)                ::set(this,"wishbone_env0.master0","data_width", `UART_DATA_WIDTH);
  uvm_config_db#(wishbone_endianness_t)  ::set(this,"wishbone_env0.master0","endianness", WB_LITTLE_ENDIAN);

  
  
  
    // Instantiate the UART_IP_VERIF_CONFIG_MONITOR
  
   
  
  // Configure the UART VIP
  if ( ! cfg.randomize() with {
          min_baud_rate      == 115200;      // 1,250Mbps (Bits/second) = 800ns per bit
          max_baud_rate      == 115200;      // 1,250Mbps
          parity             == EVEN;      // Parity EVEN
          size               == bits_8;    // Data 8 bits   
          stop_format        == stop_2;    // 2 stop bits
          illegal_frame      == 0;         // By default Frames are legal
    } )
    `uvm_fatal("F_GEN_CFG","Unable to generate a valid configuration for UART");

  uvm_config_db#(uart_config)      ::set(this, "uart_env0.uart_agent0"  ,"config" , cfg );

  uvm_config_db#(integer)::set(this, "uart_env0", "nr_slaves" , 1);  
  uvm_config_db#(integer)::set(this, "uart_env0", "nr_masters" , 0);  
  uvm_config_db#(string) ::set(this, "uart_env0.slave0", "name" , "uart_agent0"); 
  

  wishbone_env0 = wishbone_env::type_id::create("wishbone_env0",this);
  uart_env0 = uart_env::type_id::create("uart_env0",this);
  config_monitor0 = uart_wb_ip_verif_config_monitor::type_id::create("config_monitor0",this);
endfunction

   //------------------------
    // Connect phase
    //------------------------
    function void uart_wb_ip_verif_env::connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      wishbone_env0.masters[0].monitor.collected_request.connect(config_monitor0.wishbone_import);
      config_monitor0.p_uart_agent = uart_env0.agents["uart_agent0"];
      
    endfunction