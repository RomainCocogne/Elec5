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
#include <linux/ioport.h> 
#include <asm/io.h> 
#include <linux/uaccess.h> /* copy_from/to_user */

#include "leds.h"

MODULE_LICENSE("Dual BSD/GPL");



/* Declaration of leds.c functions */
int leds_open(struct inode *inode, struct file *filp);
int leds_release(struct inode *inode, struct file *filp);
ssize_t leds_read(struct file *filp, char *buf, size_t count, loff_t *f_pos);
ssize_t leds_write(struct file *filp, const char *buf, size_t count, loff_t *f_pos);
void leds_exit(void);
int leds_init(void);
long leds_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param); 

/* Structure that declares the usual file */
/* access functions */
struct file_operations leds_fops = {
  .read = leds_read,
  .write = leds_write,
  .unlocked_ioctl = leds_ioctl, 
  .open = leds_open,
  .release = leds_release
};

/* Declaration of the init and exit functions */
module_init(leds_init);
module_exit(leds_exit);

/* Global variables of the driver */
/* Buffer to store data */
char *leds_buffer;
void *led_data_v_address;
void *led_tri_v_address;

int leds_init(void) {
  int result;

  /* Registering device */
  result = register_chrdev(LEDS_MAJOR, "leds", &leds_fops);
  if (result < 0) {
   printk(
   "<1>leds: cannot obtain major number %d\n", LEDS_MAJOR);
   return result;
  }
  
  request_mem_region(XPAR_LEDS_8BIT_BASEADDR,8,"leds");
  led_data_v_address = ioremap(GPIO_DATA_ADDR, 4);
  led_tri_v_address = ioremap(GPIO_TRI_ADDR, 4);
  iowrite8(0x00, led_tri_v_address);     

  /* Allocating leds for the buffer */
  leds_buffer = kmalloc(MAX_BUFFER_SIZE, GFP_KERNEL); 
  if (!leds_buffer) { 
   result = -ENOMEM;
   goto fail; 
  } 
  memset(leds_buffer, 0, 1);

  printk("<1>Inserting leds module\n"); 
  return 0;

  fail: 
   leds_exit(); 
   return result;
}

void leds_exit(void) {
  /* Freeing the major number */
  unregister_chrdev(LEDS_MAJOR, "leds");
  release_mem_region(XPAR_LEDS_8BIT_BASEADDR,8);
  iounmap(led_data_v_address);
  iounmap(led_tri_v_address);
  /* Freeing buffer leds */
  if (leds_buffer) {
   kfree(leds_buffer);
  }

  printk("<1>Removing leds module\n");

}

int leds_open(struct inode *inode, struct file *filp) {

  /* Success */
  return 0;
}

int leds_release(struct inode *inode, struct file *filp) {

  /* Success */
  return 0;
}

ssize_t leds_read(struct file *filp, char *buf, size_t count, loff_t *f_pos) { 

  int msg_length; 
	
  /* Transfering data to user space */ 
  copy_to_user(buf, leds_buffer, MAX_BUFFER_SIZE);
  msg_length = strlen(leds_buffer);
  printk("leds_READ: message sent to userspace -> %s\n", leds_buffer);
	
  return count;
}

ssize_t leds_write(struct file *filp, const char *buf, size_t count, loff_t *f_pos) {
	
  /* Transfering data from user space */ 
  copy_from_user(leds_buffer, buf, count);
  printk("leds_WRITE: message received by kernel -> %s\n", leds_buffer);
  
  iowrite8((uint8_t)(*leds_buffer), led_data_v_address); 
  
  return count;

}

long leds_ioctl(struct file *filp, unsigned int ioctl_num, unsigned long ioctl_param) {

  return 0;
}

