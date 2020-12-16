#include <systemc.h>
#include "benches.h"
#include "clk_unit.h"

const uint16_t TX_PERIOD = 4167;
const uint16_t RX_PERIOD = 260;

void test_clk_unit(){
// GTK wave
	sc_trace_file *tf = sc_create_vcd_trace_file("clk_unit_wave");
	sc_write_comment(tf, "Simulation");
// signals
	sc_clock sys_clk ("sys_clk", 25, SC_NS);
	sc_signal<bool> reset;
    sc_signal<bool> en_tx, en_rx;
// instanciate 
	Clk_unit clk_unit("clkunit", TX_PERIOD, RX_PERIOD);
        clk_unit.clk(sys_clk);
        clk_unit.reset(reset);
        clk_unit.enable_tx(en_tx);
        clk_unit.enable_rx(en_rx);

// GTKwave
	sc_trace(tf, sys_clk, "Clock");
    sc_trace(tf, reset, "reset");
    sc_trace(tf, en_tx, "en_tx");
    sc_trace(tf, en_rx, "en_rx");

    reset.write(false);
    sc_start(100, SC_NS);
    reset.write(true);
    sc_start(300, SC_US);


	sc_close_vcd_trace_file(tf);
				
}