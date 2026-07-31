`timescale 1ns / 1ps

module controller_tb;

//--------------------------------------------------
// Inputs
//--------------------------------------------------

reg clk;
reg rst;

reg start;
reg feed_done;

//--------------------------------------------------
// Outputs
//--------------------------------------------------

wire load;
wire shift_enable;
wire enable;
wire store_enable;
wire done;

//--------------------------------------------------
// DUT
//--------------------------------------------------

controller uut
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
// Clock
//--------------------------------------------------

always #5 clk = ~clk;

//--------------------------------------------------
// Test
//--------------------------------------------------

initial
begin

    $dumpfile("controller_tb.vcd");
    $dumpvars(0, controller_tb);

    clk = 0;
    rst = 1;

    start = 0;
    feed_done = 0;

    //----------------------------
    // Reset
    //----------------------------

    #20;
    rst = 0;

    //----------------------------
    // Start controller
    //----------------------------

    #10;
    start = 1;

    //----------------------------
    // Stay in FEED
    //----------------------------

    repeat(8)
        @(posedge clk);

    //----------------------------
    // Input buffer finished
    //----------------------------

    feed_done = 1;

    @(posedge clk);

    feed_done = 0;

    //----------------------------
    // Wait for FLUSH + STORE
    //----------------------------

    repeat(10)
        @(posedge clk);

    //----------------------------
    // Return to IDLE
    //----------------------------

    start = 0;

    repeat(3)
        @(posedge clk);

    $finish;

end;

//--------------------------------------------------
// Console Output
//--------------------------------------------------

initial
begin

    $display("--------------------------------------------------------------------------------------");
    $display("Time\tState\tFlush\tLoad\tShift\tEnable\tStore\tDone");
    $display("--------------------------------------------------------------------------------------");

    $monitor("%0t\t%0d\t%0d\t%b\t%b\t%b\t%b\t%b",
        $time,
        uut.state,
        uut.flush_count,
        load,
        shift_enable,
        enable,
        store_enable,
        done
    );

end

endmodule