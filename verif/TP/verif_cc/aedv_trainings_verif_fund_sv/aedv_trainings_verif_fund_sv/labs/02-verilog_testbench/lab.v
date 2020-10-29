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
// File: lab.sv
// Description: File to include all the necessary files.


`timescale 10ns/1ps

//Comment the two following lines if you want to use your design
`include "dut/adder_nxn.v"
`include "dut/adder_top.v"
//Uncomment the following line if you want to use your design
//`include "../005-verilog_basic/adder_top.v"

`include "tb.v"
