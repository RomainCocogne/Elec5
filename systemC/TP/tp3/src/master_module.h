#ifndef PROCESSOR_H
#define PROCESSOR_H

#include <systemc.h>
#include <iostream>
#include "tlm_master_bus_if.h"
#include "tlm_bus.h"

SC_MODULE(MasterModule)
{
	// Port Declaration
	sc_port<tlm_master_bus_if> master_port;
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
	void boot_thread(){
		wait(10, SC_MS);
		std::cout << "<" << sc_time_stamp() << "> " << "writing 8 at 0x00..." << std::endl;
		master_port->writeToSlave(0x00, 8);
		wait(200, SC_MS);
		std::cout << "<" << sc_time_stamp() << "> " << "Asking data at 0x01..." << std::endl;
		int d = master_port->readToSlave(0x01);
		std::cout << "<" << sc_time_stamp() << "> " << "reading " << d << " at 0x01" << std::endl;
		wait(200, SC_MS);
		std::cout << "<" << sc_time_stamp() << "> " << "Asking data at 0x00..." << std::endl;
		d = master_port->readToSlave(0x00);
		std::cout << "<" << sc_time_stamp() << "> " << "reading " << d << " at 0x00" << std::endl;
	}
	void isr0_thread(){
		while(true){
			wait(master_port->irq0Event());
			std::cout << "<" << sc_time_stamp() << "> " << "irq0 event" << std::endl;
		}
	}
	void isr1_thread(){
		while(true){
			wait(master_port->irq1Event());
			std::cout << "<" << sc_time_stamp() << "> " << "irq1 event" << std::endl;
		}
	}

	// Helper Functions
};

#endif