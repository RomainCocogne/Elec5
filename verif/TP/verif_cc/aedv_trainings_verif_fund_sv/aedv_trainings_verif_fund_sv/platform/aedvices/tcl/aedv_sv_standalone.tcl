# Compilation and Execution of standalone SystemVerilog programs


proc aed_sv_compile_test {{testarg ""}} {
    global SIMULATOR
    aed_sv_compile_test_${SIMULATOR} $testarg
}

proc aed_sv_compile_test_ncsim {{testarg ""}} {
	global AMBERSOC_HOME AEDV_ENV
	global PUTS
	global SIMULATOR
	global TOP_WM

	if { $testarg eq "" } {
    	set filename [${TOP_WM}.fTest.enTest get]
    	set seed     [${TOP_WM}.fTest.enSeed get]
  	} else {
    	set filename $testarg
    	set seed 1
  	}

	# Get the testname
	# Assume the testname is the filename without extension
	set testdir  [file dirname $filename]
	set shortfilename [file tail $filename]
	set testname [file root $shortfilename]

	set INCDIRLIST ""

	set ARGS ""

	#This includes are not necessaries for the SV labs
	#set INCDIRLIST "$INCDIRLIST +incdir+$AMBERSOC_HOME/aedvices/vip/apb/src/sv"
	#set INCDIRLIST "$INCDIRLIST +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl"
    set INCDIRLIST "$INCDIRLIST +incdir+${testdir}"

    set NCSIM_ARGS "-access rwc +acc -disable_sem2009 -ALLOWREDEFINITION"

	$PUTS "========================"
	$PUTS "Compiling SystemVerilog"
	$PUTS "========================"

	aed_cmd "xrun -covoverwrite -covtest ${testname}_${seed} -coverage all -linedebug -UVMLINEDEBUG -c ${NCSIM_ARGS} $INCDIRLIST $filename"
}
proc aed_sv_compile_test_questasim {{testarg ""}} {
	global AMBERSOC_HOME AEDV_ENV
	global PUTS
	global SIMULATOR
	global TOP_WM

	if { ! [file exists work] } {
		vlib work
	}

	if { $testarg eq "" } {
    	set filename [${TOP_WM}.fTest.enTest get]
    	set seed     [${TOP_WM}.fTest.enSeed get]
  	} else {
    	set filename $testarg
    	set seed 1
  	}

	# Get the testname 
	# Assume the testname is the filename without extension
	set testdir  [file dirname $filename]
	set shortfilename [file tail $filename]
	set testname [file root $shortfilename]

	set INCDIRLIST ""

	$PUTS "========================"
	$PUTS "Compiling SystemVerilog"
	$PUTS "========================"
	aed_cmd "vlog  +acc +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps $INCDIRLIST $filename"
    
}



proc aed_sv_compile_rtl {{testarg ""}} {
	aed_sv_compile_test $testarg
}

proc aed_sv_compile_tb {{testarg ""}} {
	aed_sv_compile_test $testarg
}

proc aed_sv_load_sim {{testarg ""}} {
	global SIMULATOR
    aed_sv_load_sim_${SIMULATOR} $testarg
}

proc aed_sv_load_sim_ncsim {{testarg ""}} {
	global PUTS 
	global SIMULATOR
	global GUI

	# Get filename
	set seed $::seed

	set ARGS ""


	$PUTS "========================"
    $PUTS "Loading SystemVerilog"
    $PUTS "========================"

    if { $GUI eq 1 } {
    	append ARGS " -gui"
    }

	aed_cmd "xrun -covoverwrite -covtest lab_test_${seed} -coverage all -linedebug -UVMLINEDEBUG -access rwc +acc -disable_sem2009 -seed ${seed} -top lab_test -top tb +UVM_TESTNAME=lab_test $ARGS &"
	
}

proc aed_sv_load_sim_questasim {{testarg ""}} {
	global PUTS 
	global SIMULATOR

	# Get filename
	if { $testarg eq "" } {
    	set filename [.top.fTest.enTest get]
    	set seed     [.top.fTest.enSeed get]
  	} else {
    	set filename $testarg
    	set seed 1
  	}

	# Get the testname 
	# Assume the testname is the filename without extension
	set testdir  [file dirname $filename]
	set shortfilename [file tail $filename]
	set testname [file root $shortfilename]

    $PUTS "========================"
    $PUTS "Loading SystemVerilog"
    $PUTS "========================"

	aed_cmd "vsim lab_test tb  +UVM_TESTNAME=lab_test -sv_seed $seed -coverage -msgmode both -uvmcontrol=all -classdebug "
  	aed_cmd "add log -r sim:/*"
	# TODO: GUI should show test name, seed.
}