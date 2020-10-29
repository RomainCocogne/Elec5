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


// Lab : SystemVerilog Basics - Programming in SystemVerilog
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Understand how manipulate data and lists
//--------------------------------------------------------------------------------
// File: tb.v
// Description: Testbench module+program that implments a task to drive and verify
//             the DUT.  

/// This is a package containing some nice and useful types and classes
package lab_utils_pkg;

  parameter N = 8;

  typedef logic [N-1:0] data_t;

  typedef struct     {
    data_t      data1;
    data_t      data2;
    data_t      result;
    logic       cout;
    logic       cin;
  } trans_adder_t;


  typedef struct     {
    data_t      cfg;
    data_t      data1;
    data_t      data2;
    logic       cin;
    data_t      result;
    logic       cout;
  } regs_adder_t;

  /// returns a string with the transaction content
  function string get_trans_str(trans_adder_t tr);
    return $psprintf("|Transaction \n|data1=0x%02x   data2=0x%02x \n|cout=0x%01x     result=0x%02x  \n|cin=0x%01x  ",tr.data1,tr.data2,tr.cout,tr.result,tr.cin);
  endfunction

endpackage
