// ===============================================================================
// Copyright (c) 2015-2019 - AEDVICES Consulting
// ===============================================================================
//                     Training
//                        on
//            Functional Verification Methodology
//                     using UVM
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for
// training purposes.
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab : SystemVerilog Basics - Virtual Interfaces
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Be familiar with the concept of virtual interfaces 
//  - Connect modules and classes using interfaces
//--------------------------------------------------------------------------------
// File: tb.sv
// Description: Testbench that instantiates the DUT, the program and the interface.

module tb;

	parameter N = 8;

	reg i_clk;
    reg i_rstn;

    // LAB-TODO-STEP4-a : Instantiate the interface 


    // LAB-TODO-STEP4-b : Instantiate the program
//	lab_prog #(.N(N)) prog(
//		.add_if(add_if)
//	);

    // LAB-TODO-STEP4-c : Instantiate the DUT
//	full_adder #(.N(N)) dut (
//		.add_if(add_if.adder)
//    );

    initial begin 
    	i_clk = 0;
    end

    initial begin 
    	i_rstn = 0;
    	#10;
    	i_rstn = 1;
    end

    always begin
    	#5 i_clk <= ~ i_clk;
    end

    initial begin 
        #710; //TIMEOUT: Used for the first exercise simulation
        $finish;
    end

endmodule
/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// END OF FILE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

program lab_test;
	// Empty. Just make the script happy. 
  // Keep it empty. We'll work in listed files below
endprogram