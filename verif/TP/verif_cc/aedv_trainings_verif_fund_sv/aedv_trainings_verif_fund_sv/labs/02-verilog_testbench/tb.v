// ===============================================================================
// Copyright (c) 2015-2018 - AEDVICES Consulting
// ===============================================================================
//                     Training
//                        on
//            IP & SoC Verification Methodology
//                     using UVM
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for
// training purposes.
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab : Verilog Basics - Testbench
//--------------------------------------------------------------------------------
// Goals:
//  - Get started with Verilog testbenches;
//  - Be able to build a testbench;
//  - Be able to use tasks and functions.
//--------------------------------------------------------------------------------
// File: tb.v
// Description: Simple testbench to test the adder top module using tasks and functions.  

module tb();

    parameter N = 8;

    wire [N-1:0] result;
    wire cout;

    reg [N-1:0] data1;
    reg set1;

    reg [N-1:0] data2;
    reg set2;

    reg get;

    reg clk;

    //LAB-TODO-STEP-1: Create the sum function

    task drive_and_verify;
        integer ii, jj; //Counters
        integer kk; //Counter
        reg [N:0] sum_result;
        reg [N-1:0] aux_data1, aux_data2;
        begin
            //LAB-TODO-STEP-2a: Complete the task (uncomment the code)
            //for(ii=0;ii<((2**N)-1);ii=ii+1) begin
            //    for(jj=0;jj<((2**N)-1);jj=jj+1) begin
            //        for(kk=0;kk<((2**3));kk=kk+1) begin
            //            //Driving the signals
            //            {set1, set2, get} <= kk;
            //
            //            data1 <= ii;
            //            data2 <= jj;
            //            //LAB-TODO-STEP-2b: Wait for a positive clock edge (uncomment the code)
            //            //@(posedge clk);//Wait a positive clock edge
            //
            //            //The aux_datas are set just when we have set signals active, so we will keep the value hold in the internal DUT register
            //            if(set1 === 1'b1) begin
            //                aux_data1 <= ii;
            //            end
            //            if(set2 === 1'b1) begin
            //                aux_data2 <= jj;
            //            end
            //
            //            //Verifying if the result is the sum or 0
            //            if(get === 1'b1) begin
            //                //We use the aux_datas registers responsible to hold the last datas set (when set1 and set2 are set)
            //                //LAB-TODO-STEP-2c: Call the sum function passing the aux_data# variables as argument
            //                //sum_result <= sum(aux_data1, aux_data2);
            //            end
            //            else begin
            //                sum_result <= 'h0;
            //            end
            //
            //            @(posedge clk);
            //
            //            if({cout,result} !== sum_result) begin
            //                $display("**ERROR: data1 = %d, data2 = %d", data1, data2);
            //            end
            //        end
            //    end
            //end
        end
    endtask

    //DUT Instance
    adder_top #( .N(N)) DUT (
                                .o_result(result),
                                .o_cout(cout),
    
                                .i_data1(data1),
                                .i_set1(set1),
    
                                .i_data2(data2),
                                .i_set2(set2),
    
                                .i_get(get),
    
                                .i_clk(clk)
    );
    
    initial begin
        clk = 0;
        //LAB-TODO-STEP-3: Call the drive_and_verify task
//        drive_and_verify;
        
        repeat(2)
            @(posedge clk);
        $display("LAB: Testbench completed");
        $finish;

    end

    //Clock generation
    always begin
        #1 clk <= ~clk;
    end

endmodule



/////////////////////////////////////////////////////////////////////////////////////
/////////////////////////// END OF FILE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////

module lab_test;
	// Empty. Just make the script happy.
    // Keep it empty.
endmodule
