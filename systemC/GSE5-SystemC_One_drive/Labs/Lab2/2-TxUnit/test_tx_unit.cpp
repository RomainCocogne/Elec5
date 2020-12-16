#include <systemc.h>
#include "clk_unit.h"
#include "tx_unit.h"

void test_tx_unit() {
	// Declare signals
	sc_clock clk("clk",25,SC_NS);
	...
	
	// Declare ClkUnit
	ClkUnit ClkUnit_inst("ClkUnit");
		...

	// Declare TxUnit
	TxUnit TxUnit_inst("TxUnit");
		...

	// Trace
	sc_trace_file *tf = sc_create_vcd_trace_file("wave_txunit");
	sc_write_comment(tf, "Simulation of Tx Unit");
	tf->set_time_unit(1, SC_NS);
	...

	// Reset
	cout << sc_time_stamp() << ": " << "Reset ..." << endl;
	load.write(false);
	reset.write(true);
	sc_start(1, SC_US);
	reset.write(false);
	sc_start(1, SC_US);

	// Send 0x11 during 10 us
	cout << sc_time_stamp() << ": " << "Load ..." << endl;
	tx_data.write(0x11);
	load.write(true);
	sc_start(10, SC_US);
	load.write(false);
	sc_start(10, SC_US);

	// Send 0x22 and 0x33 without transition (... b7,Stop,Start,b0...)



	sc_close_vcd_trace_file(tf);
}
