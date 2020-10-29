
# XM-Sim Command File
# TOOL:	xmsim(64)	18.09-s003
#
#
# You can restore this configuration with:
#
#      xrun -access rwc -top uart_tb +define+IMPORT_LAB_PKG -top lab_test_pkg -timescale 1ns/10ps -seed 3 +UVM_TESTNAME=lab_test -input APB_UART_WAVE.tcl -input /local/work_raid/aedvices/adahil/Platforms/Verification2/simulation/ius/APB_UART_WAVE.tcl
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 3
set assert_reporting_mode 0
database -open -shm -into waves.shm waves -default
probe -create -database waves uart_tb.uart0.PADDR_i uart_tb.uart0.PCLK_i uart_tb.uart0.PENABLE_i uart_tb.uart0.PPROT_i uart_tb.uart0.PRDATA_o uart_tb.uart0.PREADY_o uart_tb.uart0.PRESETn_i uart_tb.uart0.PSEL_i uart_tb.uart0.PSLVERR_o uart_tb.uart0.PSTRB_i uart_tb.uart0.PWDATA_i uart_tb.uart0.PWRITE_i uart_tb.uart0.rx_i uart_tb.uart0.tx_o uart_tb.uart0.uart0.regs.ier uart_tb.uart0.uart0.regs.iir uart_tb.uart0.uart0.regs.lcr uart_tb.uart0.uart0.regs.lsr uart_tb.uart0.uart0.regs.mcr uart_tb.uart0.uart0.regs.msr uart_tb.uart0.uart0.regs.fcr uart_tb.uart0.uart0.regs.dl uart_tb.uart0.uart0.regs.dlab uart_tb.uart0.uart0.regs.transmitter.fifo_tx.tfifo.ram uart_tb.uart0.uart0.regs.transmitter.fifo_tx.count uart_tb.uart0.uart0.regs.transmitter.fifo_tx.overrun uart_tb.uart0.uart0.regs.transmitter.fifo_tx.push uart_tb.uart0.uart0.regs.transmitter.fifo_tx.pop uart_tb.uart0.uart0.regs.receiver.fifo_rx.push uart_tb.uart0.uart0.regs.receiver.fifo_rx.pop uart_tb.uart0.uart0.regs.receiver.fifo_rx.overrun uart_tb.uart0.uart0.regs.receiver.fifo_rx.count uart_tb.uart0.uart0.regs.receiver.fifo_rx.rfifo.ram

simvision -input APB_UART_WAVE.tcl.svcf
