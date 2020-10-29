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


// Lab : SystemVerilog Basics - Interfaces
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Be familiar with the concept of interfaces 
//  - Be familiar with interface connection and modport 
//  - Connect modules using interfaces
//--------------------------------------------------------------------------------
// File: tb.sv
// Description: Testbenchs that instantiates the DUT, the program and the interface.

module tb;

    parameter N = 8;

    reg i_clk;
    reg i_rstn;

    // LAB-TODO-STEP4-a : Instantiate the interface - call it "add_if" ( or replace add_if below to the name you specified )


    // LAB-TODO-STEP4-b : Instantiate the driver
//    driver #(.N(N)) d(
//        .add_if(add_if.driver)
//    );

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
        #15ms; //TIMEOUT: Used for the first exercise simulation
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