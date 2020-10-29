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
//             to drive and monitor the DUT signals. 


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

  task body();
    foreach (trans[ii]) begin
      if ( ! trans[ii].randomize() with {
          ii == 0 -> (trans[ii].in_data == 'h00 && trans[ii].addr == 'h01 && trans[ii].dir == WRITE && trans[ii].action == ACC);
          ii == 1 -> (trans[ii].in_data == 'h01 && trans[ii].addr == 'h03 && trans[ii].dir == WRITE && trans[ii].action == ACC);
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

  function new (int count = 10);
    super.new(count);
  endfunction

  task body();
    $display($psprintf("**incremental_data_labseq**"));
    foreach (trans[ii]) begin
      if ( ! trans[ii].randomize() with {
          ii > 0  -> trans[ii].in_data == trans[ii-1].in_data + 8'h01; // We must specify the constant length or the randomize will interpret as X or Z
          ii < 10 -> trans[ii].dir == WRITE && trans[ii].action == ACC;
        } )
      begin
        $error("Randomization failed!");
      end;
    end

  endtask
  
  
endclass


//---------------------------------------
//---------------------------------------
class read_labseq extends base_labseq;

  function new (int count = 10);
    super.new(count);
  endfunction

  task body();
    $display($psprintf("**read_labseq**"));
    foreach (trans[ii]) begin
      if ( ! trans[ii].randomize() with { 
          ii == 0 -> trans[ii].action == COMPUTE;
          ii > 0  -> trans[ii].dir  == READ && trans[ii].action  == ACC;
        } )
      begin
        $error("Randomization failed!");
      end;
    end
  endtask
endclass


//---------------------------------------
//---------------------------------------
class random_labseq extends base_labseq;

  function new (int count = 10);
    super.new(count);
  endfunction

  task body();
    $display($psprintf("**random_sequence**"));
    foreach (trans[ii]) begin
      if ( ! trans[ii].randomize())
      begin
        $error("Randomization failed!");
      end;
    end

  endtask
endclass



  adderTransactionBase tr;
  init_labseq init_seq;
  incremental_data_labseq inc_seq;
  read_labseq read_seq;
  random_labseq rand_seq; 
  
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

            init_seq = new;
            init_seq.body();
            foreach(init_seq.trans[ii]) begin
              dri.run(init_seq.trans[ii]);
            end
            // LAB-TODO-STEP-6
            for (int ii=0; ii<3; ii++)
            begin
                randcase
                1 : begin
                  inc_seq = new;
                  inc_seq.body();
                  foreach(inc_seq.trans[ii]) begin
                    dri.run(inc_seq.trans[ii]);
                  end
                end
                1 : begin
                  read_seq = new;
                  read_seq.body();
                  foreach(read_seq.trans[ii]) begin
                    dri.run(read_seq.trans[ii]);
                  end
                end
                1 : begin
                  rand_seq = new;
                  rand_seq.body();
                  foreach(rand_seq.trans[ii]) begin
                    dri.run(rand_seq.trans[ii]);
                  end
                end
                endcase
            end
          end

        join_any

        $display("Simulation end");
        $finish;


  end
endprogram