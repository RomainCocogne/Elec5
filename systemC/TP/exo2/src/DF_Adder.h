#ifndef _DFADDER_H_
#define _DFADDER_H_

#include <systemc.h>

SC_MODULE(DF_Adder){

    sc_fifo_in<double> const_value;
    sc_fifo_in<double> feedback;

    sc_fifo_out<double> added_value;

    SC_CTOR(DF_Adder){
        SC_THREAD(DF_Adder_thread);
    }
    void DF_Adder_thread();

};

#endif