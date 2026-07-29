module output_buffer
#(
    parameter ACC_WIDTH = 32
)
(
    input clk,
    input rst,

    // Store results
    input store_enable,

    // Inputs from systolic array
    input signed [ACC_WIDTH-1:0] sum00,
    input signed [ACC_WIDTH-1:0] sum01,
    input signed [ACC_WIDTH-1:0] sum02,
    input signed [ACC_WIDTH-1:0] sum03,

    input signed [ACC_WIDTH-1:0] sum10,
    input signed [ACC_WIDTH-1:0] sum11,
    input signed [ACC_WIDTH-1:0] sum12,
    input signed [ACC_WIDTH-1:0] sum13,

    input signed [ACC_WIDTH-1:0] sum20,
    input signed [ACC_WIDTH-1:0] sum21,
    input signed [ACC_WIDTH-1:0] sum22,
    input signed [ACC_WIDTH-1:0] sum23,

    input signed [ACC_WIDTH-1:0] sum30,
    input signed [ACC_WIDTH-1:0] sum31,
    input signed [ACC_WIDTH-1:0] sum32,
    input signed [ACC_WIDTH-1:0] sum33,

    // Stored outputs
    output reg signed [ACC_WIDTH-1:0] C00,
    output reg signed [ACC_WIDTH-1:0] C01,
    output reg signed [ACC_WIDTH-1:0] C02,
    output reg signed [ACC_WIDTH-1:0] C03,

    output reg signed [ACC_WIDTH-1:0] C10,
    output reg signed [ACC_WIDTH-1:0] C11,
    output reg signed [ACC_WIDTH-1:0] C12,
    output reg signed [ACC_WIDTH-1:0] C13,

    output reg signed [ACC_WIDTH-1:0] C20,
    output reg signed [ACC_WIDTH-1:0] C21,
    output reg signed [ACC_WIDTH-1:0] C22,
    output reg signed [ACC_WIDTH-1:0] C23,

    output reg signed [ACC_WIDTH-1:0] C30,
    output reg signed [ACC_WIDTH-1:0] C31,
    output reg signed [ACC_WIDTH-1:0] C32,
    output reg signed [ACC_WIDTH-1:0] C33
);

always @(posedge clk)
begin

    if(rst)
    begin

        C00 <= 0; C01 <= 0; C02 <= 0; C03 <= 0;
        C10 <= 0; C11 <= 0; C12 <= 0; C13 <= 0;
        C20 <= 0; C21 <= 0; C22 <= 0; C23 <= 0;
        C30 <= 0; C31 <= 0; C32 <= 0; C33 <= 0;

    end

    else if(store_enable)
    begin

        C00 <= sum00; C01 <= sum01; C02 <= sum02; C03 <= sum03;
        C10 <= sum10; C11 <= sum11; C12 <= sum12; C13 <= sum13;
        C20 <= sum20; C21 <= sum21; C22 <= sum22; C23 <= sum23;
        C30 <= sum30; C31 <= sum31; C32 <= sum32; C33 <= sum33;

    end

end

endmodule