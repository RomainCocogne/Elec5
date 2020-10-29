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
// File: lab.sv
// Description: File to include all the necessary files.

`timescale 1ns/1ps


`include "dut/adder_nxn.sv"
`include "dut/full_adder.sv"
`include "adder_if.sv"
`include "lab_prog.sv"
`include "tb.sv"