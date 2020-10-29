// ===============================================================================
//                    Copyright (c) 2015 - AEDVICES Consulting
// ===============================================================================
// This material is provided as part of the training from AEDVICES Consulting,
// The directory "opencores" contains open source codes from opencores.org
// Other directories contains files and data developped by AEDVICES Consulting for 
// training purposes.  
// Personal copy is limited to training attendants.
// Copy and duplication other than in the context of the training is not allowed.
// ===============================================================================
// Copyright (c) 2016-2017 - AEDVICES Consulting 
// 39 Montee du Chatenay - 38690 Oyeu - France
// www.aedvices.com/vip
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
// Version Management Info (SVN)
// $Id: terminal_bench.sv 305 2017-09-12 17:04:24Z francois $
// $Author: francois $
// $LastChangedDate: 2017-09-12 19:04:24 +0200 (mar., 12 sept. 2017) $
// $Revision: 305 $
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -




module terminal_bench(input stim_clk);
  
  byte stim_data;
  wire stim_req; 


  term_stim stim0(
    .clk(stim_clk),
    .req(stim_req),
    .data(stim_data)
  );


  always @(posedge stim_clk)
  begin
    if ( stim_req === 1 )
      uart_ip_verif_pkg::uart_write(stim_data);
  end



endmodule // terminal_bench