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


// Lab : SystemVerilog Basics - Advanced Constraints
//--------------------------------------------------------------------------------
// Goals:
//      - Generate more complex seqeunces
//      - Generate more complex tests using advanced constraint constructs. 
//--------------------------------------------------------------------------------
// File: lab_prog.sv
// Description: This file contains a program that uses the classes in the project_utils_pkg.sv
//             to drive and monitor the DUT signals. In this lab, the student will use random
//             variables generation  and constraints to generate complex sequences used to drive 
//             the DUT

//@TODO:
// QUESTION: Add solve ... before?

/////////////////////////////////////////////////////////////////////////////////////////////////
// LAB - MAIN
/////////////////////////////////////////////////////////////////////////////////////////////////
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
// LAB-TODO-STEP-2 : Create a sequence to perform  complete addition
class addition_labseq extends base_labseq;


  rand data_t      data1;
  rand data_t      data2;
  rand logic       cin;
  
  data_t           result;
  logic            cout;

  //(Extra Stepc 2)
  // LAB-TODO-EXTRA-STEP-2a : Uncomment the constraint below
 //  constraint dist_c{
 //      //Distribution to limit the result value
 //      (data1 + data2 + cin) dist {
 //      // LAB-TODO-EXTRA-STEP-2b : Replace the single values with interval, for example: [0:3] (Re-run)
 //      // LAB-TODO-EXTRA-STEP-2c : Replace the := operator with the :/ one for each interval (Re-run)
 //        [0:3]   := 20,
 //        [4:7]   := 50,
 //        [8:11]  := 20,
 //        [12:15] := 10
 //      };
 //  }


  function new (int count = 6);
    super.new(count);
  endfunction

  // LAB-TODO-STEP-2-a : Complete the body task
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
    // LAB-TODO-STEP-2-b : Write the cin register

    //Compute                         
    assert (trans[3].randomize() with {action == COMPUTE;});

    //Read the result register                           
    assert (trans[4].randomize() with {addr == 'h04; 
                               dir == READ;});

    //Read the cout register
    // LAB-TODO-STEP-2-c : Read the cout register

  endtask
  
endclass

//---------------------------------------
// addition dynamic array Sequence (Extra Step 1)
//---------------------------------------
// LAB-TODO-EXTRA-STEP-1 : Create a sequence to perform a random amount of complete additions using dynamic array
class addition_dyn_arrays_labseq;

  // LAB-TODO-EXTRA-STEP-1-e : Replace the dynamic array with a queue
  rand addition_labseq adds_dyn [];


  // LAB-TODO-EXTRA-STEP-1-a : Limit the array size using a constraint
//  constraint size_array {adds_dyn.size() > 5;
//                        adds_dyn.size() < 10;}


  // LAB-TODO-EXTRA-STEP-1-b : Set each array element with a random addition sequence
  // LAB-TODO-EXTRA-STEP-1-c : Call the body task for each element
endclass


  addition_dyn_arrays_labseq addition_dyn_seq;
  addition_labseq addition_seq;
  addition_labseq addition_dist_seq;
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

            // LAB-TODO-STEP-0 : Analyse the random list generation
            for (int ii=0; ii<10; ii++) begin
                tr = new;
                if(ii%3 === 0) begin
                  assert (tr.randomize() with { action == COMPUTE;});
                end
                else begin 
                  assert (tr.randomize() with { in_data inside { [0:'h81] };
                                                action == ACC;});
                end
                
                dri.run(tr);
            end

            // LAB-TODO-STEP-2-d : replace the random list generation with 
            // the generation of a addition_seq
//            $display($psprintf("Single Addition Sequence"));
//            addition_seq = new; //Instantiation
//            assert(addition_seq.randomize()); //Randomize the addition sequence attributes (data1, data2, ...)
//            addition_seq.body(); //Call body task to randomize each transaction
//            foreach(addition_seq.trans[ii]) begin
//              dri.run(addition_seq.trans[ii]); //Drive each transaction
//            end

            //(Extra Step1)
            // LAB-TODO-EXTRA-STEP-1-d : Intantiate and drive all the addition_dyn_arrays_labseq elements
//            $display($psprintf("Array Addition Sequence"));
//            addition_dyn_seq = new; // Intantiation
//            assert(addition_dyn_seq.randomize());//Randomize the size
//            addition_dyn_seq.body();//Call the body task from addition_dyn_seq to randomize each array element
//            foreach(addition_dyn_seq.adds_dyn[ii]) begin
//              $display($psprintf("|==================================================================="));
//              $display($psprintf("|===========================ADDITION================================"));
//              foreach(addition_dyn_seq.adds_dyn[ii].trans[jj]) begin
//                dri.run(addition_dyn_seq.adds_dyn[ii].trans[jj]); //Call drive for each transaction from each addition_seq
//              end
//            end
//
//            print_table(addition_dyn_seq);//Call the function to print the distribution table
//

          end

        join_any

        $display("Simulation end");
        $finish;
  end

  function void print_table (addition_dyn_arrays_labseq array);
    int dist_table[(2**(N))-1:0];
    int count;
    foreach(array.adds_dyn[ii]) begin
      dist_table[addition_dyn_seq.adds_dyn[ii].data1 + addition_dyn_seq.adds_dyn[ii].data2 + addition_dyn_seq.adds_dyn[ii].cin]++;
      count++;
    end
    $display("Distribution Table (%4d)",count);
    foreach(dist_table[ii]) begin
      $display("[%2d] -- %d",ii, dist_table[ii]);
    end
  endfunction

endprogram