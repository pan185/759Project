//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#include"BasicSolver.h"
#include "matrix.h"
#include  <fstream>

// constructor
BasicSolver::BasicSolver(int dimension) {
	this->size = dimension;

	this->A = createMatrix<double>(size, size);

	this->A_flat = createVector<double>(size*size);

	this->b = createVector<double>(size);

	this->x = createVector<double>(size);

	this->nextX = createVector<double>(size);

	for (int i = 0; i < size; i++) {
		x[i] = 0;
	}
}

void BasicSolver::input(string rFile) {
	int n = this->size;
	ifstream  fin(rFile);
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			fin >> A[i][j];
			//cout << A[i][j] << " ";
		}
		//cout << endl;
	}
	for (int i = 0; i < n; i++) {
		fin >> b[i];
	}
	fin.close();
}

void BasicSolver::output(string wfile) {
	int n = size;
	ofstream fout(wfile);
	for (int i = 0; i < n; i++)
	{
		fout << fixed<<x[i] << " ";
		//cout << x[i] << "   ";
	}
	fout << endl;
	fout.close();
}

void BasicSolver::freeMemory() {
	freeMatrix(A, size);
	// for (int i = 0; i < size; i++) {
	// 	delete [] A[i];
	// }
	delete[] A_flat;
	delete[]b;
	delete[]x;
	delete[]nextX;
}
