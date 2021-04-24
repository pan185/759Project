#ifndef JACOBIGPU_H
#define JACOBIGPU_H
#include <string>
#include "BasicSolver.h"
#include "solve_jacobi.cuh"
class JacobiGPU:public BasicSolver {
public:
	JacobiGPU(int dimension) :BasicSolver(dimension) {};
	void freeAllMemory();
    void solve_host(double eps);
    void solve_device(double eps);
    void solve(double eps);
	void input(std::string rFile, bool generate_random);
};
#endif