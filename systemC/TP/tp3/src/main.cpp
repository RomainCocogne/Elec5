#include <systemc.h>
#include "slave_module.h"
#include "master_module.h"
#include "tlm_bus.h"

int sc_main(int argc, char* argv[]) {

	TLMBus bus;
	MasterModule mm("masterModule");
		mm.master_port(bus);
	SlaveModule sm("slaveModule", 1024);
		sm.slave_port(bus);

	sc_start(1000, SC_MS);

	return 0;
}


