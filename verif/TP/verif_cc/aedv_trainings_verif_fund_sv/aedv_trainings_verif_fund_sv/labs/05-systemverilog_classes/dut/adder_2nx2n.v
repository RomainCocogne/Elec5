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
// File: adder_2nx2n.v
// Description: Top adder module that uses two simple adders instantiation. 

module adder_2nx2n #(parameter N = 8) (
    output [N-1:0] o_result,
    output o_cout,

    input [N-1:0] i_data1,
    input i_set1,

    input [N-1:0] i_data2,
    input i_set2,

    input i_get,

    input i_clk
    );

    //Internal Registers
    reg [N-1:0] reg_data1;
    reg [N-1:0] reg_data2;

    //Internal signals
    wire internal_carry;

    wire [N-1:0] wire_result;
    wire wire_cout;


    always @(posedge i_clk) begin
        case({i_set2, i_set1})
            2'b01: reg_data1 <= i_data1;
            2'b10: reg_data2 <= i_data2;
            2'b11: begin
                reg_data1 <= i_data1;
                reg_data2 <= i_data2;
            end 
        endcase
    end


    assign {o_cout, o_result} = i_get ? {wire_cout, wire_result} : 'h0;

    adder_nxn #(.N(N/2)) add1(
        .o_result(wire_result[((N/2)-1):0]),
        .o_cout(internal_carry),

        .i_data1(reg_data1[((N/2)-1):0]),
        .i_data2(reg_data2[((N/2)-1):0]),

        .i_cin(1'b0)
        );

    adder_nxn #(.N(N/2)) add2(
        .o_result(wire_result[N-1:(N/2)]),
        .o_cout(wire_cout),

        .i_data1(reg_data1[N-1:(N/2)]),
        .i_data2(reg_data2[N-1:(N/2)]),

        .i_cin(internal_carry)
        );


endmodule