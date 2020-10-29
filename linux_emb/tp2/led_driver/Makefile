obj-m = leds.o

KVERSION=$(shell uname -r)

all:
	make -C /home/gse5/Zedboard/linux-xlnx-master M=$(PWD) modules
	arm-linux-gnueabihf-gcc -o led_driver led_driver.c -static

clean:
	make -C /home/gse5/Zedboard/linux-xlnx-master M=$(PWD) clean
	rm -rf led_driver

