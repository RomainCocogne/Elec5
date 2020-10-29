
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>	// mmap/munmap
#include <unistd.h>
#include <fcntl.h>

#include "mydevice.h"

/* This function sends a message to the kernel */
void ioctl_set_msg(int file_desc, char *message)
{

}

/* This function reads a message from the kernel */
/* and just printk the message in kernel space */
void ioctl_get_msg(int file_desc)
{

}


int main()
{
  int mydevice_file; 
  char *msg_passed = "Hello World !!\n";
  char *msg_received; 
  int msg_length; 

  msg_length = strlen(msg_passed); 
  msg_received = malloc(msg_length); 

  mydevice_file = open(MYDEVICE_PATH, O_RDWR);
  if (mydevice_file == -1) 
  { 
    printf("ERROR OPENING FILE %s\n", MYDEVICE_PATH); 
    exit(EXIT_FAILURE); 
  }

  // BASIC WRITE/READ TEST
  write(mydevice_file, msg_passed, msg_length);  
  read(mydevice_file, msg_received, msg_length); 
  printf("write/read test: %s\n", msg_received);

  // IOCTL TEST
  ioctl_set_msg(mydevice_file, msg_passed);
  ioctl_get_msg(mydevice_file);

  close(mydevice_file);


  return 0;
}

