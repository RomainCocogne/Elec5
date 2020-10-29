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


/// My test program
program lab_prog#(parameter N = 8)(
    
    input logic [N-1:0] data_out,
    input logic ready,
    input logic ack,

    output logic [N-1:0] addr,
    output logic [N-1:0] data_in,
    output logic we,
    output logic start,

    input logic clk,
    input logic rstn
  );

  // Start importing the useful package
  import lab_utils_pkg::*;


  regs_adder_t  adder_registers;     ///< Keep update the internal adder registers

  trans_adder_t single_trans;        ///< defines a single transaction
  trans_adder_t trans_sa[12];        ///< defines a static array
  trans_adder_t trans_dl[];          ///< defines a dynamic list
  trans_adder_t trans_q[$];          ///< defines a queue
  trans_adder_t trans_aa[string];    ///< defines a associative array / map / keyed list


  //Generate the expected DUT result
  function trans_adder_t expected(input trans_adder_t tr);

        expected = tr;

        {expected.cout, expected.result} = adder_registers.data1 + adder_registers.data2 + adder_registers.cin;

        return expected;

  endfunction

  //Drive the DUT signals and verify the result comparing with the function expected result
  task drive_and_verify(input trans_adder_t tr);
    trans_adder_t expec;
    begin
        //Driving the signals
        addr     = 'h01;
        data_in  = tr.data1;
        we       = 'h1;
        @(posedge clk);
        addr     = 'h02;
        data_in  = tr.data2;
        we       = 'h1;
        @(posedge clk);
        addr     = 'h03;
        data_in  = tr.cin;
        we       = 'h1;
        @(posedge clk);

        
        we   = 'h0;
        addr = 'h01;
        @(posedge clk);
        adder_registers.data1 = data_out;
        addr  = 'h02;
        @(posedge clk);
        adder_registers.data2 = data_out;
        addr  = 'h03;
        @(posedge clk);
        adder_registers.cin = data_out;

        if(adder_registers.data1 !== tr.data1 || adder_registers.data2 !== tr.data2 || adder_registers.cin !== tr.cin ) begin
            $display($psprintf("**ERROR : registers were not loaded \n %s ",get_trans_str(tr)));
            $display("|========================");
        end

        @(posedge clk);
        we    = 'h0;
        start = 'h1;
        @(posedge clk);
        start = 'h0;

        @(posedge ready);
        
        expec = expected(tr);

        addr = 'h04;
        @(posedge clk);
        tr.result = data_out;

        addr = 'h05;
        @(posedge clk);
        tr.cout = data_out;

        if({tr.cout,tr.result} !=={expec.cout, expec.result}) begin
          $display($psprintf("**ERROR : results do not match \n %s ",get_trans_str(tr)));
          $display("|========================");
        end
        else begin 
          $display($psprintf("%s",get_trans_str(tr)));
          $display("|========================");
        end
      end

    endtask


  initial begin : main
    @(rstn);
    $display("Hello World !");

    single_trans.data1 = 'hCA;
    single_trans.data2 = 'hFE;
    single_trans.cin   = 'h1;


    $display("------------- STEP 1 -----------------");

    

    for (int idx=0;idx<12;idx++)
    begin
      single_trans.data1 += 7 ;
      /// LAB-TODO: Initialize the static array trans_sa with the content of single_trans, using a for loop

    end

    ///// LAB-TODO: modify single_trans data1

    ///// LAB-TODO: modify trans_sa[5] data2

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_sa element and the single_trans as argument
//    foreach (trans_sa[ii] )
//      drive_and_verify(trans_sa[ii]);
//
//    $display("Single Transaction:");
//    drive_and_verify(single_trans);

    $display("------------- STEP 2 -----------------");

    ///// LAB-TODO: Initialize the Dynamic List trans_dl with the 12 elements of the static array trans_sa

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_dl element as argument
//    foreach (trans_dl[ii] )
//      drive_and_verify(trans_dl[ii]);

    $display("------------- STEP 3 -----------------");

    single_trans.data1 = 'hC3;
    single_trans.data2 = 'h78;
    single_trans.cin   = 'h0;

    ///// LAB-TODO: Resize the Dynamic List trans_dl with 13 elements, adding single_trans at the end

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_dl element as argument
//    foreach (trans_dl[ii] )
//      drive_and_verify(trans_dl[ii]);


    $display("------------- STEP 4 -----------------");

    ///// LAB-TODO: Push(back) single_trans to the queue trans_q

    single_trans.data1 = 'h78;
    single_trans.data2 = 'hC3;
    single_trans.cin   = 'h1;

    ///// LAB-TODO: Push(back) single_trans to the queue trans_q

    single_trans.data1 = 'hFA;
    single_trans.data2 = 'hDA;
    single_trans.cin   = 'h1;

    ///// LAB-TODO: Push(front) single_trans to the queue trans_q

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_q element as argument
//    foreach (trans_q[ii] )
//      drive_and_verify(trans_q[ii]);

    $display("------------- STEP 5 -----------------");

    ///// LAB-TODO: Pop(back) trans_q into single_trans
    
    ///// LAB-TODO: Call the drive_and_verify() task passing the single_trans as argument

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_q element as argument
//    foreach (trans_q[ii] )
//      drive_and_verify(trans_q[ii]);

    $display("------------- STEP 6 -----------------");

    ///// LAB-TODO: Pop(front) trans_q into single_trans
    
    ///// LAB-TODO: Call the drive_and_verify() task passing the single_trans as argument

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_q element as argument
//    foreach (trans_q[ii] )
//      drive_and_verify(trans_q[ii]);

    $display("------------- STEP 7 -----------------");

    ///// LAB-TODO: Add single_trans to the associative array trans_aa with the key "yellow"

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_aa element as argument
//    foreach (trans_aa[key] ) begin
//      $display($psprintf("\ntrans_aa[%s]: \n",key)); //Printing the key
//      drive_and_verify(trans_aa[key]);
//    end

    single_trans.data1 = 'hBA;
    single_trans.data2 = 'hB0;

    $display("------------- STEP 8 -----------------");

    ///// LAB-TODO: Add single_trans to the associative array trans_aa with keys "red" and "yellow" again

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_aa element as argument
//    foreach (trans_aa[key] ) begin
//      $display($psprintf("\ntrans_aa[%s]: \n",key)); //Printing the key
//      drive_and_verify(trans_aa[key]);
//    end

    $display("------------- STEP 9 -----------------");

    ///// LAB-TODO: Check if key "yellow" exists, if so delete this entry from the associative array trans_aa

    ///// LAB-TODO: Set the trans_aa["yellow"] content to the trans_aa["blue"]

    ///// LAB-TODO: Call the drive_and_verify() task passing each trans_aa element as argument
//    foreach (trans_aa[key] ) begin
//      $display($psprintf("\ntrans_aa[%s]: \n",key)); //Printing the key
//      drive_and_verify(trans_aa[key]);
//    end

  end // initial begin

endprogram

