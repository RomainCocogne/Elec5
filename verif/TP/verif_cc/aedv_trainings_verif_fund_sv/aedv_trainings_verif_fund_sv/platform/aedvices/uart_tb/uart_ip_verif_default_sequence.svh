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
// $Id: uart_ip_verif_default_sequence.svh 445 2018-05-15 09:05:58Z adrien $
// $Author: adrien $
// $LastChangedDate: 2018-05-15 11:05:58 +0200 (mar., 15 mai 2018) $
// $Revision: 445 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


class uart_ip_verif_default_sequence extends uart_ip_verif_base_sequence;
  `uvm_object_utils(uart_ip_verif_default_sequence)

  rand int count;
  constraint count_c { count > 0 && count <= 10; }

  constraint test_control_c { test_control == 1;}
  
  
  function new(string name="uart_ip_verif_default_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
      bit fifo_empty = 0;
   
    // Some user message
    `uvm_info("LAB1","starting",UVM_LOW);

    `uvm_do_with(apb_trans, { apb_trans.address   == `UART_LCR; // 3
                              apb_trans.direction == WRITE;
                              apb_trans.data      == 'h80;
                              apb_trans.width     == BYTE; } );

    `uvm_do_with(apb_trans, { apb_trans.address      == `UART_IER_OR_DIVISOR_MSB;
                              apb_trans.direction == WRITE;
                              apb_trans.data      == 0;
                              apb_trans.width     == BYTE; } );
              
    // DL = F / ( 16 * BPS ) = 21.701 = 22 
    `uvm_do_with(apb_trans, { apb_trans.address   == `UART_TX_RX_OR_DIVISOR_LSB; // 0   
                              apb_trans.direction == WRITE;
                              apb_trans.data      == 1;
                              apb_trans.width     == BYTE; } );
            
    // Write 0 to LCR[7] to get back to normal mode (DLAB=0)
    `uvm_do_with(apb_trans, { apb_trans.address   == `UART_LCR;
                              apb_trans.direction == WRITE;
                              apb_trans.data      == 0;   
                              apb_trans.width     == BYTE; } );
    
    // Set bit 7 of LCR to 0 so that we can programm the UART
    `uvm_do_with(apb_trans, { apb_trans.address   == `UART_LCR;
                              apb_trans.direction == WRITE;
                              //apb_trans.data    == 'h00;
                              apb_trans.data[1:0] == 'b11;  
                              // 2 Stop bits
                              apb_trans.data[2:2] == 0;  
                              // Parity enable
                              apb_trans.data[3:3] == 0;  
                              // Even parity
                              apb_trans.data[4:4] == 0;               
                              // Force other bits to 0
                              apb_trans.data[7:5] == 0;
                                    
                              apb_trans.width     == BYTE; } );
    
    
    repeat (10)
      begin
        `uvm_do_with(apb_trans, { apb_trans.address   == `UART_TX_RX_OR_DIVISOR_LSB;
                                  apb_trans.direction == WRITE;
                                  //apb_trans.data      == count;
                                  apb_trans.width     == BYTE; } );
                          
        // Poll register: UART_LSR 020
        fifo_empty = 0;
        while ( ! fifo_empty ) begin
          `uvm_do_with(apb_trans , { apb_trans.address   == 5;
                                     apb_trans.direction == READ;
                                     apb_trans.width     == BYTE;} )
            //apb_trans.print();
          `uvm_info(get_type_name(),$psprintf("Waiting for fifo empty received data 0x%08x !!!",apb_trans.data),UVM_LOW)
              
          if ( ( apb_trans.data[13] == 1 ) ) 
            fifo_empty = 1;
        end // while
        
      end // repeat
      
    #100us;
               
    `uvm_info(get_type_name(),"ending",UVM_LOW);
      
  endtask

endclass : uart_ip_verif_default_sequence
