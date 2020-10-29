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
// $Id: uart_wb_ip_verif_default_sequence.svh 319 2017-09-30 16:48:03Z francois $
// $Author: francois $
// $LastChangedDate: 2017-09-30 18:48:03 +0200 (sam., 30 sept. 2017) $
// $Revision: 319 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


class uart_wb_ip_verif_default_sequence extends uart_wb_ip_verif_base_sequence;
  `uvm_object_utils(uart_wb_ip_verif_default_sequence)

  rand int count;
  constraint count_c { count > 0 && count <= 10; }

  constraint test_control_c { test_control == 1;}
              
  function new(string name="uart_wb_ip_verif_default_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
      bit fifo_empty = 0;
   
    // Some user message
    `uvm_info("LAB1","starting",UVM_LOW);

    `uvm_do_with(req, { req.addr      == `UART_LCR; // 3
          req.direction == WB_WRITE;
          req.data      == 'h80;
          req.width     == BYTE; } );

    `uvm_do_with(req, { req.addr      == `UART_IER_OR_DIVISOR_MSB;
          req.direction == WB_WRITE;
          req.data      == 0;
          req.width     == BYTE; } );
              
    // DL = F / ( 16 * BPS ) = 21.701 = 22 
    `uvm_do_with(req, { req.addr      == `UART_TX_RX_OR_DIVISOR_LSB; // 0   
          req.direction == WB_WRITE;
          req.data      == 22;
          req.width     == BYTE; } );
            
    // Write 0 to LCR[7] to get back to normal mode (DLAB=0)
    `uvm_do_with(req, { req.addr      == `UART_LCR;
          req.direction == WB_WRITE;
          req.data      == 0;   
          req.width     == BYTE; } );
    
    // Set bit 7 of LCR to 0 so that we can programm the UART
    `uvm_do_with(req, { req.addr      == `UART_LCR;
          req.direction == WB_WRITE;
          //req.data      == 'h00;
          req.data[1:0] == 'b11;  
          // 2 Stop bits
          req.data[2:2] == 1;  
          // Parity enable
          req.data[3:3] == 1;  
          // Even parity
          req.data[4:4] == 1;               
          // Force other bits to 0
          req.data[7:5] == 0;
                
          req.width     == BYTE; } );
    
    
    repeat (10)
      begin
        `uvm_do_with(req, { req.addr == `UART_TX_RX_OR_DIVISOR_LSB;
              req.direction == WB_WRITE;
              req.data      == count;
              req.width     == BYTE; } );
                          
        // Poll register: UART_LSR 020
        fifo_empty = 0;
        while ( fifo_empty == 0 ) begin
          `uvm_do_with(req , { req.addr == `UART_LSR;
                req.direction == WB_READ;
                req.width     == BYTE;} )
            
          `uvm_info(get_type_name(),$psprintf("waiting for fifo empty received data 0x%08x",req.data),UVM_LOW)
              
          if ( ( req.data[6] == 1 ) ) 
            fifo_empty = 1;
        end // while
        
      end // repeat
      
    #100us;
               
    `uvm_info(get_type_name(),"ending",UVM_LOW);
      
  endtask

endclass : uart_wb_ip_verif_default_sequence
