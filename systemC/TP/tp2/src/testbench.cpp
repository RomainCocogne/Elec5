#include <systemc.h>
#include "testbench.h"

// Processes

void TestBench::sysclk_method() {
	sys_clk->write(clock.read()); 
}

void TestBench::main_thread() {
	cpt_car = 0;
	mess = (char *)"Hello !\n";

	resetTest();
	wait(CLK_PERIOD * 5);

	cout << sc_time_stamp() << ": " << "Write Boot " << mess[cpt_car] << endl;
	write(0x00, mess[cpt_car]);
}

void TestBench::tx_isr_thread() {
	while (true) {
		wait(irqTX->posedge_event());
		cout << "TX Interrupt at time : " << sc_time_stamp() << endl;
		if (cpt_car < sizeof(mess)) {
			cpt_car += 1;
			cout << sc_time_stamp() << ": " << "Write " << mess[cpt_car] << endl;
			write(0x00, mess[cpt_car]);
		}
	}
}

void TestBench::rx_isr_thread() {
	sc_uint<8> value;
	while (true) {
		wait(irqRX->posedge_event());
		cout << "RX Interrupt at time : " << sc_time_stamp() << endl;
		read(0x00, value);
		cout << sc_time_stamp() << ": " << "Read " << char(value) << endl;
	}
}

// Helper Functions

void TestBench::resetTest(void) {

	ce->write(SC_LOGIC_0);
	wr->write(SC_LOGIC_0);
	rd->write(SC_LOGIC_0);
	addr->write(0);
	data_out->write("ZZZZZZZZ");
	reset->write(true);
	wait(CLK_PERIOD * 20);
	reset->write(false);

	ce->write(SC_LOGIC_Z);
	wr->write(SC_LOGIC_Z);
	rd->write(SC_LOGIC_Z);
}

void TestBench::write(unsigned int addr_, sc_uint<8> data_) {
	
	ce->write(SC_LOGIC_1);
	wr->write(SC_LOGIC_0);
	rd->write(SC_LOGIC_0);
	addr->write(addr_);

	data_out->write("ZZZZZZZZ");

	wait(CLK_PERIOD);

	wr->write(SC_LOGIC_1);
	data_out->write(data_);
	wait(CLK_PERIOD * 3);

	ce->write(SC_LOGIC_0);
	wr->write(SC_LOGIC_0);
	data_out->write("ZZZZZZZZ");
	wait(CLK_PERIOD);

	ce->write(SC_LOGIC_Z);
	wr->write(SC_LOGIC_Z);
	rd->write(SC_LOGIC_Z);
}

void TestBench::read(unsigned int addr_, sc_uint<8>& data_) {

	ce->write(SC_LOGIC_1);
	wr->write(SC_LOGIC_0);
	rd->write(SC_LOGIC_1);
	addr->write(addr_);

	wait(CLK_PERIOD);
	data_ = data_in->read();
	wait(CLK_PERIOD);

	ce->write(SC_LOGIC_0);
	rd->write(SC_LOGIC_0);
	wait(CLK_PERIOD);

	ce->write(SC_LOGIC_Z);
	wr->write(SC_LOGIC_Z);
	rd->write(SC_LOGIC_Z);
}
