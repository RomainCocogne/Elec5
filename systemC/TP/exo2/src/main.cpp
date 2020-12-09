#include <systemc.h>
#include "DF_Adder.h"
#include "DF_Constant.h"
#include "DF_Display.h"
#include "DF_Fork.h"

int sc_main(int argc, char* argv[]) {

	sc_fifo<double> const_value, added_value, feedback, result;

	DF_Constant DF_Constant_inst("DF_Constant_inst", 5);
		DF_Constant_inst.const_value(const_value);

	DF_Adder DF_Added_inst("DF_Added_inst");
		DF_Added_inst.const_value(const_value);
		DF_Added_inst.added_value(added_value);
		DF_Added_inst.feedback(feedback);

	DF_Fork DF_Fork_inst("DF_Fork_inst");
		DF_Fork_inst.result(result);
		DF_Fork_inst.feedback(feedback);
				
	DF_Display DF_Display_inst("DF_Display_inst");
		DF_Display_inst.result(result);

	std::cout << "Start" << std::endl;
	feedback.write(0);
	sc_start(100, SC_MS);
	std::cout << sc_time_stamp() << std::endl;

	return 0;
}


