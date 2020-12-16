#include <systemc.h>
#include "clk_unit.h"
#include "tx_unit.h"
#include "rx_unit.h"
#include "uart.h"
#include "testbench.h"

const uint16_t TX_PERIOD = 4167;
const uint16_t RX_PERIOD = 260;

void test_miniuart() {
	// Declare signal
	sc_signal<bool> sys_clk;
	sc_signal<bool> reset;
    sc_signal_resolved ce, rd, wr;
    sc_signal<bool> rtxd;
    sc_signal_rv<8> data_in, data_out;
    sc_signal_rv<2> addr;
    sc_signal<bool> irqRx, irqTx;
	// Deaclare MiniUart
	Uart_unit uart_unit("uartunit", TX_PERIOD, RX_PERIOD);
        uart_unit.clk(sys_clk);
        uart_unit.reset(reset);
        uart_unit.data_in(data_in);
        uart_unit.data_out(data_out);
        uart_unit.addr(addr);
        uart_unit.rxd(rtxd);
        uart_unit.txd(rtxd);
        uart_unit.ce(ce);
        uart_unit.rd(rd);
        uart_unit.wr(wr);
        uart_unit.irqRx(irqRx);
        uart_unit.irqTx(irqTx);

	// Declare TestBench
	TestBench TestBench_inst("TestBench");
		TestBench_inst.sys_clk(sys_clk);
        TestBench_inst.reset(reset);
        TestBench_inst.data_in(data_out);
        TestBench_inst.data_out(data_in);
        TestBench_inst.addr(addr);
        TestBench_inst.ce(ce);
        TestBench_inst.rd(rd);
        TestBench_inst.wr(wr);
        TestBench_inst.irqRX(irqRx);
        TestBench_inst.irqTX(irqTx);

	// Trace
	sc_trace_file *tf = sc_create_vcd_trace_file("wave_miniuart");
	sc_write_comment(tf, "Simulation of Mini Uart");
	//tf->set_time_unit(1, SC_NS);
	sc_trace(tf, sys_clk, "Clock");
    sc_trace(tf, reset, "reset");
    sc_trace(tf, data_in, "data_in");
    sc_trace(tf, data_out, "data_out");
    sc_trace(tf, addr, "addr");
    sc_trace(tf, rtxd, "rtxd");
    sc_trace(tf, ce, "ce");
    sc_trace(tf, rd, "rd");
    sc_trace(tf, wr, "wr");
    sc_trace(tf, irqRx, "irqRx");
    sc_trace(tf, irqTx, "irqTx");

	// Run simulation
	sc_start(8, SC_MS);

	// Close Trace
	sc_close_vcd_trace_file(tf);
}
