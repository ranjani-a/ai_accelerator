`timescale 1ns / 1ps

module top_tb;

parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;

//--------------------------------------------------
// Inputs
//--------------------------------------------------

reg clk;
reg rst;
reg start;

reg signed [16*DATA_WIDTH-1:0] A_flat_in;
reg signed [16*DATA_WIDTH-1:0] B_flat_in;

//--------------------------------------------------
// Outputs
//--------------------------------------------------

wire done;

wire signed [ACC_WIDTH-1:0] C00;
wire signed [ACC_WIDTH-1:0] C01;
wire signed [ACC_WIDTH-1:0] C02;
wire signed [ACC_WIDTH-1:0] C03;

wire signed [ACC_WIDTH-1:0] C10;
wire signed [ACC_WIDTH-1:0] C11;
wire signed [ACC_WIDTH-1:0] C12;
wire signed [ACC_WIDTH-1:0] C13;

wire signed [ACC_WIDTH-1:0] C20;
wire signed [ACC_WIDTH-1:0] C21;
wire signed [ACC_WIDTH-1:0] C22;
wire signed [ACC_WIDTH-1:0] C23;

wire signed [ACC_WIDTH-1:0] C30;
wire signed [ACC_WIDTH-1:0] C31;
wire signed [ACC_WIDTH-1:0] C32;
wire signed [ACC_WIDTH-1:0] C33;
//--------------------------------------------------
// DUT
//--------------------------------------------------

top
#(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
)
uut
(
    .clk(clk),
    .rst(rst),
    .start(start),

    .A_flat_in(A_flat_in),
    .B_flat_in(B_flat_in),

    .done(done),

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
//--------------------------------------------------
// Clock
//--------------------------------------------------

always #5 clk = ~clk;
//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);

    clk = 0;
    rst = 1;
    start = 0;

    A_flat_in = 0;
    B_flat_in = 0;

    //--------------------------------------------------
    // Matrix A (Identity)
    //
    // 1 0 0 0
    // 0 1 0 0
    // 0 0 1 0
    // 0 0 0 1
    //--------------------------------------------------

    A_flat_in = {
        8'd1,8'd0,8'd0,8'd0,
        8'd0,8'd1,8'd0,8'd0,
        8'd0,8'd0,8'd1,8'd0,
        8'd0,8'd0,8'd0,8'd1
    };

    //--------------------------------------------------
    // Matrix B
    //
    //  2  3  4  5
    //  6  7  8  9
    // 10 11 12 13
    // 14 15 16 17
    //--------------------------------------------------

    B_flat_in = {
        8'd17,8'd16,8'd15,8'd14,
        8'd13,8'd12,8'd11,8'd10,
        8'd9,8'd8,8'd7,8'd6,
        8'd5,8'd4,8'd3,8'd2
    };

    //--------------------------------------------------
    // Reset
    //--------------------------------------------------

    #20;
    rst = 0;

    //--------------------------------------------------
    // Start Accelerator
    //--------------------------------------------------

    #10;
    start = 1;

    //--------------------------------------------------
    // Wait until computation finishes
    //--------------------------------------------------

    wait(done);

    @(posedge clk);

    //--------------------------------------------------
    // Print Result Matrix
    //--------------------------------------------------

    $display("");
    $display("==============================================");
    $display("Final Result Matrix");
    $display("==============================================");

    $display("%d %d %d %d", C00,C01,C02,C03);
    $display("%d %d %d %d", C10,C11,C12,C13);
    $display("%d %d %d %d", C20,C21,C22,C23);
    $display("%d %d %d %d", C30,C31,C32,C33);

    $display("==============================================");

    #20;

    $finish;

end

endmodule
