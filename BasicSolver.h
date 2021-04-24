//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#ifndef BASICSOLVER_H_
#define BASICSOLVER_H_
#include <string>
#include <limits.h>
class BasicSolver {
protected:
	const int maxIterations = 100;//INT_MAX;
	double **A;
	double *A_flat;

	double * b;
	double * x;
	double * nextX;
	int size;
	void freeMemory();
public:
	BasicSolver(int dimension);
	void input(std::string rFile);
	void output(std::string wfile);
	void virtual solve(double eps) = 0;
};
#endif