obj-m = mydevice.o

KVERSION=$(shell uname -r)

all:
	make -C /home/gse5/Zedboard/linux-xlnx-master M=$(PWD) modules
	arm-linux-gnueabihf-gcc -o test_driver test_driver.c -static

clean:
	make -C /home/gse5/Zedboard/linux-xlnx-master M=$(PWD) clean
	rm -rf test_driver

