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

__global__ void solve2(double* dx, double* dA, double* db, double* dnextX, int size) {
    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    //int A_index = tidx;
    
    double sum = 0;
    for (int j = 0; j < size; j++) {
        if (tidx != j) sum += dA[tidx*size + j] * dx[j];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}

__global__ void solve3(double* dx, double* dA, double* db, double* dnextX, int size) {
    extern __shared__ double shared_dx[];

    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    
    //write to shared memory
    for(int i=threadIdx.x; i < size; i = i+blockDim.x)
	{
		shared_dx[i] = dx[i];
	}
    __syncthreads();

    double sum = 0;
    for (int j = 0; j < size; j++) {
        if (tidx != j) sum += dA[tidx*size + j] * shared_dx[j];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}

// loop unrolling 2
__global__ void solve4(double* dx, double* dA, double* db, double* dnextX, int size) {
    extern __shared__ double shared_dx[];

    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    
    //write to shared memory
    for(int i=threadIdx.x; i < size; i = i+blockDim.x)
	{
		shared_dx[i] = dx[i];
	}
    __syncthreads();

    double sum = 0;
    //unrolling by a factor of 2
    for (int j = 0; j < size; j = j+2) {
        if (tidx != j) sum += dA[tidx*size + j] * shared_dx[j];
        if (tidx != j+1) sum += dA[tidx*size + j+1] * shared_dx[j+1];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}

// loop unrolling 4
__global__ void solve5(double* dx, double* dA, double* db, double* dnextX, int size) {
    extern __shared__ double shared_dx[];

    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    
    //write to shared memory
    for(int i=threadIdx.x; i < size; i = i+blockDim.x)
	{
		shared_dx[i] = dx[i];
	}
    __syncthreads();

    double sum = 0;
    //unrolling by a factor of 4
    for (int j = 0; j < size; j = j+4) {
        if (tidx != j) sum += dA[tidx*size + j] * shared_dx[j];
        if (tidx != j+1) sum += dA[tidx*size + j+1] * shared_dx[j+1];
        if (tidx != j+2) sum += dA[tidx*size + j+2] * shared_dx[j+2];
        if (tidx != j+3) sum += dA[tidx*size + j+3] * shared_dx[j+3];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}