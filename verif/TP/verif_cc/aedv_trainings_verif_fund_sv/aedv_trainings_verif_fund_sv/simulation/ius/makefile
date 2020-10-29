## No Launcher, run command directly
LAB_LAUNCHER ?= 

## Debug, only prints the command
#LAB_LAUNCHER ?= echo

## Bsub 
#LAB_LAUNCHER ?= bsub -q 

S = @

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIR  := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))

ROOTDIR ?= ../..

RUNDIR ?= .

NCSIM_CMD  ?= xrun
NCSIM_ARGS ?= -64 -linedebug -access -rwc +acc -vtimescale 1ns/10ps -disable_sem2009 -ALLOWREDEFINITION


AMBERSOC_HOME ?=$(abspath ${ROOTDIR}/platform)
AMBER_BASE    =$(abspath ${AMBERSOC_HOME}/opencores/amber)
DIRUTILS      =$(abspath ${AMBERSOC_HOME}/tools/utils/linux)

LAB_TYPE ?= 'SV'
LAB_SET=all_labs/solutions
LAB_NAME ?= 999-systemverilog_sanity
LAB_DIR=$(abspath ${ROOTDIR}/${LAB_SET}/${LAB_NAME})
LAB_PATH=$(abspath $(LAB_DIR)/lab.sv)



UVM_INCDIR = 	+incdir+${AMBERSOC_HOME}/aedvices/vip/apb/src/sv \
		+incdir+${AMBERSOC_HOME}/aedvices/vip/uart/src/sv \
		+incdir+${AMBERSOC_HOME}/opencores/uart_apb/uart16550_core/uart16550/rtl/verilog \
		+incdir+${AMBERSOC_HOME}/aedvices/uart_tb


UVM_LIBS = 	${AMBERSOC_HOME}/aedvices/vip/uart/src/sv/aed_uart_pkg.sv \
		${AMBERSOC_HOME}/aedvices/vip/apb/src/sv/aed_apb_pkg.sv \
		${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_verif_pkg.sv \
		${AMBERSOC_HOME}/aedvices/uart_tb/uart_ip_tb.sv \

SEED?=1
GUI?=0
ifeq ($(GUI),1)
	EXTRA_ARGS=-gui
else
	EXTRA_ARGS=-run -q -licqueue
endif

ifeq ("$(wildcard $(LAB_PATH))","")
	LAB_PATH=$(abspath $(LAB_DIR)/lab.v)
endif




CODESOURCERY = ${AMBERSOC_HOME}/tools/codesourcery/linux

export AMBER_BASE
export AMBERSOC_HOME

TIMEOUTCMD=

USE_LAUNCHER ?=1
LAUNCHER_CMD=
ifeq ($(USE_LAUNCHER),1)
	LAUNCHER_CMD = ${LAB_LAUNCHER}
endif

.PHONY:run.lab
run.lab:
ifeq ($(LAB_TYPE),SV) 
	make sv.run  LAB_NAME=$(LAB_NAME) RUNDIR=${RUNDIR}
else 
	make uvm.run LAB_NAME=$(LAB_NAME) RUNDIR=${RUNDIR}
endif

${RUNDIR}:
	mkdir -p $@

.PHONY:sv.run
sv.run: ${RUNDIR}
	@echo "--> $@ <--"
	tclsh regression.tcl ${LAB_PATH} '3'


.PHONY:uvm.run
uvm.run: ${RUNDIR}
	@echo "--> $@ <--"
	tclsh regression.tcl ${LAB_PATH} '2'

.PHONY: 999-uvm_sanity
999-uvm_sanity: LAB_NAME=999-uvm_sanity
999-uvm_sanity: TIMEOUTCMD=timeout 60s
999-uvm_sanity: GUI=0
999-uvm_sanity: uvm.run
	@grep "UVM_ERROR :    0" ${NCSIM_CMD}.log
	@grep "UVM_FATAL :    0" ${NCSIM_CMD}.log
	@echo "--> UVM Sanity Test Passed" >> $@.tag


.PHONY: 999-systemverilog_sanity
999-systemverilog_sanity: LAB_NAME=999-systemverilog_sanity
999-systemverilog_sanity: GUI=0
999-systemverilog_sanity: TIMEOUTCMD=timeout 60s
999-systemverilog_sanity: sv.run
	@grep "Test completed" ${NCSIM_CMD}.log
	@echo "--> SystemVerilog Sanity Test Passed" >> $@.tag

.PHONY: sanity
sanity:
	@$(LAUNCHER_CMD) make sanity_check USE_LAUNCHER=0

.PHONY: sanity_check
sanity_check: clean sanity.sv sanity.uvm
	@echo "---------------------------"
	@cat 999-systemverilog_sanity.tag 999-uvm_sanity.tag
	@echo "---------------------------"
	@echo "--> SANITY TESTS PASSED <--"
	@echo "---------------------------"

.PHONY: sanity.sv
sanity.sv: 999-systemverilog_sanity 

.PHONY: sanity.uvm
sanity.uvm: 999-uvm_sanity



.PHONY: clean
clean:
	rm -rf *.tag xcelium.d xrun.log INCA_libs cov_work waves.shm *.log ${NCSIM_CMD}.key *.elog *~ cmd.txt

