//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#ifndef BASICSOLVER_H_
#define BASICSOLVER_H_
#include <string>
#include <limits.h>
class BasicSolver {
protected:
	const int maxIterations = 100;//INT_MAX;
	float **A;
	float *A_flat;

	float * b;
	float * x;
	float * nextX;
	int size;
	void freeMemory();
public:
	BasicSolver(int dimension);
	void input(std::string rFile);
	void output(std::string wfile);
	void virtual solve(float eps) = 0;
	void computeError();
};
#endif