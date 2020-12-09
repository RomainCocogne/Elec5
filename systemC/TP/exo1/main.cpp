#include <systemc.h>
#include "sc_counter.h"
#include "user.h"


int sc_main(int argc, char* argv[]){
  sc_signal<bool> reset, up_down, load;
  sc_signal<int> data, Q;
  sc_signal<double> period;
  
  sc_counter counter_inst("counter_inst");
    counter_inst.period(period);
    counter_inst.reset(reset);
    counter_inst.up_down(up_down);
    counter_inst.load(load);
    counter_inst.data_in(data);
    counter_inst.Q(Q);
    
  user user_inst("user_inst");
    user_inst.period(period);
    user_inst.reset(reset);
    user_inst.up_down(up_down);
    user_inst.load(load);
    user_inst.data_out(data);
    
    std::cout << "START SIMULATION" << std::endl;
    
    sc_start(400, SC_NS);
    
    std::cout << sc_time_stamp() << " STOP SIMULATION" << std::endl;
    
  
  return 0;
}
