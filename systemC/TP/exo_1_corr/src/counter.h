#ifndef _COUNTER_H_
#define _COUNTER_H_

#include <systemc.h>

SC_MODULE(counter) {
    sc_in<double> period;
    sc_in<bool> reset,up_down,load;
    sc_in<int> data_in;
    sc_out<int> Q;
    

    SC_CTOR(counter) : period("period"), reset("reset"),up_down("up_down") {
        SC_THREAD(counter_thread);
    }
    
    void counter_thread();     
   
};

#endif
