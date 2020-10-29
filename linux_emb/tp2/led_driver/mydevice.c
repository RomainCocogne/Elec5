/* Character driver example */
/* June 23 2011 */
/* Sébastien Bilavarn */
/* Polytech'Nice Sophia / University of Nice Spophia Antipolis */

/* Necessary includes for device drivers */
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h> /* printk() */

#include <linux/slab.h> /* kmalloc() */
#include <linux/fs.h> /* everything... */
#include <linux/errno.h> /* error codes */
#include <linux/types.h> /* size_t */
#include <linux/proc_fs.h> 
#include <linux/fcntl.h> /* O_ACCMODE */
#include <linux/uaccess.h> /* copy_from/to_user */

#include "leds.h"

MODULE_LICENSE("Dual BSD/GPL");

/* Declaration of mydevice.c functions */
int mydevice_open(struct inode *inode, struct file *filp);
int mydevice_release(struct inode *inode, struct file *filp);
ssize_t mydevice_read(struct file *filp, char *buf, size_t count, loff_t *f_pos);
ssize_t mydevice_write(struct file *filp, const char *buf, size_t count, loff_t *f_pos);
void mydevice_exit(void);
int mydevice_init(void);
long mydevice_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param); 

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

  int msg_length; 
	
  /* Transfering data to user space */ 
  copy_to_user(buf, mydevice_buffer, MAX_BUFFER_SIZE);
  msg_length = strlen(mydevice_buffer);
  printk("MYDEVICE_READ: message sent to userspace -> %s\n", mydevice_buffer);
	
  return count;
}

ssize_t mydevice_write(struct file *filp, const char *buf, size_t count, loff_t *f_pos) {
	
  /* Transfering data from user space */ 
  copy_from_user(mydevice_buffer, buf, count);
  printk("MYDEVICE_WRITE: message received by kernel -> %s\n", mydevice_buffer);

  return count;

}

long mydevice_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param) {

  return 0;
}

