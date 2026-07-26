`timescale 1ns/1ps

import accelerator_pkg::*;

module pe (
    input  logic clk,
    input  logic rst,
    input  logic enable,

    input  data_t A_in,
    input  data_t B_in,

    output data_t A_out,
    output data_t B_out,

    output acc_t partial_sum
);

    // Internal registers
    data_t A_reg;
    data_t B_reg;
    acc_t  accumulator;

    // Processing element logic
    always_ff @(posedge clk) begin
        if (rst) begin
            A_reg       <= '0;
            B_reg       <= '0;
            accumulator <= '0;
        end
        else if (enable) begin
            A_reg       <= A_in;
            B_reg       <= B_in;
            accumulator <= accumulator + (A_in * B_in);
        end
    end

    // Forward registered data
    assign A_out = A_reg;
    assign B_out = B_reg;

    // Output accumulated result
    assign partial_sum = accumulator;

endmodule