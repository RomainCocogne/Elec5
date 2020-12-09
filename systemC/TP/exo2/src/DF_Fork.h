#ifndef _DFORK_H_
#define _DFORK_H_

#include <systemc.h>

SC_MODULE(DF_Fork){
    sc_fifo_in<double> added_value;

    sc_fifo_out<double> result;
    sc_fifo_out<double> feedback;

    SC_CTOR(DF_Fork){
        SC_THREAD(DF_Fork_thread);
    }
    void DF_Fork_thread();

};

#endif