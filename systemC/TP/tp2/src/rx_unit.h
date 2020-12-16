#ifndef _RX_H_
#define _RX_H_

#include <systemc.h>

SC_MODULE(Rx_unit){
    static const uint8_t DATA_WIDTH = 8;
    sc_in_clk clk;
    sc_in<bool> reset;
    sc_in<bool> enable;
    sc_in<bool> read;
    sc_in<bool> rxd;

    sc_out<sc_lv<DATA_WIDTH>> data_out;
    sc_out<bool> data_rdy;
    sc_out<bool> frame_err;
    sc_out<bool> output_err;
    

    // Registres internes
    uint8_t buff_out;
    uint8_t shift_reg;
    uint8_t bit_count;
    uint8_t sample_count;

    SC_CTOR(Rx_unit){
        SC_METHOD(rxUpdate);
        sensitive << clk.pos() << reset.neg();
    }

    void rxUpdate(){
        if (reset->read() == 0){
        sample_count = 0;
        bit_count = 10;
        data_rdy->write(0);
        frame_err->write(0);
        output_err->write(0);
        data_out->write(0x00);
        } else {
        if (enable->read() == true){
            // Attente du 8éme ech.
            sample_count++;
            if(sample_count == 8){
            // lecture du char
            if (bit_count == 10){
                // attente du bit start
                if (rxd->read() == false){
                // Start detecté
                bit_count--;
                }
            } else if (bit_count > 1){
                // 8 data bits 
                shift_reg = shift_reg >> 1;
                shift_reg |= rxd->read() << 7;
                bit_count--;
            } else if (bit_count > 0){
                // check stop bit 
                if (rxd->read() == true){
                // stop bit à 1 --> transmission finie
                buff_out = shift_reg;
                if (data_rdy->read()){
                    // Donnée précédente va être écrasée --> output_err
                    output_err->write(true);
                }
                data_rdy->write(true);
                } else {
                // stop bit à 0 --> frame error
                frame_err->write(true);
                }
                bit_count = 10;

            } else {

            }
            } else if (sample_count == 16){
            sample_count = 0;
            }
        }
        //Need to read data ?
        if (read->read()){
            data_rdy->write(false);
            frame_err->write(false);
            output_err->write(false);
            data_out = buff_out;
        }
        }
    }
};

#endif