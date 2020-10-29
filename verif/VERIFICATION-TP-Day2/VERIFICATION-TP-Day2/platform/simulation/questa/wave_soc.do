onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/u_system/u_amber/u_fetch/i_clk
add wave -noupdate /tb/u_system/u_amber/u_fetch/i_address
add wave -noupdate /tb/u_system/u_amber/u_fetch/i_address_nxt
add wave -noupdate /tb/u_system/u_amber/u_fetch/o_fetch_stall
add wave -noupdate /tb/u_system/u_amber/u_fetch/i_system_rdy
add wave -noupdate /tb/u_system/u_amber/imm32
add wave -noupdate /tb/u_system/u_amber/o_wb_adr
add wave -noupdate /tb/u_system/u_amber/o_wb_sel
add wave -noupdate /tb/u_system/u_amber/o_wb_we
add wave -noupdate /tb/u_system/u_amber/i_wb_dat
add wave -noupdate /tb/u_system/u_amber/o_wb_dat
add wave -noupdate /tb/u_system/u_amber/o_wb_cyc
add wave -noupdate /tb/u_system/u_amber/o_wb_stb
add wave -noupdate /tb/u_system/u_amber/i_wb_ack
add wave -noupdate /tb/u_system/u_amber/i_wb_err
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r0
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r1
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r2
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r3
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r4
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r5
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r6
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r7
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r8
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r9
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r10
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r11
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r12
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r13
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r14
add wave -noupdate /tb/u_system/u_amber/u_execute/u_register_bank/r15
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_clk
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_wb_adr
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_wb_sel
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_wb_we
add wave -noupdate -group UART0 /tb/u_system/u_uart0/o_wb_dat
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_wb_dat
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_wb_cyc
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_wb_stb
add wave -noupdate -group UART0 /tb/u_system/u_uart0/o_wb_ack
add wave -noupdate -group UART0 /tb/u_system/u_uart0/o_wb_err
add wave -noupdate -group UART0 /tb/u_system/u_uart0/o_uart_int
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_uart_cts_n
add wave -noupdate -group UART0 /tb/u_system/u_uart0/o_uart_txd
add wave -noupdate -group UART0 /tb/u_system/u_uart0/o_uart_rts_n
add wave -noupdate -group UART0 /tb/u_system/u_uart0/i_uart_rxd
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_clk_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_rst_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_adr_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_dat_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_dat_o
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_we_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_stb_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_cyc_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_sel_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/wb_ack_o
add wave -noupdate -group UART1 /tb/u_system/u_uart1/int_o
add wave -noupdate -group UART1 /tb/u_system/u_uart1/srx_pad_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/stx_pad_o
add wave -noupdate -group UART1 /tb/u_system/u_uart1/rts_pad_o
add wave -noupdate -group UART1 /tb/u_system/u_uart1/cts_pad_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/dtr_pad_o
add wave -noupdate -group UART1 /tb/u_system/u_uart1/dsr_pad_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/ri_pad_i
add wave -noupdate -group UART1 /tb/u_system/u_uart1/dcd_pad_i
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/ier
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/iir
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/fcr
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/mcr
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/lcr
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/msr
add wave -noupdate -group {UART Reg Values} /tb/u_system/u_uart1/regs/lsr
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_clk
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_mem_ctrl
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_wb_adr
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_wb_cyc
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_wb_dat
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_wb_sel
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_wb_stb
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/i_wb_we
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/o_wb_ack
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/o_wb_dat
add wave -noupdate -group {MEM WB I/F} /tb/u_system/u_main_mem/o_wb_err
add wave -noupdate /tb/msg_if0/clk
add wave -noupdate /tb/msg_if0/data
add wave -noupdate /tb/msg_if0/en
add wave -noupdate /tb/msg_if0/msg
add wave -noupdate /tb/uartif0/tx/sig_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {518112059 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 285
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {768601486 ps} {776137724 ps}
