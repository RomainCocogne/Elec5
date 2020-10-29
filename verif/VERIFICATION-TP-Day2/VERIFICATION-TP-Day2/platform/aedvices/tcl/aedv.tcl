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
	set wm_btn_margin [expr $wm_txt_margin + 20 * 8]
	set bt_width 20
	set wm_background lightgrey

	# Top level window
  if { [catch {
    toplevel .top -class toplevel
  } err] } {
     aed_close_form
     toplevel .top -class toplevel
  }
   
  
	wm title .top $gui_title
	wm geometry .top ${wm_width}x${wm_height}

	#wm resizable .top 0 0  # Not resizable - TODO uncomment once correct window is drawn
	wm protocol .top WM_DELETE_WINDOW aed_close_form

	# Main Menu
 	menu .top.menu -tearoff 0
  	set file .top.menu.file
	menu $file -tearoff 0
  	.top.menu add cascade -label "File" -menu $file -underline 0
  	#$file add command -label "Save" -command write_user_env_settings -accelerator "Ctrl-S" -underline 0
  	#$file add separator
  	$file add command -label "Close" -command aed_close_form -accelerator "Ctrl-W" -underline 0
	.top configure -menu .top.menu


	# Menu Accelerator
	bind .top <Control-w> {aed_close_form}

	# Create Form Canvas
	# Flow: C test | UVM
	# Test File:
	# Compile | Run | Show Wave
	
	
	frame  .top.fTest -height [expr $wm_height-20] -width [expr $wm_width-20] -background $wm_background
	place  .top.fTest -x 10 -y 10

	# Sim mode: "SoC C Test"      "SoC UVM"       "UART UVM"      "Standalone"
	#set count [expr $count+1]
	radiobutton .top.fTest.rbCTrek -text "TrekSoC C Test" -variable ::testmode -value 4  -background $wm_background
	place       .top.fTest.rbCTrek -x [expr $wm_btn_margin - 200] -y [expr 10+30*$count]
	radiobutton .top.fTest.rbCTest -text "SoC C Test" -variable ::testmode -value 0  -background $wm_background
	place       .top.fTest.rbCTest -x [expr $wm_btn_margin - 65] -y [expr 10+30*$count]
	radiobutton .top.fTest.rbUVM   -text "SoC UVM" -variable ::testmode -value 1  -background $wm_background
	place       .top.fTest.rbUVM -x [expr $wm_btn_margin + 60 ] -y [expr 10+30*$count]
	radiobutton .top.fTest.rbUART   -text "UART UVM" -variable ::testmode -value 2  -background $wm_background
	place       .top.fTest.rbUART -x [expr $wm_btn_margin+180] -y [expr 10+30*$count]
	radiobutton .top.fTest.rbVlog   -text "System Verilog" -variable ::testmode -value 3  -background $wm_background
	place       .top.fTest.rbVlog -x [expr $wm_btn_margin+290] -y [expr 10+30*$count]

	# Filename
	set count [expr $count+1]
	label  .top.fTest.lbTest -text "Test File" -background $wm_background
	place  .top.fTest.lbTest -x 10 -y [expr 10+30*$count]
	button .top.fTest.btTest -text "Browse" -width $bt_width -command {aed_browse_testfile}
	place  .top.fTest.btTest -x $wm_txt_margin -y [expr 10+30*$count]
	entry  .top.fTest.enTest -width [expr ($wm_width - $wm_txt_margin) / 10 - $bt_width]
        place  .top.fTest.enTest -x [expr $wm_btn_margin+$bt_width+20] -y [expr 10+30*$count]

	.top.fTest.enTest delete 0 end
	.top.fTest.enTest insert 0 $::testname

	set count [expr $count+1]


	# Compile RTL
	set count [expr $count+1]
	button .top.fTest.btCompileRTL -text "Compile RTL" -width $bt_width -command {aed_compile_rtl}
	place  .top.fTest.btCompileRTL -x $wm_txt_margin -y [expr 10+30*$count] 

	# Compile TB
	set count [expr $count+1]
	button .top.fTest.btCompileTB -text "Compile TB" -width $bt_width -command {aed_compile_tb}
	place  .top.fTest.btCompileTB -x $wm_txt_margin -y [expr 10+30*$count] 

	# Compile Test
	set count [expr $count+1]
	button .top.fTest.btCompileC -text "Compile Test" -width $bt_width -command {aed_compile_test}
	place  .top.fTest.btCompileC -x $wm_txt_margin -y [expr 10+30*$count] 

	# Load Simulation
	set count [expr $count+1]
	set SIM_SEED $::seed
	button .top.fTest.btLoadSim -text "Load Simulation" -width $bt_width -command {aed_load_sim}
	place  .top.fTest.btLoadSim -x $wm_txt_margin -y [expr 10+30*$count] 
	label  .top.fTest.lbSeed -text "Seed" -background $wm_background
        place  .top.fTest.lbSeed -x [expr $wm_btn_margin+$bt_width+20] -y [expr 10+30*$count]
	entry  .top.fTest.enSeed -width 5 -textvariable ::seed
	place  .top.fTest.enSeed -x [expr $wm_btn_margin+$bt_width+20+5*10] -y [expr 10+30*$count]
	.top.fTest.enSeed delete 0 end
	.top.fTest.enSeed insert 0 $SIM_SEED

    set count [expr $count+1]
    set count [expr $count+1]
    button .top.fTest.btRunSim -text "run -all" -width $bt_width -command {run -all}
    place  .top.fTest.btRunSim -x [expr $wm_txt_margin+50] -y [expr 10+30*$count]

    button .top.fTest.btRestartSim -text "restart -f" -width $bt_width -command {restart -f}
    place  .top.fTest.btRestartSim -x [expr $wm_txt_margin+250] -y [expr 10+30*$count]
    
    button .top.fTest.btCleanWork -text "clean" -width $bt_width -command {aed_clean_sim}
    place  .top.fTest.btCleanWork -x [expr $wm_txt_margin+450] -y [expr 10+30*$count]
    
    

#
#	frame  .top.test -height 40 -width 500
#	place  .top.test -x 500 -y 20 -anchor ne
#	button .top.test.browse -text "browse" -width 10 -height 2 -command {browse}
#	place   .top.test.browse -x 1 -y 500 -anchor ne

	focus -force .top
	#tkwait window .top

}




proc aed_close_form {} {
	global PUTS
	foreach ww [winfo children .top] {
		destroy $ww
	}
	destroy .top

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
	global PUTS

	set types {
      {{Verilog}          {.v .sv }       TEXT}
	    {{C Source Files}   {.c}      			TEXT}
	    {{All Files}        *             			}
	}

	set ::testname [tk_getOpenFile -filetypes $types]
	.top.fTest.enTest delete 0 end
	.top.fTest.enTest insert 0 $::testname
	
	$PUTS "Test set to $::testname"
	focus -force .top

	
}

proc aed_compile_test {} {
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
	focus -force .top
}


proc aed_compile_rtl {} {
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
	focus -force .top
}

proc aed_compile_tb {} {
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
	focus -force .top
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
	#aed_close_form
	run 0

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

