#include "solve_jacobi.cuh"
//#include <stdio.h>
__global__ void solve1(double* dx, double* dA, double* db, double* dnextX, int size) {
    //printf("kernel launched!\n");
    double sum = 0;
    for (int j = 0; j < size; j++) {
        if (threadIdx.x != j) {
            sum += dA[threadIdx.x*size+j] * dx[j];
        }
    }
    dnextX[threadIdx.x] = (db[threadIdx.x] - sum) / dA[threadIdx.x*size+threadIdx.x];
}