
WISHBONE_VIP_DIR ?= ../../wishbone
WISHBONE_VIP_SRC = ${WISHBONE_VIP_DIR}/src/sv

VERILOG_SOURCE_DIR = ../rtl
VERILOG_TESTBENCH_DIR = ../bench/sv

ifeq ($(DATA_BUS_WIDTH_8), 1)
	MODELSIM_DEFINES =  +define+DATA_BUS_WIDTH_32
endif

NC_UVM_HOME ?= ${INCISIVHOME}/tools.lnx86/uvm-1.1/uvm_lib/uvm_sv

modelsim:
	vlib msiwork
	vlog -work msiwork ${VERILOG_SOURCE_DIR}/*.v +incdir+${VERILOG_SOURCE_DIR} ${MODELSIM_DEFINES}
	vlog -sv -work msiwork ${WISHBONE_VIP_SRC}/wishbone_pkg.sv +incdir+${WISHBONE_VIP_SRC} 
	vlog -sv -work msiwork ${VERILOG_TESTBENCH_DIR}/*.sv +incdir+${VERILOG_SOURCE_DIR} +incdir+${WISHBONE_VIP_SRC} ${MODELSIM_DEFINES}
	vopt -work msiwork uart16550_tb +acc=rnpq -o tb    # optimization does not work with parameterized interfaces
	vsim  msiwork.tb -permit_unmatched_virtual_intf +UVM_TESTNAME="uart_base_test"
	
ncwork:
	mkdir ncwork
ncsim: ncwork
	irun -gui -access +rw -work work -VTimescale 1ns/10ps -sv -uvm -uvmhome ${NC_UVM_HOME} \
	${MODELSIM_DEFINES} \
	+incdir+${VERILOG_SOURCE_DIR} \
	+incdir+${WISHBONE_VIP_SRC}  \
	+incdir+${VERILOG_SOURCE_DIR} \
	+incdir+${WISHBONE_VIP_SRC} \
	${VERILOG_SOURCE_DIR}/*.v \
	${WISHBONE_VIP_SRC}/wishbone_pkg.sv \
	${VERILOG_TESTBENCH_DIR}/*.sv 
	#ncsim -work work uart16550_tb
	
	

clean:
	rm -rf transcript  vsim.wlf  work ncwork msiwork INCA_libs
	



