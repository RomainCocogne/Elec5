
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>	// mmap/munmap
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>	// ioctl 

#include "mydevice.h"

void ioctl_start_perf(int file_desc){
  ioctl(file_desc, IOCTL_PERFMON_START, "");
}

void ioctl_stop_perf(int file_desc){
  ioctl(file_desc, IOCTL_PERFMON_STOP, "");
}


void ioctl_set_msg(int file_desc, char* msg){
  ioctl(file_desc, IOCTL_SET_MSG, msg);
}

void ioctl_get_msg(int file_desc, char* msg){
  ioctl(file_desc, IOCTL_GET_MSG, msg);
  printf("Msg got : %s\n",msg);
}

int main()
{
  int mydevice_file; 
  char msg_passed[MAX_BUFFER_SIZE] = "Hello World !!";
  char msg_received[MAX_BUFFER_SIZE] = ""; 
  int msg_length; 
  int ret_val;

  msg_length = strlen(msg_passed) + 1;

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
  ioctl_start_perf(mydevice_file);
  for (int i = 0; i < 100; i++)
   ioctl_set_msg(mydevice_file, msg_passed);
  ioctl_stop_perf(mydevice_file);
  ioctl_get_msg(mydevice_file, msg_received);
  close(mydevice_file);

  return 0;
}

