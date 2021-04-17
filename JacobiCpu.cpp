//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#include"JacobiCpu.h"
//#include "Util.h"
#include  <fstream>
#include<iostream>
#include <math.h>
#include <cstring>
#include <random>
// The std::chrono namespace provides timer functions in C++
#include <chrono>

// std::ratio provides easy conversions between metric units
#include <ratio>

// Provide some namespace shortcuts
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

using namespace std;


void JacobiCpu::freeAllMemory() {
	freeMemory();
}
void JacobiCpu::solve(double eps) {

	// CpuTimer timer = CpuTimer();
	// timer.start();

	high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    
	double residual = 0.0;  //	
	double sum = 0.0;
	double dis = 0.0;
	double diff = 1.0;  
	int multicity = int(0.1 / eps);
	//timer.start();
	// Get the starting timestamp
    start = high_resolution_clock::now();

	int count = 1;
	for (; (count < maxIterations) && (diff > eps); count++)
	{
		diff = 0.0;

		for (int i = 0; i < size; i++)
		{
			for (int j = 0; j < size; j++)
			{
				if (i != j)
				{
					sum += A[i][j] * x[j];
				}
			}
			nextX[i] = (b[i] - sum) / A[i][i];

			// if (isnan(nextX[i])) {
			// 	cout << "Not converge"<<endl;
			// 	freeAllMemory();
			// 	exit(EXIT_FAILURE);
			// }

			sum = 0.0;
		}
		residual = 0.0;
		
		for (int m = 0; m < size; m++)
		{
			dis = fabs(nextX[m] - x[m]);
			if (dis > residual)
				residual = dis;
		}
		diff = residual;
		if (diff < eps*multicity) {
			//cout << "======time stop:" << timer.stop() << " ";
			multicity = int(multicity / 10);
		}
		memcpy(x, nextX, size * sizeof(double));
	}
	// Get the ending timestamp
	end = high_resolution_clock::now();
	cout << endl << "Iterations:" << count << endl;
	
    
    // Convert the calculated duration to a double using the standard library
    duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	cout << duration_sec.count() << "\n";

}

void JacobiCpu::input(string wfile) {
	int n = this->size;
	ofstream fout(wfile);

	std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(-10, 10);

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++) {
			if (i == j) {
				A[i][j] = 1000 * dis(gen);
			}
			else {
				A[i][j] = dis(gen);
			}
			
			//cout << A[i][j] << " ";
			fout << A[i][j] << " ";
		}
		//cout << endl;
		fout<< endl;
	}
	
	for (int i = 0; i < n; i++) {
		b[i] = dis(gen)*10;
		//cout << b[i]<<endl;
		fout << b[i]<<" ";
	}
	fout << endl;
	fout.close();
	cout << "generated random inputs, written to "<<wfile<<endl;
}

int main(int argc, char ** argv) {
	int dimension = stoi(argv[1], 0, 10);
	//cout << dimension;
	JacobiCpu * jacobi = new JacobiCpu(dimension);
	jacobi->input(argv[2]);
	double eps = stod(argv[3]);
	jacobi->solve(eps);
	jacobi->output(argv[4]);
	jacobi->freeAllMemory();
}