// ===============================================================================
//                    3 day training
//                  on 
//                      IP & SoC Verification Methodology 
//                                using UVM
// ===============================================================================
//                    Copyright (c) 2015 - AEDVICES Consulting
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for 
// training purposes.  
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab_scoreboard : Implement a scoreboard
//---------------------------------------------------------------------------------------------------------
// Goals: 


package lab_test_pkg;

  import uvm_pkg::*;
  import aed_apb_pkg::*;
  import aed_uart_pkg::*;
  import uart_ip_verif_pkg::*;


  typedef enum {ODD=0, EVEN=1} parity_t;      // ODD or EVEN parity
  typedef enum {FIVE=0,SIX=1,SEVEN=2,EIGHT=3} char_width_t; 
  typedef enum {ONE_STOP=0,TWO_STOP_OR_ONE_AND_HALF=1} stop_bit_t;

/*! \function log2
 * \brief returns the log base 2 of the integer passed as an argument
*/
	function int unsigned log2(int unsigned value);

    	int unsigned clogb2;
      if(value >0)
        value = value - 1;
      for (clogb2 = 0; value > 0; clogb2 = clogb2 + 1) begin
          value = value >> 1;
      end
		return clogb2;

  endfunction  

  `include "uvm_macros.svh"
  `include "uart_reg_addresses.svh"
  `include "lab_sequence_lib.svh"
  `include "lab_scoreboard.svh"
  `include "lab_test.svh"

endpackage 
