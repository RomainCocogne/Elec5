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
// $Id: uart_ip_verif_config_monitor.svh 474 2019-01-05 19:41:27Z francois $
// $Author: francois $
// $LastChangedDate: 2019-01-05 20:41:27 +0100 (sam., 05 janv. 2019) $
// $Revision: 474 $
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
  
  //Attributes
  int unsigned freq_div ;
  //UART Attributes:
  uart_parity_t       parity;     ///< Define the parity configuration
  uart_frame_size_t   size;       ///< Define the size of each frame
  uart_frame_stop_format_t stop_format;


  /// Min/Max Delay Settings
  int unsigned min_interframe; ///< minimum cycles between two frames
  int unsigned max_interframe; ///< minimum cycles between two frames

  int unsigned min_baud_rate; ///< Min baud rate Uart Transmission (in bit-per-second).
  int unsigned max_baud_rate; ///< Max baud rate Uart Transmission (in bit-per-second).
  int unsigned baud_rate;     ///< Theoritical baud rate Uart Transmission (in bit-per-second).

  //Packet control
  bit illegal_frame;     ///< Defines the Frame corruptions.

  // Debug/Display Settings
  bit print_tx_char;   ///< Enable printing of tx char from monitor (default: disabled)
  bit print_rx_char;   ///< Enable printing of rx char from monitor (default: disabled)
  bit print_tx_string; ///< Enable printing of tx string ending with '\n' from monitor (default: disabled)
  bit print_rx_string; ///< Enable printing of rx string ending with '\n' from monitor (default: disabled)


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

  
    `uvm_info(get_name(),$sformatf("APB TRANSFER: \n%s",apb_tr.sprint()),UVM_FULL)
  
  
    if ( apb_tr.direction == WRITE ) 
    begin
  
      apb_tr.data = apb_tr.data >> (apb_tr.address[1:0]*8);
  
      apb_address = apb_tr.address[3:0];
  
      if ( ( dlab_mode == 1 ) && ( (apb_address) == `UART_IER_OR_DIVISOR_MSB ) )
      begin
        freq_div[15:8] = apb_tr.data[7:0] ;
      end
      else if ( ( dlab_mode == 1 ) && ( (apb_address ) == `UART_TX_RX_OR_DIVISOR_LSB ) )
      begin
        freq_div[7:0] = apb_tr.data[7:0] ;
      end
      else if  ( (apb_address )== `UART_LCR ) 
      begin
        uart_config cfg = p_uart_agent.get_config();
  
        dlab_mode = apb_tr.data[7:7];
  
        // char_length : size  
        case ( apb_tr.data[1:0] )
          0 : size = bits_5;
          1 : size = bits_6;
          2 : size = bits_7;
          3 : size = bits_8;
        endcase
        
        // stop_format
        case ( apb_tr.data[2:2] )
          0 : stop_format = stop_1;
          1 : if (size == bits_5)
                 stop_format = stop_1_2;
              else 
                 stop_format = stop_2;      
        endcase
        
        // parity 
        if ( apb_tr.data[3:3] )
            case ( apb_tr.data[4:4] )
            0 : parity = ODD;
            1 : parity = EVEN;                
            endcase
        else
            parity = NONE;
        
        // baud_rate
        if ( freq_div != 0 ) 
        begin
            baud_rate = 40_000_000/(16*freq_div);
            min_baud_rate = 40_000_000/(16*freq_div);
            max_baud_rate = 40_000_000/(16*freq_div);     
        end
        else if ( ! dlab_mode )
          `uvm_error(get_name(),"Configuring freq_div == 0 is not allowed to get UART working properly")
        //This is a workaround to Error (suppressible): (vlog-8386)
        assert(cfg.randomize() with 
                    {
                      parity     == local::parity;
                      size     == local::size;
                      stop_format  == local::stop_format;
                      if(freq_div != 0){
                        baud_rate    == local::baud_rate;
                        min_baud_rate == local::min_baud_rate;
                        max_baud_rate == local::max_baud_rate;
                      }
                    }
        )else `uvm_fatal("UART_VIP_CONFIGURATION", "Unable to configure the UART VIP");
        
        `uvm_info(get_name(),$sformatf("New config detected: \n%s",cfg.sprint()),UVM_NONE)
        p_uart_agent.set_config(cfg);
      end
    end
     
  endfunction
    

        
endclass