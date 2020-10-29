
/*
/// Simple Model that just send some SENT frames to check the VIP
module apb2wb_bridge(
// WB signals
  output clk,
  output cyc,
  output stb, 
  output we,
  output addr, 
  output data_o,
  output sel, 
  input data_i,
  input ack, 
  input err,
// APB Signals
  input PCLK,
  input PRESETn,
  input PADDR,
  input PPROT,
  input PSEL,
  input PENACLE,
  input PWRITE,
  input PWDATA,
  input PSTRB,
  output PREADY,
  output PRDATA,
  output PSLVERR
  );

  
  wire                       clk;
  wire                       cyc;
  wire                       stb;
  wire                       we;
  wire [`ADDR_WB_WIDTH]      addr;
  wire [`DATA_WB_WIDTH]      data_o;
  wire [`DATA_WB_WIDTH]      data_i;
  wire [`DATA_WB_WIDTH / 8]  sel;
  wire                       ack;
  wire                       err;
  
  wire                       PCLK;
  wire [`ADDR_APB_WIDTH]     PADDR;
  wire                       PPROT;
  wire                       PSEL;
  wire                       PENACLE;
  wire                       PWRITE;
  wire [`DATA_APB_WIDTH]     PWDATA;
  wire [`DATA_APB_WIDTH / 8] PSTRB;
  wire                       PREADY;
  wire [`DATA_APB_WIDTH]     PRDATA;
  wire                       PSLVERR;
  
  wire                       PRESETn;
  
  
  assign clk       =  PCLK   ;
  assign cyc       =  PSEL   ;
  assign stb       =  PENABLE;
  assign we        =  PWRITE ;
  assign addr      =  PADDR  ;
  assign data_o    =  PWDATA ;
  assign sel       =  PSTRB  ;
  assign PRDATA    =  data_i ;
  assign PREADY    =  ack    ;
  assign PSLVERR   =  err    ;
  



endmodule
*/