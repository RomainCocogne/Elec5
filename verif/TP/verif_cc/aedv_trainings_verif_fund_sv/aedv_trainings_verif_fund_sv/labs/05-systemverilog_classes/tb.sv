// ===============================================================================
// Copyright (c) 2015-2019 - AEDVICES Consulting
// ===============================================================================
//                     Training
//                        on
//            Functional Verification Methodology
//                      using UVM
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for
// training purposes.
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab : SystemVerilog - Object Oriented Programming
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Understand how manipulate SystemVerilog Classes
//  - Understand the concepts of inheritance and ancapsulation
//  - Be familiar with the concept of virtual methods
//--------------------------------------------------------------------------------
// File: tb.sv
// Description: Testbench that instantiates the DUT, the program and the interface.

module tb();

  parameter N = 8;

  logic [N-1:0] o_data;
  logic o_ready;
  logic o_ack;

  logic [N-1:0] i_addr;
  logic [N-1:0] i_data;
  logic i_we;
  logic i_start;

  logic clk;
  logic rstn;


  //DUT Instance
  full_adder #( .N(N)) DUT (
    .o_data(o_data),
    .o_ready(o_ready),
    .o_ack(o_ack),

    .i_addr(i_addr),
    .i_data(i_data),
    .i_we(i_we),
    .i_start(i_start),

    .i_clk(clk),
    .i_rstn(rstn)
  );

  lab_prog test(
    .data_out(o_data),
    .ready(o_ready),
    .ack(o_ack),

    .addr(i_addr),
    .data_in(i_data),
    .we(i_we),
    .start(i_start),

    .clk(clk),
    .rstn(rstn)
  );

  initial begin
      clk = 0;
  end

  initial begin 
      rstn = 0;
      #10;
      rstn = 1;
  end

  //Clock generation
  always begin
      #5 clk <= ~clk;
  end
    

endmodule



/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// END OF FILE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

program lab_test;
	// Empty. Just make the script happy. 
  // Keep it empty. We'll work in listed files below
endprogram