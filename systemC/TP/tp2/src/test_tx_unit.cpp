#include <systemc.h>
#include "benches.h"
#include "tx_unit.h"

void test_tx_unit(){
// GTK wave
	sc_trace_file *tf = sc_create_vcd_trace_file("tx_unit_wave");
	sc_write_comment(tf, "Simulation");
// signals
	sc_clock sys_clk ("sys_clk", 25, SC_NS);
    sc_clock en_tx ("en_tx", 104, SC_US, 0.0002);
	sc_signal<bool> reset;
    sc_signal<bool> txd, load, reg_empty, buf_empty;
    sc_signal<sc_lv<8>> data_in;
// instanciate 
    Tx_unit tx_unit("txunit");
        tx_unit.clk(sys_clk);
        tx_unit.reset(reset);
        tx_unit.enable(en_tx);
        tx_unit.load(load);
        tx_unit.reg_empty(reg_empty);
        tx_unit.buf_empty(buf_empty);
        tx_unit.data_in(data_in);
        tx_unit.txd(txd);

// GTKwave
	sc_trace(tf, sys_clk, "Clock");
    sc_trace(tf, reset, "reset");
    sc_trace(tf, en_tx, "en_tx");
    sc_trace(tf, txd, "txd");
    sc_trace(tf, load, "load");
    sc_trace(tf, reg_empty, "reg_empty");
    sc_trace(tf, buf_empty, "buf_empty");
    sc_trace(tf, data_in, "data_in");
    sc_trace(tf, tx_unit.reg, "reg");

    reset.write(false);
    load.write(false);
    sc_start(100, SC_NS);

    reset.write(true);
    load.write(true);
    data_in.write("00101000");
    sc_start(120, SC_US);

    load.write(false);
    sc_start(120, SC_US);
    load.write(true);
    data_in.write("01111100");
    sc_start(120, SC_US);
    load.write(false);
    sc_start(4000, SC_US);

	sc_close_vcd_trace_file(tf);
				
}