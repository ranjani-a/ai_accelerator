module systolic_array
#(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)
(
    input clk,
    input rst,
    input enable,

    // Row inputs (A operand enters from the left of each row)
    input signed [DATA_WIDTH-1:0] A0,
    input signed [DATA_WIDTH-1:0] A1,
    input signed [DATA_WIDTH-1:0] A2,
    input signed [DATA_WIDTH-1:0] A3,

    // Column inputs (B operand enters from the top of each column)
    input signed [DATA_WIDTH-1:0] B0,
    input signed [DATA_WIDTH-1:0] B1,
    input signed [DATA_WIDTH-1:0] B2,
    input signed [DATA_WIDTH-1:0] B3,

    // One accumulator output per PE (output-stationary result matrix)
    output wire signed [ACC_WIDTH-1:0] sum00,
    output wire signed [ACC_WIDTH-1:0] sum01,
    output wire signed [ACC_WIDTH-1:0] sum02,
    output wire signed [ACC_WIDTH-1:0] sum03,

    output wire signed [ACC_WIDTH-1:0] sum10,
    output wire signed [ACC_WIDTH-1:0] sum11,
    output wire signed [ACC_WIDTH-1:0] sum12,
    output wire signed [ACC_WIDTH-1:0] sum13,

    output wire signed [ACC_WIDTH-1:0] sum20,
    output wire signed [ACC_WIDTH-1:0] sum21,
    output wire signed [ACC_WIDTH-1:0] sum22,
    output wire signed [ACC_WIDTH-1:0] sum23,

    output wire signed [ACC_WIDTH-1:0] sum30,
    output wire signed [ACC_WIDTH-1:0] sum31,
    output wire signed [ACC_WIDTH-1:0] sum32,
    output wire signed [ACC_WIDTH-1:0] sum33
);

    // -----------------------------------------------------------
    // Internal horizontal wires (A operand, moving left -> right)
    // Naming: A_r_c  = A value leaving row r, column c,
    //                  entering row r, column c+1
    // -----------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] A_0_0, A_0_1, A_0_2;
    wire signed [DATA_WIDTH-1:0] A_1_0, A_1_1, A_1_2;
    wire signed [DATA_WIDTH-1:0] A_2_0, A_2_1, A_2_2;
    wire signed [DATA_WIDTH-1:0] A_3_0, A_3_1, A_3_2;

    // -----------------------------------------------------------
    // Internal vertical wires (B operand, moving top -> bottom)
    // Naming: B_r_c  = B value leaving row r, column c,
    //                  entering row r+1, column c
    // -----------------------------------------------------------
    wire signed [DATA_WIDTH-1:0] B_0_0, B_0_1, B_0_2, B_0_3;
    wire signed [DATA_WIDTH-1:0] B_1_0, B_1_1, B_1_2, B_1_3;
    wire signed [DATA_WIDTH-1:0] B_2_0, B_2_1, B_2_2, B_2_3;

    // =============================================================
    // Row 0
    // =============================================================
    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe00 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A0),      .B_in(B0),
        .A_out(A_0_0),  .B_out(B_0_0),
        .partial_sum(sum00)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe01 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_0_0),   .B_in(B1),
        .A_out(A_0_1),  .B_out(B_0_1),
        .partial_sum(sum01)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe02 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_0_1),   .B_in(B2),
        .A_out(A_0_2),  .B_out(B_0_2),
        .partial_sum(sum02)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe03 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_0_2),   .B_in(B3),
        .A_out(),       .B_out(B_0_3),   // A_out drives off the right edge, unused
        .partial_sum(sum03)
    );

    // =============================================================
    // Row 1
    // =============================================================
    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe10 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A1),      .B_in(B_0_0),
        .A_out(A_1_0),  .B_out(B_1_0),
        .partial_sum(sum10)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe11 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_1_0),   .B_in(B_0_1),
        .A_out(A_1_1),  .B_out(B_1_1),
        .partial_sum(sum11)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe12 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_1_1),   .B_in(B_0_2),
        .A_out(A_1_2),  .B_out(B_1_2),
        .partial_sum(sum12)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe13 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_1_2),   .B_in(B_0_3),
        .A_out(),       .B_out(B_1_3),
        .partial_sum(sum13)
    );

    // =============================================================
    // Row 2
    // =============================================================
    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe20 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A2),      .B_in(B_1_0),
        .A_out(A_2_0),  .B_out(B_2_0),
        .partial_sum(sum20)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe21 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_2_0),   .B_in(B_1_1),
        .A_out(A_2_1),  .B_out(B_2_1),
        .partial_sum(sum21)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe22 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_2_1),   .B_in(B_1_2),
        .A_out(A_2_2),  .B_out(B_2_2),
        .partial_sum(sum22)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe23 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_2_2),   .B_in(B_1_3),
        .A_out(),       .B_out(B_2_3),
        .partial_sum(sum23)
    );

    // =============================================================
    // Row 3
    // =============================================================
    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe30 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A3),      .B_in(B_2_0),
        .A_out(A_3_0),  .B_out(),        // B_out drives off the bottom edge, unused
        .partial_sum(sum30)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe31 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_3_0),   .B_in(B_2_1),
        .A_out(A_3_1),  .B_out(),
        .partial_sum(sum31)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe32 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_3_1),   .B_in(B_2_2),
        .A_out(A_3_2),  .B_out(),
        .partial_sum(sum32)
    );

    pe #(.DATA_WIDTH(DATA_WIDTH), .ACC_WIDTH(ACC_WIDTH)) u_pe33 (
        .clk(clk), .rst(rst), .enable(enable),
        .A_in(A_3_2),   .B_in(B_2_3),
        .A_out(),       .B_out(),
        .partial_sum(sum33)
    );

endmodule