CC=g++
#CC=arm-linux-gnueabihf-g++

all: vector_add vector_add_opencl

vector_add_opencl: common.o vector_add_opencl.o
	$(CC) -g -o vector_add_opencl common.o vector_add_opencl.o -lOpenCL

vector_add_opencl.o: vector_add_opencl.cpp 
	$(CC) -g -c vector_add_opencl.cpp -lOpenCL
	
common.o: common.cpp 
	$(CC) -c common.cpp -lOpenCL

vector_add: vector_add.cpp 
	$(CC) -o vector_add vector_add.cpp

clean: 
	rm -r *.o vector_add_opencl vector_add
