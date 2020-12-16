#ifndef _TLM_MASTER_BUS_IF_H_
#define _TLM_MASTER_BUS_IF_H_

#include <systemc.h>

struct tlm_master_bus_if: virtual public sc_interface{

    virtual void writeToSlave(unsigned int addr_, int data_) = 0;
	virtual int readToSlave(unsigned int addr_) = 0;
	virtual const sc_event& irq0Event() const = 0;
	virtual const sc_event& irq1Event() const = 0;
};

#endif