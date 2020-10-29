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
// $Id: uart_ip_verif_config_monitor.svh 335 2017-10-18 22:57:38Z francois $
// $Author: francois $
// $LastChangedDate: 2017-10-19 00:57:38 +0200 (jeu., 19 oct. 2017) $
// $Revision: 335 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// UART IP VERIF CONFIG MONITOR
/// Instanciate a monitor that allows to corralate design's config to UART Vip config 
`define UART1_BASE_ADDR 'h17000000
`define UART1_REG_RB  (`UART1_BASE_ADDR+0)	// receiver buffer
`define UART1_REG_TR  (`UART1_BASE_ADDR+0)	// transmitter
`define UART1_REG_IE  (`UART1_BASE_ADDR+1)	// Interrupt enable
`define UART1_REG_II  (`UART1_BASE_ADDR+2)	// Interrupt identification
`define UART1_REG_FC  (`UART1_BASE_ADDR+2)	// FIFO control
`define UART1_REG_LC  (`UART1_BASE_ADDR+3)	// Line Control
`define UART1_REG_MC  (`UART1_BASE_ADDR+4)	// Modem control
`define UART1_REG_LS  (`UART1_BASE_ADDR+5)	// Line status
`define UART1_REG_MS  (`UART1_BASE_ADDR+6)	// Modem status
`define UART1_REG_SR  (`UART1_BASE_ADDR+7)	// Scratch register
`define UART1_REG_DL1 (`UART1_BASE_ADDR+0)	// Divisor latch LSB
`define UART1_REG_DL2 (`UART1_BASE_ADDR+1) // Divisor latch MSB 
`define UART1_REG_32_0 (`UART1_BASE_ADDR+8)
`define UART1_REG_32_1 (`UART1_BASE_ADDR+9)

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_wb_ip_verif_config_monitor extends uvm_monitor; 
  //register the class within UVM factory
  `uvm_component_utils(uart_wb_ip_verif_config_monitor)
  
  int unsigned freq_div ;

  uvm_analysis_imp #(wishbone_transfer    , uart_wb_ip_verif_config_monitor) wishbone_import;
  uart_agent p_uart_agent;
    
  /// Constructor
  function new(string name="uart_wb_ip_verif_config_monitor",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  bit monitor_enable = 0;
  bit dlab_mode ;

  /// UVM Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wishbone_import = new("wishbone_import", this);
  endfunction
        
  function void write(wishbone_transfer wbtr);
    // check if wbtr is related to a configuration register
    // if so, get the uart config,  update to p_uart_agent
    
    if ( wbtr.direction == WB_WRITE ) 
    begin
      $display(" IN CONFIG MONITOOOOOOOOOR ");
      wbtr.print();
      $display("*****************************");
      if ( ( dlab_mode == 1 ) && ( wbtr.addr == (`UART1_REG_DL2 ) ))
        freq_div[15:8] = wbtr.data ;
      else if ( ( dlab_mode == 1 ) && ( wbtr.addr == (`UART1_REG_DL1)) )
        freq_div[7:0] = wbtr.data ;
      else if  ( wbtr.addr == (`UART1_REG_LC ) )
      begin
        uart_config cfg = p_uart_agent.get_config();
  
        dlab_mode = wbtr.data[7:7];

        // char_length : size  
        case ( wbtr.data[1:0] )
          0 : cfg.size = bits_5;
          1 : cfg.size = bits_6;
          2 : cfg.size = bits_7;
          3 : cfg.size = bits_8;
        endcase
        
        // stop_format
        case ( wbtr.data[2:2] )
          0 : cfg.stop_format = stop_1;
          1 : if (cfg.size == bits_5)
                 cfg.stop_format = stop_1_2;
              else 
                 cfg.stop_format = stop_2;      
        endcase
        
        // parity 
        if ( wbtr.data[3:3] )
            case ( wbtr.data[4:4] )
            0 : cfg.parity = ODD;
            1 : cfg.parity = EVEN;                
            endcase
        else
            cfg.parity = NONE;
        
        // baud_rate
        if ( freq_div != 0 ) 
        begin
            cfg.baud_rate = 40_000_000/(16*freq_div);
            cfg.min_baud_rate = 40_000_000/(16*freq_div);
            cfg.max_baud_rate = 40_000_000/(16*freq_div);     
        end
        else if ( ! dlab_mode )
          `uvm_error(get_name(),"Configuring freq_div == 0 is not allowed to get UART working properly")
                    
        `uvm_info(get_name(),$sformatf("New config detected: \n%s",cfg.sprint()),UVM_MEDIUM)
        p_uart_agent.set_config(cfg);
      end
    end
       
  endfunction
    
    

        
endclass