
`include "apb2wb_bridge_defines.svh"
/// Simple Model that just send some SENT frames to check the VIP
module apb2wb_bridge(
// WB signals
  output                             clk        ,
  output                             rst        ,
  output                             cyc        ,
  output                             stb        , 
  output                             we         ,
  output [`ADDR_WB_WIDTH -1:0      ] addr       , 
  output [`DATA_WB_WIDTH -1:0      ] data_o     ,
  output [`DATA_WB_WIDTH / 8 -1:0  ] sel        , 
  input  [`DATA_WB_WIDTH-1:0       ] data_i     ,
  input                              ack        , 
  input                              err        ,
  // APB Signals
  input                              PCLK       ,
  input                              PRESETn    ,
  input  [`ADDR_APB_WIDTH -1 :0   ]  PADDR      ,
  input                              PPROT      ,
  input                              PSEL       ,
  input                              PENABLE    ,
  input                              PWRITE     ,
  input  [`DATA_APB_WIDTH -1 :0    ] PWDATA     ,
  input  [`DATA_APB_WIDTH / 8 -1 :0] PSTRB      ,
  output                             PREADY     ,
  output [`DATA_APB_WIDTH : 0      ] PRDATA     ,
  output                             PSLVERR
  );

  //reg [`DATA_WB_WIDTH / 8 -1: 0] sel_intern;
  //
  //initial
  //begin
  //  forever begin
  //  @(posedge PCLK);
  //    if( PENABLE )
  //    begin
  //      if( PWRITE == 0)
  //        sel_intern <= 4'b1111;
  //      else
  //        sel_intern <= PSTRB;    
  //    end// end if PENABLE
  //  end // end forever
  //end// end initial
  
  
  
  assign clk       =  PCLK   ;
  assign rst       =  ~PRESETn;
  assign cyc       =  PSEL   ;
  assign stb       =  PENABLE;
  assign we        =  PWRITE ;
  assign addr      =  PADDR  ;
  `ifdef NOT_DEFINED
  assign data_o    =  PWDATA ;
  assign sel       =  PSTRB;
  `else
    // reverse endianness
  assign data_o[31:24]  =  PWDATA[7:0] ;
  assign data_o[23:16]  =  PWDATA[15:8] ;
  assign data_o[15:8]   =  PWDATA[23:16] ;
  assign data_o[7:0]    =  PWDATA[31:24] ;

  assign sel[3]         = (PWRITE == 'b1 ?  PSTRB[0]: (  addr[1]  &    addr[0]));
  assign sel[0]         = (PWRITE == 'b1 ?  PSTRB[3]: ((~addr[1]) &  (~addr[0])));
  assign sel[1]         = (PWRITE == 'b1 ?  PSTRB[2]: (  addr[1]  &  (~addr[0])));
  assign sel[2]         = (PWRITE == 'b1 ?  PSTRB[1]: ((~addr[1]) &    addr[0]));

  // assign sel[3]      =  PSTRB[0];
  // assign sel[0]      =  PSTRB[3];
  // assign sel[1]      =  PSTRB[2];
  // assign sel[2]      =  PSTRB[1];
   
  `endif
  
  assign PRDATA    =  { data_i[7:0] , data_i[15:8] , data_i[23:16] , data_i[31:24] } ;
  assign PREADY    =  ack    ;
  assign PSLVERR   =  err    ;
  



endmodule
