global AMBERSOC_HOME
global UART_APB_DUT_LIBRARIES

set MODULE_DIR ${AMBERSOC_HOME}/opencores/uart_apb
set DIR_UART   ${MODULE_DIR}/uart16550_core/uart16550/rtl/verilog
set DIR_TOP    ${MODULE_DIR}/uart_apb/src
set DIR_APB2WB ${MODULE_DIR}/apb2wb_bridge/src

set UART_APB_DUT_LIBRARIES [list]

#*********** UART ***********#

# =================================
# UART APB LIB
# =================================
set dut_lib(name) "uart_lib"
set dut_lib(work) "work"
set dut_lib(language) "VERILOG"
set dut_lib(path) "${DIR_UART}"
set dut_lib(args) "+acc +cover -timescale 1ns/10ps +define+AEDV_LAB_SCOREBOARD +define+AEDV_LAB_ASSERTION"
set dut_lib(incdir) [list \
    "${DIR_UART}"  \
]
set dut_lib(files) [list \
    "raminfr.v"           \
    "uart_debug_if.v"     \
    "uart_rfifo.v"        \
    "uart_tfifo.v"        \
    "uart_receiver.v "    \
    "uart_transmitter.v"  \
    "uart_sync_flops.v"   \
    "uart_regs.v"         \
    "uart_wb.v"           \
    "uart_top.v"          \
]
lappend UART_APB_DUT_LIBRARIES [array get dut_lib]

#*********** BRIDGE ***********#

# =================================
# APB2WB Bridge
# =================================
set dut_lib(name) "apb2wb_bridge_lib"
set dut_lib(work) "work"
set dut_lib(language) "VERILOG"
set dut_lib(path) "${DIR_APB2WB}"
set dut_lib(args) "+acc +cover -timescale 1ns/10ps "
set dut_lib(incdir) [list \
    "${DIR_APB2WB}"  \
]
set dut_lib(files) [list \
    "apb2wb_bridge.v" \
]
lappend UART_APB_DUT_LIBRARIES [array get dut_lib]


#*********** UART APB ***********#

# =================================
# UART APB Top
# =================================
set dut_lib(name) "uart_apb_lib"
set dut_lib(work) "work"
set dut_lib(language) "VERILOG"
set dut_lib(path) "${DIR_TOP}"
set dut_lib(args) "+acc +cover -timescale 1ns/10ps "
set dut_lib(incdir) [list \
    "${DIR_TOP}"  \
    "${DIR_APB2WB}"  \
]
set dut_lib(files) [list \
    "uart_apb.v" \
]
lappend UART_APB_DUT_LIBRARIES [array get dut_lib]