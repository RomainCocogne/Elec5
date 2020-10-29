
## Default test mode value
## Uncomment and set value accordingly
##        0 - C tests for SoC
##        1 - UVM Headless for SoC
##        2 - UART UVM
##        3 - Verilog
set ::testmode 3


proc aed_setup {} {
	global AEDV_ENV
	global AMBERSOC_HOME
	global AEDV_ENV
	global AMBER_BASE
	global ARCH
	global CODESOURCERY 
	global DIRUTILS 
	global SIMULATOR
	global TOP_WM

	set TOP_WM .top
	set SIMULATOR questasim
	if { ! [info exists AEDV_ENV]  } {
		puts "settings up directory variables"
		set simdir [pwd]
		cd ../../platform
		set AMBERSOC_HOME [pwd]
		cd $simdir
		set AEDV_ENV $AMBERSOC_HOME/aedvices	
	}
	if { ! [info exists AMBERSOC_HOME]  } {
		set AMBERSOC_HOME $AEDV_ENV/..	
	}

	# TODO: use if info exists for all of these
	set AMBER_BASE $AMBERSOC_HOME/opencores/amber
	set ARCH [string tolower $::tcl_platform(os)]
	if { [string tolower $::tcl_platform(os)] != "linux" } {
		set ARCH windows
	}
	set CODESOURCERY $AMBERSOC_HOME/tools/codesourcery/$ARCH
	set DIRUTILS $AMBERSOC_HOME/tools/utils/$ARCH
}




aed_setup
echo "ARCH = $ARCH"
source $AEDV_ENV/tcl/aedv.tcl
aed_sim_main


