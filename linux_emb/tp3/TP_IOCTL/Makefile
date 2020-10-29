obj-m = mydevice.o

KVERSION=$(shell uname -r)

all:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules CROSS_COMPILE=
#	make -C /media/Development/beagleboard/ubuntu/2.6-stable/KERNEL M=$(PWD) modules
	gcc -o test_driver test_driver.c
#	powerpc-linux-gcc -o test_driver test_driver.c

clean:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean CROSS_COMPILE=
#	make -C /media/Development/beagleboard/ubuntu/2.6-stable/KERNEL M=$(PWD) clean
	rm -rf test_driver
#export PATH=/media/Development/beagleboard/ubuntu/arm-2010.09/bin:$PATH
#make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi-
