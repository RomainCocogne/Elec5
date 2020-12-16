#ifndef MINI_UART_H
#define MINI_UART_H

#include <systemc.h>
#include "clk_unit.h"
#include "tx_unit.h"
#include "rx_unit.h"

SC_MODULE(MiniUart) {
	// Port Declaration
	...
	sc_out<sc_lv<8> > data_out;
	sc_out<bool> irqRX, irqTX;
	...


	// Channel Members
	...

	// Data Members
	...

	// Sub-modules
	ClkUnit ClkUnit_inst;
	...

	// Constructor
	SC_CTOR(MiniUart) : ClkUnit_inst("ClkUnit") {
		// Ititialize outpout port
		data_out.initialize("ZZZZZZZZ");
		irqRX.initialize(false);
		irqTX.initialize(false);

		// Process registration
		SC_METHOD(interfaceProcess_method);
			sensitive << ce << rd << wr << addr << data_in;
			dont_initialize();
		SC_METHOD(combinational_method);
			...
			
		// Sub-modules Connections

	}

	// Processes
	void interfaceProcess_method();
	void combinational_method();
};

#endif
