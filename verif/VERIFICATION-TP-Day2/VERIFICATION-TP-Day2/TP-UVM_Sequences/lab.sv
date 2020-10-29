// ===============================================================================
//                    3 day training
//                  on
//                      IP & SoC Verification Methodology
//                                using UVM
// ===============================================================================
//                    Copyright (c) 2015-2018 - AEDVICES Consulting
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


package lab_test_pkg;

  import uvm_pkg::*;
  import aed_apb_pkg::*;
  import aed_uart_pkg::*;
  import uart_ip_verif_pkg::*;


  `include "uvm_macros.svh"
  `include "uart_reg_addresses.svh"
  `include "lab_sequence_lib.svh"
  `include "lab_test.svh"

/*class uart_init_seq extends wishbone_base_sequence;
	`uvm_object_utils(uart_init_seq)

	rand bit enable;
	rand int freq_div;
	rand bit parity;
	rand int char_lenght;


	constraint freq_div_c { freq_div inside {[1:10]};}

	uart_init_seq subseq;

	task body();
		if ( enable )
			`uvm_do(req)
		`uvm_do(subseq)
	endtask
endclass*/
	

endpackage
