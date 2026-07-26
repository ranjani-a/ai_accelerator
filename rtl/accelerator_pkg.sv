package accelerator_pkg;

    
    // Accelerator Parameters
    

    // Number of rows/columns in the systolic array
    parameter int N = 4;

    // Width of each matrix element
    parameter int DATA_WIDTH = 8;

    // Width of multiplication result
    parameter int PRODUCT_WIDTH = 2 * DATA_WIDTH;

    // Width of accumulator inside each PE
    parameter int ACC_WIDTH = 32;

    /
    // Common Data Types
    

    typedef logic signed [DATA_WIDTH-1:0] data_t;
    typedef logic signed [PRODUCT_WIDTH-1:0] product_t;
    typedef logic signed [ACC_WIDTH-1:0] acc_t;

endpackage : accelerator_pkg