/* The declarations here have to be in a header file, because
 *  they need to be known both to the kernel module
 *  (in mydevice.c) and the process calling ioctl (test_driver.c) */

#include <linux/ioctl.h>

#define MYDEVICE_MAJOR 259
#define MYDEVICE_PATH "/dev/mydevice"
#define MAX_BUFFER_SIZE 100

/* Command numbers of the device driver */
#define IOCTL_SET_MSG _IOW(MYDEVICE_MAJOR, 0, char *)
#define IOCTL_GET_MSG _IOR(MYDEVICE_MAJOR, 1, char *)

#define IOCTL_PERFMON_START 45
#define IOCTL_PERFMON_STOP  31

