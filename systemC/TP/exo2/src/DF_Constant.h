#ifndef _DF_CONSTANT_H_
#define _DF_CONSTANT_H_

#include <systemc>

SC_MODULE(DF_Constant){
    sc_fifo_out<double> const_value;

    const double cte;

    SC_HAS_PROCESS(DF_Constant);
    DF_Constant(sc_module_name name, const double _cte): sc_module(name), cte(_cte){
        SC_THREAD(DF_Constant_thread);
    }

    void DF_Constant_thread();

};

#endif