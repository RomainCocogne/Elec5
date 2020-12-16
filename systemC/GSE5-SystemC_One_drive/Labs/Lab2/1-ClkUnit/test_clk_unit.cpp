#include <systemc.h>
#include "clk_unit.h"

void test_clk_unit() {
	// Declare signal
	sc_clock clk("clk",25,SC_NS);	// 40MHz
	...
	
	// Declare ClkUnit
	ClkUnit ClkUnit_inst("ClkUnit");
		...

	// Trace
	sc_trace_file *tf = sc_create_vcd_trace_file("wave_clkunit");
	sc_write_comment(tf, "Simulation of Clk Unit");
	tf->set_time_unit(1, SC_NS);
	...

	cout << "simulation ..."  << endl;

	for (int i=0; i<5; i++) {
		sc_start(1, SC_MS);
		cout << ".";
	}
	cout << endl;

	// CLose Trace
	sc_close_vcd_trace_file(tf);
}
