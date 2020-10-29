`uvm_analysis_imp_decl(_uart_frame)
`uvm_analysis_imp_decl(_input_frame)

class my_uart_scoreboard extends uvm_component;
  `uvm_component_utils(my_uart_scoreboard)
  
  uvm_analysis_imp_uart_frame     #(uart_frame        , my_uart_scoreboard)  uart_imp     ;
  uvm_analysis_imp_input_frame    #(uart_frame        , my_uart_scoreboard)  expected_imp ;
  
  
  byte expected_fifo[$] ;
  
  
  
  // Constructor 
  function new(string name="",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  
  // Build all analysis port 
  function void build_phase(uvm_phase phase);
    uart_imp      = new("uart_imp"     , this);
    expected_imp  = new("expected_imp" , this);
  endfunction
  
  function write_uart_frame( uart_frame rxf);
    byte expected;
    // get data and compare with expected 
    `uvm_warning("SCBD",$sformatf(" Received an UART frame with data : %d ",rxf.data ))
  
    if( expected_fifo.size() !=0 )
    begin
      // Pop data from fifo and compute expected
      expected = expected_fifo.pop_back();
      
      //expected = compute( expected );   //Expected is already in frame, no need to compute it
      // Compare expected to the current transaction data 
      if ( expected != rxf.data )
      begin
      // Value is deferent from expected so we issue a uvm_error
      `uvm_error("DATA_MISMATCH",$sformatf(" Value is different from expected : \n Expected data : %d   \n Actual data : %d ", expected, rxf.data ))
      end
  
    end
    else
      `uvm_error("UNEXPECTED_FRAME","Received an unexpected UART frame from UART1 ")
  
  endfunction
  
  // Function write_input_frame, called each time a transaction is pushed in uart_imp port
  function write_input_frame( uart_frame exf);
    expected_fifo.push_front( exf.data);
  endfunction
  
  
  
  // Function used to compute expected data from the data sent by the UART VIP  - Should be the same that is implemented in the C code
  function byte compute( byte data );
    return data + 10;
  endfunction 
  
endclass // my_uart_scoreboard