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
// File: adder_if.sv
// Description: Interface that encapsulates the DUT signals and declares the modports.

interface adder_if(
    input i_clk,
    input i_rstn);

    parameter N = 8;

    // LAB-TODO-STEP1-a : Declare the interface ports
//
//    logic [N-1:0] o_data;
//    logic o_ready;
//    logic o_ack;
//
//    logic [N-1:0] i_addr;
//    logic [N-1:0] i_data;
//    logic i_we;
//    logic i_start;

    // LAB-TODO-STEP1-b : Declare the modport to the DUT module
//    modport adder  (output o_data, o_ready, o_ack, input i_addr, i_data, i_we, i_start, input i_clk, input i_rstn);

    // LAB-TODO-STEP1-c : Declare the modport to the Driver module

endinterface