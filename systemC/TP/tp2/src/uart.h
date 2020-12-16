#ifndef _UART_H_
#define _UART_H_

#include <systemc.h>
#include "rx_unit.h"
#include "tx_unit.h"
#include "clk_unit.h"

SC_MODULE(Uart_unit){
    static const uint8_t DATA_WIDTH = 8;
    Clk_unit clk_unit;
    Rx_unit rx_unit;
    Tx_unit tx_unit;

    sc_in_clk clk;
    sc_in<bool> reset;

    sc_in<sc_logic>ce, rd, wr;
    sc_in<bool> rxd;
    sc_in<sc_lv<DATA_WIDTH>> data_in;
    sc_out<sc_lv<DATA_WIDTH>> data_out;
    sc_out<sc_lv<2>> addr;
    sc_out<bool> txd;
    sc_out<bool> irqRx, irqTx;

    sc_signal<bool> en_tx, en_rx;
    sc_signal<sc_lv<DATA_WIDTH>> rx_data, tx_data;
    sc_signal<bool> f_err, o_err, d_rdy, read;
    sc_signal<bool> load, reg_empty, buf_empty;

    sc_lv<8> ctrl_status_reg;

    SC_HAS_PROCESS(Uart_unit);
    Uart_unit(sc_module_name name, uint16_t tx_p, uint16_t rx_p): sc_module(name),
                                                                  clk_unit("clkunit", tx_p, rx_p),
                                                                  rx_unit("rxunit"),
                                                                  tx_unit("txunit"){
        clk_unit.clk(clk);
        clk_unit.reset(reset);
        clk_unit.enable_tx(en_tx);
        clk_unit.enable_rx(en_rx);

        rx_unit.clk(clk);
        rx_unit.reset(reset);
        rx_unit.enable(en_rx);
        rx_unit.data_out(rx_data);
        rx_unit.frame_err(f_err);
        rx_unit.output_err(o_err);
        rx_unit.data_rdy(d_rdy);
        rx_unit.rxd(rxd);
        rx_unit.read(read);

        tx_unit.clk(clk);
        tx_unit.reset(reset);
        tx_unit.enable(en_tx);
        tx_unit.load(load);
        tx_unit.reg_empty(reg_empty);
        tx_unit.buf_empty(buf_empty);
        tx_unit.data_in(tx_data);
        tx_unit.txd(txd);

        SC_METHOD(interfaceProcess);
            sensitive << ce << rd << wr << addr << data_in;
			dont_initialize();
        SC_METHOD(combinationnal);
            sensitive << o_err << f_err << buf_empty << reg_empty << d_rdy;
			dont_initialize();
    }
    void interfaceProcess(){
        sc_lv<4> input1;
        sc_lv<4> input2;
        //while(true){
            //wait(10, SC_NS);
            input1[0] = addr.read()[0];
            input1[1] = addr.read()[1];
            input1[2] = wr.read();
            input1[3] = ce.read();
            input2[0] = addr.read()[0];
            input2[1] = addr.read()[1];
            input2[2] = rd.read();
            input2[3] = ce.read();

            if (input1[3] == sc_logic_0 ||  input1[2] == sc_logic_0 || input1[0] == sc_logic_1 || input1[1] == sc_logic_1){
                load.write(false);
                tx_data.write("00000000");
            } else if (input1 == ("1100")){
                load.write(true);
                tx_data.write(data_in.read());
            }

            if (input2[3] == sc_logic_0 ||  input2[2] == sc_logic_0 || input2[1] == sc_logic_1){
                read.write(false);
                data_out.write("ZZZZZZZZ");
            } else if (input2 == ("1100")){
                read.write(true);
                data_out.write(rx_data.read());
            } else if (input2 == ("1101")){
                read.write(0);
                data_out.write(ctrl_status_reg);
            }
        //}
    }
    void combinationnal(){
        //while(true){
            //wait(10, SC_NS);
            ctrl_status_reg[0] = o_err.read();
            ctrl_status_reg[1] = f_err.read();
            ctrl_status_reg[2] = buf_empty.read();

            if (buf_empty.read() && !reg_empty.read()) irqTx.write(true);
            else irqTx.write(false);

            if (d_rdy.read()) irqRx.write(true);
            else irqRx.write(false);
        //}
    }
};

#endif