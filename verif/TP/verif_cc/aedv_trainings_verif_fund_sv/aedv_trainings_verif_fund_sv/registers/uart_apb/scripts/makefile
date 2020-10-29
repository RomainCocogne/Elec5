
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR  := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))

UART_DIR := $(abspath $(MAKEFILE_DIR)/../..)

FILE_LIST = \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/raminfr.v           \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_debug_if.v     \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_receiver.v     \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_regs.v         \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_rfifo.v        \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_sync_flops.v   \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_tfifo.v        \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_top.v          \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_transmitter.v  \
	$(UART_DIR)/uart16550_core/uart16550/rtl/verilog/uart_wb.v           \
	$(UART_DIR)/apb2wb_bridge/src/apb2wb_bridge.v                        \
	$(UART_DIR)/uart_apb/src/uart_apb.v

INCDIR = \
	+incdir+$(UART_DIR)/uart16550_core/uart16550/rtl/verilog \
	+incdir+$(UART_DIR)/apb2wb_bridge/src



NCSIM_CMD  ?= xrun
NCSIM_ARGS ?= -64 -linedebug -access -rwc +acc -vtimescale 1ns/10ps +define+LITLE_ENDIAN

compile.ius:
	${NCSIM_CMD} -c ${NCSIM_ARGS} ${INCDIR} ${FILE_LIST}
