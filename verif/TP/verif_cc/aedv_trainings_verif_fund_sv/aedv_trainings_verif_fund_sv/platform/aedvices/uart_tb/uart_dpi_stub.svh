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
// $Id: uart_dpi_stub.svh 305 2017-09-12 17:04:24Z francois $
// $Author: francois $
// $LastChangedDate: 2017-09-12 19:04:24 +0200 (mar., 12 sept. 2017) $
// $Revision: 305 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -


  import "DPI-C" context task dpi_main();

  export "DPI-C" task dpi_write;
  export "DPI-C" task dpi_read;
  export "DPI-C" task dpi_wait;


  uvm_tlm_b_transport_port #(uvm_tlm_generic_payload) tlm_transaction_transport;  
  uvm_tlm_b_transport_port #(uvm_tlm_generic_payload) uart_transaction_transport;  


  task dpi_write(int unsigned addr,byte data);
    bit superuser;
    uvm_tlm_generic_payload tr;
    uvm_tlm_time tt;
    tt = new();
    tr = new();


    //`uvm_info("dpi_tlm",$psprintf("sending to UVM VIP addr=0x%08x, data=0x%08x",addr,data),UVM_LOW)
    
      tr.m_address = addr;
      // create a list of 4 bytes initialized with all data bytes starting from byte 0
      tr.m_data = new[1] ( {data} ) ;
      
      tr.set_write();
      
      tlm_transaction_transport.b_transport(tr,tt);
  endtask


  task dpi_read(int unsigned addr,output byte read_val);
    uvm_tlm_generic_payload tr;
    uvm_tlm_time tt;

    tt = new();
    tr = new();
    //`uvm_info("dpi_tlm",$psprintf("sending to UVM addr=0x%08x",addr),UVM_LOW)
    
    tr.m_address = addr;
    tr.set_read();
 
    tlm_transaction_transport.b_transport(tr,tt);

//   `uvm_info("dpi_tlm",$psprintf("returning to UVM addr=0x%08x",addr),UVM_LOW)

    read_val = tr.m_data[0];

//       `uvm_info("dpi_tlm",$psprintf("returning 2 to UVM addr=0x%08x",addr),UVM_LOW)

      
  endtask



  task dpi_wait(int timens);
    #(timens*1ns);
  endtask



  task uart_write(byte data);
    bit superuser;
    uvm_tlm_generic_payload tr;
    uvm_tlm_time tt;
    tt = new();
    tr = new();


//    `uvm_info("dpi_tlm",$psprintf("sending to UART data=0x%08x",0,data),UVM_LOW)
    
      tr.m_address = 0;
      // create a list of 4 bytes initialized with all data bytes starting from byte 0
      tr.m_data = new[1] ( {data} ) ;
      
      tr.set_write();
      
      uart_transaction_transport.b_transport(tr,tt);
  endtask
