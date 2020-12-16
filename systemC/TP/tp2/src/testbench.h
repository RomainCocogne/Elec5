#ifndef _TESTBENCH_H_
#define _TESTBENCH_H_

#include <systemc.h>

SC_MODULE(TestBench) {
	// Port Declaration
	sc_out<bool> sys_clk, reset;

	sc_out_resolved ce, rd, wr;
	sc_out_rv<2> addr;

	sc_in<sc_lv<8> > data_in;
	sc_out<sc_lv<8> > data_out;

	sc_in<bool> irqRX, irqTX;

	// Channel Members
	sc_clock clock;
	sc_mutex bus_mutex;

	// Data Members
	sc_time CLK_PERIOD;	// 40 MHz
	char *mess;
	unsigned int cpt_car;

	// Constructor
	SC_CTOR(TestBench) : clock("Clock", sc_time(25, SC_NS)) {
		CLK_PERIOD = sc_time(25, SC_NS);

		cpt_car = 0;

		ce.initialize(SC_LOGIC_Z);
		rd.initialize(SC_LOGIC_Z);
		wr.initialize(SC_LOGIC_Z);
		addr.initialize(0);
		data_out.initialize("ZZZZZZZZ");

		SC_METHOD(sysclk_method);
			sensitive << clock.default_event();
		SC_THREAD(main_thread);
		SC_THREAD(tx_isr_thread);
		SC_THREAD(rx_isr_thread);
	}

	// Processes
	void sysclk_method();
	void main_thread();
	void tx_isr_thread();
	void rx_isr_thread();

	// Helper Functions
	void resetTest(void);
	void write(unsigned int addr, sc_uint<8> data);
	void read(unsigned int addr, sc_uint<8>& data);
};

#endif
