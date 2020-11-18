#ifndef _USER_H_
#define _USER_H_

#include <iostream>
#include <systemc.h>

SC_MODULE(user){
  sc_out<double> period;
  sc_out<bool> reset;
  sc_out<bool> up_down;
  sc_out<bool> load;
  sc_out<int> data_out;
  
  SC_CTOR(user): period("period"), reset("reset"), up_down("up_down"), load("load"), data_out("data_out"){
    SC_THREAD (user_thread);
  }
  
  void user_thread();

};


#endif
