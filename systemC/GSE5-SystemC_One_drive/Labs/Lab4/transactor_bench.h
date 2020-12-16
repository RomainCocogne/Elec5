#ifndef Transactor_Bench_H
#define Transactor_Bench_H

#include <systemc.h>
#include "mini_uart.h"
#include "processor.h"
#include "transactor.h"
#include "tlm_bus.h"

SC_MODULE(Transactor_Bench)
{
	/* Channel Members */
	// TLM Port
	TLMBus tlm_bus;

	// RTL Port
	sc_signal<bool> sys_clk, reset, irqRX, irqTX, txd_rxd;
	sc_signal_resolved ce, rd, wr;
	sc_signal_rv<2> addr;
	sc_signal_rv<8> data;

	// Sub-modules
	???

	// Constructor
	SC_CTOR(Transactor_Bench) : processor("Processor"), transactor("Transactor"), mini_uart("MiniUart")
	{
		// MiniUART Connections
		mini_uart.sys_clk(transactor.sys_clk);
		???
		
		// Transactor Connections
		transactor.reset(reset);
		???

		// Processor Connections
		???
	}

	// Helper Functions
	void trace(sc_trace_file*& tf) const;
};

#endif
