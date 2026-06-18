`default_nettype none
`timescale 1ns/1ps

module accumulator_v2
#(
    parameter WIDTH = 8,
    parameter ACC_WIDTH = (2*WIDTH)
)
(
    input                             clk,
    input                             rst,
    input                             valid_in,
    input signed [ACC_WIDTH-1:0]      product_in,
    output reg signed [ACC_WIDTH-1:0] acc_out,
    output reg                        overflow_flag
);

    wire signed [ACC_WIDTH-1:0] next_acc;
    wire                        overflow_detected;

    assign next_acc = acc_out + product_in;

    // Signed overflow: same-sign operands produce a result with opposite sign.
    assign overflow_detected = (acc_out[ACC_WIDTH-1] == product_in[ACC_WIDTH-1]) &&
                               (next_acc[ACC_WIDTH-1] != acc_out[ACC_WIDTH-1]);

    always @(posedge clk) begin
        if (rst) begin
            acc_out       <= {ACC_WIDTH{1'b0}};
            overflow_flag <= 1'b0;
        end else if (overflow_flag) begin
            acc_out       <= acc_out;
            overflow_flag <= overflow_flag;
        end else if (valid_in) begin
            if (overflow_detected) begin
                acc_out       <= acc_out;
                overflow_flag <= 1'b1;
            end else begin
                acc_out       <= next_acc;
                overflow_flag <= 1'b0;
            end
        end else begin
            acc_out       <= acc_out;
            overflow_flag <= overflow_flag;
        end
    end

endmodule

`default_nettype wire
