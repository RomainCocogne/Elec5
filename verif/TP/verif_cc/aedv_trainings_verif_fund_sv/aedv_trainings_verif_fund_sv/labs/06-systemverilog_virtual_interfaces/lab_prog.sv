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


// Lab : SystemVerilog Basics - Virtual Interfaces
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Be familiar with the concept of virtual interfaces 
//  - Connect modules and classes using interfaces
//--------------------------------------------------------------------------------
// File: lab_prog.sv
// Description: This file contains a package that declares a driver and a monitor class and a program that
//             uses these classes to drive and monitor the DUT signals

package project_utils_pkg;

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

  static regs_adder_t addRegs;

  /// returns a string with the transaction content
  function string get_trans_str(trans_adder_t tr);
    return $psprintf("|Transaction \n|data1=0x%02x   data2=0x%02x \n|cout=0x%01x     result=0x%02x  \n|cin=0x%01x  ",tr.data1,tr.data2,tr.cout,tr.result,tr.cin);
  endfunction


  class driver;

    // LAB-TODO-STEP2-a : Declare the vitural interface
//    virtual adder_if.driver vif;

    // LAB-TODO-STEP2-b : Declare the constructor function responsible to set the VIF
//    function new (virtual adder_if.driver vif);
//        this.vif = vif;
//    endfunction


    //Drive the DUT signals
    task run(trans_adder_t tr);
        begin
            //Driving the signals
            // LAB-TODO-STEP2-c : Uncomment this to drive the DUT
//            //Set the operands
//            this.vif.i_addr   = 'h01;
//            this.vif.i_data   = tr.data1;
//            this.vif.i_we     = 'h1;
//            @(posedge this.vif.i_clk);
//            this.vif.i_addr   = 'h02;
//            this.vif.i_data   = tr.data2;
//            this.vif.i_we     = 'h1;
//            @(posedge this.vif.i_clk);
//            this.vif.i_addr   = 'h03;
//            this.vif.i_data   = tr.cin;
//            this.vif.i_we     = 'h1;
//            @(posedge this.vif.i_clk);
//
//            //Start the computation
//            this.vif.i_we    = 'h0;
//            this.vif.i_start = 'h1;
//            @(posedge this.vif.i_clk);
//            this.vif.i_start = 'h0;
//            
//            //Wait by the ready signal
//            @(posedge this.vif.o_ready);
//            
//            //Read the result
//            this.vif.i_addr = 'h04;
//            @(posedge this.vif.i_clk);
//            #1ps; //Input skew. We will see a more elegant solution usign clocking block
//            tr.result = this.vif.o_data;
//    
//            this.vif.i_addr = 'h05;
//            @(posedge this.vif.i_clk);
//            #1ps; //Input skew. We will see a more elegant solution usign clocking block
//            tr.cout = this.vif.o_data;
//
        end

    endtask

  endclass

  class monitor;

    // LAB-TODO-STEP3-a : Declare the vitural interface
    trans_adder_t expec;

    // LAB-TODO-STEP3-b : Declare the constructor function responsible to set the VIF


    //Generate the expected DUT result
    function trans_adder_t expected(input trans_adder_t tr);
        expected = tr;
        {expected.cout, expected.result} = addRegs.data1 + addRegs.data2 + addRegs.cin;
        return expected;
    endfunction


    //Monitor the DUT signals and verify the result comparing with the function expected result
    task run();
        begin
            //Monitoring the signals
            // LAB-TODO-STEP3-c : Wait by a positive edge clock or by a negative edge reset using the virtual interface

            // LAB-TODO-STEP3-d : reset the model registers when the reset is low
//            if(~this.vif.i_rstn) begin
//                $display($psprintf("[RESET]"));
//                addRegs.data1 = 'h0;
//                addRegs.data2 = 'h0;
//                addRegs.cin   = 'h0;
//            end
            // LAB-TODO-STEP3-e : Set the addRegs registers with the respective data using the VIF

            // LAB-TODO-STEP3-f : Execute the expected function when the start signals is asserted
//            else if(vif.i_start) begin
//                $display($psprintf("[%d] Start signal was set, the addition: %2x + %2x + %2x will be executed", $realtime, addRegs.data1, addRegs.data2, addRegs.cin));
//                this.expec = expected(this.expec);
//            end
            // LAB-TODO-STEP3-g : Uncomment the rest of the monitor task
//            else if(vif.o_ready) begin
//                $display($psprintf("[%d] Ready signal was set, the addition: %2x + %2x + %2x was performed", $realtime, addRegs.data1, addRegs.data2, addRegs.cin));
//            end
//            else begin
//                $display($psprintf("[%d] Reading transaction Addr:%2x Data:%2x ", $realtime, vif.i_addr, vif.o_data));
//                case (vif.i_addr)
//                    'h1: begin
//                        if(addRegs.data1 !== this.vif.o_data) begin
//                            $display($psprintf("**ERROR : The read Data1 does not match the expected one: Read Data %2x, Expected data: %2x ",this.vif.o_data, addRegs.data1));
//                        end
//                    end 
//                    'h2: begin 
//                        if(addRegs.data2 !== this.vif.o_data) begin
//                            $display($psprintf("**ERROR : The read Data2 does not match the expected one Read Data %2x, Expected data: %2x ",this.vif.o_data, addRegs.data2));
//                        end
//                    end 
//                    'h3: begin 
//                        if(addRegs.cin !== this.vif.o_data) begin
//                            $display($psprintf("**ERROR : The read Carry In does not match the expected one: Read Data %2x, Expected data: %2x ",this.vif.o_data, addRegs.cin));
//                        end
//                    end 
//                    'h4: begin 
//                        addRegs.result = this.vif.o_data;
//                        if(addRegs.result !== this.expec.result) begin
//                            $display($psprintf("**ERROR : The read Result does not match the expected one: Read Result %2x, Expected Result: %2x ",this.vif.o_data, this.expec.result));
//                        end
//                        else begin 
//                            $display($psprintf("==========================================================================================="));
//                            $display($psprintf("The Result was read: %2x",this.vif.o_data));
//                            $display($psprintf("==========================================================================================="));
//                        end
//                    end 
//                    'h5: begin 
//                        addRegs.cout = this.vif.o_data;
//                        if(addRegs.cout !== this.expec.cout) begin
//                            $display($psprintf("**ERROR : The read Carry Out does not match the expected one: Read Carry Out %2x, Expected Carry Out: %2x ",this.vif.o_data, this.expec.cout));
//                        end
//                        else begin
//                            $display($psprintf("===========================================================================================")); 
//                            $display($psprintf("The COUT was read: %2x",this.vif.o_data));
//                            $display($psprintf("==========================================================================================="));
//                        end
//                    end 
//
//                endcase
//            end

        end

    endtask

  endclass


endpackage


program lab_prog(
    adder_if add_if
    );

    // Start importing the useful package
    import project_utils_pkg::*;

    parameter N = 8;

    initial begin 
        integer ii;
        trans_adder_t tr;
        // LAB-TODO-STEP5-a : Instantiate the driver object passing the interface driver modport as argument


        @(add_if.i_rstn);

        // LAB-TODO-STEP5-b : Perform 10 additions. Modify, if you wish.
//        for (int ii = 0; ii < 10; ii++ ) begin
//            tr.data1 = ii;
//            tr.data2 = (ii+2);
//            tr.cin = ii;
//            dri.run(tr);
//        end

        $finish;

    end

    initial begin 
        // LAB-TODO-STEP5-c : Instantiate the monitor object passing the interface monitor modport as argument
        forever begin 
            // LAB-TODO-STEP5-d : Call the run method from monitor to start monitoring.
//            mon.run();
        end

    end

endprogram