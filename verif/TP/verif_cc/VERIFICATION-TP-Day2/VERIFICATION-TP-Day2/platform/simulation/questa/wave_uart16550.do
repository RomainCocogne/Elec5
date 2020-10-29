onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PADDR_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PCLK_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PENABLE_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PPROT_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PRDATA_o
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PREADY_o
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PRESETn_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PSEL_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PSLVERR_o
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PSTRB_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PWDATA_i
add wave -noupdate -expand -group {APB I/F} /uart_tb/uart0/PWRITE_i
add wave -noupdate -expand -group {Serial Tx/Rx} /uart_tb/uart0/rx_i
add wave -noupdate -expand -group {Serial Tx/Rx} /uart_tb/uart0/tx_o
add wave -noupdate -expand -group Interrupt /uart_tb/uart0/int_o
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/dl
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/dsr
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/enable
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/fcr
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/ier
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/iir
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/lcr
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/lsr
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/mcr
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/msr
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/rf_count
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/rstate
add wave -noupdate -expand -group Internal /uart_tb/uart0/uart0/regs/tstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {175100 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {1595500 ps}
