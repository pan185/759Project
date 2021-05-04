#ifndef JACOBIGPU_H
#define JACOBIGPU_H
#include <string>
#include "BasicSolver.h"
#include "solve_jacobi.cuh"
class JacobiGPU:public BasicSolver {
public:
	JacobiGPU(int dimension) :BasicSolver(dimension) {};
	void freeAllMemory();
    void solve_host(float eps);
    void solve_device(float eps);
    void solve(float eps);
	void input(std::string rFile, bool generate_random);
    void mycomputeError();
//private:
	int kernel_option;
    int threads_per_tile;
};
#endif