
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>	// mmap/munmap
#include <unistd.h>
#include <fcntl.h>

#include "leds.h"




int main() {
  int mydevice_file; 
  char msg_passed = 0xFF;


  mydevice_file = open(LEDS_PATH, O_RDWR);
  if (mydevice_file == -1) 
  { 
    printf("ERROR OPENING FILE %s\n", LEDS_PATH); 
    exit(EXIT_FAILURE); 
  }

  // BASIC WRITE/READ TEST
  write(mydevice_file, &msg_passed, 1);  
  printf("write/read test: %d\n", 1);

  close(mydevice_file);

  return 0;
}
