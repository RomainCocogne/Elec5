#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <systemc.h>
#include "tlm_master_bus_if.h"

SC_MODULE(MasterModule)
{
	// Port Declaration

	// Channel Members

	// Data Members

	// Sub-modules

	// Constructor
	SC_CTOR(MasterModule)
	{
		SC_THREAD(boot_thread);
		SC_THREAD(isr0_thread);
		SC_THREAD(isr1_thread);
	}

	// Processes
	void boot_thread();
	void isr0_thread();
	void isr1_thread();

	// Helper Functions
};

#endif