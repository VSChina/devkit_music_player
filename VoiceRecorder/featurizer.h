//
// ELL header for module mfcc
//

#pragma once

#include <stdint.h>

#if defined(__cplusplus)
extern "C"
{
#endif // defined(__cplusplus)

//
// Types
//

#if !defined(ELL_TensorShape)
#define ELL_TensorShape

typedef struct TensorShape
{
    int32_t rows;
    int32_t columns;
    int32_t channels;
} TensorShape;

#endif // !defined(ELL_TensorShape)

//
// Functions
//

// Input size: 256
// Output size: 40
void mfcc_Filter(void* context, float* input0, float* output0);

void mfcc_Reset();

int32_t mfcc_GetInputSize();

int32_t mfcc_GetOutputSize();

int32_t mfcc_GetNumNodes();

void mfcc_GetInputShape(int32_t index, TensorShape* shape);

void mfcc_GetOutputShape(int32_t index, TensorShape* shape);

#if defined(__cplusplus)
} // extern "C"
#endif // defined(__cplusplus)

