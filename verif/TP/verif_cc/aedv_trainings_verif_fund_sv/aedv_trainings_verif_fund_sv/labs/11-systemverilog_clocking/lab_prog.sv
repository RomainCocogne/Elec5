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
// File: lab_prog.sv
// Description: This file contains a program that uses the classes in the project_utils_pkg.sv
//             to drive and monitor the DUT signals.


program lab_prog#(parameter N = 4)(
    adder_if add_if
    );


  // Start importing the useful package
  import project_utils_pkg::*;


//---------------------------------------
// Base Sequence Common Class
//---------------------------------------
class base_labseq;
  adderTransactionBase trans[];
  int count;


  function new (int count = 10);
    this.count = count;
    this.create_trans();
  endfunction

  function void create_trans();
    trans = new [count];
    foreach (trans[ii]) begin
      trans[ii] = new;
    end
  endfunction

endclass  


//---------------------------------------
// addition Sequence
//---------------------------------------
class addition_labseq extends base_labseq;


  rand data_t      data1;
  rand data_t      data2;
  rand logic       cin;
  
  data_t           result;
  logic            cout;


  function new (int count = 6);
    super.new(count);
  endfunction
  task body();
    //Write the data1 register
    assert (trans[0].randomize() with {in_data == local::data1; 
                               addr == 'h01; 
                               dir == WRITE;});

    //Write the data2 register
    assert (trans[1].randomize() with {in_data == local::data2; 
                               addr == 'h02; 
                               dir == WRITE;});

    //Write the cin register                         
    assert (trans[2].randomize() with {in_data == local::cin; 
                               addr == 'h03; 
                               dir == WRITE;});

    //Compute                         
    assert (trans[3].randomize() with {action == COMPUTE;});

    //Read the result register                           
    assert (trans[4].randomize() with {addr == 'h04; 
                               dir == READ;});

    //Read the cout register                         
    assert (trans[5].randomize() with {addr == 'h05; 
                               dir == READ;});

  endtask
  
endclass


  addition_labseq addition_seq;
  adderTransactionBase tr;
  initial
  begin

        static driver dri = new(add_if.driver);
        static monitor mon = new(add_if.monitor);

        @(add_if.i_rstn);

        fork

          begin : thread_monitor
              forever begin 
                  mon.run();
              end
          end

          begin : thread_driver

            $display($psprintf("Single Addition Sequence"));
            addition_seq = new; //Instantiation
            assert(addition_seq.randomize()); //Randomize the addition sequence attributes (data1, data2, ...)
            addition_seq.body(); //Call body task to randomize each transaction
            foreach(addition_seq.trans[ii]) begin
              dri.run(addition_seq.trans[ii]); //Drive each transaction
            end

          end

        join_any

        #5; // Delay to get all transactions

        $display("Simulation end");
        $finish;
  end


endprogram