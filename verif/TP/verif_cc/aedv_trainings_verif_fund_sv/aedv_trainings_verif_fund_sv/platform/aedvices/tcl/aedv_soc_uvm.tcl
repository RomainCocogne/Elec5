
proc aed_soc_uvm_compile_rtl {} {
  global VLOG_ARG AMBER_BASE simdir DIRUTILS PUTS AMBERSOC_HOME
  #cd $simdir

  set filename [.top.fTest.enTest get]
  set testdir  [file dirname $filename]
  set bootdir  $AMBER_BASE/sw/boot-loader-serial
  set shortfilename [file tail $filename]
  set testname [file root $shortfilename]

  set ::env(AMBER_BASE) $AMBER_BASE
  set ::env(AMBERSOC_HOME) $AMBERSOC_HOME

  set BOOT_MEM_FILE obj/boot-loader-serial.mem
  set MAIN_MEM_FILE obj/$testname.mem
  set AMBER_TIMEOUT 0
  set AMBER_LOG_FILE "tests.log"
  set AMBER_SIM_CTRL 4
  set AMBER_TEST_NAME $testname

  set VLOG_ARG "+acc"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/lib"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/system"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber23"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber25"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/tb"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/ethmac"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBERSOC_HOME}/aedvices/socv"
  set VLOG_ARG "${VLOG_ARG} +define+BOOT_MEM_FILE=${BOOT_MEM_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+MAIN_MEM_FILE=${MAIN_MEM_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_LOG_FILE=${AMBER_LOG_FILE}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_TIMEOUT=${AMBER_TIMEOUT}" 
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL}"
  set VLOG_ARG "${VLOG_ARG} +define+AMBER_TEST_NAME={AMBER_TEST_NAME}"

  if { [file isdirectory work] } {
  # file delete -force work
  } else {
    vlib work
  }
  vlog +acc -work work -timescale 1ns/10ps +incdir+${AMBER_BASE}/hw/vlog/lib \
    +incdir+${AMBER_BASE}/hw/vlog/system \
    +incdir+${AMBER_BASE}/hw/vlog/amber23 \
    +incdir+${AMBER_BASE}/hw/vlog/amber25 \
    +incdir+${AMBER_BASE}/hw/vlog/tb \
    +incdir+${AMBER_BASE}/hw/vlog/ethmac \
    +incdir+${AMBERSOC_HOME}/aedvices/socv \
    +define+BOOT_MEM_FILE="${BOOT_MEM_FILE}" \
    +define+MAIN_MEM_FILE="${MAIN_MEM_FILE}" \
    +define+AMBER_LOAD_MAIN_MEM=1 \
    +define+AMBER_LOG_FILE="${AMBER_LOG_FILE}" \
    +define+AMBER_TIMEOUT=${AMBER_TIMEOUT} \
    +define+AMBER_SIM_CTRL=${AMBER_SIM_CTRL} \
    +define+AMBER_TEST_NAME="${AMBER_TEST_NAME}" \
    -f filelist_headless.txt}

proc aed_soc_uvm_compile_tb {} {
  global VLOG_ARG AMBER_BASE simdir DIRUTILS
  global AMBERSOC_HOME
  global PUTS
  set ::env(AMBER_BASE) $AMBER_BASE
  set DEFINES "+define+IMPORT_LAB_PKG"
  
  set filename [.top.fTest.enTest get]
  
  set VLOG_ARG "+acc"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/lib"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/system"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber23"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/amber25"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/tb"
  set VLOG_ARG "${VLOG_ARG} +incdir+${AMBER_BASE}/hw/vlog/ethmac"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/VIP"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/VIP/cdn/socv/interface_uvc_lib/uart/sv"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/aedvices/vip/apb/src/sv"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/aedvices/vip/uart/src/sv"

  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/aedvices/design/apb2wb_bridge"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/aedvices/vip/uart16550_vip/sv"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/opencores/uart16550/rtl"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/aedvices/vip/wishbone/src/sv"
  set VLOG_ARG "${VLOG_ARG} +incdir+$AMBERSOC_HOME/aedvices/socv"
  set TOP_FILES ""
  set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/vip/apb/src/sv/aed_apb_pkg.sv"
  set TOP_FILES "${TOP_FILES} ${AMBERSOC_HOME}/aedvices/vip/uart/src/sv/aed_uart_pkg.sv"

  $PUTS "========================"
  $PUTS "Compiling Testbench"
  $PUTS "========================"
    aed_cmd "vlog +acc=mnprt -work work -timescale 1ns/10ps \
    $VLOG_ARG \
    $VLOG_ARG ${DEFINES} ${TOP_FILES}\
    +define+AMBER_LOAD_MAIN_MEM=0 \
    $AMBERSOC_HOME/aedvices/socv/headless_pkg.sv \
    $AMBERSOC_HOME/aedvices/socv/headless_tb.sv \
    $filename"
}

proc aed_soc_uvm_compile_test {} {

}


proc aed_soc_uvm_load_sim {} {
  global PUTS 

  # Get filename
    set filename [.top.fTest.enTest get]
    set seed     [.top.fTest.enSeed get]

  # Get the testname 
  # Assume the testname is the filename without extension
  set testdir  [file dirname $filename]
  set shortfilename [file tail $filename]
  set testname [file root $shortfilename]
    set packagename "${testname}_pkg" 

    aed_cmd "vsim tb $packagename +UVM_TESTNAME=$testname -sv_seed $seed -coverage -msgmode both"

  do wave_soc.do
  # TODO: GUI should show test name, seed.


}
