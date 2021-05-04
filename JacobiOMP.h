#ifndef JACOBIOMP_H
#define JACOBIOMP_H
#include <string>
#include"BasicSolver.h"
class JacobiOMP:public BasicSolver {
public:
	JacobiOMP(int dimension) :BasicSolver(dimension) {};
	void freeAllMemory();
	void solve(float eps, int num_threads);
    void solve(float eps);
	void input(std::string rFile, bool generate_random);
};
#endif