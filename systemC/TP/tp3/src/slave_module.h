#ifndef _SLAVE_MODULE_H_
#define _SLAVE_MODULE_H_

#include <systemc.h>
#include <iostream>
#include "tlm_slave_bus_if.h"
#include "tlm_bus.h"

SC_MODULE(SlaveModule)
{
	// Port Declaration
	sc_port<tlm_slave_bus_if> slave_port;
	// Channel Members

	// Data Members
	int *mem;
	int mem_size;
	// Sub-modules

	// Constructor
	SC_HAS_PROCESS(SlaveModule);
	SlaveModule(sc_module_name inst_name, int mem_depth)
		: sc_module(inst_name), mem_size(mem_depth) {
		mem = (int*)malloc((size_t)mem_depth*sizeof(int));
		SC_THREAD(main_thread);
		SC_THREAD(interrupt_thread);
	}

	~SlaveModule() {
		delete[] mem;
	}

	// Processes
	void main_thread(){
		int addr;
		while(true){
			wait(slave_port->rwEvent());
			if (!slave_port->isRead()) {
				std::cout << "<" << sc_time_stamp() << "> " << "Slave: reading data ";
				if ((addr = slave_port->getAddress()) < mem_size){
					mem[addr] = slave_port->getData();
					slave_port->sendAckToMaster();
					std::cout << mem[addr] << " at addr " << addr;
				}
				std::cout << std::endl;
			} else {
				std::cout << "<" << sc_time_stamp() << "> " << "Slave: sending data ";
				if ((addr = slave_port->getAddress()) < mem_size){
					slave_port->sendDataToMaster(mem[addr]);
					std::cout << mem[addr] << " at addr " << addr;
				}
				std::cout << std::endl;
			}
		}
	}
	void interrupt_thread(){
		while(true){
			wait(100, SC_MS);
			slave_port->irq0Notify();
			wait(100, SC_MS);
			slave_port->irq1Notify();
		}
	}

	// Helper Functions
	void write(unsigned int addr_, sc_uint<8> data_);
	void read(unsigned int addr_, sc_uint<8>& data_);
};

#endif