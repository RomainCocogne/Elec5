
## Default test mode value
## Uncomment and set value accordingly
##        0 - C tests for SoC
##        1 - UVM Headless for SoC
##        2 - UART UVM
##        3 - Verilog
set ::testmode 3


proc echo { arg } {
    puts $arg
}


proc aed_setup {} {
	global AEDV_ENV
	global AMBERSOC_HOME
	global AEDV_ENV
	global AMBER_BASE
	global ARCH
	global CODESOURCERY 
	global DIRUTILS 

	#global SIMULATOR 

	#set SIMULATOR xcelium

	global SIMULATOR
	global TOP_WM
	global EXEC_CMD

	set SIMULATOR ncsim
	set TOP_WM ""
	set EXEC_CMD "exec -keepnewline --"

	if { ! [info exists AEDV_ENV]  } {
		puts "settings up directory variables"
		set simdir [pwd]
		cd ../../platform
		set AMBERSOC_HOME [pwd]
		cd $simdir
	
	}

	# TODO: use if info exists for all of these
	set AEDV_ENV $AMBERSOC_HOME/aedvices
	set AMBER_BASE $AMBERSOC_HOME/opencores/amber
	set ARCH [string tolower $::tcl_platform(os)]
	if { [string tolower $::tcl_platform(os)] != "linux" } {
		set ARCH windows
	}
	set CODESOURCERY $AMBERSOC_HOME/tools/codesourcery/$ARCH
	set DIRUTILS $AMBERSOC_HOME/tools/utils/$ARCH

	#Files to be compiled
	source ${AEDV_ENV}/tcl/aedv_filelist_uart_apb.tcl
	source ${AEDV_ENV}/tcl/aedv_filelist_uart_uvm_tb.tcl


}



aed_setup

#puts "ARCH = $ARCH"
#source $AEDV_ENV/tcl/aedv.tcl
#aed_sim_main
#source run_test.tcl

echo "ARCH = $ARCH"
source $AEDV_ENV/tcl/aedv.tcl
aed_sim_main
