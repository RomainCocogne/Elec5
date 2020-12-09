#include "DF_Fork.h"

void DF_Fork::DF_Fork_thread(){
    double v;

    while(true){
        v = added_value->read();
        
        wait(10, SC_NS);

        result->write(v);
        feedback->write(v);
        std::cout << sc_time_stamp() << " : return " << v << std::endl;
    }
}