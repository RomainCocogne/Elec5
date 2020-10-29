
proc compile_and_load { args } {
    global LAB_FILE
    global LAB_TYPE
    global AMBERSOC_HOME


    if { $LAB_TYPE == 0 } {
        # SoC C Test
        #Not Tested
        #set testname $AMBERSOC_HOME/trainings/test_install/aedvices_soc_install_test.c 
        #aed_soc_compile_rtl $testname
        #aed_soc_compile_tb $testname 
        #aed_soc_load_sim $testname
        #aed_soc_compile_test $testname
    } elseif { $LAB_TYPE == 1 } {
        # SoC UVM 
        #Not Implemented
        # aed_soc_uvm_compile_test $LAB_FILE
    } elseif { $LAB_TYPE == 2 } {
        # UART UVM
        aed_uart_uvm_compile_rtl
        aed_uart_uvm_compile_tb $LAB_FILE
        aed_uart_uvm_load_sim $LAB_FILE
    } elseif { $LAB_TYPE == 3 } {
        # System Verilog
        aed_sv_compile_test $LAB_FILE
        aed_sv_load_sim $LAB_FILE
    } elseif { $LAB_TYPE == 4 } {
        #TrekSoc C test
        #Not Tested
        #aed_compile_trek_test $LAB_FILE
        #aed_soc_compile_trek_tb $LAB_FILE
        #aed_soc_compile_trek_rtl $LAB_FILE
        #aed_soc_load_trek_sim $LAB_FILE
    }
}

#compile_and_load