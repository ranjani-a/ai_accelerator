module input_buffer
#(
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input rst,

    // Load matrices
    input load,
    input signed [16*DATA_WIDTH-1:0] A_flat_in,
    input signed [16*DATA_WIDTH-1:0] B_flat_in,

    // Shifts data after every clock cycle
    input shift_enable,

    // Outputs to left edge of array
    output reg signed [DATA_WIDTH-1:0] A0,
    output reg signed [DATA_WIDTH-1:0] A1,
    output reg signed [DATA_WIDTH-1:0] A2,
    output reg signed [DATA_WIDTH-1:0] A3,

    // Outputs to top edge of array
    output reg signed [DATA_WIDTH-1:0] B0,
    output reg signed [DATA_WIDTH-1:0] B1,
    output reg signed [DATA_WIDTH-1:0] B2,
    output reg signed [DATA_WIDTH-1:0] B3,

    // High once all real inputs have been injected
    output reg feed_done
);

    // Matrix storage
    reg signed [DATA_WIDTH-1:0] A_mem [0:15];
    reg signed [DATA_WIDTH-1:0] B_mem [0:15];

    // Injection cycle
    reg [3:0] cycle;

    integer i;

    // Load matrices
    always @(posedge clk) begin
        if (rst) begin
            cycle <= 4'd0;
            for(i=0; i<16; i=i+1) begin
                A_mem[i] <= 0;
                B_mem[i] <= 0;
            end
        end
        else begin
            if(load) begin
                cycle <= 4'd0;
                for(i=0; i<16; i=i+1) begin
                    A_mem[i] <= A_flat_in[i*DATA_WIDTH +: DATA_WIDTH];
                    B_mem[i] <= B_flat_in[i*DATA_WIDTH +: DATA_WIDTH];
                end
            end
            else if(shift_enable) begin
                // Saturate cycle at 7 to prevent wraparound re-injection
                if (cycle < 4'd7) begin
                    cycle <= cycle + 1'b1;
                end
            end
        end
    end

    // Scheduler
    always @(*) begin
        // Default outputs are zero
        A0 = 0; A1 = 0; A2 = 0; A3 = 0;
        B0 = 0; B1 = 0; B2 = 0; B3 = 0;

        // All real data injected after cycle 6
        feed_done = (cycle >= 4'd6);

        case(cycle)
            4'd0: begin
                A0 = A_mem[0];
                B0 = B_mem[0];
            end

            4'd1: begin
                A0 = A_mem[1]; A1 = A_mem[4];
                B0 = B_mem[4]; B1 = B_mem[1];
            end

            4'd2: begin
                A0 = A_mem[2]; A1 = A_mem[5]; A2 = A_mem[8];
                B0 = B_mem[8]; B1 = B_mem[5]; B2 = B_mem[2];
            end

            4'd3: begin
                A0 = A_mem[3];  A1 = A_mem[6];  A2 = A_mem[9];  A3 = A_mem[12];
                B0 = B_mem[12]; B1 = B_mem[9];  B2 = B_mem[6];  B3 = B_mem[3];
            end

            4'd4: begin
                A1 = A_mem[7];  A2 = A_mem[10]; A3 = A_mem[13];
                B1 = B_mem[13]; B2 = B_mem[10]; B3 = B_mem[7];
            end

            4'd5: begin
                A2 = A_mem[11]; A3 = A_mem[14];
                B2 = B_mem[14]; B3 = B_mem[11];
            end

            4'd6: begin
                A3 = A_mem[15];
                B3 = B_mem[15];
            end

            default: begin
                // Zero padding after cycle 6
            end
        endcase
    end

endmodule