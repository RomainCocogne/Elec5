#include <systemc.h>
#include "benches.h"
#include "uart.h"

const uint16_t TX_PERIOD = 4167;
const uint16_t RX_PERIOD = 260;

void test_uart_unit(){
// GTK wave
	sc_trace_file *tf = sc_create_vcd_trace_file("uart_unit_wave");
	sc_write_comment(tf, "Simulation");
// signals
	sc_clock sys_clk ("sys_clk", 25, SC_NS);
	sc_signal<bool> reset;
    sc_signal<sc_logic> ce, rd, wr;
    sc_signal<bool> rtxd;
    sc_signal<sc_lv<8>> data_in, data_out;
    sc_signal<sc_lv<2>> addr;
    sc_signal<bool> irqRx, irqTx;
// instanciate 
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

// GTKwave
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
    sc_trace(tf, uart_unit.buf_empty, "buf_empty");
    sc_trace(tf, uart_unit.reg_empty, "reg_empty");

    reset.write(false);
    sc_start(100, SC_NS);
    reset.write(true);
    sc_start(300, SC_US);

    addr.write("00");
    data_in.write("00100111");
    ce.write(sc_dt::SC_LOGIC_1);
    wr.write(sc_dt::SC_LOGIC_1);
    rd.write(sc_dt::SC_LOGIC_0);
    sc_start(500, SC_US);
    ce.write(sc_dt::SC_LOGIC_0);
    wr.write(sc_dt::SC_LOGIC_0);
    sc_start(1500, SC_US);
    ce.write(sc_dt::SC_LOGIC_1);
    rd.write(sc_dt::SC_LOGIC_1);
    sc_start(1500, SC_US);

	sc_close_vcd_trace_file(tf);
				
}