#include <systemc.h>
#include "benches.h"
#include "rx_unit.h"
#include "tx_unit.h"

void test_rx_unit(){
// GTK wave
	sc_trace_file *tf = sc_create_vcd_trace_file("rx_unit_wave");
	sc_write_comment(tf, "Simulation");
// signals
	sc_clock sys_clk ("sys_clk", 25, SC_NS);
    sc_clock en_rx ("en_rx", 6.5, SC_US, 0.002);
    sc_clock en_tx ("en_tx", 104, SC_US, 0.0002);
	sc_signal<bool> reset;
    sc_signal<bool> frame_err, output_err, data_rdy, read;
    sc_signal<bool> txd, load, reg_empty, buf_empty;
    sc_signal<sc_lv<8>> data_out, data_in;
// instanciate 
    Rx_unit rx_unit("rxunit");
        rx_unit.clk(sys_clk);
        rx_unit.reset(reset);
        rx_unit.enable(en_rx);
        rx_unit.data_out(data_out);
        rx_unit.frame_err(frame_err);
        rx_unit.output_err(output_err);
        rx_unit.data_rdy(data_rdy);
        rx_unit.rxd(txd);
        rx_unit.read(read);
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
    sc_trace(tf, en_rx, "en_rx");
    sc_trace(tf, txd, "rxd");
    sc_trace(tf, read, "read");
    sc_trace(tf, frame_err, "frame_err");
    sc_trace(tf, output_err, "output_err");
    sc_trace(tf, data_rdy, "data_rdy");
    sc_trace(tf, data_in, "data_in");
    sc_trace(tf, data_out, "data_out");

    reset.write(false);
    load.write(false);
    read.write(false);
    sc_start(100, SC_NS);

    reset.write(true);
    load.write(true);
    data_in.write("00101000");
    sc_start(120, SC_US);

    load.write(false);
    sc_start(120, SC_US);
    read.write(false);
    load.write(true);
    data_in.write("01111100");
    sc_start(120, SC_US);
    load.write(false);
    sc_start(1000, SC_US);
    read.write(true);
    sc_start(500, SC_US);
    read.write(false);
    sc_start(3000, SC_US);
	sc_close_vcd_trace_file(tf);
				
}