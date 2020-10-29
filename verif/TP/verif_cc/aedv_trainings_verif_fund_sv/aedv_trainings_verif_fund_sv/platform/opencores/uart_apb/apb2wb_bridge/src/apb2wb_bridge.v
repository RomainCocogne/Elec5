
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
  input  [`DATA_WB_WIDTH -1:0      ] data_i     ,
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
  output [`DATA_APB_WIDTH -1 :0    ] PRDATA     ,
  output                             PSLVERR
  );
  
  assign clk       =  PCLK   ;
  assign rst       =  ~PRESETn;
  assign cyc       =  PSEL   ;
  assign stb       =  PENABLE;
  assign we        =  PWRITE ;
  assign addr      =  PADDR  ;
  
  assign data_o    =  PWDATA ;
  assign sel       =  PSTRB !== 0 ? PSTRB : ( 1 << (addr[1:0]) ) ;
  //`else
  //  // reverse endianness
  //assign data_o[31:24]  =  PWDATA[7:0] ;
  //assign data_o[23:16]  =  PWDATA[15:8] ;
  //assign data_o[15:8]   =  PWDATA[23:16] ;
  //assign data_o[7:0]    =  PWDATA[31:24] ;
//
  //assign sel[0]         = (PWRITE == 'b1 ?  PSTRB[3]: ((~addr[1]) &  (~addr[0])));
  //assign sel[1]         = (PWRITE == 'b1 ?  PSTRB[2]: (  addr[1]  &  (~addr[0])));
  //assign sel[2]         = (PWRITE == 'b1 ?  PSTRB[1]: ((~addr[1]) &    addr[0]));
  //assign sel[3]         = (PWRITE == 'b1 ?  PSTRB[0]: (  addr[1]  &    addr[0]));
  // 
  //`endif
  
  assign PRDATA    =  data_i ;
  assign PREADY    =  ack    ;
  assign PSLVERR   =  err    ;

endmodule
