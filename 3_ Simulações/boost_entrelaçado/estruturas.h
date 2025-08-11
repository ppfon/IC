typedef struct {
    // inputs
    float reference;
    float measurement;

    // gains
    float kp;
    float ki; 

    // output
    float output;
    float output_sat;

    // internal variables
    float error;
    float err
}