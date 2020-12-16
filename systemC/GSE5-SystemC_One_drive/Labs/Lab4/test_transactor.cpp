#include <systemc.h>
#include "transactor_bench.h"

void test_transactor() {
	Transactor_Bench Transactor_Bench_inst("Transactor_Bench");

	sc_trace_file *tf = sc_create_vcd_trace_file("wave_transactor");
	sc_write_comment(tf, "Simulation of MiniUart with Transactor");

	Transactor_Bench_inst.trace(tf);

	sc_start(8, SC_MS);

	sc_close_vcd_trace_file(tf);
}
