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

// Lab : SystemVerilog Basics - Checkers
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Use a simple checker encapsulation 
//--------------------------------------------------------------------------------
// File: project_utils_pkg.sv
// Description: This file contains a package that declares a driver and a monitor
//             classe and some useful types. The student will declare and complete
//             checker in this file.

package project_utils_pkg;

  parameter N = 8;

  typedef logic [N-1:0] data_t;

  typedef struct     {
    data_t      cfg;
    data_t      data1;
    data_t      data2;
    logic       cin;
    data_t      result;
    logic       cout;
  } regs_adder_t;

  static regs_adder_t addRegs;

  typedef enum logic {READ, WRITE} direction_t;
  typedef enum logic {ACC, COMPUTE} action_t;

  //Transaction Class
  class adderTransactionBase ;

    //-----------------------
    /// rand class members
    //-----------------------
    rand data_t      in_data;
    rand data_t      addr;
    rand direction_t dir;
    rand action_t    action;
    
    data_t           out_data;


    constraint acc_default {
      soft action == ACC;
    }

    constraint addr_range {
      addr inside {['h0:'h5]};
    }

    constraint read_only_area {
      addr inside {'h4, 'h5} -> dir == READ;
    }

    function void print();
        $display($psprintf("|==================================================================="));
        if(this.action == ACC) begin
            if(this.dir == WRITE) begin
                $display($psprintf("|Transaction (ACCESS) \n|Direction=WRITE   data_in=0x%02x addr=0x%02x ", this.in_data,this.addr));
            end
            else begin 
                $display($psprintf("|Transaction (ACCESS) \n|Direction=READ   data_out=0x%02x addr=0x%02x ", this.out_data,this.addr));
            end
        end
        else begin 
            $display($psprintf("|Transaction (COMPUTE)"));
            
        end
        
        
    endfunction


  endclass

  class driver;

    virtual adder_if.driver vif;
 
    function new (virtual adder_if.driver vif);
        this.vif = vif;
    endfunction


    //Drive the DUT signals
    task run(adderTransactionBase tr);
        process job[0:1];
        logic ready;
        begin
            //Driving the signals
            if(tr.action == ACC) begin
                if(tr.dir == WRITE) begin
                    this.vif.cb.i_addr   <= tr.addr;
                    this.vif.cb.i_data   <= tr.in_data;
                    this.vif.cb.i_we     <= 'h1;
                    @(this.vif.cb);
                    this.vif.cb.i_we     <= 'h0;
                end
                else if(tr.dir == READ) begin
                    this.vif.cb.i_addr   <= tr.addr;
                    this.vif.cb.i_we     <= 'h0;
                    @(this.vif.cb);
                    tr.out_data = this.vif.cb.o_data;
                    $display($psprintf("|Driver: data_out=0x%02x", tr.out_data));
                end
            end
            else begin
                this.vif.cb.i_we    <= 'h0;
                this.vif.cb.i_start <= 'h1;
                @(this.vif.cb);
                this.vif.cb.i_start <= 'h0;
                //Waiting by the ready signal
                //NOTE: It is not the best solution, but to not turn this lab too much complex(adding a new action or verifying the previous action),
                //this solution was chosen.
                fork
                    begin : wait_by_ready
                        job[0] = process::self();
                        while(vif.cb.o_ready !== 'h1) begin
                            @(this.vif.cb);
                        end
                    end
    
                    begin : timeout
                        job[1] = process::self();
                        @(this.vif.cb);
                        @(this.vif.cb);
                    end
                join_any
                foreach(job[ii]) begin
                    job[ii].kill();
                end
            end
        end

    endtask

  endclass

class monitor;

    virtual adder_if.monitor vif;
    adderTransactionBase tr;

    function new (virtual adder_if.monitor vif);
        this.vif = vif;
        tr = new;
    endfunction


    //Monitor the DUT signals and verify the result comparing with the function expected result
    task run();
        process job[0:1];
        begin

            @(posedge this.vif.i_clk or negedge this.vif.i_rstn);

            if(~this.vif.i_rstn) begin
                $display($psprintf("[RESET]"));
            end

            else if(this.vif.i_we) begin
                this.tr.dir       = WRITE;
                this.tr.action    = ACC;
                this.tr.addr      = this.vif.i_addr;
                this.tr.in_data   = this.vif.i_data;
            end

            else if(this.vif.o_ready) begin
                $display($psprintf("|Ready signal was set, the addition was performed"));
            end
            else if(this.vif.i_start === 1) begin
                this.tr.action = COMPUTE;
                //Waiting by the ready signal
                //NOTE: It is not the best solution, but to not turn this lab too much complex(adding a new action or verifying the previous action),
                //this solution was chosen.
                fork
                    begin : wait_by_ready
                        job[0] = process::self();
                        @(posedge vif.o_ready);
                    end
    
                    begin : timeout
                        job[1] = process::self();
                        @(posedge this.vif.i_clk);
                        @(posedge this.vif.i_clk);
                    end
                join_any
                job[0].kill();
            end
            else begin
                this.tr.dir        = READ;
                this.tr.action     = ACC;
                this.tr.addr       = this.vif.i_addr;
                this.tr.out_data   = this.vif.o_data;
            end
            
            this.tr.print();
        end

    endtask

  endclass

  checker adder_checker(
    // LAB-TODO-STEP-1a: Declare the checker ports
    );

    // LAB-TODO-STEP-1b: Declare the assertions

  endchecker


endpackage