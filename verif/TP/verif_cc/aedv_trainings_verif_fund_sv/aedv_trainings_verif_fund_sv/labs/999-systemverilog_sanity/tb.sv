// ===============================================================================
// Copyright (c) 2015-2019 - AEDVICES Consulting
// ===============================================================================
//                     Training
//                        on
//            Functional Verification Methodology
//                      using UVM
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developed by AEDVICES Consulting for
// training purposes.
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================


// Lab : SystemVerilog - Object Oriented Programming
//---------------------------------------------------------------------------------------------------------
// Goals:
//  - Understand how manipulate SystemVerilog Classes
//  - Understand the concepts of inheritance and ancapsulation
//  - Be familiar with the concept of virtual methods
//--------------------------------------------------------------------------------
// File: tb.sv
// Description: Testbench that instantiates the DUT, the program and the interface.



/// This is a package containing some nice and useful types and classes
package project_utils_pkg;

  parameter N = 8;

  typedef logic [N-1:0] data_t;

  enum {LOW, HIGH} level_t;

  //adderRegisters class represents the internal DUT registers
  class adderRegisters;
    local data_t      cfg;
    local data_t      data1;
    local data_t      data2;
    local data_t      cin;
    local data_t      result;
    local data_t      cout;

    //-----------------------
    /// public functions
    //-----------------------
    // set data
    function void set_data1(data_t data1);
      this.data1 = data1;
    endfunction

    function void set_data2(data_t data2);
      this.data2= data2;
    endfunction

    function void set_cin(data_t cin);
      this.cin= cin;
    endfunction

    function void set_result(data_t result);
      this.result= result;
    endfunction

    function void set_cout(data_t cout);
      this.cout= cout;
    endfunction

    // get data
    function data_t get_data1();
      return this.data1;
    endfunction

    function data_t get_data2();
      return this.data2;
    endfunction

    function data_t get_cin();
      return this.cin;
    endfunction

    function data_t get_result();
      return this.result;
    endfunction

    function data_t get_cout();
      return this.cout;
    endfunction

  endclass

endpackage



// LAB-TODO-STEP1 : understand the main program.
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
  import project_utils_pkg::*;



  class adderTransactionBase ;
    //-----------------------
    /// protected class members
    //-----------------------
    protected data_t      data1;
    protected data_t      data2;
    protected data_t      result;

    static adderRegisters addRegs = new();
  
    //Constructor
    function new(data_t data1, data_t data2);
      this.data1 = data1;
      this.data2 = data2;
    endfunction

    //-----------------------
    /// protected function/task
    //-----------------------
    protected task compute();
      @(posedge clk);
      we    = 'h0;
      start = 'h1;
      @(posedge clk);
      start = 'h0;
    endtask

    // LAB-TODO-STEP-3: make this function virtual
    /// Print the Transaction String
    virtual function void print();
      $display("----------------------------------------------------------------------");
      $display($psprintf("|Registers   \n|data1=0x%02x   data2=0x%02x \n|result=0x%02x",this.addRegs.get_data1(),this.addRegs.get_data2(),this.addRegs.get_result()));
      $display($psprintf("|cin =0x%01x     cout=0x%01x \n",this.addRegs.get_cin(),this.addRegs.get_cout()));
      $display($psprintf("|Transaction \n|data1=0x%02x   data2=0x%02x \n|result=0x%02x",this.data1,this.data2,this.result));
    endfunction

  
    // LAB-TODO-STEP-3: make this task virtual  
    // Drive
    virtual protected task drive();
      //Drive the signals
      addr     = 'h01;
      data_in  = this.data1;
      we       = 'h1;
      @(posedge clk);
      addr     = 'h02;
      data_in  = this.data2;
      we       = 'h1;
      @(posedge clk);

      //Get the data1 and data2 registers from DUT and update the addRegs
      we   = 'h0;
      addr = 'h01;
      @(posedge clk);
      this.addRegs.set_data1(data_out);
      addr  = 'h02;
      @(posedge clk);
      this.addRegs.set_data2(data_out);

    endtask

    // LAB-TODO-STEP-4: make this task virtual
    //Verify
    virtual protected task verify();
    
      //Get result
      @(posedge ready);
      addr = 'h04;
      @(posedge clk);
      this.addRegs.set_result(data_out);

      //Calcule the expected
      {this.result} = this.addRegs.get_data1() + this.addRegs.get_data2();

      //Compare
      if({this.result} !== {this.addRegs.get_result()}) begin
        $display("----------------------------------------------------------------------");
        $display("**ERROR:");
      end
    endtask 

    //-----------------------
    /// public task
    //-----------------------

    task drive_and_verify();
        this.drive();
        this.compute();
        this.verify();
        this.print();
    endtask



  endclass



  class adderTransactionCarry extends adderTransactionBase;
    
    //-----------------------
    /// public class members
    //-----------------------
    logic       cin;
    logic       cout;
  
    //Constructor
    function new(data_t data1, data_t data2, logic cin);
      super.new(data1, data2);
      this.cin  = cin;
    endfunction
  
  
    //-----------------------
    /// local task
    //-----------------------
    // Get Result 
    local task get_result();

      //Get result
      @(posedge ready);
      addr = 'h04;
      @(posedge clk);
      //this.int_result = data_out;
      this.addRegs.set_result(data_out);
      addr = 'h05;
      @(posedge clk);
      this.addRegs.set_cout(data_out);

    endtask

    //-----------------------
    /// public function
    //-----------------------

    /// Print the Transaction String
    function void print();
      super.print();
      $display($psprintf("|cin =0x%01x     cout=0x%01x ",this.cin,this.cout));
    endfunction
      
    // LAB-TODO-STEP-2: override drive and verify functions to drive the control signals and verify comparing to a complete "model".
    // Drive
    protected task drive();

      super.drive();

      addr     = 'h03;
      data_in  = this.cin;
      we       = 'h1;
      @(posedge clk);
      we       = 'h0;
      addr     = 'h03;
      @(posedge clk);
      this.addRegs.set_cin(data_out);


    endtask


    //Verify
    protected task verify();

      //Calcule the expected
      {this.cout, this.result} = this.addRegs.get_data1() + this.addRegs.get_data2() + this.addRegs.get_cin();

      if({this.cout, this.result} !== {this.addRegs.get_cout(), this.addRegs.get_result()}) begin
        $display("----------------------------------------------------------------------");
        $display("**ERROR:");
      end

    endtask  
    task drive_and_verify();
        this.drive();
        super.compute();
        this.get_result();
        this.verify();
        this.print();
    endtask

  endclass

  // LAB-TODO-STEP-1 : understand the main program.
  initial
    begin
      adderTransactionCarry a,b,d;
      adderTransactionBase c;

      @(rstn);

      $display("---------------------------------------------------------");
      $display("Verification Training - LAB01 - starting simulation");
      $display("---------------------------------------------------------");

      $display("\nCASE-1");
      a = new('h02, 'h03, 'h0);
      a.drive_and_verify();

      $display("\nCASE-2");
      b = new('h07, 'h08, 'h1);
      b.drive_and_verify();

      $display("\nCASE-3");
      c = b;
      c.drive_and_verify();

      //// LAB-TODO-STEP5 : uncomment next lines
      $display("\nCASE-4");
      //// d = c;
      assert( $cast(d,c) ) else $display("ERROR of casting");
      d.drive_and_verify();

      $display("---------------------------------------------------------");
      $display("Test completed");
      $display("---------------------------------------------------------");
    end
endprogram
////////////////////////////////////////////////////////
/// END OF LAB
////////////////////////////////////////////////////////
module tb();

  parameter N = 8;

  logic [N-1:0] o_data;
  logic o_ready;
  logic o_ack;

  logic [N-1:0] i_addr;
  logic [N-1:0] i_data;
  logic i_we;
  logic i_start;

  logic clk;
  logic rstn;


  //DUT Instance
  full_adder #( .N(N)) DUT (
    .o_data(o_data),
    .o_ready(o_ready),
    .o_ack(o_ack),

    .i_addr(i_addr),
    .i_data(i_data),
    .i_we(i_we),
    .i_start(i_start),

    .i_clk(clk),
    .i_rstn(rstn)
  );

  lab_prog test(
    .data_out(o_data),
    .ready(o_ready),
    .ack(o_ack),

    .addr(i_addr),
    .data_in(i_data),
    .we(i_we),
    .start(i_start),

    .clk(clk),
    .rstn(rstn)
  );

  initial begin
      clk = 0;
  end

  initial begin 
      rstn = 0;
      #10;
      rstn = 1;
  end

  //Clock generation
  always begin
      #5 clk <= ~clk;
  end
    

endmodule
