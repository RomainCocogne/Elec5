/* The declarations here have to be in a header file, because
 *  they need to be known both to the kernel module
 *  (in mydevice.c) and the process calling ioctl (test_driver.c) */

#include <linux/ioctl.h>

#define LEDS_MAJOR 255
#define LEDS_PATH "/dev/leds"
#define MAX_BUFFER_SIZE 100

#define GPIO_DATA_ADDR (XPAR_LEDS_8BIT_BASEADDR + 0x00)
#define GPIO_TRI_ADDR  (XPAR_LEDS_8BIT_BASEADDR + 0x04)

#define XPAR_LEDS_8BIT_BASEADDR 0x41200000
#define GPIO_DATA (*((unsigned int*)GPIO_DATA_ADDR))
#define GPIO_TRI (*((unsigned int*)GPIO_TRI_ADDR))
