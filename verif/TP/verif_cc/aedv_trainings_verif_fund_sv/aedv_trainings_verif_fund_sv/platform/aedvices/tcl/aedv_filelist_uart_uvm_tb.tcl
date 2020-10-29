global AMBERSOC_HOME
global UART_UVM_TB_LIBRARIES

set UART_UVM_TB_LIBRARIES [list]

set DIR_UART   ${AMBERSOC_HOME}/opencores/uart_apb/uart16550_core/uart16550/rtl/verilog
set DIR_VIP    ${AMBERSOC_HOME}/aedvices/vip


# =================================
# UART IF
# =================================
set dut_lib(name) "uart_if_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${DIR_VIP}/uart/src/sv"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${DIR_VIP}/uart/src/sv"  \
]
set dut_lib(files) [list \
    "uart_if.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]

# =================================
# UART VIP
# =================================
set dut_lib(name) "uart_vip_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${DIR_VIP}/uart/src/sv"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${DIR_VIP}/uart/src/sv"  \
]
set dut_lib(files) [list \
    "aed_uart_pkg.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]

# =================================
# APB IF
# =================================
set dut_lib(name) "apb_if_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${DIR_VIP}/apb/src/sv"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${DIR_VIP}/apb/src/sv"  \
]
set dut_lib(files) [list \
    "apb_if.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]

# =================================
# APB VIP
# =================================
set dut_lib(name) "apb_vip_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${DIR_VIP}/apb/src/sv"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${DIR_VIP}/apb/src/sv"  \
]
set dut_lib(files) [list \
    "aed_apb_pkg.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]

# =================================
# SIDEBAND IF
# =================================
set dut_lib(name) "sideband_if_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${DIR_VIP}/sideband/src/sv"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${DIR_VIP}/sideband/src/sv"  \
]
set dut_lib(files) [list \
    "sideband_if.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]

# =================================
# SIDEBAND VIP
# =================================
set dut_lib(name) "sideband_vip_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${DIR_VIP}/sideband/src/sv"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${DIR_VIP}/sideband/src/sv"  \
]
set dut_lib(files) [list \
    "aed_sideband_pkg.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]


# =================================
# UART TB Package
# =================================
set dut_lib(name) "uart_ip_verif_lib"
set dut_lib(work) "work"
set dut_lib(language) "SYSTEM VERILOG"
set dut_lib(path) "${AMBERSOC_HOME}/aedvices/uart_tb"
set dut_lib(args) "+acc=mnprt "
set dut_lib(incdir) [list \
    "+incdir+${AMBERSOC_HOME}/aedvices/uart_tb"  \
    "+incdir+${DIR_VIP}/apb/src/sv" \
    "+incdir+${DIR_VIP}/uart/src/sv" \
    "+incdir+${DIR_UART}" \
    "+incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_pkg/sv" \
    "+incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_seq_lib_pkg/sv" \
    "+incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_complete_seq_lib_pkg/sv" \
    "+incdir+${AMBERSOC_HOME}/uart16550/testbench.4.full_uvm/uart16550_verif_test_pkg/sv" \
    "+incdir+${AMBERSOC_HOME}/aedvices/uart_tb" \
]
set dut_lib(files) [list \
    "uart_ip_verif_pkg.sv"           \
]
lappend UART_UVM_TB_LIBRARIES [array get dut_lib]






#=============================
#global INCDIR_UART_UVM_TB
#global FILELIST_UART_UVM_TB
#
#set DIR_UART   ${AMBERSOC_HOME}/opencores/uart_apb/uart16550_core/uart16550/rtl/verilog
#set DIR_VIP    ${AMBERSOC_HOME}/aedvices/vip
#
#set FILELIST_UART_UVM_TB [list      \
#    ${DIR_VIP}/uart/src/sv/aed_uart_pkg.sv   \
#    ${DIR_VIP}/apb/src/sv/aed_apb_pkg.sv     \
#    ${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_verif_pkg.sv      \
#]
#
#set INCDIR_UART_UVM_TB [list  \
#    +incdir+${DIR_VIP}/apb/src/sv \
#    +incdir+${DIR_VIP}/uart/src/sv \
#    +incdir+${DIR_UART} \
#    +incdir+${AMBERSOC_HOME}/aedvices/uart_tb \
#    +incdir+${AMBERSOC_HOME}/registers/ids \
#]
