#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/permutation_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/transform.h>
#include <thrust/reduce.h>
#include <thrust/execution_policy.h>
#include <algorithm>
#include <cstdlib>
#include <cstdio>
#include <string>
#include <cstring>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <stdio.h>

// The std::chrono namespace provides timer functions in C++
#include <chrono>

// std::ratio provides easy conversions between metric units
#include <ratio>

// // Provide some namespace shortcuts
// using std::cout;
// using std::chrono::high_resolution_clock;
// using std::chrono::duration;

//using namespace std;

struct f_mult
{
  template <typename Tuple>
  __host__ __device__
  float operator()(Tuple v)
  {
    return thrust::get<0>(v) * thrust::get<1>(v);
  }
};

struct f_nextx
{
  template <typename Tuple>
  __host__ __device__
  float operator()(Tuple v)
  {
    return ((thrust::get<0>(v) - thrust::get<1>(v)) / thrust::get<2>(v)) + thrust::get<3>(v);
    //nextX[i] = (b[i] - sum) / A[i][i];
  }
};

struct divF: thrust::unary_function<int, int>
{
  int n;

  divF(int n_) : n(n_) {}

  __host__ __device__
  int operator()(int idx)
  {
    return idx / n;
  }
};

struct modF: thrust::unary_function<int, int>
{
  int n;

  modF(int n_) : n(n_) {}

  __host__ __device__
  int operator()(int idx)
  {
    return idx % n;
  }
};

// struct diag_index : public thrust::unary_function<int,int>
// {
//   diag_index(int rows) : rows(rows){}

//   __host__ __device__
//   int operator()(const int index) const
//   {
//       return (index*rows + (index%rows));
//   }

//   const int rows;
// };

struct dmF: thrust::unary_function<int, int>
{
  int n;

  dmF(int n_) : n(n_) {}

  __host__ __device__
  int operator()(int i)
  {
    return i*n+i;
  }
};

typedef thrust::counting_iterator<int> countIt;
typedef thrust::transform_iterator<divF, countIt> columnIt;
typedef thrust::transform_iterator<modF, countIt> rowIt;
typedef thrust::transform_iterator<dmF, countIt> diagIt;


void solve(thrust::device_vector<float>& dx, thrust::device_vector<float>& dA, thrust::device_vector<float>& db,
    thrust::device_vector<float>& dnextX, int size, thrust::device_vector<float>& temp, thrust::device_vector<int>&outkey,
    thrust::device_vector<float>&sum)
{
    // std::cout <<"dA= ";
    // for (int i = 0; i<size*size; i++) {
    //     //printf("%f ", v[i]);
    //     std::cout << dA[i]<<" ";
    // }
    // //printf("\n");
    // std::cout << "\n";

    columnIt cv_begin = thrust::make_transform_iterator(thrust::make_counting_iterator(0), divF(size));
    columnIt cv_end   = cv_begin + (size*size);

    rowIt rv_begin = thrust::make_transform_iterator(thrust::make_counting_iterator(0), modF(size));
    rowIt rv_end   = rv_begin + (size*size);

    diagIt dg_begin = thrust::make_transform_iterator(thrust::make_counting_iterator(0), dmF(size));
    diagIt dg_end   = dg_begin + (size);

    // diagIt dg_begin = thrust::make_transform_iterator(thrust::make_counting_iterator(0),diag_index(size));
    // diagIt dg_end   = dg_begin + (size*size);

    //thrust::device_vector<float> temp(size*size);
    thrust::transform(make_zip_iterator(
                        make_tuple(
                            dA.begin(),
                            thrust::make_permutation_iterator(dx.begin(),rv_begin) ) ),
                        make_zip_iterator(
                        make_tuple(
                            dA.end(),
                            thrust::make_permutation_iterator(dx.end(),rv_end) ) ),
                        temp.begin(),
                        f_mult());

    // thrust::device_vector<int> outkey(size);
    // thrust::device_vector<float> sum(size);
    thrust::reduce_by_key(cv_begin, cv_end, temp.begin(), outkey.begin(), sum.begin());
    //   thrust::transform(v.begin(), v.end(), sum.begin(), v.begin(), thrust::plus<float>());

    // std::cout <<"sum= ";
    // for (int i = 0; i<size; i++) {
    //     //printf("%f ", v[i]);
    //     std::cout << sum[i]<<" ";
    // }
    // //printf("\n");
    // std::cout << "\n";

    // thrust::transform(
    //     make_zip_iterator(
    //     make_tuple(
    //         // dA.begin(),
    //         thrust::make_permutation_iterator(db.begin(),rv_begin),
    //         thrust::make_permutation_iterator(sum.begin(),rv_begin),
    //         thrust::make_permutation_iterator(dA.begin(),dg_begin),
    //         thrust::make_permutation_iterator(dx.begin(),rv_begin) 
    //     ) 
    //     ),
    //     make_zip_iterator(
    //     make_tuple(
    //         thrust::make_permutation_iterator(db.end(),rv_end),
    //         thrust::make_permutation_iterator(sum.end(),rv_end),
    //         thrust::make_permutation_iterator(dA.end(),dg_end),
    //         thrust::make_permutation_iterator(dx.end(),rv_end)
    //     ) 
    //     ),
    //     dnextX.begin(),
    //     f_nextx());
    thrust::transform(
      make_zip_iterator(
      make_tuple(
          // dA.begin(),
          db.begin(),
          sum.begin(),
          thrust::make_permutation_iterator(dA.begin(),dg_begin),
          dx.begin()
      ) 
      ),
      make_zip_iterator(
      make_tuple(
          db.end(),
          sum.end(),
          thrust::make_permutation_iterator(dA.end(),dg_end),
          dx.end()
      ) 
      ),
      dnextX.begin(),
      f_nextx());
    //nextX[i] = ((b[i] - sum) / A[i][i]) + x[i];

    // std::cout <<"nextX= ";
    // for (int i = 0; i<size; i++) {
    //     //printf("%f ", v[i]);
    //     std::cout << dnextX[i]<<" ";
    // }
    // //printf("\n");
    // std::cout << "\n";

}

int main(int argc, char ** argv) {
    int maxIterations = 100;
    int size = std::stoi(argv[1], 0, 10);
    std::cout << "size="<<size<<"\n";
    thrust::host_vector<float> A_flat(size*size);
    thrust::host_vector<float> hb(size);
    thrust::host_vector<float> hx(size);
    thrust::host_vector<float> hnextX(size);

    int n = size;
    std::string rfile = argv[2];
    std::ifstream fin(rfile);
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        fin >> A_flat[i*n+j];
        //cout << A[i][j] << " ";
      }
        //cout << endl;
    }
      for (int i = 0; i < n; i++) {
        fin >> hb[i];
      }
      fin.close();
      std::cout << "Read benchmark file "<<rfile<<std::endl;

//   //float * A_flat = new float [size*size];
//   for (int i = 0; i< size*size; i++) {
//       A_flat[i] = i;
//   }
  int size2=size*size;
  thrust::device_vector<float> dA(size2);
  thrust::device_vector<float> dx(size);
  thrust::device_vector<float> db(size);
  thrust::device_vector<float> dnextX(size);
  
  thrust::device_vector<float> temp(size*size);
  thrust::device_vector<int> outkey(size);
  thrust::device_vector<float> sum(size);

  //thrust::fill(dA.begin(), dA.end(), A_flat);
  //thrust::copy(dA.begin(), dA.end(), A_flat);
  dA = A_flat;
  db = hb;
//   thrust::fill(db.begin(), db.end(), 3);
  thrust::fill(dx.begin(), dx.end(), 0);
  thrust::fill(dnextX.begin(), dnextX.end(), 0);

  cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

  int count = 1;
	for (; (count < maxIterations) ; count++)
	{
    if (count % 2) {
			// odd
      solve(dnextX, dA, db, dx, size, temp, outkey, sum);
    }
    else {
      // even
      solve(dx, dA, db, dnextX, size, temp, outkey, sum);
    }
  }

  cudaEventRecord(stop);
    cudaEventSynchronize(stop);
// Get the elapsed time in milliseconds
float ms = 0;
cudaEventElapsedTime(&ms, start, stop);
  std::cout << std::endl << "Iterations:" << count << std::endl;
  printf("%f\n", ms);
  
  hx = dx;
  hnextX = dnextX;

  std::string wfile = argv[3];
  std::ofstream fout(wfile);
    for (int i = 0; i < n; i++)
	{
		fout << std::fixed<<hx[i] << " ";
		//cout << x[i] << "   ";
	}
	fout << std::endl;
	fout.close();

    float * c = new float [size];
	float maxError = 0;
	float total_err = 0;

   for(int i = 0; i < size; i++) {
      c[i] = 0;
      for(int j = 0; j < size; j++)
      {
         c[i] += A_flat[i*size+j] * hx[j];
      }
	  maxError = fmax(maxError, fabs(c[i] - hb[i]));
	  total_err += fabs(c[i] - hb[i]);
   }
   total_err = total_err / size;
   std::cout << "\n==== max error: "<<maxError<<"\n";
	std::cout << "==== avg error: "<<total_err<<"\n";
   delete[] c;

  return 0;
}
