#ifndef _TX_H_
#define _TX_H_

#include <systemc.h>



SC_MODULE(Tx_unit){
    static const uint8_t DATA_WIDTH = 8;
    sc_in_clk clk;
    sc_in<bool> reset;
    sc_in<bool> enable;
    sc_in<bool> load;
    sc_in<sc_lv<DATA_WIDTH>> data_in;
    
    sc_out<bool> reg_empty;
    sc_out<bool> buf_empty;
    sc_out<bool> txd;

    sc_lv<DATA_WIDTH> reg;
    sc_lv<DATA_WIDTH> buf;
    uint8_t idx;

    SC_CTOR(Tx_unit){
        SC_METHOD(update_reg);
            sensitive << clk.pos() << reset.neg();
        idx = 0;
    }
    void update_reg(){
        if (reset->read() == false){
            txd->write(true);
            reg_empty->write(true);
            buf_empty->write(true);
        } else {
            if (load->read()){
                buf = data_in->read();
                buf_empty->write(false);
            } else {
                if (reg_empty->read() && !buf_empty->read()){
                    reg = buf;
                    reg_empty->write(false);
                    buf_empty->write(true);
                }
            }
            if (enable->read() && !reg_empty->read()){
                if (idx == 9){
                    idx = 0;
                    reg_empty->write(true);
                    txd->write(1);
                } else if (idx == 0){
                    txd->write(0);
                    idx++;
                } else {
                    txd->write(reg.get_bit(idx-1));
                    idx++;
                }
            }
        }
    }
};

#endif