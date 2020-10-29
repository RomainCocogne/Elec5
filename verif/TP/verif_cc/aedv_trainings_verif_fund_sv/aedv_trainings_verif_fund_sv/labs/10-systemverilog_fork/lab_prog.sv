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


// Lab : SystemVerilog Basics - Threads
//---------------------------------------------------------------------------------------------------------
// Goals:
//      - Be familar with fork and process class 
//      - Be familiar with mutex and events in SV 
//--------------------------------------------------------------------------------
// File: lab_prog.sv
// Description: This file contains a program that uses the classes in the project_utils_pkg.sv
//             to drive and monitor the DUT signals. In this lab, the student will use this
//             program to declare a fork and manupulate the process.

program lab_prog(
    adder_if add_if
    );

    // Start importing the useful package
    import project_utils_pkg::*;

    parameter N = 8;

    initial begin 
        trans_adder_t tr_a;
        trans_adder_t tr_b;

        static driver dri = new(add_if.driver);
        static monitor mon = new(add_if.monitor);
        //LAB-TODO-STEP3-a : Declare a semaphore with one item (MUTEX)
//        static semaphore mutex = new(1);

        //LAB-TODO-STEP4-a : Create process vectors
//        process job[0:2];

        @(add_if.i_rstn);

        // LAB-TODO-STEP1-a : Analyse the fork block
        fork

            begin : thread_MONITOR
                //LAB-TODO-STEP4-b : Use the self method to get a handle of process for this thread
//                job[0] = process::self();

                forever begin 
                    mon.run();
                end
            end

            begin : thread_A
                //LAB-TODO-STEP4-b : Use the self method to get a handle of process for this thread
//                job[1] = process::self();

                for (int ii = 0; ii < 10; ii++ ) begin

                    //LAB-TODO-STEP3-b : Call the get() method to get the mutex
//                    mutex.get(1);

                    $display("Thread A: %d", ii);
                    tr_a.data1 = ii;
                    tr_a.data2 = (ii+2);
                    tr_a.cin = ii;
                    dri.run(tr_a);

                    //LAB-TODO-STEP3-b : Call the put() method to put the mutex back
//                    mutex.put(1);
                end
            end

            //LAB-TODO-STEP2-a : Create a third thread to perform 5 transaction with the same data1 and data2 values(Display Thread B and the number), re-run

        //LAB-TODO-STEP1-b : Replace the join with join_none, re-run
        //LAB-TODO-STEP1-c : Replace the join_none with join_any, re-run
        join

        //LAB-TODO-STEP4-c : Verify if each job is finished, if not, wait
//        foreach(job[ii]) begin
//            if(ii !== 0 && job[ii].status() !== process::FINISHED) begin
//                job[ii].await();
//            end
//        end

        //LAB-TODO-STEP4-d : Kill the monitor thread using the kill method

        $display("Simulation end");
        $finish;

    end

    initial begin 
        

    end

endprogram