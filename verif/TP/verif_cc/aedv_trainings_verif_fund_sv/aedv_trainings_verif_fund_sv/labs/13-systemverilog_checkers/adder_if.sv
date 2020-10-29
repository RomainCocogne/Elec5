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


// Lab : SystemVerilog Basics - Checkers
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Use a simple checker encapsulation 
//--------------------------------------------------------------------------------
// File: adder_if.sv
// Description: Interface that encapsulates the DUT signals and declares the modports and
// a clocking block. The student will add a checker here during the lab.

interface adder_if(
    input i_clk,
    input i_rstn);

    // Start importing the useful package
    import project_utils_pkg::*;

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

    clocking cb @(posedge i_clk);
        input o_data, o_ready, o_ack;
        output i_addr, i_data, i_we, i_start;
    endclocking

    
    // LAB-TODO-STEP-2a: Instantiate the checker
    adder_checker adder_checker0(
        );

endinterface