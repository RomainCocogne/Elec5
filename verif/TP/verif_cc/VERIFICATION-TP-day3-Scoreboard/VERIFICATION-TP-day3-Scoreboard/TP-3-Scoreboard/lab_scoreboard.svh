


//---------------------------------------------------------------------
/// LAB-TODO-STEP-2-a - uncomment to declare the classes uvm_analysis_imp_apb and uvm_analysis_imp_tx_frame
`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_tx_frame)



class lab_scoreboard extends uvm_component;
  `uvm_component_utils(lab_scoreboard)
  
  /// UVM analysis port are used to collect transactions from the main monitors
  // lab-TODO-STEP-2-b: 
  uvm_analysis_imp_apb          #(apb_transfer         , lab_scoreboard) apb_import;
  uvm_analysis_imp_tx_frame     #(uart_frame           , lab_scoreboard) tx_frame_import;
  
  bit  scoreboard_enable = 0;
  int nframe = 0;


  logic divider_lat_accessible = 0;
   
  
  function new(string name="lab_scoreboard",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  
  function void build_phase(uvm_phase phase);
    // LAB-TODO-STEP-2-c:  Instantiate/Build the TWO analysis implementation classes
    apb_import = new("apb_import",this);
    tx_frame_import = new("tx_frame_import", this);

  endfunction

  function void do_nothing();
  endfunction

   byte data_to_check ;
   byte mask;

  function void write_apb(apb_transfer trans);
  
    // Utils metrix
    apb_data_t     shifted_data = (trans.data >>  8*log2(trans.strobe));
    apb_address_t  act_address  = trans.address +log2(trans.strobe);
    shifted_data                = shifted_data &  8'hFF;
    
    // LAB-TODO-STEP-2-d - breakpoint / ensure enter in this function whenever a APB transfer is received

    // LAB-TODO-STEP-3-a
    // scoreboard_enable value management  
    // LAB-TODO-STEP-3-a: If "trans" is a write to tx FIFO register address, push data to the rx data scoreboard    
    /*
    if (trans.address == `UART_LCR) begin
      if ((trans.data & (32'h0 | (`UART_LCR_DLAB << ((`UART_LCR%4)*8)))) == (32'h0 | (`UART_LCR_DLAB << ((`UART_LCR%4)*8)))) begin
        divider_lat_accessible = 1;
      end
      else begin
        divider_lat_accessible = 0;
      end
    end*/
    if ( trans.address == `UART_LCR )
    begin 
       case ( shifted_data[1:0] )
            0 : mask = 'h1f;
            1 : mask = 'h3f;
            2 : mask = 'h7f;
            3 : mask = 'hFf;
       endcase
    end

    // LAB-TODO-STEP-4 - Store TX data into a variable of the current class
    // if the transaction is a write to `UART_TX_RX_OR_DIVISOR_LSB, and DL7 is 0, then the data is pushed to the TX
    if ( trans.address == 0 ) 
       data_to_check = shifted_data & mask ;

  endfunction // write_apb

  
  
  // record tx frame
  function void write_tx_frame(uart_frame txf);
    // LAB-TODO-STEP-3-b
    `uvm_info("SCOREBOARD", $psprintf("UART TX sent: \n%s",txf.sprint()), UVM_NONE)
     if ( txf.data != data_to_check ) `uvm_error("SCBD",$sformatf("Not good %x != %x",txf.data , data_to_check));
  endfunction // write_tx_frame

  


endclass

