#include <systemc.h>
#include "memory.h"

#define ADDR_SIZE 16
#define WORD_SIZE 8
#define MEM_SIZE 32

int sc_main(int argc, char* argv[]) {
// GTK wave
	sc_trace_file *tf = sc_create_vcd_trace_file("wave");
	sc_write_comment(tf, "Simulation");
// signals
	sc_clock clk ("clk", 1, SC_MS);
    sc_signal<bool> enable;
    sc_signal<bool> rd_we;
    sc_signal<sc_uint<ADDR_SIZE>> addr;

    sc_signal<sc_lv<WORD_SIZE>> data_in;
    sc_signal<sc_lv<WORD_SIZE>> data_out;
// instanciate mem
	Memory<ADDR_SIZE, WORD_SIZE, MEM_SIZE> memory_inst ("Memory1");
		memory_inst.clk(clk);
		memory_inst.enable(enable);
		memory_inst.rd_we(rd_we);
		memory_inst.addr(addr);
		memory_inst.data_in(data_in);
		memory_inst.data_out(data_out);
// GTKwave
	sc_trace(tf, clk, "Clock");
	sc_trace(tf, rd_we, "read_write");
	sc_trace(tf, enable, "enable");
	sc_trace(tf, addr, "addr");
	sc_trace(tf, data_in, "data_in");
	sc_trace(tf, data_out, "data_out");

// write 3 at addr 7
	addr.write(0x07);
	enable.write(true);
	rd_we.write(true);
	data_in.write("00000011");
	sc_start(5, SC_MS);
// write B at addr 9 (but enable = false)
	addr.write(0x09);
	enable.write(false);
	rd_we.write(true);
	data_in.write("00001011");
	sc_start(5, SC_MS);
// read 3 at addr 7
	addr.write(0x07);
	enable.write(true);
	rd_we.write(false);
	sc_start(5, SC_MS);
// write 8 at addr A
	addr.write(0x0a);
	rd_we.write(true);
	data_in.write("00001000");
	sc_start(5, SC_MS);
// read x at addr 9
	addr.write(0x09);
	rd_we.write(false);
	sc_start(5, SC_MS);
// read 8 at addr A
	addr.write(0x0a);
	sc_start(5, SC_MS);

	sc_close_vcd_trace_file(tf);
				
	return 0;
}


