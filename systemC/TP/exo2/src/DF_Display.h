#ifndef _DDISPLAY_H_
#define _DDISPLAY_H_

#include <systemc.h>

SC_MODULE(DF_Display){

    sc_fifo_in<double> result;
    const int n;

    SC_HAS_PROCESS(DF_Display);
    DF_Display(sc_module_name inst_name, const int n); sc_module(inst_name), n(n){
        SC_THREAD(DF_Display_thread);
    }
    void DF_Display_thread();

};

#endif