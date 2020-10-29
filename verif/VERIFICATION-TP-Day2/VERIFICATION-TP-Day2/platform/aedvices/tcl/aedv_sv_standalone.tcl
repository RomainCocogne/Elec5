# Compilation and Execution of standalone SystemVerilog programs


proc aed_sv_compile_test {} {
	global AMBERSOC_HOME AEDV_ENV
	global PUTS
	if { ! [file exists work] } {
		vlib work
	}

	# Get filename
	set filename [.top.fTest.enTest get]
	set seed     [.top.fTest.enSeed get]

	# Get the testname 
	# Assume the testname is the filename without extension
	set testdir  [file dirname $filename]
	set shortfilename [file tail $filename]
	set testname [file root $shortfilename]

	set INCDIRLIST ""
	set INCDIRLIST "$INCDIRLIST +incdir+$AMBERSOC_HOME/aedvices/vip/apb/src/sv"
	set INCDIRLIST "$INCDIRLIST +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl"



	$PUTS "========================"
	$PUTS "Compiling SystemVerilog"
	$PUTS "========================"
    aed_cmd "vlog  +acc +acc +cover=bcesfx -coveropt 1  -work work -timescale 1ns/10ps $INCDIRLIST $filename"
}



proc aed_sv_compile_rtl {} {
	aed_sv_compile_test
}

proc aed_sv_compile_tb {} {
	aed_sv_compile_test
}




proc aed_sv_load_sim {} {
	global PUTS 

	# Get filename
	set filename [.top.fTest.enTest get]
	set seed     [.top.fTest.enSeed get]

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