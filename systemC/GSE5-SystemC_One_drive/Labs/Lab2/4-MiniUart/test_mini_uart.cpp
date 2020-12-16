#include <systemc.h>
#include "clk_unit.h"
#include "tx_unit.h"
#include "rx_unit.h"
#include "mini_uart.h"
#include "testbench.h"

void test_miniuart() {
	// Declare signal
	sc_signal<bool> sys_clk, reset, irqRX, irqTX, txd_rxd;
	sc_signal_resolved ce, rd, wr;
	sc_signal_rv<2> addr;
	...

	// Deaclare MiniUart
	MiniUart MiniUart_inst("MiniUart");
		...	

	// Declare TestBench
	TestBench TestBench_inst("TestBench");
		...	

	// Trace
	sc_trace_file *tf = sc_create_vcd_trace_file("wave_miniuart");
	sc_write_comment(tf, "Simulation of Mini Uart");
	tf->set_time_unit(1, SC_NS);
	...

	// Run simulation
	sc_start(8, SC_MS);

	// Close Trace
	sc_close_vcd_trace_file(tf);
}
