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
// File: tb.sv
// Description: Testbench that instantiates the DUT, the program and the interface.


module tb;

  parameter N = 8;

  reg i_clk;
    reg i_rstn;

  adder_if #(.N(N)) add_if(
        .i_clk(i_clk),
        .i_rstn(i_rstn));

  lab_prog #(.N(N)) prog(
    .add_if(add_if)
  );

  full_adder #(.N(N)) dut (
    .add_if(add_if.adder)
    );

    initial begin 
      i_clk = 0;
    end

    initial begin 
      i_rstn = 0;
      #5;
      i_rstn = 1;
    end

    always begin
      #5 i_clk <= ~ i_clk;
    end

endmodule

/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// END OF FILE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

program lab_test;
	// Empty. Just make the script happy. 
  // Keep it empty. We'll work in listed files below
endprogram