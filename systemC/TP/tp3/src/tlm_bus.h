#ifndef TLM_BUS_H
#define TLM_BUS_H

#include <iostream>
#include "tlm_master_bus_if.h"
#include "tlm_slave_bus_if.h"

struct TLMBus : public sc_prim_channel, public tlm_master_bus_if, tlm_slave_bus_if
{
	// Constructor
	explicit TLMBus() : sc_prim_channel(sc_gen_unique_name("TLMBus")){
		// do nothing
	}

	explicit TLMBus(sc_module_name nm) : sc_prim_channel(nm) {
		// do nothing
	}

	// tlm__master_bus_if
	void writeToSlave(unsigned int addr_, int data_){
		mutex.lock();
		addr = addr_;
		data = data_;
		is_read = false;
		rwToSlaveEV.notify();
		wait(ackToMasterEV);
		mutex.unlock();
	}
	int readToSlave(unsigned int addr_){
		mutex.lock();
		addr = addr_;
		is_read = true;
		rwToSlaveEV.notify();
		wait(ackToMasterEV);
		mutex.unlock();
		return data;
	}
	const sc_event& irq0Event() const{
		return irq0;
	}
	const sc_event& irq1Event() const{
		return irq1;
	}

	// tlm__slave_bus_if
	const sc_event& rwEvent() const{
		return rwToSlaveEV;
	}
	bool isRead() const{
		return is_read;
	}
	int getData() const{
		return data;
	}
	unsigned int getAddress() const{
		return addr;
	}
	void sendAckToMaster(){
		ackToMasterEV.notify();
	}
	void sendDataToMaster(int data_){
		data = data_;
		sendAckToMaster();
	}
	void irq0Notify(){
		irq0.notify();
	}
	void irq1Notify(){
		irq1.notify();
	}

private:
	// Variables
	sc_event rwToSlaveEV;
	sc_event ackToMasterEV;
	sc_event irq0, irq1;
	sc_mutex mutex;
	bool is_read;
	int data;
	uint addr;
	// Copy constructor so compiler won't create one
	TLMBus( const TLMBus& );
};

#endif

