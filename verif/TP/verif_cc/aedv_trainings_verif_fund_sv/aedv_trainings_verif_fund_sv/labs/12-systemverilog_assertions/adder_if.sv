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


// Lab : SystemVerilog Basics - Assertions
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Use immediate assertions 
//  - Use concurrent assertions 
//  - Use clocking blocks to define default clock of assertions 
//--------------------------------------------------------------------------------
// File: adder_if.sv
// Description: Interface that encapsulates the DUT signals and declares the modports and
// a clocking block. The student will add some assertion here during the lab.

interface adder_if(
    input i_clk,
    input i_rstn);

    parameter N = 8;

    logic [N-1:0] o_data;
    logic o_ready;
    logic o_ack;

    logic [N-1:0] i_addr;
    logic [N-1:0] i_data;
    logic i_we;
    logic i_start;

    modport adder   (output o_data, o_ready, o_ack, input i_addr, i_data, i_we, i_start, input i_clk, input i_rstn);

    modport driver  (clocking cb, input i_clk, input i_rstn);

    modport monitor (input o_data, o_ready, o_ack, i_addr, i_data, i_we, i_start, input i_clk, input i_rstn);

    // LAB-TODO-STEP-1d: Make this clocking block default
    clocking cb @(posedge i_clk);
        input o_data, o_ready, o_ack;
        output i_addr, i_data, i_we, i_start;
        // LAB-TODO-STEP-2d: Create a property inside the clocking block
        //property p;
        //    i_start |-> s_ready;
        //endproperty
    endclocking : cb

    // LAB-TODO-STEP-2c: Create the sequence to the o_ready signal assignment
//    sequence s_ready;
//        ##2 o_ready;
//    endsequence

    always
    begin
        @(posedge i_clk);
        if ( i_start == 1 ) begin
            @(posedge i_clk);
            // LAB-TODO-STEP-1a: Create an assertion to detect the i_start signal
        end
    end

    // LAB-TODO-STEP-1b: Uncomment to create the assertion
//    ASSERTION_1:assert property (
//         // LAB-TODO-STEP-1d: Delete the @(posedge i_clk)
//         @(posedge i_clk)
//         // LAB-TODO-STEP-1b: Replace -> #1 with =>
//         i_start |-> ##1 ~i_start
//    )$info("ASSERT_1: Assertion Passed"); //Using $info to see on the waveform
//    else $error("ASSERT_1: Assertion Failed");

    // LAB-TODO-STEP-2a: Uncomment to create the assertion
//    ASSERTION_2:assert property (
//         // LAB-TODO-STEP-2c: replace ##2 o_ready with s_ready  
//         i_start |-> ##2 o_ready
//    )$info("ASSERT_2: Assertion Passed"); //Using $info to see on the waveform
//    else $error("ASSERT_2: Assertion Failed");

    // LAB-TODO-STEP-2d: Uncomment to create the assertion and delete the ASSERTION_2 
//    ASSERTION_P_2:assert property (cb.p)$info("ASSERT_P_2: Assertion Passed"); //Using $info to see on the waveform
//    else $error("ASSERT_P_2: Assertion Failed");

    // LAB-TODO-STEP-3a: Create assertion to deal the i_we and o_ack signals

endinterface : adder_if