#ifndef _SLAVE_MODULE_H_
#define _SLAVE_MODULE_H_

#include <systemc.h>
#include "tlm_slave_bus_if.h"

SC_MODULE(SlaveModule)
{
	// Port Declaration

	// Channel Members

	// Data Members

	// Sub-modules

	// Constructor
	SC_HAS_PROCESS(SlaveModule);
	SlaveModule(sc_module_name inst_name, int mem_depth)
		: sc_module(inst_name) {

		SC_THREAD(main_thread);
		SC_THREAD(interrupt_thread);
	}

	~SlaveModule() {
		delete[] mem;
	}

	// Processes
	void main_thread();
	void interrupt_thread();

	// Helper Functions
	void write(unsigned int addr_, sc_uint<8> data_);
	void read(unsigned int addr_, sc_uint<8>& data_);
};

#endif