


proc aed_uart_uvm_compile_rtl {{testarg ""}} {
    global AMBERSOC_HOME
    global PUTS
    if { ! [file exists work] } {
    	vlib work
    }
    $PUTS "========================"
    $PUTS "Compiling RTL"
    $PUTS "========================"

    set DEFINES ""
    #set DEFINES +define+AED_NO_BUG

    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/raminfr.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_top.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_debug_if.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_receiver.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_regs.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_rfifo.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_sync_flops.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_tfifo.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_transmitter.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl $AMBERSOC_HOME/opencores/uart16550/rtl/uart_wb.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/aedvices/design/apb2wb_bridge $AMBERSOC_HOME/aedvices/design/apb2wb_bridge/apb2wb_bridge.v"
    aed_cmd "vlog +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps ${DEFINES} +incdir+$AMBERSOC_HOME/aedvices/design/apb2wb_bridge $AMBERSOC_HOME/aedvices/design//uart_apb//uart_apb.v"
}


proc aed_uart_uvm_compile_tb {{testarg ""}} {
	global AMBERSOC_HOME
	global PUTS

  # Get filename
  if { $testarg eq "" } {
    set filename $::testname
    set seed     $::seed
  } else {
    set filename $testarg
    set seed 1
  }

  # Get the testname 
  # Assume the testname is the filename without extension
  set testdir  [file dirname $filename]
  set shortfilename [file tail $filename]

  if { $shortfilename eq "" } {
    set testname "uart_ip_verif_base_test"
    set packagename "uart_ip_verif_pkg" 
    set DEFINES ""
  } else {
    set testname "[file root $shortfilename]_test"
    set packagename "[file root $shortfilename]_pkg" 
    set DEFINES "+define+IMPORT_LAB_PKG"
  }

  set TOPDIR [file normalize ${filename}/..]
	$PUTS "========================"
	$PUTS "Compiling Testbench"
	$PUTS "========================"

  set INCDIR ""
  set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/vip/apb/src/sv"
  set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv"
  set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/opencores/uart16550/rtl"
  set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/uart_tb"
  set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/registers/ids"
  set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/design/apb2wb_bridge"

  set TOP_FILES ""
  set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/vip/uart/src/sv/aed_uart_pkg.sv"
  set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/vip/apb/src/sv/aed_apb_pkg.sv"
  set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/design/apb2wb_bridge/apb2wb_pkg.sv"
  set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_verif_pkg.sv"
  set TOP_FILES "${TOP_FILES} $filename"

  if { [file exists "${testdir}/uart_ip_tb.sv"] } {
    set TOP_FILES "${TOP_FILES} ${testdir}/uart_ip_tb.sv"
  } else {
    set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_tb.sv"
  }

  $PUTS "${testdir}/uart_ip_tb.sv"
  aed_cmd "vlog +acc=mnprt -work work -timescale 1ns/10ps ${INCDIR} ${DEFINES} ${TOP_FILES}"
}

proc aed_uart_uvm_compile_test {{testarg ""}} {
	global AMBERSOC_HOME
	global UVM_TEST
	global PUTS

	# Get testname
  if { $testarg eq "" } {
    set filename $::testname
  } else {
    set filename $testarg
  }

	$PUTS "Nothing to be done. Tests are compiled as part of the testbench"

}

proc aed_uart_uvm_load_sim {{testarg ""}} {
	global PUTS 

	# Get filename
  if { $testarg eq "" } {
    set filename $::testname
    set seed     $::seed
  } else {
    set filename $testarg
    set seed 1
  }

	# Get the testname 
	# Assume the testname is the filename without extension
	set testdir  [file dirname $filename]
	set shortfilename [file tail $filename]

  if { $shortfilename eq "" } {
    set testname "uart_ip_verif_base_test"
    set packagename "uart_ip_verif_pkg" 
    set DEFINES ""
  } else {
    set testname "[file root $shortfilename]_test"
    set packagename "[file root $shortfilename]_test_pkg" 
    set DEFINES "+define+IMPORT_LAB_PKG"
  }


    aed_cmd "vsim -t 100ps -coverage -msgmode both -uvmcontrol=all -classdebug -solvefaildebug=2 uart_tb ${DEFINES} $packagename +UVM_TESTNAME=${testname} -sv_seed $seed"

	do wave_uart16550.do
	# TODO: GUI should show test name, seed.

}
