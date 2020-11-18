/**
* Basic integer array addition implemented in OpenCL.
* 26/05/2020 Polytech Nice Sophia GSE5
* S. Bilavarn
* Based on ARM integer array addition example
* CPU: 22.33 ms
* GPU: 2.86447 ms
* SPU: 7.795508419
*/

//#include <...>
#include <stdlib.h>
#include <CL/cl.h>
#include <iostream>
#include <string>
#include <string.h>
#include "common.h"

using namespace std;



int main(void) {
    /* VARIABLES DECLARATION */
    const string program_filename = "vector_add_opencl.cl"; 
    int i,j;
    const unsigned int VECTOR_SIZE=4096*4096;

    //const int VECTOR_SIZE=256*256*256;
    void *va;
    void *vb;
    void *vc;
    int *A = new int[VECTOR_SIZE];
    int *B = new int[VECTOR_SIZE];
    int *C = new int[VECTOR_SIZE];

    for(i = 0; i < VECTOR_SIZE;i++){
        A[i] = i;
        B[i] = VECTOR_SIZE - i;
    }
    
    /* 1. SET UP OPENCL ENVIRONMENT: create context, command queue, program and kernel. */
    /* 1.a Create Context */
    /* Create an OpenCL context on a GPU on the first available platform. See createContext in common.h */
    cl_context context;
    createContext(&context);
    /* 1.b Create Command Queue */
    /* Create an OpenCL command queue for a given context. See create&commandQueue in common.h */
    cl_command_queue queue;
    cl_device_id device_id; 
    createCommandQueue(context, &queue, &device_id);
    /* 1.c Create Program */
    /* Create an OpenCL program from a given file and compile it. See createProgram in common.h */
    cl_program program;
    createProgram(context, device_id, program_filename, &program);
    /* 1.d Create kernel */
    /* Create our OpenCL kernel for the kernel function. See clCreateKernel in OpenCL 1.2 Reference Pages */
    cl_int err;
    cl_kernel kernel;
    kernel = clCreateKernel(program, "vector_add_kernel", &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    } 
    cout << "Kernel created without errors" << endl;     

    /* 2. SET UP MEMORY / DATA */
    /* 2.a Create memory buffers */
    /* Create 3 memory buffers for the input/output data. See clCreateBuffer in OpenCL 1.2 Reference Pages */
    cl_mem cl_A, cl_B, cl_C;
    cl_A = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(int)*VECTOR_SIZE, NULL, &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    cl_B = clCreateBuffer(context, CL_MEM_READ_ONLY, sizeof(int)*VECTOR_SIZE, NULL, &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    cl_C = clCreateBuffer(context, CL_MEM_WRITE_ONLY, sizeof(int)*VECTOR_SIZE, NULL, &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
 
    cout << "Buffers created without errors" << endl;  
    /* 2.b Initialize the input data */
    /* Map the input buffers to pointers. See clEnqueueMapBuffer in OpenCL 1.2 Reference Pages */
    va = clEnqueueMapBuffer(queue, cl_A, CL_TRUE, CL_MAP_READ, 0, sizeof(int)*VECTOR_SIZE, 0, NULL,  NULL, &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    vb = clEnqueueMapBuffer(queue, cl_B, CL_TRUE, CL_MAP_READ, 0, sizeof(int)*VECTOR_SIZE, 0, NULL, NULL, &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
   
    cout << "Buffers mapped without errors" << endl;
    /* Fill the input data */
    memcpy(va, A, sizeof(int)*VECTOR_SIZE);
    memcpy(vb, B, sizeof(int)*VECTOR_SIZE);
    cout << "A and B copied without errors" << endl;
    /* Unmap the input data. See clEnqueueUnmapMemObject in OpenCL 1.2 Reference Pages */
    err = clEnqueueUnmapMemObject(queue, cl_A, va, 0, NULL,  NULL); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    err = clEnqueueUnmapMemObject(queue, cl_B, vb, 0, NULL, NULL); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }

    cout << "Buffers unmapped without errors" << endl;
    /* 2.c Set the kernel arguments */
    /* Pass the 3 memory buffers to the kernel as arguments. See clSetKernelArg in OpenCL 1.2 Reference Pages */
    err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &cl_A);
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    err = clSetKernelArg(kernel, 1, sizeof(cl_mem), &cl_B);
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    err = clSetKernelArg(kernel, 2, sizeof(cl_mem), &cl_C);
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    cout << "Arguments set without errors" << endl;
    /* 3. EXECUTE THE KERNEL INSTANCES */
    /* 3.a Define the global work size and enqueue the kernel. See clEnqueueNDRangeKernel in OpenCL 1.2 Reference Pages */
    const size_t global_work_size = VECTOR_SIZE;
    const size_t local_work_size = 1;

    cl_event event;
    err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_work_size, &local_work_size, 0, NULL, &event); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    cout << "Kernel started without errors" << endl;
    /* Each instance of our OpenCL kernel operates on a single element of each array so the number of instances needed is the number of
    elements in the array. */

    /* 3.b Wait for kernel execution completion */
    /* See clFinish in OpenCL 1.2 Reference Pages */
    err = clFinish(queue);
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    cout << "Kernel execution finished without errors" << endl;
    /* 4. AFTER EXECUTION */
    clWaitForEvents(1, &event);
    /*cl_ulong start, stop;
    clGetEventProfilingInfo( , CL_PROFILING_COMMAND_QUEUED, sizeof(cl_ulong), &start, NULL);
    clGetEventProfilingInfo( , CL_PROFILING_COMMAND_END, sizeof(cl_ulong), &stop, NULL);*/
    /* 4.a Retrieve results: */
    /* Map the output buffer to a local pointer. See clEnqueueMapBuffer in OpenCL 1.2 Reference Pages */
     vc = clEnqueueMapBuffer(queue, cl_C, CL_TRUE, CL_MAP_WRITE, 0, VECTOR_SIZE, 0, NULL,  NULL,  &err); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    /* Read the results using the mapped pointer */
    memcpy(C, vc, sizeof(int)*VECTOR_SIZE);

    for (i = VECTOR_SIZE-100; i < VECTOR_SIZE;i++){
        std::cout << A[i] << " + " << B[i] << " = " << C[i] << std::endl;
    } 
    /* Unmap the output data. See clEnqueueUnmapMemObject in OpenCL 1.2 Reference Pages */
    err = clEnqueueUnmapMemObject(queue, cl_C, vc, 0, NULL, NULL); 
    if (err != CL_SUCCESS){
        cout << "Error : " << errorNumberToString(err) << endl;
        exit(0);
    }
    printProfilingInfo(event);
    /* 4.b Release OpenCL objects */
    /* See cleanUpOpenCL in common.h */
    cl_mem mem[] = {cl_A, cl_B, cl_C};
    cleanUpOpenCL( context, queue, program, kernel,mem, 3); 

    delete[] A;
    delete[] B;
    delete[] C; 
    return 0;
}
