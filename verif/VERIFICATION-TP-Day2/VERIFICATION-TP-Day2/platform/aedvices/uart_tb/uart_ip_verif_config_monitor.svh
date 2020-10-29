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
// $Id: uart_ip_verif_config_monitor.svh 445 2018-05-15 09:05:58Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-05-15 11:05:58 +0200 (mar., 15 mai 2018) $
// $Revision: 445 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

/// UART IP VERIF CONFIG MONITOR
/// Instanciate a monitor that allows to corralate design's config to UART Vip config 

/*! \function log2
 * \brief returns the log base 2 of the integer passed as an argument
*/
	function int unsigned log2(int unsigned value);

    	int unsigned clogb2;

      value = value - 1;
        for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
            value = value >> 1;
        end
		return clogb2;

	endfunction

class uart_ip_verif_config_monitor extends uvm_monitor; 
  //register the class within UVM factory
  `uvm_component_utils(uart_ip_verif_config_monitor)
  
  int unsigned freq_div ;

  uvm_analysis_imp #(apb_transfer    , uart_ip_verif_config_monitor) apb_import;
  uart_agent p_uart_agent;
    
  /// Constructor
  function new(string name="uart_ip_verif_config_monitor",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  bit monitor_enable = 0;
  bit dlab_mode  ;
  apb_address_t apb_address;

  /// UVM Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_import = new("apb_import", this);
  endfunction
        
  function void write(apb_transfer apb_tr);
    // check if apb_tr is related to a configuration register
    // if so, get the uart config,  update to p_uart_agent
    int stb_dec;
    
    if ( apb_tr.direction == WRITE ) 
    begin
      
      
      
      
      stb_dec = log2(apb_tr.strobe);
      apb_address = (apb_tr.address / 4)*4 + stb_dec;


      
      if ( ( dlab_mode == 1 ) && ( (apb_address) == `UART_IER_OR_DIVISOR_MSB ) )
      begin
        freq_div[15:8] = apb_tr.data[15:8] ;
      end
      else if ( ( dlab_mode == 1 ) && ( (apb_address ) == `UART_TX_RX_OR_DIVISOR_LSB ) )
      begin
        freq_div[7:0] = apb_tr.data[7:0] ;
      end
      else if  ( (apb_address )== `UART_LCR ) 
      begin
        uart_config cfg = p_uart_agent.get_config();
        //end_tr(cfg);
        //void'(begin_tr(cfg));

        dlab_mode = apb_tr.data[31:31];

        // char_length : size  
        case ( apb_tr.data[25:24] )
          0 : cfg.size = bits_5;
          1 : cfg.size = bits_6;
          2 : cfg.size = bits_7;
          3 : cfg.size = bits_8;
        endcase
        
        // stop_format
        case ( apb_tr.data[26:26] )
          0 : cfg.stop_format = stop_1;
          1 : if (cfg.size == bits_5)
                 cfg.stop_format = stop_1_2;
              else 
                 cfg.stop_format = stop_2;      
        endcase
        
        // parity 
        if ( apb_tr.data[27:27] )
            case ( apb_tr.data[28:28] )
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
                    
        `uvm_info(get_name(),$sformatf("New config detected: \n%s",cfg.sprint()),UVM_NONE)
        p_uart_agent.set_config(cfg);
      end
    end
       
  endfunction
    
    

        
endclass