`timescale 1ns / 1ps

module input_buffer_tb;

parameter DATA_WIDTH = 8;

// Inputs
reg clk;
reg rst;
reg load;
reg shift_enable;
reg signed [16*DATA_WIDTH-1:0] A_flat_in;
reg signed [16*DATA_WIDTH-1:0] B_flat_in;

// Outputs
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
// DUT
//--------------------------------------------------

input_buffer uut
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
// Clock (10 ns period)
//--------------------------------------------------

always #5 clk = ~clk;


//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

    // Create waveform
    $dumpfile("input_buffer_tb.vcd");
    $dumpvars(0, input_buffer_tb);

    // Initialize
    clk = 0;
    rst = 1;
    load = 0;
    shift_enable = 0;

    A_flat_in = 0;
    B_flat_in = 0;

    //--------------------------------------------------
    // Matrix A
    //
    //  1  2  3  4
    //  5  6  7  8
    //  9 10 11 12
    // 13 14 15 16
    //--------------------------------------------------

    A_flat_in = {
        8'd16,8'd15,8'd14,8'd13,
        8'd12,8'd11,8'd10,8'd9,
        8'd8,8'd7,8'd6,8'd5,
        8'd4,8'd3,8'd2,8'd1
    };

    //--------------------------------------------------
    // Matrix B
    //
    //17 18 19 20
    //21 22 23 24
    //25 26 27 28
    //29 30 31 32
    //--------------------------------------------------

    B_flat_in = {
        8'd32,8'd31,8'd30,8'd29,
        8'd28,8'd27,8'd26,8'd25,
        8'd24,8'd23,8'd22,8'd21,
        8'd20,8'd19,8'd18,8'd17
    };

    // Hold reset
    #20;

    rst = 0;

    // Load matrices
    #10;
    load = 1;

    #10;
    load = 0;

    // Start shifting
    shift_enable = 1;

    // Run long enough to flush array
    #150;

    shift_enable = 0;

    #20;

    $finish;

end


//--------------------------------------------------
// Console Output
//--------------------------------------------------

initial
begin

    $display("--------------------------------------------------------------------------");
    $display("Time\tCycle\tA0 A1 A2 A3\t|\tB0 B1 B2 B3\t|\tfeed_done");
    $display("--------------------------------------------------------------------------");

    $monitor("%0t\t%0d\t%0d %0d %0d %0d\t|\t%0d %0d %0d %0d\t|\t%b",
             $time,
             uut.cycle,
             A0,A1,A2,A3,
             B0,B1,B2,B3,
             feed_done);

end

endmodule