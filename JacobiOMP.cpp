#include"JacobiOMP.h"
#include  <fstream>
#include<iostream>
#include <math.h>
#include <cstring>
#include <random>
// The std::chrono namespace provides timer functions in C++
#include <chrono>

// std::ratio provides easy conversions between metric units
#include <ratio>

#include <omp.h>

// Provide some namespace shortcuts
using std::cout;
using std::chrono::high_resolution_clock;
using std::chrono::duration;

using namespace std;


void JacobiOMP::freeAllMemory() {
	freeMemory();
}
void JacobiOMP::solve(double eps, int num_threads) {
    cout << "number of threads: "<<num_threads<<std::endl;
    omp_set_num_threads(num_threads);
    JacobiOMP::solve(eps);

}

void JacobiOMP::solve(double eps) {

	high_resolution_clock::time_point start;
    high_resolution_clock::time_point end;
    duration<double, std::milli> duration_sec;
    
	double residual = 0.0;  //	
	//double sum = 0.0;
	double dis = 0.0;
	double diff = 1.0;  
	int multicity = int(0.1 / eps);
	//timer.start();
	// Get the starting timestamp
    start = high_resolution_clock::now();

	int count = 1;
	for (; (count < maxIterations); count++)
	{
        if ((diff <= eps)) break;

		diff = 0.0;

        residual = 0.0;

        #pragma omp parallel for schedule(guided,8)
        //#pragma omp parallel for collapse(2) reduction(+:sum)
		for (int i = 0; i < size; i++)
		{
            double sum = 0.0;
            //#pragma omp parallel for
            //#pragma omp parallel for reduction(+:sum)
			for (int j = 0; j < size; j++)
			{
				//if (i != j)
				//{
					sum += (i != j) ? (A[i][j] * x[j]) : 0;
				//}
			}
			nextX[i] = (b[i] - sum) / A[i][i];

			
		//}
		
		
        //#pragma omp parallel for
		//for (int m = 0; m < size; m++)
		//{
			dis = fabs(nextX[i] - x[i]);
			if (dis > residual)
				residual = dis;
		}
        
		diff = residual;
		if (diff < eps*multicity) {
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

void JacobiOMP::input(string wfile, bool generate) {
	if (generate) {
		int n = this->size;
		ofstream fout(wfile);

		std::random_device rd;
		std::mt19937 gen(rd());
		std::uniform_real_distribution<> dis(-10, 10);

		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				if (i == j) {
					A[i][j] = 10000 * dis(gen);
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
			b[i] = dis(gen)*100;
			//cout << b[i]<<endl;
			fout << b[i]<<" ";
		}
		fout << endl;
		fout.close();
		cout << "Generated random inputs, written to "<<wfile<<endl;
	}
	else {
		BasicSolver::input(wfile);
		cout << "Read benchmark file "<<wfile<<endl;
	}
}

int main(int argc, char ** argv) {
	int dimension = stoi(argv[1], 0, 10);
	bool generate_random = stoi(argv[3], 0, 10);
    int num_threads = stoi(argv[6], 0, 10);
	//cout << dimension;
	JacobiOMP * jacobi = new JacobiOMP(dimension);
	jacobi->input(argv[2], generate_random);
	double eps = stod(argv[4]);
	jacobi->solve(eps, num_threads);
	jacobi->output(argv[5]);
	jacobi->freeAllMemory();
}