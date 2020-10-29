
# NC-Sim Command File
# TOOL:	ncsim(64)	13.20-s010
#
#
# You can restore this configuration with:
#
#      irun +incdir+../../opencores/amber/hw/vlog/lib +incdir+../../opencores/amber/hw/vlog/system +incdir+../../opencores/amber/hw/vlog/amber23 +incdir+../../opencores/amber/hw/vlog/tb +incdir+../../opencores/amber/hw/vlog/ethmac +incdir+../../aedvices/socv -define BOOT_MEM_FILE="obj/boot-loader-serial.mem" -define MAIN_MEM_FILE="obj/lab.mem" -define AMBER_LOAD_MAIN_MEM=1 -define AMBER_LOG_FILE="tests.log" -define AMBER_TIMEOUT=0 -define AMBER_SIM_CTRL=4 -define AMBER_TEST_NAME="lab" -f filelist.txt ../../opencores/amber/hw/vlog/tb/tb.v -timescale 1ns/10ps -top tb -licqueue -64 -input cmd.txt -access +rwc +acc -input restore.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
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
set svseed 1
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves tb -all -depth all -waveform
probe -create -database waves tb.u_system.m_wb_adr tb.u_system.m_wb_dat_r tb.u_system.m_wb_dat_w tb.u_system.m_wb_sel tb.u_system.s_wb_adr tb.u_system.s_wb_dat_r tb.u_system.s_wb_dat_w tb.u_system.s_wb_sel

simvision -input restore.tcl.svcf
