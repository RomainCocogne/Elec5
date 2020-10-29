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

/// This is a package containing some nice and useful types and classes
package project_utils_pkg;

  parameter N = 8;

  typedef logic [N-1:0] data_t;

  enum {LOW, HIGH} level_t;

  //adderRegisters class represents the internal DUT registers
  class adderRegisters;
    local data_t      cfg;
    local data_t      data1;
    local data_t      data2;
    local data_t      cin;
    local data_t      result;
    local data_t      cout;

    //-----------------------
    /// public functions
    //-----------------------
    // set data
    function void set_data1(data_t data1);
      this.data1 = data1;
    endfunction

    function void set_data2(data_t data2);
      this.data2= data2;
    endfunction

    function void set_cin(data_t cin);
      this.cin= cin;
    endfunction

    function void set_result(data_t result);
      this.result= result;
    endfunction

    function void set_cout(data_t cout);
      this.cout= cout;
    endfunction

    // get data
    function data_t get_data1();
      return this.data1;
    endfunction

    function data_t get_data2();
      return this.data2;
    endfunction

    function data_t get_cin();
      return this.cin;
    endfunction

    function data_t get_result();
      return this.result;
    endfunction

    function data_t get_cout();
      return this.cout;
    endfunction

  endclass

endpackage
