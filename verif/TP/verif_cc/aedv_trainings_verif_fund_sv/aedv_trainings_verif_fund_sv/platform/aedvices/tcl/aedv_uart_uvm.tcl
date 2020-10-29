


proc aed_uart_uvm_compile_rtl_questasim {{testarg ""}} {
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

    source ${AMBERSOC_HOME}/opencores/uart_apb/scripts/compile.tcl
}

proc aed_uart_uvm_compile_rtl_ncsim {{testarg ""}} {
    global AMBERSOC_HOME
    global UART_APB_DUT_LIBRARIES

    global SIMULATOR
    global PUTS
    
    $PUTS "========================"
    $PUTS "Compiling RTL"
    $PUTS "========================"

    set DEFINES "+define+LITLE_ENDIAN"
    set NCSIM_ARGS "-access rwc "
  
    $PUTS "\n"
    $PUTS "########################"
    $PUTS "#UART APB Compiling"
    $PUTS "########################\n"
  
    
    foreach element $UART_APB_DUT_LIBRARIES {
      array set element_handle [lindex $element]

      set COMP_LIST ""

      # Create +incdir args
      set INCDIR [list]
      foreach id $element_handle(incdir) {
        lappend INCDIR +incdir+${id}
      }


      foreach file $element_handle(files) {
        #$PUTS "xrun -c $DEFINES $NCSIM_ARGS $element_handle(args) {*}$INCDIR ${element_handle(path)}/${file}"
        set COMP_LIST "$COMP_LIST {*}$INCDIR ${element_handle(path)}/${file}"
      }
      aed_cmd "xrun -linedebug -c $DEFINES $NCSIM_ARGS $element_handle(args) ${COMP_LIST}"
    }
    $PUTS " ----> DESIGN COMPILATION DONE !"
}

proc aed_uart_uvm_compile_rtl {{testarg ""}} {
    global SIMULATOR
    aed_uart_uvm_compile_rtl_${SIMULATOR} $testarg
}

proc aed_uart_uvm_compile_tb_ncsim {{testarg ""}} {
    global AMBERSOC_HOME
    global UART_UVM_TB_LIBRARIES
    

    global SIMULATOR
    global PUTS

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
    }

    if { [file exists "${testdir}/uart_ip_tb.sv"] } {
      set dir ${testdir}
    } else {
      set dir "${AMBERSOC_HOME}/aedvices/uart_tb"
    }

    #set CURRENT_TB_LIBRARIES $UART_UVM_TB_LIBRARIES

    
    set tb_lib(name) "uart_ip_tb_lib"
    set tb_lib(work) "work"
    set tb_lib(language) "SYSTEM VERILOG"
    set tb_lib(path) "${dir}"
    set tb_lib(args) ""


    if { [file exists "${testdir}/vlog_incdir.tcl"] } {
      $PUTS "Using ${testdir}/vlog_incdir.tcl"
      source ${testdir}/vlog_incdir.tcl
      set tb_lib(incdir) ${INCDIR}
    } else {
      set tb_lib(incdir) [list \
        "+incdir+${AMBERSOC_HOME}/aedvices/vip/apb/src/sv" \
        "+incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv" \
        "+incdir+${AMBERSOC_HOME}/opencores/uart_apb/uart16550_core/uart16550/rtl/verilog" \
         +incdir+${AMBERSOC_HOME}/uart16550/dut/uart16550_core/uart16550/rtl/verilog/" \
        "+incdir+${AMBERSOC_HOME}/aedvices/uart_tb" \
        "+incdir+${AMBERSOC_HOME}/registers/ids" \
        "+incdir+${dir}" \
      ]
    }

    if { [file exists "${testdir}/vlog_files.tcl"] } {
      $PUTS "Using  ${testdir}/vlog_files.tcl"
      source ${testdir}/vlog_files.tcl
      lappend tb_lib(files) {*}$TOP_FILES
    } else {
      set tb_lib(files) [list \
        "uart_ip_tb.sv"           \
      ]
      set CURRENT_TB_LIBRARIES $UART_UVM_TB_LIBRARIES
    }
    if { [file exists "${testdir}/uart_ip_tb.sv"] } {
      lappend tb_lib(files) "${testdir}/uart_ip_tb.sv"
    } else {
      set tb_lib(files) [list \
        "uart_ip_tb.sv"        \
      ]
    }

    

    lappend CURRENT_TB_LIBRARIES [array get tb_lib]


    set tb_lib(name) "${shortfilename}_lib"
    set tb_lib(work) "work"
    set tb_lib(language) "SYSTEM VERILOG"
    set tb_lib(path) "${testdir}"
    set tb_lib(args) ""
    set tb_lib(incdir) [list \
      "+incdir+${AMBERSOC_HOME}/aedvices/vip/apb/src/sv" \
      "+incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv" \
      "+incdir+${AMBERSOC_HOME}/opencores/uart_apb/uart16550_core/uart16550/rtl/verilog" \
         +incdir+${AMBERSOC_HOME}/uart16550/dut/uart16550_core/uart16550/rtl/verilog/" \
      "+incdir+${AMBERSOC_HOME}/aedvices/uart_tb" \
      "+incdir+${testdir}" \
    ]
    set tb_lib(files) [list \
      "$shortfilename"  \
    ]
    lappend CURRENT_TB_LIBRARIES [array get tb_lib]


    #compile_uart_uvm_tb_${SIMULATOR} $TOBE_COMPILE

    set DEFINES "+define+IMPORT_LAB_PKG"
    set NCSIM_ARGS "+acc=mnprt -timescale 1ns/10ps -access rwc  -uvm "

    # HACK: deal with the fact that we now compile the Interface together with the testbench
    # TODO: remove this line and remove interface from compilation list
    set NCSIM_ARGS "$NCSIM_ARGS -ALLOWREDEFINITION"

    $PUTS "\n"
    $PUTS "########################"
    $PUTS "#UART UVM TB Compiling"
    $PUTS "########################\n"
  
    #foreach file ${FILELIST_UART_UVM_TB} {
    #    $PUTS "# Compiling $file : started"
    #    $PUTS "xrun -c $DEFINES $ARGS {*}${INCDIR_UART_UVM_TB} ${file}"
    #    $PUTS "# Compilation of $file : done !! "
    #}

    set COMP_LIST ""
    foreach element $CURRENT_TB_LIBRARIES {
      array set element_handle [lindex $element]
      
      # Create +incdir args
      set INCDIR [list]
      foreach id $element_handle(incdir) {
        lappend INCDIR ${id}
      }

      foreach file $element_handle(files) {
        #$PUTS "xrun -c ${NCSIM_ARGS} $DEFINES $element_handle(args) {*}$INCDIR ${element_handle(path)}/${file}"
        # TODO: this only work under Linux
        set first_slash [string first / ${file}]
        if { $first_slash == 0 } {
          set file_path ${file}
        } else {
          set file_path ${element_handle(path)}/${file}
        }
        set COMP_LIST "$element_handle(args) $COMP_LIST {*}$INCDIR ${file_path}"
        
      }
      
    }
    aed_cmd "xrun -linedebug -UVMLINEDEBUG -c $DEFINES $NCSIM_ARGS $COMP_LIST"
    $PUTS " ----> TESTBENCH COMPILATION DONE !"


}

proc aed_uart_uvm_compile_tb_questasim {{testarg ""}} {
	global AMBERSOC_HOME
	global PUTS
  global SIMULATOR
  global TOP_FILES
  global testdir

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

  if { [file exists "${testdir}/vlog_incdir.tcl"] } {
    global INCDIR
    $PUTS "INFO: Using ${testdir}/vlog_incdir.tcl"
    source "${testdir}/vlog_incdir.tcl"
  } else {  

    set INCDIR ""
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/vip/apb/src/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/vip/sideband/src/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/reg2apb_adapter/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_uvm_reg/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/dut/uart16550_core/uart16550/rtl/verilog/"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_pkg/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_seq_lib_pkg/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_complete_seq_lib_pkg/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_test_pkg/sv"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/opencores/uart_apb/uart16550_core/uart16550/rtl/verilog"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/aedvices/uart_tb"
    set INCDIR "${INCDIR} +incdir+${AMBERSOC_HOME}/registers/ids"
  }

   if { [file exists "${testdir}/vlog_files.tcl"] } {
    $PUTS "INFO: Using ${testdir}/vlog_files.tcl"
    source "${testdir}/vlog_files.tcl"
    lappend TOP_FILES $filename
  } else {
    set TOP_FILES [list \
      "${AMBERSOC_HOME}/aedvices/vip/uart/src/sv/aed_uart_pkg.sv"           \
      "${AMBERSOC_HOME}/aedvices/vip/apb/src/sv/aed_apb_pkg.sv"             \
      "${AMBERSOC_HOME}/aedvices/vip/sideband/src/sv/aed_sideband_pkg.sv"   \
      "${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/reg2apb_adapter/sv/reg2apb_adapter_pkg.sv"   \
      "${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_uvm_reg/sv/UART_16550_Description_pkg.regmem.sv"   \
      "${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_pkg/sv/uart16550_verif_pkg.sv"   \
      "${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_seq_lib_pkg/sv/uart16550_verif_seq_pkg.sv"   \
      "${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_complete_seq_lib_pkg/sv/uart16550_verif_complete_seq_pkg.sv"   \
      "${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_test_pkg/sv/uart16550_verif_test_pkg.sv"   \
      "${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_verif_pkg.sv"              \
      "$filename"                                                           \
    ]
  }

  if { [file exists "${testdir}/uart_ip_tb.sv"] } {
    lappend TOP_FILES "${testdir}/uart_ip_tb.sv"
  } else {
    lappend TOP_FILES "${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_tb.sv"
  }

  foreach file ${TOP_FILES} {
    aed_cmd "vlog +acc=mnprt -work work -timescale 1ns/10ps ${INCDIR} ${DEFINES} ${file}"
  }
}

proc aed_uart_uvm_compile_tb {{testarg ""}} {
    global SIMULATOR
    aed_uart_uvm_compile_tb_${SIMULATOR} $testarg
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

proc aed_uart_uvm_load_sim_ncsim {{testarg ""}} {
  global PUTS 
  global GUI
  global SIMULATOR

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

  set ARGS ""
  
  $PUTS "\n"
  $PUTS "========================"
  $PUTS "Loading UART UVM"
  $PUTS "========================\n"

  #$PUTS "xrun -top $ARGS uart_tb ${DEFINES} $packagename +UVM_TESTNAME=${testname} -sv_seed $seed -gui"
  if { $GUI eq 1 } {
    append ARGS " -input APB_UART_WAVE.tcl -gui"
  }
  aed_cmd "xrun -covoverwrite -covtest ${testname}_${seed} -coverage all -linedebug -UVMLINEDEBUG -access rwc -top uart_tb ${DEFINES} -top $packagename -timescale 1ns/10ps -seed $seed +UVM_TESTNAME=${testname} $ARGS"
  # TODO: How to load a wave file?
  # TODO: GUI should show test name, seed.

}


proc aed_uart_uvm_load_sim_questasim {{testarg ""}} {
	global PUTS 
  global GUI
  global SIMULATOR

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

  $PUTS "========================"
  $PUTS "Loading UART UVM"
  $PUTS "========================"


  aed_cmd "vsim -t 100ps -coverage -msgmode both -uvmcontrol=all -classdebug -solvefaildebug=2 uart_tb ${DEFINES} $packagename +UVM_TESTNAME=${testname} -sv_seed $seed"
  if { $GUI eq 1 } {
    do wave_uart16550.do
  }
 
  $PUTS "========================"
  $PUTS "Loaaaaaaaaaaaaaaaaaaa"
  $PUTS "========================\n"
  # TODO: GUI should show test name, seed.

}


proc aed_uart_uvm_load_sim {{testarg ""}} {
  global SIMULATOR
  aed_uart_uvm_load_sim_${SIMULATOR} $testarg
}
