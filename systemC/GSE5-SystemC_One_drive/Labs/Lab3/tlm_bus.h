#ifndef TLM_BUS_H
#define TLM_BUS_H

#include "tlm_master_bus_if.h"
#include "tlm_slave_bus_if.h"

struct TLMBus : public sc_prim_channel, public tlm_master_bus_if, tlm_slave_bus_if
{
	// Constructor
	explicit TLMBus() : sc_prim_channel(sc_gen_unique_name("TLMBus"))
		// do nothing
	}

	explicit TLMBus(sc_module_name nm) : sc_prim_channel(nm) {
		// do nothing
	}

	// tlm__master_bus_if
	...	

	// tlm__slave_bus_if
	...

private:
	// Variables
	...

	// Copy constructor so compiler won't create one
	TLMBus( const TLMBus& );
};

#endif

