#ifndef SOLVE_JACOBI_CUH
#define SOLVE_JACOBI_CUH
__global__ void solve1(float* dx, float* dA, float* db, float* dnextX, int size);
//__global__ void solve2_sum(float* dx, float* dA, float* db, float* dnextX, int size, int nTile);
__global__ void solve2(float* dx, float* dA, float* db, float* dnextX, int size);
__global__ void solve3(float* dx, float* dA, float* db, float* dnextX, int size);
__global__ void solve4(float* dx, float* dA, float* db, float* dnextX, int size);
__global__ void solve5(float* dx, float* dA, float* db, float* dnextX, int size);
#endif