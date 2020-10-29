# AEDVICES Consulting (c) 2014
# contact@aedvices.com
#---------------------------------
# $Id$
#
# Description: 
#    Main TCL environment for Amber SoC platform



source $AEDV_ENV/tcl/aedv_setup.tcl
source $AEDV_ENV/tcl/aedv_sv_standalone.tcl
source $AEDV_ENV/tcl/aedv_uart_uvm.tcl
source $AEDV_ENV/tcl/aedv_soc.tcl
source $AEDV_ENV/tcl/aedv_soc_uvm.tcl
source $AEDV_ENV/tcl/aedv_trek_soc.tcl

global GUI

set GUI 0

if { ! [info exists ::testmode] } {
	set ::testmode 0
}

if { ! [info exists ::testname] } {
	set ::testname ""
}

if { ! [info exists ::seed] } {
  set ::seed 3
}

proc aed_gui {} {
	global GUI
	global TOP_WM
	global SIMULATOR

	set GUI 1
	set count 0
	set gui_title "Verification Lab - Main GUI - AEDVICES Consulting"
	if { [wm title .] == $gui_title } {
		wm withdraw .
		set strResourePath "."
	} else { 
		set strResourePath "."
	}

	set count 0
	set wm_width  750
	set wm_height 320
	set wm_txt_margin [expr 10 * 8]
	set wm_btn_margin [expr $wm_txt_margin + 20 * 8 + 10]
	set bt_width 18
	set wm_background lightgrey

	# Top level window
	if { ${TOP_WM} == ".top" } {
	    set TOP .top

        if { [catch {
            toplevel ${TOP} -class toplevel
        } err] } {
            aed_close_form
            toplevel ${TOP} -class toplevel
        }
    } else {
        set TOP .
    }




	wm title ${TOP} $gui_title
	wm geometry ${TOP} ${wm_width}x${wm_height}

	#wm resizable ${TOP} 0 0  # Not resizable - TODO uncomment once correct window is drawn
	wm protocol ${TOP} WM_DELETE_WINDOW aed_close_form

	# Main Menu
 	menu ${TOP_WM}.menu -tearoff 0
  	set file ${TOP_WM}.menu.file
	menu $file -tearoff 0
  	${TOP_WM}.menu add cascade -label "File" -menu $file -underline 0
  	#$file add command -label "Save" -command write_user_env_settings -accelerator "Ctrl-S" -underline 0
  	#$file add separator
  	$file add command -label "Close" -command aed_close_form -accelerator "Ctrl-W" -underline 0
	${TOP} configure -menu ${TOP_WM}.menu


	# Menu Accelerator
	bind ${TOP} <Control-w> {aed_close_form}

	# Create Form Canvas
	# Flow: C test | UVM
	# Test File:
	# Compile | Run | Show Wave


	frame  ${TOP_WM}.fTest -height [expr $wm_height-20] -width [expr $wm_width-20] -background $wm_background
	place  ${TOP_WM}.fTest -x 10 -y 10

	# Sim mode: "SoC C Test"      "SoC UVM"       "UART UVM"      "Standalone"
	#set count [expr $count+1]
	radiobutton ${TOP_WM}.fTest.rbCTrek -text "TrekSoC C Test" -variable ::testmode -value 4  -background $wm_background
	place       ${TOP_WM}.fTest.rbCTrek -x [expr $wm_btn_margin - 200] -y [expr 10+30*$count]
	radiobutton ${TOP_WM}.fTest.rbCTest -text "SoC C Test" -variable ::testmode -value 0  -background $wm_background
	place       ${TOP_WM}.fTest.rbCTest -x [expr $wm_btn_margin - 65] -y [expr 10+30*$count]
	radiobutton ${TOP_WM}.fTest.rbUVM   -text "SoC UVM" -variable ::testmode -value 1  -background $wm_background
	place       ${TOP_WM}.fTest.rbUVM -x [expr $wm_btn_margin + 60 ] -y [expr 10+30*$count]
	radiobutton ${TOP_WM}.fTest.rbUART   -text "UART UVM" -variable ::testmode -value 2  -background $wm_background
	place       ${TOP_WM}.fTest.rbUART -x [expr $wm_btn_margin+180] -y [expr 10+30*$count]
	radiobutton ${TOP_WM}.fTest.rbVlog   -text "System Verilog" -variable ::testmode -value 3  -background $wm_background
	place       ${TOP_WM}.fTest.rbVlog -x [expr $wm_btn_margin+290] -y [expr 10+30*$count]

	# Filename
	set count [expr $count+1]
	label  ${TOP_WM}.fTest.lbTest -text "Test File" -background $wm_background
	place  ${TOP_WM}.fTest.lbTest -x 10 -y [expr 10+30*$count]
	button ${TOP_WM}.fTest.btTest -text "Browse" -width $bt_width -command {aed_browse_testfile}
	place  ${TOP_WM}.fTest.btTest -x $wm_txt_margin -y [expr 10+30*$count]
	entry  ${TOP_WM}.fTest.enTest -width [expr ($wm_width - $wm_txt_margin) / 10 - $bt_width]
        place  ${TOP_WM}.fTest.enTest -x [expr $wm_btn_margin+$bt_width+20] -y [expr 10+30*$count]

	${TOP_WM}.fTest.enTest delete 0 end
	${TOP_WM}.fTest.enTest insert 0 $::testname

	set count [expr $count+1]


	# Compile RTL
	set count [expr $count+1]
	button ${TOP_WM}.fTest.btCompileRTL -text "Compile RTL" -width $bt_width -command {aed_compile_rtl}
	place  ${TOP_WM}.fTest.btCompileRTL -x $wm_txt_margin -y [expr 10+30*$count]

	# Compile TB
	set count [expr $count+1]
	button ${TOP_WM}.fTest.btCompileTB -text "Compile TB" -width $bt_width -command {aed_compile_tb}
	place  ${TOP_WM}.fTest.btCompileTB -x $wm_txt_margin -y [expr 10+30*$count]

	# Compile Test
	set count [expr $count+1]
	button ${TOP_WM}.fTest.btCompileC -text "Compile Test" -width $bt_width -command {aed_compile_test}
	place  ${TOP_WM}.fTest.btCompileC -x $wm_txt_margin -y [expr 10+30*$count]

	# Load Simulation
	set count [expr $count+1]
	set SIM_SEED $::seed
	button ${TOP_WM}.fTest.btLoadSim -text "Load Simulation" -width $bt_width -command {aed_load_sim}
	place  ${TOP_WM}.fTest.btLoadSim -x $wm_txt_margin -y [expr 10+30*$count]
	label  ${TOP_WM}.fTest.lbSeed -text "Seed" -background $wm_background
        place  ${TOP_WM}.fTest.lbSeed -x [expr $wm_btn_margin+$bt_width+20] -y [expr 10+30*$count]
	entry  ${TOP_WM}.fTest.enSeed -width 5 -textvariable ::seed
	place  ${TOP_WM}.fTest.enSeed -x [expr $wm_btn_margin+$bt_width+20+5*10] -y [expr 10+30*$count]
	${TOP_WM}.fTest.enSeed delete 0 end
	${TOP_WM}.fTest.enSeed insert 0 $SIM_SEED

    if { ${SIMULATOR} == "questasim" } {
        set count [expr $count+1]
        set count [expr $count+1]
        button ${TOP_WM}.fTest.btRunSim -text "run -all" -width $bt_width -command {run -all}
        place  ${TOP_WM}.fTest.btRunSim -x [expr $wm_txt_margin+50] -y [expr 10+30*$count]

        button ${TOP_WM}.fTest.btRestartSim -text "restart -f" -width $bt_width -command {restart -f}
        place  ${TOP_WM}.fTest.btRestartSim -x [expr $wm_txt_margin+250] -y [expr 10+30*$count]

        button ${TOP_WM}.fTest.btCleanWork -text "clean" -width $bt_width -command {aed_clean_sim}
        place  ${TOP_WM}.fTest.btCleanWork -x [expr $wm_txt_margin+450] -y [expr 10+30*$count]

#
#	frame  ${TOP_WM}.test -height 40 -width 500
#	place  ${TOP_WM}.test -x 500 -y 20 -anchor ne
#	button ${TOP_WM}.test.browse -text "browse" -width 10 -height 2 -command {browse}
#	place   ${TOP_WM}.test.browse -x 1 -y 500 -anchor ne
    }

	focus -force ${TOP_WM}
	#tkwait window ${TOP_WM}

}




proc aed_close_form {} {
	global PUTS TOP_WM
	if { ${TOP_WM} == ".top" } {
	    set TOP .top
    } else {
        set TOP .
    }
    foreach ww [winfo children ${TOP}] {
        destroy $ww
    }
    destroy ${TOP}



	$PUTS "Main GUI closed. "
	$PUTS "\tCommands:"
	$PUTS "\t\t'aed_gui'           : Main GUI"
  $PUTS "\t\t'aed_compile_rtl'   : Compile RTL"
  $PUTS "\t\t'aed_compile_tb'    : Compile Test Bench"
  $PUTS "\t\t'aed_compile_test'  : Compile Test"
  $PUTS "\t\t'aed_load_sim'      : Load Simulator"
  $PUTS "\t\t'aed_clean'         : Clean Work directory"

}


proc aed_browse_testfile {} {
	global PUTS TOP_WM

	set types {
      {{Verilog}          {.v .sv }       TEXT}
	    {{C Source Files}   {.c}      			TEXT}
	    {{All Files}        *             			}
	}

	set ::testname [tk_getOpenFile -filetypes $types]
	${TOP_WM}.fTest.enTest delete 0 end
	${TOP_WM}.fTest.enTest insert 0 $::testname

	$PUTS "Test set to $::testname"
	focus -force ${TOP_WM}


}

proc aed_compile_test {} {
    global TOP_WM
	# Check mode
	if { $::testmode == 0 } {
		# SoC C Test
		aed_soc_compile_test
	} elseif { $::testmode == 1 } {
		# SoC UVM
		aed_soc_uvm_compile_test
	} elseif { $::testmode == 2 } {
		# UART UVM
		aed_uart_uvm_compile_test
	} elseif { $::testmode == 3 } {
		# System Verilog
		aed_sv_compile_test
	} elseif { $::testmode == 4 } {
		#TrekSoc C test
		aed_compile_trek_test
	}
	focus -force ${TOP_WM}
}


proc aed_compile_rtl {} {
    global TOP_WM
	# Check mode
	if { $::testmode == 0 } {
		# SoC C Test
		aed_soc_compile_rtl
	} elseif { $::testmode == 1 } {
		# SoC UVM
		aed_soc_uvm_compile_rtl
	} elseif { $::testmode == 2 } {
		# UART UVM
		aed_uart_uvm_compile_rtl
	} elseif { $::testmode == 3 } {
		# UART UVM
		aed_sv_compile_test
	} elseif { $::testmode ==  4 } {

		aed_soc_compile_trek_rtl
	}
	focus -force ${TOP_WM}
}

proc aed_compile_tb {} {
    global TOP_WM
	# Check mode
	if { $::testmode == 0 } {
		# SoC C Test
		aed_soc_compile_tb
	} elseif { $::testmode == 1 } {
		# SoC UVM
		aed_soc_uvm_compile_tb
	} elseif { $::testmode == 2 } {
		# UART UVM
		aed_uart_uvm_compile_tb
	} elseif { $::testmode == 3 } {
		# UART UVM
		aed_sv_compile_test
	} elseif { $::testmode ==  4 } {

		aed_soc_compile_trek_tb
	}
	focus -force ${TOP_WM}
}

proc aed_load_sim {} {
	global PUTS SIMULATOR 

	# Check mode
	if { $::testmode == 0 } {
		# SoC C Test
		aed_soc_load_sim
	} elseif { $::testmode == 1 } {
		# SoC UVM
		aed_soc_uvm_load_sim
	} elseif { $::testmode == 2 } {
		# UART UVM
		aed_uart_uvm_load_sim
	} elseif { $::testmode == 3 } {
		# UART UVM
		aed_sv_load_sim
	} elseif { $::testmode ==  4 } {

		aed_soc_load_trek_sim
	}

	if { ${SIMULATOR} == "questasim" } {
	    run 0
	}

	$PUTS "Make sure you have traced all signals you want to see before you run"
	$PUTS "Type 'run -all' to start simulation"
	if { $SIMULATOR == "questasim" } { 
		$PUTS "When completed, don't click on finish as it will close the simulation"
	}
}

proc aed_clean_sim {} {
  global PUTS SIMULATOR 
  vdel -all -obj all
}


proc reload {} {
	global AEDV_ENV
	
	quit -sim
	
	unset AEDV_ENV
	source sim.do
}
proc aed_reload {} { reload }



proc aed_sim_main {} {
	global AMBERSOC_HOME PUTS
	# Main

	$PUTS "==========================================="
	$PUTS "=        VERIFICATION LAB                =="
	$PUTS "==========================================="
	$PUTS "= Copyright (c) 2014 - Francois Cerisier - AEDVICES Consulting"
	$PUTS "= OpenCores source codes under $AMBERSOC_HOME/opencores is distributed as is as a copy from opencores.org under GNU LGPL license"
	$PUTS "= Tools directory delivered as is under Mentor Graphics free license"
	$PUTS "==========================================="
  $PUTS "Main Training Commands: "
  $PUTS "    aed_gui    : Open the training compilation and simulation GUI"
  $PUTS "    sanity_uvm : Run sanity check for UVM testbench"
  $PUTS "    sanity_soc : Run sanity check for SoC testbench"
	#aed_gui

}

proc sanity_soc {} {
  global AMBERSOC_HOME
  
  set testname $AMBERSOC_HOME/trainings/test_install/aedvices_soc_install_test.c 
  aed_soc_compile_rtl $testname
  aed_soc_compile_tb $testname 
  aed_soc_load_sim $testname
  aed_soc_compile_test $testname
  run -all
}

proc sanity_uvm {} {
  global AMBERSOC_HOME
  
  set testname $AMBERSOC_HOME/trainings/test_install/aedvices_uvm_install_test.sv 
  aed_uart_uvm_compile_rtl $testname
  aed_uart_uvm_compile_tb $testname 
  aed_uart_uvm_load_sim $testname
  aed_uart_uvm_compile_test $testname
  run -all  
}

