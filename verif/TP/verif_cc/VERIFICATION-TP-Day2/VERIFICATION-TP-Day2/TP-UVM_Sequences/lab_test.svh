
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




class lab_test extends uart_ip_verif_base_test;
  `uvm_component_utils(lab_test)
    
  function new(string name="lab_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
    
  virtual function void build_phase(uvm_phase phase);
    
    `uvm_info(get_name(), $sformatf("Setting default sequence uvm_wb_env0.masters0.sequencer.run_phase"), UVM_LOW)
      // Use the UVM configuration database feature to set the main test sequence of the apb master agent.
      uvm_config_db#(uvm_object_wrapper)::set(this, 
        "verif_env0.apb_env0.master0.sequencer.run_phase", 
        "default_sequence", 
        lab_on_seq_test_sequence::type_id::get());   
      
      super.build_phase(phase);
      
  endfunction
    
  // Run Phase
  // This phase is called once every component has been built.
  virtual task run_phase(uvm_phase phase);
    `uvm_info("lab_test","Starting run_phase()",UVM_LOW)
      // allow some time after the main sequence so that the UART can send data
      
      phase.phase_done.set_drain_time(this, 5000);
    
  endtask

endclass

