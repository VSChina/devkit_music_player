//
// ELL header for module model
//

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

// Input size: 40
// Output size: 6
void model_Predict(void* context, float* input0, float* output0);

void model_Reset();

int32_t model_GetInputSize();

int32_t model_GetOutputSize();

int32_t model_GetNumNodes();

void model_GetInputShape(int32_t index, TensorShape* shape);

void model_GetOutputShape(int32_t index, TensorShape* shape);

#if defined(__cplusplus)
} // extern "C"
#endif // defined(__cplusplus)

