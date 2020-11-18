#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
MODULE_LICENSE("Dual BSD/GPL");
int hello_init(void);
void hello_exit(void); 
module_init(hello_init); 
module_init(hello_init);
module_exit(hello_exit);
int hello_init(void) { 
	printk("<1> Hello world!\n"); return 0;
} 
void hello_exit(void) {
	printk("<1> Bye, cruel world\n");
} 