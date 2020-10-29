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


// Lab : SystemVerilog Basics - Clocking Blocks
//--------------------------------------------------------------------------------
// Goals:
//      - Use clocking blocks to sample and drive signals at specific time around 
//      clock edge.
//      - Use modport to define clocking block of an interface.
//--------------------------------------------------------------------------------
// File: adder_if.sv
// Description: Interface that encapsulates the DUT signals, declares the modports and 
//             a clocking block.

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

    // LAB-TODO-STEP-1b : Use the port from cb as the driver port
    modport driver  (output i_addr, i_data, i_we, i_start, input o_data, o_ready, o_ack, input i_clk, input i_rstn);

    modport monitor (input o_data, o_ready, o_ack, i_addr, i_data, i_we, i_start, input i_clk, input i_rstn);
    // LAB-TODO-STEP-1a: Declare the clocking block
    //clocking cb @(posedge i_clk);
    //    // LAB-TODO-STEP-3a: Declare default with output skew = #0
    //    // LAB-TODO-STEP-3b: Replace the input skew with another value
    //    // LAB-TODO-STEP-3c: Declare the output skew with some value
    //    input o_data, o_ready, o_ack;
    //    output i_addr, i_data, i_we, i_start;
    //endclocking

endinterface