#include "ex2.h"

void v_add_naive(double* x, double* y, double* z) {
    #pragma omp parallel
    {
        for(int i=0; i<ARRAY_SIZE; i++)
            z[i] = x[i] + y[i];
    }
}

// Adjacent Method
void v_add_optimized_adjacent(double* x, double* y, double* z) {
    // TODO: Implement this function
    int total_threads = 0;
    #pragma omp parallel
    {
        total_threads = omp_get_num_threads();
        int id = omp_get_thread_num();
        for(int i = id; i < ARRAY_SIZE; i+=total_threads)
        {
            z[i] = x[i] + y[i];
        }
    }

    for(int i = ARRAY_SIZE / total_threads * total_threads; i < ARRAY_SIZE; i++)
    {
        z[i] = x[i] + y[i];
    }
    // Do NOT use the `for` directive here!
}

// Chunks Method
void v_add_optimized_chunks(double* x, double* y, double* z) {
    // TODO: Implement this function
    int total_threads = 0;
    #pragma omp parallel
    {
        total_threads = omp_get_num_threads();
        int id = omp_get_thread_num();
        int begin = ARRAY_SIZE / total_threads * id;
        int end = ARRAY_SIZE / total_threads * (id + 1);
        for(int i = begin; i < end; i++)
        {
            z[i] = x[i] + y[i];
        }
    }

    for(int i = ARRAY_SIZE / total_threads * total_threads; i < ARRAY_SIZE; i++)
    {
        z[i] = x[i] + y[i];
    }
    // Do NOT use the `for` directive here!
}
