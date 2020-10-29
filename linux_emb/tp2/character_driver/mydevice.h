/* The declarations here have to be in a header file, because
 *  they need to be known both to the kernel module
 *  (in mydevice.c) and the process calling ioctl (test_driver.c) */

#include <linux/ioctl.h>

#define MYDEVICE_MAJOR 255
#define MYDEVICE_PATH "/dev/mydevice"
#define MAX_BUFFER_SIZE 100


