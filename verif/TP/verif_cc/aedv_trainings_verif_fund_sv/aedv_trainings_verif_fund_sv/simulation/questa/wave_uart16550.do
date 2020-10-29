onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Interrupt /uart_tb/uart0/int_o
add wave -noupdate -expand -group {Serial Tx/Rx} /uart_tb/uart0/rx_i
add wave -noupdate -expand -group {Serial Tx/Rx} /uart_tb/uart0/tx_o
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PCLK
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PRESETn
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PADDR
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PSEL
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PENABLE
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PWRITE
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PWDATA
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PREADY
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PRDATA
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PSLVERR
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PSTRB
add wave -noupdate -expand -group {APB I/F} /uart_tb/apbif0/PPROT
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/ier
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/iir
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/fcr
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/mcr
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/lcr
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/msr
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/lsr
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/dl
add wave -noupdate -expand -group {UART Internal Signals} /uart_tb/uart0/uart0/regs/dlab
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {TX FIFO} /uart_tb/uart0/uart0/regs/transmitter/fifo_tx/push
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {TX FIFO} /uart_tb/uart0/uart0/regs/transmitter/fifo_tx/pop
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {TX FIFO} /uart_tb/uart0/uart0/regs/transmitter/fifo_tx/overrun
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {TX FIFO} /uart_tb/uart0/uart0/regs/transmitter/fifo_tx/count
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {TX FIFO} /uart_tb/uart0/uart0/regs/transmitter/fifo_tx/tfifo/ram
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {RX FIFO} /uart_tb/uart0/uart0/regs/receiver/fifo_rx/push
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {RX FIFO} /uart_tb/uart0/uart0/regs/receiver/fifo_rx/pop
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {RX FIFO} /uart_tb/uart0/uart0/regs/receiver/fifo_rx/overrun
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {RX FIFO} /uart_tb/uart0/uart0/regs/receiver/fifo_rx/count
add wave -noupdate -expand -group {UART Internal Signals} -expand -group {RX FIFO} /uart_tb/uart0/uart0/regs/receiver/fifo_rx/rfifo/ram
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3707800 ps} 0}
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
WaveRestoreZoom {0 ps} {14118400 ps}
