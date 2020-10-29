
// TODO: should be design specific defines
`include "apb2wb_bridge_defines.svh"

module uart_apb(
    // APB Signals
    input                              PCLK_i       ,
    input                              PRESETn_i    ,
    input  [`ADDR_APB_WIDTH -1 :0   ]  PADDR_i      ,
    input                              PPROT_i      ,
    input                              PSEL_i       ,
    input                              PENABLE_i    ,
    input                              PWRITE_i     ,
    input  [`DATA_APB_WIDTH -1 :0    ] PWDATA_i     ,
    input  [`DATA_APB_WIDTH / 8 -1 :0] PSTRB_i      ,
    output                             PREADY_o     ,
    output [`DATA_APB_WIDTH : 0      ] PRDATA_o     ,
    output                             PSLVERR_o    ,
    // Serial Signals
    input                              rx_i ,
    output                             tx_o ,
    output                             int_o
    );
  
  wire            wb_clk        ;
  wire            wb_cyc        ;
  wire            wb_rst        ;
  wire            wb_stb        ;
  wire            wb_we         ;
  wire [31: 0]    wb_addr       ;
  wire [31: 0]    wb_data_wr    ;
  wire [ 3: 0]    wb_sel        ; 
  wire [31: 0]    wb_data_rd    ;
  wire            wb_ack        ;
  wire            wb_err        ;  

  apb2wb_bridge apb2wb_bridge_inst(
      // .APB Signals
      .PCLK        ( PCLK_i    ) ,
      .PRESETn     ( PRESETn_i ) ,
      .PADDR       ( PADDR_i   ) ,
      .PPROT       ( PPROT_i   ) ,
      .PSEL        ( PSEL_i    ) , 
      .PWRITE      ( PWRITE_i  ) ,
      .PWDATA      ( PWDATA_i  ) ,
      .PSTRB       ( PSTRB_i   ) ,
      .PREADY      ( PREADY_o  ) ,
      .PRDATA      ( PRDATA_o  ) ,
      .PSLVERR     ( PSLVERR_o ) ,
      .PENABLE     ( PENABLE_i ) ,
      // WB signals
      .clk         ( wb_clk        ) , 
      .cyc         ( wb_cyc        ) , 
      .rst         ( wb_rst        ) ,
      .stb         ( wb_stb        ) , 
      .we          ( wb_we         ) , 
      .addr        ( wb_addr       ) , 
      .data_o      ( wb_data_wr    ) , 
      .sel         ( wb_sel        ) ,
      .data_i      ( wb_data_rd    ) , 
      .ack         ( wb_ack        ) , 
      .err         ( wb_err        ) 
    );

  
  // Design Instance  
  uart_top uart0  (
      .wb_clk_i   ( wb_clk        ), 
      .wb_rst_i   ( wb_rst        ), 
      .wb_adr_i   ( wb_addr       ), // 1 register each 4 address // TODO
      .wb_dat_i   ( wb_data_wr    ), 
      .wb_dat_o   ( wb_data_rd    ), 
      .wb_we_i    ( wb_we         ), 
      .wb_stb_i   ( wb_stb        ), 
      .wb_cyc_i   ( wb_cyc        ), 
      .wb_ack_o   ( wb_ack        ), 
      .wb_sel_i   ( wb_sel        ),
      .wb_err_o   ( wb_err        ),
      .int_o      ( int_o         ), 
      .stx_pad_o  ( tx_o          ), 
      .srx_pad_i  ( rx_i          ), 
      // Modem signals
      .rts_pad_o  (               ), // open
      .cts_pad_i  (1'b0           ),
      .dtr_pad_o  (               ), // open
      .dsr_pad_i  (1'b0           ),
      .ri_pad_i   (1'b0           ), 
      .dcd_pad_i  (               )  // open
      `ifdef UART_HAS_BAUDRATE_OUTPUT
        , baud_o ()
      `endif
    );
  
    
  
endmodule
