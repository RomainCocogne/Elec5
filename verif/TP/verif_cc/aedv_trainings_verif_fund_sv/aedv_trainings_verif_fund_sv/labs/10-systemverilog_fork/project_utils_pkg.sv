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
// File: project_utils_pkg.sv
// Description: This file contains a package that declares a driver and a monitor
//             classe and some useful types.

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

    virtual adder_if.driver vif;
 
    function new (virtual adder_if.driver vif);
        this.vif = vif;
    endfunction


    //Drive the DUT signals
    task run(trans_adder_t tr);
        begin
            //Driving the signals
            //Set the operands
            this.vif.i_addr   = 'h01;
            this.vif.i_data   = tr.data1;
            this.vif.i_we     = 'h1;
            @(posedge this.vif.i_clk);
            this.vif.i_addr   = 'h02;
            this.vif.i_data   = tr.data2;
            this.vif.i_we     = 'h1;
            @(posedge this.vif.i_clk);
            this.vif.i_addr   = 'h03;
            this.vif.i_data   = tr.cin;
            this.vif.i_we     = 'h1;
            @(posedge this.vif.i_clk);

            //Start the computation
            this.vif.i_we    = 'h0;
            this.vif.i_start = 'h1;
            @(posedge this.vif.i_clk);
            this.vif.i_start = 'h0;
            
            //Wait by the ready signal
            @(posedge this.vif.o_ready);
            
            //Read the result
            this.vif.i_addr = 'h04;
            @(posedge this.vif.i_clk);
            #1ps; //Input skew. We will see a better solution usign clocking block
            tr.result = this.vif.o_data;
    
            this.vif.i_addr = 'h05;
            @(posedge this.vif.i_clk);
            #1ps; //Input skew. We will see a better solution usign clocking block
            tr.cout = this.vif.o_data;
        end

    endtask

  endclass

  class monitor;

    virtual adder_if.monitor vif;
    trans_adder_t expec;

    function new (virtual adder_if.monitor vif);
        this.vif = vif;
    endfunction


    //Generate the expected DUT result
    function trans_adder_t expected(input trans_adder_t tr);
        expected = tr;
        {expected.cout, expected.result} = addRegs.data1 + addRegs.data2 + addRegs.cin;
        return expected;
    endfunction


    //Monitor the DUT signals and verify the result comparing with the function expected result
    task run();
        begin

            @(posedge this.vif.i_clk or negedge this.vif.i_rstn);

            if(~this.vif.i_rstn) begin
                $display($psprintf("[RESET]"));
                addRegs.data1 = 'h0;
                addRegs.data2 = 'h0;
                addRegs.cin   = 'h0;
            end

            else if(vif.i_we) begin
                $display($psprintf("[%d] Writting transaction Addr:%2x Data:%2x ", $realtime, vif.i_addr, vif.i_data));
                case (vif.i_addr)
                    'h1: begin
                        addRegs.data1      = this.vif.i_data;
                        this.expec.data1   = this.vif.i_data;
                    end 
                    'h2: begin 
                        addRegs.data2      = this.vif.i_data;
                        this.expec.data2   = this.vif.i_data;
                    end 
                    'h3: begin 
                        
                        addRegs.cin        = this.vif.i_data;
                        this.expec.cin     = this.vif.i_data;
                    end 
                    default : $display($psprintf("**ERROR : Writting in R/O register\n %2x ",vif.i_addr));
                endcase
            end

            else if(vif.i_start) begin
                $display($psprintf("[%d] Start signal was set, the addition: %2x + %2x + %2x will be executed", $realtime, addRegs.data1, addRegs.data2, addRegs.cin));
                this.expec = expected(this.expec);
            end

            else if(vif.o_ready) begin
                $display($psprintf("[%d] Ready signal was set, the addition: %2x + %2x + %2x was performed", $realtime, addRegs.data1, addRegs.data2, addRegs.cin));
            end
            else begin
                $display($psprintf("[%d] Reading transaction Addr:%2x Data:%2x ", $realtime, vif.i_addr, vif.o_data));
                case (vif.i_addr)
                    'h1: begin
                        if(addRegs.data1 !== this.vif.o_data) begin
                            $display($psprintf("**ERROR : The read Data1 does not match the expected one: Read Data %2x, Expected data: %2x ",this.vif.o_data, addRegs.data1));
                        end
                    end 
                    'h2: begin 
                        if(addRegs.data2 !== this.vif.o_data) begin
                            $display($psprintf("**ERROR : The read Data2 does not match the expected one Read Data %2x, Expected data: %2x ",this.vif.o_data, addRegs.data2));
                        end
                    end 
                    'h3: begin 
                        if(addRegs.cin !== this.vif.o_data) begin
                            $display($psprintf("**ERROR : The read Carry In does not match the expected one: Read Data %2x, Expected data: %2x ",this.vif.o_data, addRegs.cin));
                        end
                    end 
                    'h4: begin 
                        addRegs.result = this.vif.o_data;
                        if(addRegs.result !== this.expec.result) begin
                            $display($psprintf("**ERROR : The read Result does not match the expected one: Read Result %2x, Expected Result: %2x ",this.vif.o_data, this.expec.result));
                        end
                        else begin 
                            $display($psprintf("==========================================================================================="));
                            $display($psprintf("The Result was read: %2x",this.vif.o_data));
                            $display($psprintf("==========================================================================================="));
                        end
                    end 
                    'h5: begin 
                        addRegs.cout = this.vif.o_data;
                        if(addRegs.cout !== this.expec.cout) begin
                            $display($psprintf("**ERROR : The read Carry Out does not match the expected one: Read Carry Out %2x, Expected Carry Out: %2x ",this.vif.o_data, this.expec.cout));
                        end
                        else begin
                            $display($psprintf("===========================================================================================")); 
                            $display($psprintf("The COUT was read: %2x",this.vif.o_data));
                            $display($psprintf("==========================================================================================="));
                        end
                    end 

                endcase
            end
        end

    endtask

  endclass


endpackage