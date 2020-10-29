// ===============================================================================
//                    3 day training
//                  on 
//                      IP & SoC Verification Methodology 
//                                using UVM
// ===============================================================================
//                    Copyright (c) 2018 - AEDVICES Consulting
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for 
// training purposes.  
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab_sequence : Implement sequences
//---------------------------------------------------------------------------------------------------------
// Goals: 

typedef enum bit[1:0] {char5=0,char6=1,char7=2,char8=3} lab_char_width_t ;


// This sequence performs a byte access onto the APB
class apb_byte_access extends apb_sequence;
  rand apb_address_t address;     ///< register address 
  rand byte data;                 ///< register data to write
  rand apb_direction_t direction; ///< Direction APB_READ or WRITE
  
  
  // UVM factory settings
  `uvm_object_utils_begin(apb_byte_access)
    `uvm_field_int(address   , UVM_DEFAULT)
    `uvm_field_int(data      , UVM_DEFAULT)
    `uvm_field_enum(apb_direction_t , direction , UVM_DEFAULT)
  `uvm_object_utils_end

  // constructor
  function new(string name="apb_byte_access");
    super.new(name);
  endfunction
  
  // Sequence Body
  virtual task body();
    
    `uvm_do_with( 
        req , {
        req.address           == local::address;
        req.direction         == local::direction;
        if ( direction == WRITE )
          req.data              == ( apb_data_t'(local::data) << ((local::address%4)*8) );
        req.sel               == 0;
        req.prot              == 3'b000;
        req.strobe            == (1'b1 << (local::address%4));
        req.full_access       == 0;
      })
    
    `uvm_info(get_name(),$psprintf("Req.data = 0x%02x",req.data),UVM_NONE)
    if ( direction == READ ) 
      this.data = ( req.data >>  ((this.address%4)*8) );
  endtask
  
endclass



///////////////////////////////////////////////////////////////////////////////////
// LAB-TODO-STEP-1-a: implement a random init sequence
class lab_uart_init_seq extends apb_sequence;
  `uvm_object_utils(lab_uart_init_seq)

  rand int count;
  rand int unsigned divisor;
  rand lab_char_width_t char_width;
  rand bit parity_en,parity;
  
  constraint count_c          { count > 20 && count <= 100; }   
  constraint divisor_c        { divisor inside {[0:65535]};}
  
  

  apb_byte_access req8;
     
  task body();
    // TODO: LAB: register access using the randome parameters
    //--------------------
    // UART Init Start
    //--------------------    
    // Some user message
    `uvm_info(get_type_name(),"Initialization started",UVM_NONE);
    
    // LAB-TODO-STEP-1-d:  uncomment the following line
    // `uvm_do(init_seq);      
    
    //--------------------
    // UART Init Start
    //--------------------
    // LAB-TODO-STEP-1-b: replace the following with `uvm_do(init_seq)
    
    // Set bit 7 of LCR to 1 so that we can programm the Divisor Latch
    `uvm_do_with(req8, { 
                        req8.address           == `UART_LCR; // 0x03
                        req8.direction         == WRITE;
                        req8.data              == 'h80 ;
                      } 
                );
    `uvm_info("debug", $psprintf("seq LCR_0x03: %s",req8.sprint()), UVM_HIGH);
  
    `uvm_do_with(req8, { 
                        req8.address           == `UART_TX_RX_OR_DIVISOR_LSB; // 0x00   
                        req8.direction         == WRITE;
                        req8.data              == 'h01;
                      } 
                );
    `uvm_info("debug", $psprintf("seq DIV_LSB_0x00: %s",req8.sprint()), UVM_HIGH);

    `uvm_do_with(req8, { 
                        req8.address           == `UART_IER_OR_DIVISOR_MSB; // 0x01
                        req8.direction         == WRITE;
                        req8.data              == 'h00;  // keep it to 0

                      } 
                );
    `uvm_info("debug", $psprintf("seq DIV_MSB_0x01: %s",req8.sprint()), UVM_HIGH);
                
    // Set bit 7 of LCR to 0 so that we can programm the UART
    // Write 0 to LCR[7] to get back to normal mode (DLAB=0)  
    `uvm_do_with(req8, { 
                        req8.address           == `UART_LCR; // 0x03
                        req8.direction         == WRITE;
                        req8.data              == 'h00  ;
                      } 
                );
    `uvm_info("debug", $psprintf("seq UART_LCR_0x03: %s",req8.sprint()), UVM_HIGH);
    
    // 8 bits per character
    // 1 stop bit
    // Parity disable
    // No Parity
    // TODO: LAB: make this random
    `uvm_do_with(req8, { 
                        req8.address           == `UART_LCR;
                        req8.direction         == WRITE;
                        req8.data              == { 3'b000, parity, parity_en, 1'b0, char_width };

                      } 
                );
    
    // No Interrupt
    // TODO: LAB: make this random
    `uvm_do_with(req8, { 
                        req8.address           == `UART_IER_OR_DIVISOR_MSB;
                        req8.direction         == WRITE;
                        req8.data              == 'h00 ;   // todo: LAB: make this a random configuration

                      } 
                );

  endtask
endclass


///////////////////////////////////////////////////////////////////////////////////
// LAB-TODO-STEP-2-a: implement test sequence A
class lab_send_tx_data extends apb_sequence;
  `uvm_object_utils(lab_send_tx_data)

  rand byte data_tx;
  apb_byte_access req8;
  
  function new(string name="lab_send_tx_data");
    super.new(name);
  endfunction
  
  task body();
    bit fifo_empty = 0;     
    begin
      `uvm_do_with(req8, { 
                          req8.address           == `UART_TX_RX_OR_DIVISOR_LSB; // 0x00
                          req8.direction         == WRITE;
                          req8.data              == data_tx;
                        } 
                  );
      `uvm_info("debug", $psprintf("data send: %s",req8.sprint()), UVM_NONE);
                      
      //Poll register: UART_LSR 020
      fifo_empty = 0;
      while ( fifo_empty == 0 ) begin
        `uvm_do_with(req8 , { 
                             req8.address            == `UART_LSR;
                             req8.direction          == READ;

                           } 
                     );      
      
        `uvm_info(get_type_name(),$psprintf("waiting for fifo empty received data: %b",req8.data),UVM_HIGH)   
        if( (req8.data) ==  `UART_LSR_THRE) 
          #4000ns
          fifo_empty = 1;
      end //while
                  
      // Some user message
      `uvm_info(get_type_name(),"Transfer done",UVM_NONE);             
    end  

  endtask  
  
  
endclass






class lab_test_sequence extends uart_ip_verif_base_sequence;
  `uvm_object_utils(lab_test_sequence)

  // Using sub-sequences 
  lab_uart_init_seq uart_init_seq0;
  lab_send_tx_data  send_tx_data_seq0;
         
  // Task Body
  virtual task body();

    starting_phase.raise_objection(this);            
      
    `uvm_info(get_type_name(),"Top seq - Starting",UVM_NONE);
    
    `uvm_do_with(uart_init_seq0, {char_width == char5; });
    repeat (100)
    begin
      randcase 
        20 : `uvm_do(uart_init_seq0)
        80 : `uvm_do(send_tx_data_seq0)
      endcase
    end
              
    `uvm_info(get_type_name(),"Top seq - Done",UVM_NONE);             
    starting_phase.drop_objection(this);
    
  endtask // Body
    
endclass // lab_on_seq_test_sequence
