#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <systemc.h>

SC_MODULE(Clk_unit){
    sc_in_clk clk;
    sc_in<bool> reset;
    sc_out<bool> enable_tx;
    sc_out<bool> enable_rx;

    uint16_t cnt_tx, cnt_rx;
    uint16_t tx_period, rx_period;

    SC_HAS_PROCESS(Clk_unit);
    Clk_unit(sc_module_name name, uint16_t tx_p, uint16_t rx_p): sc_module(name), tx_period(tx_p), rx_period(rx_p){
        SC_METHOD(update_tx);
            sensitive << clk.pos() << reset.neg();
        SC_METHOD(update_rx);
            sensitive << clk.pos() << reset.neg();
        cnt_tx = 0;
        cnt_rx = 0;
    }

    void update_tx(){
        if (reset->read() == false){
            enable_tx->write(false);
            cnt_tx = 0;
        } else {
            if (cnt_tx == tx_period) enable_tx->write(!enable_tx->read());
            if (enable_tx->read()) enable_tx->write(!enable_tx->read());
            ++cnt_tx;
            if (cnt_tx > tx_period) cnt_tx = 0;
        }
    }

    void update_rx(){
        if (reset->read() == false){
            enable_rx->write(false);
            cnt_rx = 0;
        } else {
            if (cnt_rx == rx_period)  enable_rx->write(!enable_rx->read());
            if (enable_rx->read()) enable_rx->write(!enable_rx->read());
            ++cnt_rx;
            if (cnt_rx > rx_period) cnt_rx = 0;
        }
    }
};

#endif