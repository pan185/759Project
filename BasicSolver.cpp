//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#include"BasicSolver.h"
#include "matrix.h"
#include  <fstream>

// constructor
BasicSolver::BasicSolver(int dimension) {
	this->size = dimension;

	this->A = createMatrix<float>(size, size);

	this->A_flat = createVector<float>(size*size);

	this->b = createVector<float>(size);

	this->x = createVector<float>(size);

	this->nextX = createVector<float>(size);

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

void BasicSolver::computeError() {
	float * c = createVector<float>(size);
	float maxError = 0;
	float total_err = 0;

   for(int i = 0; i < size; i++) {
      c[i] = 0;
      for(int j = 0; j < size; j++)
      {
         c[i] += A[i][j] * x[j];
      }
	  maxError = fmax(maxError, fabs(c[i] - b[i]));
	  total_err += fabs(c[i] - b[i]);
   }
   total_err = total_err / size;
   cout << "\n==== max error: "<<maxError<<"\n";
	cout << "==== avg error: "<<total_err<<"\n";
   delete[] c;

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
