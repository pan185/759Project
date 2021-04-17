//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#ifndef JACOBICPU_H
#define JACOBICPU_H
#include <string>
#include"BasicSolver.h"
class JacobiCpu:public BasicSolver {
public:
	JacobiCpu(int dimension) :BasicSolver(dimension) {};
	void freeAllMemory();
	void solve(double eps);
	void input(std::string rFile);
};
#endif