#include "counter.h"

void counter::counter_thread() {
	while(true) {
	
		// On attend la periode avant la prochaine operation
		wait(period->read(), SC_NS, reset->posedge_event());
		
		// Si reset
		if (reset->read() == true) {
			Q->write(0);
		}
		// déclenchement Period ns 
		// Si chargement d une valeur : Q prend la valeur de data_in
		else if (load->read() == true) {
			Q->write(data_in->read());
		}
		// Sinon on compte ou decompte
		else {
			// On regarde si on compte ou decompte
			if (up_down->read() == true) {
				// On compte
				Q->write((Q->read() + 1) % 10);
			}
			else {
				// On décompte
				Q->write(Q->read() == 0 ? 9 : Q->read()-1);
			}
		}

		cout << sc_time_stamp() << ": Q = " << Q->read() << endl;
		
	}
}


