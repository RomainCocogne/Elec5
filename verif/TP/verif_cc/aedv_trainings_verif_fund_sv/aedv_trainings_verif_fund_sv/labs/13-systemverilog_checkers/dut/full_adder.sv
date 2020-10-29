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
// File: full_adder.v
// Description: Top adder module that uses one simple adder instantiation, a FSM,
//             a register file and an interface.   


//================================================================================
//  FULL ADDER
//
//  Register File:  
//  => CONFIG  | Configuration Register | 0x00 | R/W | |======================| OBS.: Not used currently
//  => DATA1   | Operand 1              | 0x01 | R/W | |         DATA1        |
//  => DATA2   | Operand 2              | 0x02 | R/W | |         DATA2        |
//  => CIN     | Carry In               | 0x03 | R/W | |==================|cin|
//  => RESULT  | Result                 | 0x04 | RO  | |        RESULT        |
//  => COUT    | Carry Out              | 0x05 | RO  | |=================|cout|
//
//
//  Signals:
//  <- o_data  | Data Output            | OUTPUT
//  <- o_ready | Result is Ready        | OUTPUT
//  <- o_ack   | Ack of the operation   | OUTPUT
//  -> i_addr  | Register Address       | INPUT
//  -> i_data  | Data Input             | INPUT
//  -> i_we    | Write Enable           | INPUT
//  -> i_start | Start the computation  | INPUT
//================================================================================


module full_adder #(parameter N = 8) (
    adder_if.adder add_if
    );

    parameter IDLE = 2'h0, AD1 = 2'h1, AD2 = 2'h2;

    //States
    reg [1:0] next, current;

    //Register File
    reg [N-1:0] reg_file [5:0];

    //Internal signals
    wire [(N/2)-1:0] result_half;
    wire int_cout;

    reg [(N/2)-1:0] data_half_1;
    reg [(N/2)-1:0] data_half_2;
    reg int_cin;
    reg int_next_cin;

    //Assignments
    
    //Computing (FSM)
    //Comb block
    always @(*) begin

        add_if.o_ready = 'h0;

        case (current)
            IDLE : begin
                if(add_if.i_start) begin
                    next = AD1;
                end
                else begin 
                    next = IDLE;
                end
            end
            AD1: begin
                data_half_1               = reg_file['h01][(N/2)-1:0];
                data_half_2               = reg_file['h02][(N/2)-1:0];
                int_cin                   = reg_file['h03];
                reg_file['h04][(N/2)-1:0] = result_half;
                int_next_cin              = int_cout;
                next                      = AD2;
            end
            AD2: begin 
                data_half_1               = reg_file['h01][N-1:(N/2)];
                data_half_2               = reg_file['h02][N-1:(N/2)];
                int_cin                   = int_next_cin;
                reg_file['h04][N-1:(N/2)] = result_half;
                reg_file['h5]             = int_cout;
                add_if.o_ready            = 'h1;
                next                      = IDLE;
            end
            default : /* default */;
        endcase
    
    end

    //Seq Block
    always @(posedge add_if.i_clk or negedge add_if.i_rstn) begin
        if(~add_if.i_rstn) begin
            current <= IDLE;
        end else begin
            current <= next;
        end
    end

    integer ii;
    always @(posedge add_if.i_clk, negedge add_if.i_rstn) begin
        add_if.o_ack   <= 'h0;

        if(~add_if.i_rstn) begin
            for(ii=0;ii<6;ii=ii+1) begin 
                reg_file[ii] <= 'h0;
            end
            add_if.o_ack   <= 'h0;
        end
        else begin
            if(add_if.i_we)begin
                if(add_if.i_addr < 'h04) begin
                    reg_file[add_if.i_addr] <= add_if.i_data;
                    add_if.o_ack <= 'h1;
                end
            end
            else begin
                add_if.o_data <= reg_file[add_if.i_addr];
            end
        end
    end

    //assign add_if.o_data = add_if.i_we ? 'h0 : reg_file[add_if.i_addr];


    adder_nxn #(.N(N/2)) add(
        .o_result(result_half),
        .o_cout(int_cout),

        .i_data1(data_half_1),
        .i_data2(data_half_2),

        .i_cin(int_cin)
        );


endmodule