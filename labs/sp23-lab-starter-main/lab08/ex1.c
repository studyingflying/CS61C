#include "ex1.h"

double dotp_naive(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    for (int i = 0; i < arr_size; i++)
        global_sum += x[i] * y[i];
    return global_sum;
}

// Critical Keyword
double dotp_critical(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    #pragma omp parallel
    {
        for (int i = 0; i < arr_size; i++)
        {
            #pragma omp critical
            {
                global_sum += x[i] * y[i];
            }
        }
    }
    // Use the critical keyword here!
    return global_sum;
}

// Reduction Keyword
double dotp_reduction(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Use the reduction keyword here!
    #pragma omp parallel for reduction(+:global_sum)
    for (int i = 0; i < arr_size; i++) {
        global_sum += x[i] * y[i];
    }
    
    return global_sum;
}

// Manual Reduction
double dotp_manual_reduction(double* x, double* y, int arr_size) {
    double global_sum = 0.0;
    // TODO: Implement this function
    // Do NOT use the `reduction` directive here!
    
    #pragma omp parallel
    {
        int thread_id = omp_get_thread_num();
        double local_sums = 0.0; // Initialize thread-local sum
        int begin = thread_id * arr_size / omp_get_max_threads();
        int end = (thread_id + 1)* arr_size / omp_get_max_threads();
        
        for (int i = begin; i < end; i++) {
            local_sums += x[i] * y[i];
        }
        
        // Synchronize threads before updating the global sum
        #pragma omp barrier
        
        // Use a critical section to update the global sum
        #pragma omp critical
        {
            global_sum += local_sums;
        }
    }
    
    return global_sum;
}
