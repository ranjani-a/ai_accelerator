module controller
(
    input clk,
    input rst,

    input start,
    input feed_done,

    output reg load,
    output reg shift_enable,
    output reg enable,
    output reg store_enable,
    output reg done
);

    //--------------------------------------------------
    // State Encoding
    //--------------------------------------------------

    localparam IDLE  = 3'd0;
    localparam LOAD  = 3'd1;
    localparam FEED  = 3'd2;
    localparam FLUSH = 3'd3;
    localparam STORE = 3'd4;
    localparam DONE  = 3'd5;

    reg [2:0] state;
    reg [2:0] next_state;

    reg [2:0] flush_count;

    //--------------------------------------------------
    // State Register
    //--------------------------------------------------

    always @(posedge clk) begin

        if (rst)
            state <= IDLE;
        else
            state <= next_state;

    end

    //--------------------------------------------------
    // Flush Counter
    //--------------------------------------------------

    always @(posedge clk) begin

        if (rst)
            flush_count <= 3'd0;

        else if (state != FLUSH)
            flush_count <= 3'd0;

        else if (flush_count < 3'd6)
            flush_count <= flush_count + 1'b1;

    end

    //--------------------------------------------------
    // Next State Logic
    //--------------------------------------------------

    always @(*) begin

        next_state = state;

        case (state)

            IDLE:
            begin
                if (start)
                    next_state = LOAD;
            end

            LOAD:
            begin
                next_state = FEED;
            end

            FEED:
            begin
                if (feed_done)
                    next_state = FLUSH;
            end

            FLUSH:
            begin
                if (flush_count == 3'd6)
                    next_state = STORE;
            end

            STORE:
            begin
                next_state = DONE;
            end

            DONE:
            begin
                if (!start)
                    next_state = IDLE;
            end

            default:
            begin
                next_state = IDLE;
            end

        endcase

    end

    //--------------------------------------------------
    // Output Logic
    //--------------------------------------------------

    always @(*) begin

        // Default outputs

        load         = 1'b0;
        shift_enable = 1'b0;
        enable       = 1'b0;
        store_enable = 1'b0;
        done         = 1'b0;

        case (state)

            IDLE:
            begin
            end

            LOAD:
            begin
                load = 1'b1;
            end

            FEED:
            begin
                shift_enable = 1'b1;
                enable = 1'b1;
            end

            FLUSH:
            begin
                enable = 1'b1;
            end

            STORE:
            begin
                store_enable = 1'b1;
            end

            DONE:
            begin
                done = 1'b1;
            end

            default:
            begin
            end

        endcase

    end

endmodule
