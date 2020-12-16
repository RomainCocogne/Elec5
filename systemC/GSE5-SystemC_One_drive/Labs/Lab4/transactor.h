#ifndef TRANSACTOR_H
#define TRANSACTOR_H

#include <string>
#include <systemc.h>
#include "tlm_slave_bus_if.h"

using namespace std;

struct Transactor : public sc_channel {
	// RTL Port: sys_clk, reset, ce, rd, wr, addr, data_in, data_out, irq0, irq1

	// TLM Port
	
	// Channel Members
	sc_clock clock;		// to connect to sys_clk port
	sc_mutex bus_mutex;
	
	// Data Members
	sc_time CLK_PERIOD;	// 40 MHz
	
	// Constructor
	SC_CTOR(Transactor) : clock("Clock", sc_time(25, SC_NS)) {
		CLK_PERIOD = sc_time(25, SC_NS);

		ce.initialize(SC_LOGIC_Z);
		rd.initialize(SC_LOGIC_Z);
		wr.initialize(SC_LOGIC_Z);
		addr.initialize(0);
		data_out.initialize("ZZZZZZZZ");
		
		/* Bind clock to sys_clk */
		???
		
		/* Register process */
		SC_???(transactor_???);
		SC_???(isr0_???);
			sensitive << irq0.pos();
		SC_???(isr1_???);
			sensitive << irq1.pos();
	}

	// Processes
	void transactor_???();
	void isr0_???();
	void isr1_???();

	// Helper Functions
	void resetTest(void);
	void write(unsigned int addr, sc_uint<8> data);
	void read(unsigned int addr, sc_uint<8>& data);
};

#endif
