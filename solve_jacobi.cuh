#ifndef SOLVE_JACOBI_CUH
#define SOLVE_JACOBI_CUH
__global__ void solve1(double* dx, double* dA, double* db, double* dnextX, int size);
//__global__ void solve2_sum(double* dx, double* dA, double* db, double* dnextX, int size, int nTile);
__global__ void solve2(double* dx, double* dA, double* db, double* dnextX, int size);
__global__ void solve3(double* dx, double* dA, double* db, double* dnextX, int size);

#endif