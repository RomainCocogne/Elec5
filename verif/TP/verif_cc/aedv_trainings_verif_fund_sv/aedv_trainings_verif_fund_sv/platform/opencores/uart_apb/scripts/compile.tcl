
set SCRIPT_DIR [file normalize [info script]/..]
set BASE_DIR   [file normalize ${SCRIPT_DIR}/..]

global USER_ARGS

# Allow to Run VLOG from TCLSH
if { ! [llength [namespace which vlog]] } {
    proc vlog { args } {
	exec vlog {*}$args
    }
}

# ______________________________
# Compile UART16550 OpenCore RTL
set VLOG_ARGS  [list \
   -incr \
   +acc  \
   +cover\
]

if { [info exists USER_ARGS]} {
   set VLOG_ARGS [list {*}${VLOG_ARGS} {*}${USER_ARGS}]
}

set MODULE_DIR ${BASE_DIR}/uart16550_core/uart16550/rtl/verilog
set INCDIR [list  \
    +incdir+${MODULE_DIR} \
]
set FILELIST [list      \
    raminfr.v           \
    uart_debug_if.v     \
    uart_receiver.v     \
    uart_regs.v         \
    uart_rfifo.v        \
    uart_sync_flops.v   \
    uart_tfifo.v        \
    uart_top.v          \
    uart_transmitter.v  \
    uart_wb.v           \
]
foreach file ${FILELIST} {
    echo "# Compiling $file : started"
    eval vlog +define+LITLE_ENDIAN {*}${VLOG_ARGS} {*}${INCDIR} ${MODULE_DIR}/${file}
    echo "# Compilation of $file : done !! "
}


# Compile APB2WB Bridge
set MODULE_DIR ${BASE_DIR}/apb2wb_bridge
source ${MODULE_DIR}/scripts/compile_rtl.tcl

# Compile UART16550_APB
set MODULE_DIR ${BASE_DIR}/uart_apb
source ${MODULE_DIR}/scripts/compile_rtl.tcl
