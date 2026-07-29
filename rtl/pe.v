module pe
#(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)
(
    input clk,
    input rst,
    input enable,

    input  signed [DATA_WIDTH-1:0] A_in,
    input  signed [DATA_WIDTH-1:0] B_in,

    output signed [DATA_WIDTH-1:0] A_out,
    output signed [DATA_WIDTH-1:0] B_out,

    output reg signed [ACC_WIDTH-1:0] partial_sum
);

    // Internal pipeline registers
    reg signed [DATA_WIDTH-1:0] A_reg;
    reg signed [DATA_WIDTH-1:0] B_reg;

    // Pass registered data directly to neighbors (1 cycle delay per PE)
    assign A_out = A_reg;
    assign B_out = B_reg;

    always @(posedge clk) begin
        if (rst) begin
            A_reg       <= 0;
            B_reg       <= 0;
            partial_sum <= 0;
        end
        else if (enable) begin
            A_reg       <= A_in;
            B_reg       <= B_in;

            // Multiply-Accumulate using registered inputs
            partial_sum <= partial_sum + (A_reg * B_reg);
        end
    end

endmodule