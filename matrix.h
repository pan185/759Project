//This base line Jacobi version is adapted from source:
//https://github.com/1751200/Xlab-k8s-gpu/blob/master/Iterative-Methods/Jacobi/JacobiCpu.cpp

#include <iostream>
#include<stdio.h>
#include<math.h>
#include<random>
#include <iomanip>
#include<ctime>
using namespace std;
#ifndef MATRIX_H
#define MATRIX_H	
//extern void setRandomValueForVector(double * m, int size);

//extern void setRandomValueForMatrix(double **m, int row, int col);

template<class T>
T ** createMatrix(int row, int col)
{
	T ** matrix = new T*[row];
	for (int i = 0; i < row; i++)
	{
		matrix[i] = new T[col];
	}
	return matrix;
}

template<class T>
T * createVector(int size)
{
	T * vector = new T[size];
	return vector;
}

template<class T>
void freeMatrix(T **m, int size) {
	for (int i = 0; i < size; i++)
		delete[]m[i];
	delete[]m;
}
 #endif
