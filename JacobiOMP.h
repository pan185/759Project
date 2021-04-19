#ifndef JACOBIOMP_H
#define JACOBIOMP_H
#include <string>
#include"BasicSolver.h"
class JacobiOMP:public BasicSolver {
public:
	JacobiOMP(int dimension) :BasicSolver(dimension) {};
	void freeAllMemory();
	void solve(double eps, int num_threads);
    void solve(double eps);
	void input(std::string rFile, bool generate_random);
};
#endif