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


// Lab : SystemVerilog Basics - Simple Constraints
//--------------------------------------------------------------------------------
// Goals:
//      - Be familiar with random variables and simple constraints. 
//--------------------------------------------------------------------------------
// File: lab_prog.sv
// Description: This file contains a program that uses the classes in the project_utils_pkg.sv
//             to drive and monitor the DUT signals. In this lab, the student will use random
//             variables generation  and constraints to generate sequences used to drive the DUT


/////////////////////////////////////////////////////////////////////////////////////////////////
// LAB - MAIN
/////////////////////////////////////////////////////////////////////////////////////////////////
program lab_prog#(parameter N = 8)(
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
    $display($sformatf("count = %d",count));
    trans = new [count];
    foreach (trans[ii]) begin
      trans[ii] = new;
    end
  endfunction

endclass  


//---------------------------------------
// Init Sequence
//---------------------------------------
class init_labseq extends base_labseq;

  function new (int count = 10);
    super.new(count);
  endfunction

  // LAB-TODO-STEP-3-b : Analyse the body task
  task body();
    foreach (trans[ii]) begin
      if ( ! trans[ii].randomize() with {
          ii == 0 -> (trans[ii].in_data == 'h00 && trans[ii].addr == 'h01 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 1 -> (trans[ii].in_data == 'h10 && trans[ii].addr == 'h02 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 2 -> (trans[ii].in_data == 'h20 && trans[ii].addr == 'h01 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 3 -> (trans[ii].in_data == 'h30 && trans[ii].addr == 'h02 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 4 -> (trans[ii].in_data == 'h40 && trans[ii].addr == 'h01 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 5 -> (trans[ii].in_data == 'h50 && trans[ii].addr == 'h02 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 6 -> (trans[ii].in_data == 'h60 && trans[ii].addr == 'h01 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 7 -> (trans[ii].in_data == 'h70 && trans[ii].addr == 'h02 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 8 -> (trans[ii].in_data == 'h80 && trans[ii].addr == 'h01 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 9 -> (trans[ii].in_data == 'h90 && trans[ii].addr == 'h02 && trans[ii].dir == WRITE && trans[ii].action == ACC);
        } )
      begin
        $error("Randomization failed!");
      end;
    end

  endtask
  
endclass



//---------------------------------------
//---------------------------------------
class incremental_data_labseq extends base_labseq;
  // LAB-TODO-STEP-3-c : Create a list of transactions with incremental data.
  
  
endclass


//---------------------------------------
//---------------------------------------
class read_labseq extends base_labseq;
  // LAB-TODO-STEP-EXTRA : Create a list of reading transactions after the first compute one.
endclass


//---------------------------------------
//---------------------------------------
class random_labseq extends base_labseq;
  // LAB-TODO-STEP-EXTRA : Create a list of Random transactions
endclass



  adderTransactionBase tr;
  init_labseq init_seq;
  incremental_data_labseq inc_seq;
  // LAB-TODO-STEP-EXTRA : Uncomment the classes instantiation
//  read_labseq read_seq;
//  random_labseq rand_seq; 
  
  initial
  begin


        static driver dri = new(add_if.driver);
        static monitor mon = new(add_if.monitor);

        @(add_if.i_rstn);

        fork

          begin : thread_MONITOR
              forever begin 
                  mon.run();
              end
          end

          begin : thread_driver


            // LAB-TODO-STEP-3-a : replace the random list generation with 
            // the generation of a init_seq

            for (int ii=0; ii<10; ii++) begin
                tr = new;
                assert (tr.randomize() with { addr inside { [0:'h5] };});
                dri.run(tr);
            end


            //// LAB-TODO-STEP-3-d : Generate incremental sequences
//            for (int ii = 0; ii < 10; ii++) begin
//              inc_seq = new;
//              inc_seq.body();
//              foreach(inc_seq.trans[ii]) begin
//                dri.run(inc_seq.trans[ii]);
//              end
//            end

            // LAB-TODO-STEP-EXTRA : Create a generate loop to generate any of the previous transaction randomly
//            for (int ii=0; ii<10; ii++)
//            begin
//                randcase
//                1 : begin
//                  inc_seq = new;
//                  inc_seq.body();
//                  foreach(inc_seq.trans[ii]) begin
//                    dri.run(inc_seq.trans[ii]);
//                  end
//                end
//                1 : begin
//                  read_seq = new;
//                  read_seq.body();
//                  foreach(read_seq.trans[ii]) begin
//                    dri.run(read_seq.trans[ii]);
//                  end
//                end
//                1 : begin
//                  rand_seq = new;
//                  rand_seq.body();
//                  foreach(rand_seq.trans[ii]) begin
//                    dri.run(rand_seq.trans[ii]);
//                  end
//                end
//                endcase
//            end

          end

        join_any

        $display("Simulation end");
        $finish;


  end
endprogram