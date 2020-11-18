#include "user.h"


void user::user_thread(void){
//init
  std::cout << sc_time_stamp() << " user initialisation" << std::endl;
  period->write(10);
  load->write(false);
  data_out->write(3);
  reset->write(false);
  up_down->write(false);

  wait(5, SC_NS);
  std::cout << sc_time_stamp() << " reset" << std::endl;
  reset->write(true);
  wait(15, SC_NS);

  reset->write(false);
  wait(15, SC_NS);
  std::cout << sc_time_stamp() << " load" << std::endl;
  load->write(true);

  wait(15, SC_NS);
  load->write(false);
  std::cout << sc_time_stamp() << " start count" << std::endl;
  wait(60, SC_NS);
  std::cout << sc_time_stamp() << " change up_down" << std::endl;
  up_down->write(true);
  wait(80, SC_NS);
}

