# -*- coding: utf-8 -*-

import serial as s
import numpy as np
import matplotlib.pyplot as plt
import datetime as dt



def initSerial(baudrate, port):
    ser = s.Serial()
    ser.baudrate = baudrate
    ser.port = port
    ser.timeout = 10
    return ser


NB_FRAME = 1000
frame = []

ser = initSerial(9600, "COM18")
ser.close()
ser.open()
t = np.array(dt.datetime.now())

file = open("log/log_data.csv", "w")

keepalive = '1';

while(keepalive != '0'):
    if ser.inWaiting():
         date = dt.datetime.now()
         frame_str = str(ser.readline())[2:]
         t = np.append(t, date)
         buff = frame_str.split(';')
         frame.append([buff[0], buff[1]]) 
         keepalive = buff[2]
         csv_string = str(date.time()) + "," + str(buff[0]) + '\n'
         print(csv_string)
         file.write(csv_string)
         
file.close()
ser.close()
plt.show()


