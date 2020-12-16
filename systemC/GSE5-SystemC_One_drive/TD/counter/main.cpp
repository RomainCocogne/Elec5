#include <systemc.h>
#include "user.h"
#include "counter.h"

int sc_main(int argc, char* argv[]) {

	sc_signal<bool> reset, up_down, load;
	sc_signal<int> data_in, Q;
	sc_signal<double> period_sig;
  
  // vhdl: counter_inst: counter port map(
	counter counter_inst("counter_inst");
		counter_inst.period(period_sig);	// vhdl : period => period_sig
		counter_inst.reset(reset);
		counter_inst.up_down(up_down);
		counter_inst.load(load);
		counter_inst.data_in(data_in);
		counter_inst.Q(Q);
		
	user user_inst("test_counter_inst");
		user_inst.period(period_sig);
		user_inst.reset(reset);
		user_inst.up_down(up_down);
		user_inst.load(load);
		user_inst.data_in(data_in);		

	cout << "START SIMULATION ..." <<endl;

	sc_start(400, SC_NS);

	cout << sc_time_stamp() << ": STOP SIM";
				

	return 0;
}


