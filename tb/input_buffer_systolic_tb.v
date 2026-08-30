`timescale 1ns / 1ps

module input_buffer_systolic_tb;

parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;

//==================================================
// Inputs
//==================================================

reg clk;
reg rst;

reg load;
reg shift_enable;
reg enable;

reg signed [16*DATA_WIDTH-1:0] A_flat_in;
reg signed [16*DATA_WIDTH-1:0] B_flat_in;

//==================================================
// Wires between Input Buffer and Systolic Array
//==================================================

wire signed [DATA_WIDTH-1:0] A0;
wire signed [DATA_WIDTH-1:0] A1;
wire signed [DATA_WIDTH-1:0] A2;
wire signed [DATA_WIDTH-1:0] A3;

wire signed [DATA_WIDTH-1:0] B0;
wire signed [DATA_WIDTH-1:0] B1;
wire signed [DATA_WIDTH-1:0] B2;
wire signed [DATA_WIDTH-1:0] B3;

wire feed_done;

//==================================================
// Systolic Outputs
//==================================================

wire signed [ACC_WIDTH-1:0] sum00,sum01,sum02,sum03;
wire signed [ACC_WIDTH-1:0] sum10,sum11,sum12,sum13;
wire signed [ACC_WIDTH-1:0] sum20,sum21,sum22,sum23;
wire signed [ACC_WIDTH-1:0] sum30,sum31,sum32,sum33;

//==================================================
// Input Buffer
//==================================================

input_buffer input_buf (

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

//==================================================
// Systolic Array
//==================================================

systolic_array array (

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

//==================================================
// Clock
//==================================================

always #5 clk = ~clk;

//==================================================
// Test
//==================================================

initial
begin

    $dumpfile("input_buffer_systolic_tb.vcd");
    $dumpvars(0,input_buffer_systolic_tb);

    clk = 0;
    rst = 1;

    load = 0;
    shift_enable = 0;
    enable = 0;

    A_flat_in = 0;
    B_flat_in = 0;

    //--------------------------------------------------
    // Matrix A
    //--------------------------------------------------

    A_flat_in = {

        8'd16,8'd15,8'd14,8'd13,
        8'd12,8'd11,8'd10,8'd9,
        8'd8,8'd7,8'd6,8'd5,
        8'd4,8'd3,8'd2,8'd1

    };

    //--------------------------------------------------
    // Matrix B
    //--------------------------------------------------

    B_flat_in = {

        8'd32,8'd31,8'd30,8'd29,
        8'd28,8'd27,8'd26,8'd25,
        8'd24,8'd23,8'd22,8'd21,
        8'd20,8'd19,8'd18,8'd17

    };

    //--------------------------------------------------

    #20;

    rst = 0;

    #10;

    load = 1;

    #10;

    load = 0;

    enable = 1;
    shift_enable = 1;

    //--------------------------------------------------
    // Let the array completely flush
    //--------------------------------------------------

    #300;

    $display("");
    $display("==============================================");
    $display("Final Result Matrix");
    $display("==============================================");

    $display("%d %d %d %d",sum00,sum01,sum02,sum03);
    $display("%d %d %d %d",sum10,sum11,sum12,sum13);
    $display("%d %d %d %d",sum20,sum21,sum22,sum23);
    $display("%d %d %d %d",sum30,sum31,sum32,sum33);

    $display("==============================================");

    $finish;

end

endmodule