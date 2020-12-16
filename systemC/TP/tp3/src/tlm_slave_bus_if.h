#ifndef _TLM_SLAVE_BUS_IF_H_
#define _TLM_SLAVE_BUS_IF_H_

#include <systemc.h>

struct tlm_slave_bus_if: virtual public sc_interface{

    virtual void sendDataToMaster(int data_) = 0;
	virtual void sendAckToMaster() = 0;
	virtual const sc_event& rwEvent() const = 0;
	virtual bool isRead() const = 0;
	virtual int getData() const = 0;
	virtual unsigned int getAddress() const = 0;
	virtual void irq0Notify() = 0;
	virtual void irq1Notify() = 0;
};

#endif