
#include <systemc>
#include "DF_Constant.h"

void DF_Constant::DF_Constant_thread(){
    while(true){
        wait(1, SC_MS);
        const_value->write(cte);

        std::cout << sc_time_stamp() << " : DF_Constant : send value " << cte << std::endl;
    }
}