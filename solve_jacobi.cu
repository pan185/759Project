#include "solve_jacobi.cuh"
//#include <stdio.h>
__global__ void solve1(float* dx, float* dA, float* db, float* dnextX, int size) {
    //printf("kernel launched!\n");
    float sum = 0;
    for (int j = 0; j < size; j++) {
        if (threadIdx.x != j) {
            sum += dA[threadIdx.x*size+j] * dx[j];
        }
    }
    dnextX[threadIdx.x] = (db[threadIdx.x] - sum) / dA[threadIdx.x*size+threadIdx.x];
}

__global__ void solve2(float* dx, float* dA, float* db, float* dnextX, int size) {
    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    //int A_index = tidx;
    
    float sum = 0;
    for (int j = 0; j < size; j++) {
        if (tidx != j) sum += dA[tidx*size + j] * dx[j];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}

__global__ void solve3(float* dx, float* dA, float* db, float* dnextX, int size) {
    extern __shared__ float shared_dx[];

    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    
    //write to shared memory
    for(int i=threadIdx.x; i < size; i = i+blockDim.x)
	{
		shared_dx[i] = dx[i];
	}
    __syncthreads();

    float sum = 0;
    for (int j = 0; j < size; j++) {
        if (tidx != j) sum += dA[tidx*size + j] * shared_dx[j];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}

// loop unrolling 2
__global__ void solve4(float* dx, float* dA, float* db, float* dnextX, int size) {
    extern __shared__ float shared_dx[];

    int tidx = blockIdx.x * blockDim.x + threadIdx.x;
    
    //write to shared memory
    for(int i=threadIdx.x; i < size; i = i+blockDim.x)
	{
		shared_dx[i] = dx[i];
	}
    __syncthreads();

    float sum = 0;
    for (int j = 0; j < size; j = j+2) {
        if (tidx != j) sum += dA[tidx*size + j] * shared_dx[j];
        if (tidx != j+1) sum += dA[tidx*size + j+1] * shared_dx[j+1];
    }
    dnextX[tidx] = (db[tidx] - sum) / dA[tidx*size + tidx];
}

__global__ void solve5(float* dx, float* dA, float* db, float* dnextX, int size) {
    extern __shared__ float shared_dx[];

    
}