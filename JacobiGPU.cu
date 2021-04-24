
#include <cuda.h>
#include"JacobiGPU.h"
#include  <fstream>
#include<iostream>
#include <stdio.h>
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


void JacobiGPU::freeAllMemory() {
	freeMemory();
}

void JacobiGPU::solve(double eps) {
	solve_device(eps);
}

void JacobiGPU::solve_host(double eps) {

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

void JacobiGPU::solve_device(double eps) {
    
	// double residual = 0.0; 
	// //double sum = 0.0;
	// double dis = 0.0;
	// double diff = 1.0;  
	// int multicity = int(0.1 / eps);
	int numTiles = (size + threads_per_tile - 1) / threads_per_tile;

	cout << "Using GPU kernel "<<kernel_option<<"\n";
	if (kernel_option == 2 || kernel_option == 3) {
		cout << "threads per tile: "<<threads_per_tile<<"\n";
		cout << "number of tiles: "<< numTiles <<"\n";
	}

	int numBlocks = 1;
	int threads_per_block = size;

	// device array allocation
    double *dA;
    cudaMalloc((void **)&dA, sizeof(double) * size*size);
    double *db;
    cudaMalloc((void **)&db, sizeof(double) * size);
	double *dx;
    cudaMalloc((void **)&dx, sizeof(double) * size);
	double *dnextX;
    cudaMalloc((void **)&dnextX, sizeof(double) * size);

    cudaMemcpy(dA, A_flat, (size*size)*sizeof(double), cudaMemcpyHostToDevice);
	cudaMemcpy(db, b, (size)*sizeof(double), cudaMemcpyHostToDevice);
	//cudaMemcpy(dx, x, (size)*sizeof(double), cudaMemcpyHostToDevice);
	//cudaMemcpy(dnextX, nextX, (size)*sizeof(double), cudaMemcpyHostToDevice);
	cudaMemset(dx, 0, size*sizeof(double));
	cudaMemset(dnextX, 0, size*sizeof(double));

	cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

	int count = 0;
	//&& (diff > eps)
	for (; (count < maxIterations) ; count++)
	{
		if (count % 2) {
			// odd
			switch(kernel_option) {
				case 1:
				solve1<<<numBlocks, threads_per_block>>>(dnextX, dA, db, dx, size);
				break;

				case 2:
				solve2<<< numTiles, threads_per_tile >>>(dnextX, dA, db, dx, size);
				break;

				case 3:
				solve3<<< numTiles, threads_per_tile, size*sizeof(double) >>>(dnextX, dA, db, dx, size);
				break;

				default:
				solve1<<<numBlocks, threads_per_block>>>(dnextX, dA, db, dx, size);

			}
			
		}
		else {
			// even
			switch(kernel_option) {
				case 1:
				solve1<<<numBlocks, threads_per_block>>>(dx, dA, db, dnextX, size);
				break;

				case 2:
				solve2<<< numTiles, threads_per_tile >>>(dx, dA, db, dnextX, size);
				break;

				case 3:
				solve3<<< numTiles, threads_per_tile, size*sizeof(double) >>>(dx, dA, db, dnextX, size);
				break;
				
				default:
				solve1<<<numBlocks, threads_per_block>>>(dx, dA, db, dnextX, size);

			}
		}

	}
	cudaEventRecord(stop);
    cudaEventSynchronize(stop);

	cudaDeviceSynchronize();
	cudaMemcpy(x, dx, sizeof(double) * size, cudaMemcpyDeviceToHost);
	cudaMemcpy(nextX, dnextX, sizeof(double) * size, cudaMemcpyDeviceToHost);
	
	
    // Get the elapsed time in milliseconds
    float ms = 0;
    cudaEventElapsedTime(&ms, start, stop);

	cout << endl << "Iterations:" << count << endl;
	//printf("Iterations:%d\n",count);
    printf("%f\n", ms);

	cudaFree(dA); 
	cudaFree(db); 
	cudaFree(dx); 
	cudaFree(dnextX);
	cudaEventDestroy(start);
    cudaEventDestroy(stop);

}

void JacobiGPU::input(string wfile, bool generate) {
	if (generate) {
		int n = this->size;
		ofstream fout(wfile);

		std::random_device rd;
		std::mt19937 gen(rd());
		std::uniform_real_distribution<> dis(-10, 10);

		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				if (i == j) {
					this->A_flat[i*n+j] = 10000 * dis(gen);
				}
				else {
					this->A_flat[i*n+j] = dis(gen);
				}
				
				//cout << A[i][j] << " ";
				fout << this->A_flat[i*n+j] << " ";
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
		//BasicSolver::input(wfile);
		int n = this->size;
		ifstream  fin(wfile);
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				fin >> A_flat[i*n+j];
				//cout << A[i][j] << " ";
			}
			//cout << endl;
		}
		for (int i = 0; i < n; i++) {
			fin >> b[i];
		}
		fin.close();
		cout << "Read benchmark file "<<wfile<<endl;
	}
}

void JacobiGPU::mycomputeError() {
	double * c = new double [size];
	double maxError = 0;
	double total_err = 0;

   for(int i = 0; i < size; i++) {
      c[i] = 0;
      for(int j = 0; j < size; j++)
      {
         c[i] += A_flat[i*size+j] * x[j];
      }
	  maxError = fmax(maxError, fabs(c[i] - b[i]));
	  total_err += fabs(c[i] - b[i]);
   }
   total_err = total_err / size;
   cout << "\n==== max error: "<<maxError<<"\n";
	cout << "==== avg error: "<<total_err<<"\n";
   delete[] c;

}

int main(int argc, char ** argv) {
	int dimension = stoi(argv[1], 0, 10);
	bool generate_random = stoi(argv[3], 0, 10);
	int kernel = stoi(argv[6], 0, 10);
	int tpt = stoi(argv[7], 0, 10);
	
	//cout << dimension;
	JacobiGPU * jacobi = new JacobiGPU(dimension);

	jacobi->input(argv[2], generate_random);
	double eps = stod(argv[4]);
	//jacobi->solve_host(eps);
	jacobi->kernel_option = kernel;
	jacobi->threads_per_tile = tpt;

	jacobi->solve(eps);
	jacobi->output(argv[5]);
	jacobi->mycomputeError();
	jacobi->freeAllMemory();
	
}