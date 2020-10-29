/* Character driver example with IOCTL*/
/* June 23 2011 */
/* Sébastien Bilavarn */
/* Polytech'Nice Sophia / University of Nice Spophia Antipolis */

/* Necessary includes for device drivers */
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>   /* printk() */

#include <linux/slab.h>     /* kmalloc() */
#include <linux/fs.h>       /* everything... */
#include <linux/errno.h>    /* error codes */
#include <linux/types.h>    /* size_t */
#include <linux/proc_fs.h> 
#include <linux/fcntl.h>    /* O_ACCMODE */
#include <linux/uaccess.h>  /* copy_from/to_user */

#include "mydevice.h"

MODULE_LICENSE("Dual BSD/GPL");

/* Declaration of mydevice.c functions */
int mydevice_open(struct inode *inode, struct file *filp);
int mydevice_release(struct inode *inode, struct file *filp);
ssize_t mydevice_read(struct file *filp, char *buf, size_t count, loff_t *f_pos);
ssize_t mydevice_write(struct file *filp, const char *buf, size_t count, loff_t *f_pos);
void mydevice_exit(void);
int mydevice_init(void);
long mydevice_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param); 
void perfmon_ioctl_start(void);
void perfmon_ioctl_stop(void);

/* Structure that declares the usual file */
/* access functions */
struct file_operations mydevice_fops = {
  .read = mydevice_read,
  .write = mydevice_write,
  .unlocked_ioctl = mydevice_ioctl, 
  .open = mydevice_open,
  .release = mydevice_release
};

/* Declaration of the init and exit functions */
module_init(mydevice_init);
module_exit(mydevice_exit);

/* Global variables of the driver */
/* Buffer to store data */
char *mydevice_buffer;

int mydevice_init(void) {
  int result;

  /* Registering device */
  result = register_chrdev(MYDEVICE_MAJOR, "mydevice", &mydevice_fops);
  if (result < 0) {
   printk(
   "<1>mydevice: cannot obtain major number %d\n", MYDEVICE_MAJOR);
   return result;
  }

  /* Allocating mydevice for the buffer */
  mydevice_buffer = kmalloc(MAX_BUFFER_SIZE, GFP_KERNEL); 
  if (!mydevice_buffer) { 
   result = -ENOMEM;
   goto fail; 
  } 
  memset(mydevice_buffer, 0, 1);

  printk("<1>Inserting mydevice module\n"); 
  return 0;

  fail: 
   mydevice_exit(); 
   return result;
}

void mydevice_exit(void) {
  /* Freeing the major number */
  unregister_chrdev(MYDEVICE_MAJOR, "mydevice");

  /* Freeing buffer mydevice */
  if (mydevice_buffer) {
   kfree(mydevice_buffer);
  }

  printk("<1>Removing mydevice module\n");

}

int mydevice_open(struct inode *inode, struct file *filp) {

  /* Success */
  return 0;
}

int mydevice_release(struct inode *inode, struct file *filp) {

  /* Success */
  return 0;
}

ssize_t mydevice_read(struct file *filp, char *buf, size_t count, loff_t *f_pos) { 
  int ret_val; 
  int msg_length; 
	
  /* Transfering data to user space */ 
  ret_val = copy_to_user(buf, mydevice_buffer, MAX_BUFFER_SIZE);
  msg_length = strlen(mydevice_buffer);
  printk("MYDEVICE_READ: message sent to userspace -> %s\n", mydevice_buffer);
	
  return count;
}

ssize_t mydevice_write(struct file *filp, const char *buf,size_t count, loff_t *f_pos) {
  int ret_val; 

  /* Transfering data from user space */ 
  ret_val = copy_from_user(mydevice_buffer, buf, count);
  printk("MYDEVICE_WRITE: message received by kernel -> %s\n", mydevice_buffer);

  return count;
}

/*
void testcounters(void) {
  u32 val1 = 0; 
  u32 val2 = 0;

  // Disable all individual counters
  asm volatile("mov r0, #0x8000000F");
  asm volatile("mcr p15, 0, r0, c9, c12, 2");

  // Disable the PMNC
  asm volatile("MRC p15, 0, r0, c9, c12, 0"); // Read PMNC
  asm volatile("ORR r0, r0, #0x0"); // Disable
  asm volatile("MCR p15, 0, r0, c9, c12, 0"); // Write PMNC

  // Select register and event
  asm volatile("mov r0, #0x0");
  asm volatile("mcr p15, 0, r0, c9, c12, 5");
  asm volatile("mov r0, #0x55");
  asm volatile("mcr p15, 0, r0, c9, c13, 1");

  // Enable all individual counters
  asm volatile("mov r0, #0x8000000F");
  asm volatile("mcr p15, 0, r0, c9, c12, 1");

  // Enable PMNC
  asm volatile("MRC p15, 0, r0, c9, c12, 0"); // Read PMNC
  asm volatile("ORR r0, r0, #0x7"); // Enable and re-set
  asm volatile("MCR p15, 0, r0, c9, c12, 0"); // Write PMNC

  // Read CCNT (Cycle CouNT) Register
  asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (val1));
  printk(" CCNT = 0x%08x\n", val1);

  // Run test function
  printk("<1>Profiling printk!\n");

  // Read CCNT (Cycle CouNT) Register
  asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (val2));
  printk(" CCNT = 0x%08x\n", val2);

  printk(" EXEC TIME  = %d CYCLES\n", val2-val1);
}
*/
u32 val1 = 0; 
u32 val2 = 0;
void perfmon_ioctl_start(void){

  // Disable all individual counters
  asm volatile("mov r0, #0x8000000F");
  asm volatile("mcr p15, 0, r0, c9, c12, 2");

  // Disable the PMNC
  asm volatile("MRC p15, 0, r0, c9, c12, 0"); // Read PMNC
  asm volatile("ORR r0, r0, #0x0"); // Disable
  asm volatile("MCR p15, 0, r0, c9, c12, 0"); // Write PMNC

  // Select register and event
  asm volatile("mov r0, #0x0");
  asm volatile("mcr p15, 0, r0, c9, c12, 5");
  asm volatile("mov r0, #0x55");
  asm volatile("mcr p15, 0, r0, c9, c13, 1");

  // Enable all individual counters
  asm volatile("mov r0, #0x8000000F");
  asm volatile("mcr p15, 0, r0, c9, c12, 1");

  // Enable PMNC
  asm volatile("MRC p15, 0, r0, c9, c12, 0"); // Read PMNC
  asm volatile("ORR r0, r0, #0x7"); // Enable and re-set
  asm volatile("MCR p15, 0, r0, c9, c12, 0"); // Write PMNC
  
  // Run test function
  printk("<1>Start Profiling!\n");
  // Read CCNT (Cycle CouNT) Register
  asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (val1));
  printk(" CCNT = 0x%08x\n", val1);
}

void perfmon_ioctl_stop(void){

  // Read CCNT (Cycle CouNT) Register
  asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (val2));
  printk(" CCNT = 0x%08x\n", val2);

  printk(" EXEC TIME  = %d CYCLES\n", val2-val1);
}

long mydevice_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param) { 
  switch(ioctl_num){
  case IOCTL_SET_MSG:
    copy_from_user(mydevice_buffer, (char*)(ioctl_param), MAX_BUFFER_SIZE);
    printk("IOCTL_SET_MSG: messgae ste to mydevice->%s\n", mydevice_buffer);
    break;
  case IOCTL_GET_MSG:
    copy_to_user((char*)(ioctl_param), mydevice_buffer, MAX_BUFFER_SIZE);
    printk("IOCTL_GET_MSG: message got from mydevice->%s\n",mydevice_buffer);
    break;
  case IOCTL_PERFMON_START:
      perfmon_ioctl_start();
    break;
  case IOCTL_PERFMON_STOP:
      perfmon_ioctl_stop();
    break;
  default:;
}
  return 0;
}

