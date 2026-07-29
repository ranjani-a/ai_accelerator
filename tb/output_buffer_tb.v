module output_buffer_tb;

parameter ACC_WIDTH = 32;

// Clock and control
reg clk;
reg rst;
reg store_enable;

// Inputs to output buffer
reg signed [ACC_WIDTH-1:0] sum00, sum01, sum02, sum03;
reg signed [ACC_WIDTH-1:0] sum10, sum11, sum12, sum13;
reg signed [ACC_WIDTH-1:0] sum20, sum21, sum22, sum23;
reg signed [ACC_WIDTH-1:0] sum30, sum31, sum32, sum33;

// Outputs
wire signed [ACC_WIDTH-1:0] C00, C01, C02, C03;
wire signed [ACC_WIDTH-1:0] C10, C11, C12, C13;
wire signed [ACC_WIDTH-1:0] C20, C21, C22, C23;
wire signed [ACC_WIDTH-1:0] C30, C31, C32, C33;

// Instantiate DUT
output_buffer #(
    .ACC_WIDTH(ACC_WIDTH)
) dut (
    .clk(clk),
    .rst(rst),
    .store_enable(store_enable),

    .sum00(sum00), .sum01(sum01), .sum02(sum02), .sum03(sum03),
    .sum10(sum10), .sum11(sum11), .sum12(sum12), .sum13(sum13),
    .sum20(sum20), .sum21(sum21), .sum22(sum22), .sum23(sum23),
    .sum30(sum30), .sum31(sum31), .sum32(sum32), .sum33(sum33),

    .C00(C00), .C01(C01), .C02(C02), .C03(C03),
    .C10(C10), .C11(C11), .C12(C12), .C13(C13),
    .C20(C20), .C21(C21), .C22(C22), .C23(C23),
    .C30(C30), .C31(C31), .C32(C32), .C33(C33)
);

// Clock generation
always #5 clk = ~clk;

initial begin

    clk = 0;
    rst = 1;
    store_enable = 0;

    // Initialize inputs
    sum00=250; sum01=260; sum02=270; sum03=280;
    sum10=618; sum11=644; sum12=670; sum13=696;
    sum20=986; sum21=1028; sum22=1070; sum23=1112;
    sum30=1354; sum31=1412; sum32=1470; sum33=1528;

    // Hold reset
    #15;
    rst = 0;

    // Store first matrix
    @(posedge clk);
    store_enable = 1;

    @(posedge clk);
    store_enable = 0;

    $display("\nStored Matrix:");
    $display("%d %d %d %d", C00,C01,C02,C03);
    $display("%d %d %d %d", C10,C11,C12,C13);
    $display("%d %d %d %d", C20,C21,C22,C23);
    $display("%d %d %d %d", C30,C31,C32,C33);

    // Change inputs
    sum00=9999;
    sum11=9999;
    sum22=9999;
    sum33=9999;

    @(posedge clk);

    $display("\nOutputs should NOT change:");
    $display("%d %d %d %d", C00,C01,C02,C03);
    $display("%d %d %d %d", C10,C11,C12,C13);
    $display("%d %d %d %d", C20,C21,C22,C23);
    $display("%d %d %d %d", C30,C31,C32,C33);

    // Store again
    store_enable = 1;

    @(posedge clk);
    store_enable = 0;

    $display("\nAfter second store:");
    $display("%d %d %d %d", C00,C01,C02,C03);
    $display("%d %d %d %d", C10,C11,C12,C13);
    $display("%d %d %d %d", C20,C21,C22,C23);
    $display("%d %d %d %d", C30,C31,C32,C33);

    #20;
    $finish;

end

endmodule