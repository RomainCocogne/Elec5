#include <iostream> 
#include <sys/time.h>	/* time*/


int main(void) {
    struct timeval start, end; 
    double tdiff;
    int i,j;
    const int VECTOR_SIZE = 4096*4096;
    
    int *inputA = new int[VECTOR_SIZE];
    int *inputB = new int[VECTOR_SIZE];
    int *outputC = new int[VECTOR_SIZE];    

    for (i = 0; i< VECTOR_SIZE;i++){
        inputA[i] = i;
        inputB[i] = VECTOR_SIZE-i;
    }
    gettimeofday(&start, NULL); 
    for (i = 0; i< VECTOR_SIZE;i++){
        outputC[i] = inputA[i] + inputB[i];
    }
    gettimeofday(&end, NULL); 
    
    
    for (i = VECTOR_SIZE-100; i < VECTOR_SIZE;i++){
        std::cout << inputA[i] << " + " << inputB[i] << " = " << outputC[i] << std::endl;
    }

    tdiff = (double)(1000*(end.tv_sec-start.tv_sec))+((end.tv_usec-start.tv_usec)/1000); 
    printf("ADDITION PROCESSING TIME: %f ms\n", tdiff); 
    delete[] inputA;
    delete[] inputB;
    delete[] outputC;

    return 0; 
}

