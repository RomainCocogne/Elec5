#include "DF_Adder.h"

void DF_Adder::DF_Adder_thread(){
    while(true){
        std::cout << sc_time_stamp() << " DF_Adder: wait for reading const_value." << std::endl;
        double v1 = const_value->read();
        std::cout << sc_time_stamp() << " DF_Adder: wait for reading const_value." << std::endl;
        double v2 = feedback->read();

        wait(100, SC_NS);

        std::cout << sc_time_stamp() << "DF_Adder: result = " << v1+v2 << std::endl;
        added_value->write(v1+v2);
    }
}