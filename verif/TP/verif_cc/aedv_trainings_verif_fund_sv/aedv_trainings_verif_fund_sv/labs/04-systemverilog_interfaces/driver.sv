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


// Lab : SystemVerilog Basics - Interfaces
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Be familiar with the concept of interfaces 
//  - Be familiar with interface connection and modport 
//  - Connect modules using interfaces
//--------------------------------------------------------------------------------
// File: driver.sv
// Description: Program that plays a role of driver.

program driver(
    // LAB-TODO-STEP3-a : Declare the interface as Input/Output - call it "add_if" ( or replace add_if below to the name you specified )
    );

    parameter N = 8;

    function [N:0] sum(input logic [N-1:0] a, input logic [N-1:0] b, input logic cin);
        begin
            sum = a+b+cin;
        end
    endfunction

    initial begin 
        integer ii, jj, kk; //Counters
        logic [N:0] sum_result;

    	logic [N-1:0] result;
        logic cout;
        logic [N-1:0] data1;
        logic [N-1:0] data2;
        logic cin;

        @(add_if.i_rstn);

        for(ii=0;ii<((2**N)-1);ii=ii+1) begin
            for(jj=0;jj<((2**N)-1);jj=jj+1) begin
                for (kk = 0; kk < 2; kk=kk+1) begin
                    //Driving the signals
                    // LAB-TODO-STEP3-b : Write each data to the respective registers
//                    add_if.i_addr <= 'h01;
//                    add_if.i_data <= jj;
//                    add_if.i_we   <= 'h1;
//                    @(posedge add_if.i_clk);
//
//                    add_if.i_addr <= 'h02;
//                    add_if.i_data <= ii;
//                    add_if.i_we   <= 'h1;
//                    @(posedge add_if.i_clk);
//
//                    add_if.i_addr <= 'h03;
//                    add_if.i_data <= kk;
//                    add_if.i_we   <= 'h1;
//                    @(posedge add_if.i_clk);
//
    
                    // LAB-TODO-STEP3-c : Read each data and load in the respective variables
//                    add_if.i_we   <= 'h0;
//                    add_if.i_addr <= 'h01;
//
//                    @(posedge add_if.i_clk);
//
//                    data1          = add_if.o_data;
//                    add_if.i_addr <= 'h02;
//
//                    @(posedge add_if.i_clk);
//
//                    data2          = add_if.o_data;
//                    add_if.i_addr <= 'h03;
//
//                    @(posedge add_if.i_clk);
//
//                    cin            = add_if.o_data;
    
                    if(data1 !== jj || data2 !== ii || cin !== kk ) begin
                        $display("**ERROR: data1 = %d, data2 = %d, cin = %d were not loaded", data1, data2, cin);
                    end
    
                    // LAB-TODO-STEP3-d : Start the FSM to compute the sum
//                    @(posedge add_if.i_clk);
//
//                    add_if.i_we    <= 'h0;
//                    add_if.i_start <= 'h1;
//
//                    @(posedge add_if.i_clk);
//
//                    add_if.i_start <= 'h0;
//
    
                    // LAB-TODO-STEP3-e : Wait fr a ready signal to get the result 
                    
//                    @(posedge add_if.o_ready);
                    
                    sum_result        = sum(data1, data2, cin);
    
                    // LAB-TODO-STEP3-f : Write the code to get the result and the cout, driving the interface 
    
                    if({cout,result} !== sum_result) begin
                        $display("**ERROR: data1 = %d, data2 = %d, cin = %d, results do not match", data1, data2, cin);
                    end

                end 
            end
        end

        $finish;

    end

endprogram