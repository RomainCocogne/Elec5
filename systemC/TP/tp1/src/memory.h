#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <systemc.h>

template <int ADDR_SIZE, int WORD_SIZE, int MEM_SIZE>
SC_MODULE(Memory){

    sc_in_clk clk;
    sc_in<bool> enable;
    sc_in<bool> rd_we;
    sc_in<sc_uint<ADDR_SIZE>> addr;

    sc_in<sc_lv<WORD_SIZE>> data_in;
    sc_out<sc_lv<WORD_SIZE>> data_out;

    sc_lv<WORD_SIZE> mem[MEM_SIZE];

    SC_CTOR(Memory){
        SC_METHOD(mem_update);
            sensitive << clk.neg();
    }
    
    void mem_update(){
        if (enable->read()){
            if(rd_we->read()){
                if (addr->read() < MEM_SIZE)
                    mem[addr->read()] = data_in->read();
                //else data_out->write(sc_logic_X);
            } else {
                if (addr->read() < MEM_SIZE)
                    data_out->write(mem[addr->read()]);
                //else data_out->write(sc_logic_X);
            }
        } 
        //else {
        //     data_out->write(sc_logic_Z);
        // }
    }
};

#endif