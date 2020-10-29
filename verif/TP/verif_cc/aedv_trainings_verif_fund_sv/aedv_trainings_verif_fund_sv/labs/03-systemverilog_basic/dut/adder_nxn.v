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
// File: adder_nxn.v
// Description: Module combinational adderNxN, add two values and the carry in. 

module adder_nxn #(parameter N = 4) (
	output [N-1:0] o_result,
	output o_cout,

	input [N-1:0] i_data1,
	input [N-1:0] i_data2,

	input i_cin
	);

	assign {o_cout, o_result} = i_data1 + i_data2 + i_cin;//o_cout and o_result are concatenated to hold the result of the sum with carry out

endmodule