cpu: 
	g++ JacobiCpu.cpp BasicSolver.cpp matrix.cpp -Wall -O3 -std=c++17 -o JacobiCpu

cpu10: JacobiCpu
	./JacobiCpu 1024 testbenches/test_10.txt 0 0.0000000 test.txt

cpu11: JacobiCpu
	./JacobiCpu 2048 testbenches/test_11.txt 0 0.0000000 test.txt

cpu12: JacobiCpu
	./JacobiCpu 4096 testbenches/test_12.txt 0 0.0000000 test.txt

cpu13: JacobiCpu
	./JacobiCpu 8192 testbenches/test_13.txt 0 0.0000000 test.txt

cpu14: JacobiCpu
	./JacobiCpu 16384 testbenches/test_14.txt 1 0.0000000 test.txt

omp:
	g++ JacobiOMP.cpp BasicSolver.cpp matrix.cpp -Wall -O3 -std=c++17 -o JacobiOMP -fopenmp

omp10_2: JacobiOMP
	./JacobiOMP 1024 testbenches/test_10.txt 0 0.0000000 test.txt 2

gpu:
	nvcc JacobiGPU.cu solve_jacobi.cu BasicSolver.cpp matrix.cpp -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std c++17 -o JacobiGPU

gpu10: JacobiGPU
	./JacobiGPU 1024 testbenches/test_10.txt 0 0.0000000 test.txt