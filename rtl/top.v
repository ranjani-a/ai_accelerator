module top
#(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)
(
    input clk,
    input rst,
    input start,

    // Input matrices
    input signed [(16*DATA_WIDTH)-1:0] A_flat_in,
    input signed [(16*DATA_WIDTH)-1:0] B_flat_in,

    // Accelerator finished
    output done,

    // Result matrix
    output signed [ACC_WIDTH-1:0] C00,
    output signed [ACC_WIDTH-1:0] C01,
    output signed [ACC_WIDTH-1:0] C02,
    output signed [ACC_WIDTH-1:0] C03,

    output signed [ACC_WIDTH-1:0] C10,
    output signed [ACC_WIDTH-1:0] C11,
    output signed [ACC_WIDTH-1:0] C12,
    output signed [ACC_WIDTH-1:0] C13,

    output signed [ACC_WIDTH-1:0] C20,
    output signed [ACC_WIDTH-1:0] C21,
    output signed [ACC_WIDTH-1:0] C22,
    output signed [ACC_WIDTH-1:0] C23,

    output signed [ACC_WIDTH-1:0] C30,
    output signed [ACC_WIDTH-1:0] C31,
    output signed [ACC_WIDTH-1:0] C32,
    output signed [ACC_WIDTH-1:0] C33
);
//--------------------------------------------------
// Controller Signals
//--------------------------------------------------

wire load;
wire shift_enable;
wire enable;
wire store_enable;

//--------------------------------------------------
// Input Buffer -> Systolic Array
//--------------------------------------------------

wire signed [DATA_WIDTH-1:0] A0;
wire signed [DATA_WIDTH-1:0] A1;
wire signed [DATA_WIDTH-1:0] A2;
wire signed [DATA_WIDTH-1:0] A3;

wire signed [DATA_WIDTH-1:0] B0;
wire signed [DATA_WIDTH-1:0] B1;
wire signed [DATA_WIDTH-1:0] B2;
wire signed [DATA_WIDTH-1:0] B3;

wire feed_done;

//--------------------------------------------------
// Systolic Array -> Output Buffer
//--------------------------------------------------

wire signed [ACC_WIDTH-1:0] sum00;
wire signed [ACC_WIDTH-1:0] sum01;
wire signed [ACC_WIDTH-1:0] sum02;
wire signed [ACC_WIDTH-1:0] sum03;

wire signed [ACC_WIDTH-1:0] sum10;
wire signed [ACC_WIDTH-1:0] sum11;
wire signed [ACC_WIDTH-1:0] sum12;
wire signed [ACC_WIDTH-1:0] sum13;

wire signed [ACC_WIDTH-1:0] sum20;
wire signed [ACC_WIDTH-1:0] sum21;
wire signed [ACC_WIDTH-1:0] sum22;
wire signed [ACC_WIDTH-1:0] sum23;

wire signed [ACC_WIDTH-1:0] sum30;
wire signed [ACC_WIDTH-1:0] sum31;
wire signed [ACC_WIDTH-1:0] sum32;
wire signed [ACC_WIDTH-1:0] sum33;
//--------------------------------------------------
// Controller
//--------------------------------------------------

controller controller_inst
(
    .clk(clk),
    .rst(rst),

    .start(start),
    .feed_done(feed_done),

    .load(load),
    .shift_enable(shift_enable),
    .enable(enable),
    .store_enable(store_enable),
    .done(done)
);
//--------------------------------------------------
// Input Buffer
//--------------------------------------------------

input_buffer
#(
    .DATA_WIDTH(DATA_WIDTH)
)
input_buffer_inst
(
    .clk(clk),
    .rst(rst),

    .load(load),
    .A_flat_in(A_flat_in),
    .B_flat_in(B_flat_in),

    .shift_enable(shift_enable),

    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),

    .B0(B0),
    .B1(B1),
    .B2(B2),
    .B3(B3),

    .feed_done(feed_done)
);
//--------------------------------------------------
// Systolic Array
//--------------------------------------------------

systolic_array
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
)
systolic_array_inst
(
    .clk(clk),
    .rst(rst),
    .enable(enable),

    .A0(A0),
    .A1(A1),
    .A2(A2),
    .A3(A3),

    .B0(B0),
    .B1(B1),
    .B2(B2),
    .B3(B3),

    .sum00(sum00),
    .sum01(sum01),
    .sum02(sum02),
    .sum03(sum03),

    .sum10(sum10),
    .sum11(sum11),
    .sum12(sum12),
    .sum13(sum13),

    .sum20(sum20),
    .sum21(sum21),
    .sum22(sum22),
    .sum23(sum23),

    .sum30(sum30),
    .sum31(sum31),
    .sum32(sum32),
    .sum33(sum33)
);
//--------------------------------------------------
// Output Buffer
//--------------------------------------------------

output_buffer
#(
    .ACC_WIDTH(ACC_WIDTH)
)
output_buffer_inst
(
    .clk(clk),
    .rst(rst),

    .store_enable(store_enable),

    .sum00(sum00),
    .sum01(sum01),
    .sum02(sum02),
    .sum03(sum03),

    .sum10(sum10),
    .sum11(sum11),
    .sum12(sum12),
    .sum13(sum13),

    .sum20(sum20),
    .sum21(sum21),
    .sum22(sum22),
    .sum23(sum23),

    .sum30(sum30),
    .sum31(sum31),
    .sum32(sum32),
    .sum33(sum33),

    .C00(C00),
    .C01(C01),
    .C02(C02),
    .C03(C03),

    .C10(C10),
    .C11(C11),
    .C12(C12),
    .C13(C13),

    .C20(C20),
    .C21(C21),
    .C22(C22),
    .C23(C23),

    .C30(C30),
    .C31(C31),
    .C32(C32),
    .C33(C33)
);

endmodule
