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
// File: adder_top.v
// Description: Top adder module that uses two simple adders instantiation. 


module adder_top #(parameter N = 8) (
    input clock,
    input reset_n

    //LAB-TODO-STEP2-a: Define the module interface
    );

    //Internal Registers
    //LAB-TODO-STEP2-b: Declare the module internal registers


    wire [N-1:0] wire_result;
    reg  [N-1:0] reg_result;
    wire wire_cout;

    //LAB-TODO-STEP2-c: Describe the clock synchronous behaviour to set the input registers
//    always @(posedge clock or negedge reset_n) begin


//    end

    //LAB-TODO-STEP2-d: Describe the clock and i_get synchronous behaviour to get the output signals

    //LAB-TODO-STEP2-e: Connect the adder sub-module signals
//    simple_adder #(.N(N)) i_add0(
//        .o_result(wire_result),


//        .i_cin(1'b0)
//        );



endmodule