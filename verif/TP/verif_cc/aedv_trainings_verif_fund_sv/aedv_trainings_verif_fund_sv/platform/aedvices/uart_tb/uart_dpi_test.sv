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
// $Id: uart_dpi_test.sv 345 2018-01-11 16:57:24Z francois $
// $Author: francois $
// $LastChangedDate: 2018-01-11 17:57:24 +0100 (jeu., 11 janv. 2018) $
// $Revision: 345 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

// MACRO: `UVM_TLM_NB_FW_MASK
//
// Define Non blocking Forward mask onehot assignment = 'b001
`define UVM_TLM_NB_FW_MASK  (1<<0)

// MACRO: `UVM_TLM_NB_BW_MASK
//
// Define Non blocking backward mask onehot assignment = 'b010
`define UVM_TLM_NB_BW_MASK  (1<<1)

// MACRO: `UVM_TLM_B_MASK
//
// Define blocking mask onehot assignment = 'b100
`define UVM_TLM_B_MASK      (1<<2)

/// \todo find a better way of doing this ( declare)

`define UVM_TLM_B_TRANSPORT_IMP_UART(imp, T, t, delay)                    \
  task b_transport(T t, uvm_tlm_time delay);                              \
    if (delay == null) begin                                              \
       `uvm_error("UVM/TLM/NULLDELAY",                                    \
                  {get_full_name(),                                       \
                   ".b_transport() called with 'null' delay"})            \
       return;                                                            \
    end                                                                   \
    imp.b_transport_uart(t, delay);                                       \
  endtask


class uvm_tlm_b_transport_imp_uart #(type T=uvm_tlm_generic_payload,
                            type IMP=int)
  extends uvm_port_base #(uvm_tlm_if #(T));
  `UVM_IMP_COMMON(`UVM_TLM_B_MASK, "uvm_tlm_b_transport_imp", IMP)
  `UVM_TLM_B_TRANSPORT_IMP_UART(m_imp, T, t, delay)
endclass



class uart_dpi_test extends uart_ip_verif_base_test;

  uvm_tlm_b_transport_imp #(uvm_tlm_generic_payload,uart_dpi_test) tlm_transport_imp; /// <TLM Port Implementation.
  uvm_tlm_b_transport_imp_uart #(uvm_tlm_generic_payload,uart_dpi_test) uart_transport_imp; /// <TLM Port Implementation.


  function new(string name="uart_dpi_test",uvm_component parent=null);
    super.new(name,parent);
    tlm_transport_imp = new("tlm_transport_imp",this);
    uart_transport_imp = new("tuart_transport_imp",this);
    
    tlm_transaction_transport = new("tlm_transaction_transport", this );
    uart_transaction_transport = new("uart_transaction_transport", this );

  endfunction : new


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    tlm_transaction_transport.connect(this.tlm_transport_imp);
    uart_transaction_transport.connect(this.uart_transport_imp);
  endfunction

  task run_phase(uvm_phase phase);
      uvm_component c;
      c = uvm_root::get();
      c.set_report_id_action_hier("ASSERT_UART_ERROR_PARITY",UVM_NO_ACTION);

    phase.raise_objection(this);
    `uvm_info("DPI","Starting",UVM_NONE)
    #10;
    dpi_main();
    #10;
    `uvm_info(get_name(),"completed",UVM_NONE)
    phase.drop_objection(this);

  endtask : run_phase


  virtual task b_transport(uvm_tlm_generic_payload tr, uvm_tlm_time delay);
    wishbone_transfer wb_trans = new("trans_from_DPI");
    wishbone_direction_t dir = (tr.is_write() ? WB_WRITE : WB_READ);

    // Debug
    //tr.print();
    
    // We are doing randomization here, but this is not obliged. 
    // Simple field assigments or better uvm_object.copy() may do the job if extra fields are not required to be randomized with UVM.
    assert( 
        wb_trans.randomize() with {
        wb_trans.addr   == tr.m_address;
        wb_trans.direction == dir;
        wb_trans.width == 1;
        if ( dir )
          wb_trans.data    == tr.m_data[0];
        else
          wb_trans.data == 0;
      } ) else `uvm_fatal("F_TLM_UVM_CONV","Unable to convert TLM transaction to VIP transaction item")


    // Record UVM Transaction within transaction recorder 
    void'(begin_tr(wb_trans, "wb_trans", "DPI_Trans","Converted DPI transaction to VIP transaction item"));
  
    // Send the transaction to the sequencer
    verif_env0.wishbone_env0.masters[0].sequencer.execute_item(wb_trans);
    
    // Report Read data back
    if ( tr.is_read() ) begin
      tr.m_data = new [1] ({wb_trans.data[7:0]}); 
      tr.m_length = 1;
    end
  
    // Record end of transaction within transaction recorder
    end_tr(wb_trans);
  endtask : b_transport

  virtual task b_transport_uart(uvm_tlm_generic_payload tr, uvm_tlm_time delay);
    uart_frame uf = new("UART_Character");
    `uvm_info("TESTBENCH","VHDL to Verilog UART",UVM_NONE)

    uf.data = tr.m_data[0];

    void'(begin_tr(uf, "UART_Trans", "UART_Trans","Character from VHDL testbench"));
    //uf.print();

    verif_env0.uart_env0.agents["uart_agent0"].sequencer.execute_item(uf);

    end_tr (uf);
  endtask : b_transport_uart

  `uvm_component_utils(uart_dpi_test)
endclass : uart_dpi_test
