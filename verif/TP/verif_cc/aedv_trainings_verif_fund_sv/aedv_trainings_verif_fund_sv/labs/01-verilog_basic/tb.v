// ===============================================================================
// Copyright (c) 2015-2018 - AEDVICES Consulting
// ===============================================================================
//                     Training
//                        on
//            IP & SoC Verification Methodology
//                     using UVM
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for
// training purposes.
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab : Verilog Basics - Modules and Signals
//--------------------------------------------------------------------------------
// Goals:
//  - Get started with Verilog;
//  - Be able to build a module;
//  - Be able to create a simple testbench.
//--------------------------------------------------------------------------------
// File: tb.v
// Description: Simple testbench to test the adder top module. 

module tb();

    parameter N = 8;
    
    //LAB-TODO-STEP3-a: Declare the testbench signals to be connected to the DUT

    reg clk = 0; // initial value is 0
    reg rst_n;

    adder_top #( .N(N)) DUT (
        .clock(clk),
        .reset_n(rst_n)

        //LAB-TODO-STEP3-b: Connect the signals to the DUT
        );

    initial begin
        @(posedge clk);
        rst_n <= 0;
        @(posedge clk);
        //LAB-TODO-STEP3-c: Describe a testbench behaviour
//        rst_n <= 0;
//        @(posedge clk);
//        set1  <= 0;
//        set2  <= 0;
//        get   <= 0;
//        @(posedge clk);
//        rst_n <= 1;
//
//        @(posedge clk);
//
//        data1 <= 1;  // Add 1 to 0
//        set1  <= 1;
//
//        data2 <= 8'hFF;
//        set2  <= 0;     // not setting data2, so we take the result value
//
//        @(posedge clk);
//        get  <= 1;
//        set1 <= 0;
//        @(posedge clk);
//        get  <= 0;
//

        // LAB-TODO-STEP3-d: complete with some useful tests


        // drain simulation a bit
        repeat(2)
            @(posedge clk);
        $display("LAB: Testbench completed");
        $finish;

    end

    always begin
        #1 clk <= ~clk;
    end

endmodule



/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// END OF FILE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

module lab_test;
	// Empty. Just make the script happy. 
  // Keep it empty. We'll work in listed files below
endmodule