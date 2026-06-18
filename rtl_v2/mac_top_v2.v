`default_nettype none
`timescale 1ns/1ps

module mac_top_v2
#(
    parameter WIDTH = 8,
    parameter ACC_WIDTH = (2*WIDTH)
)
(
    input                             clk,
    input                             rst,
    input                             valid_in,
    input signed [WIDTH-1:0]          a,
    input signed [WIDTH-1:0]          b,
    output signed [ACC_WIDTH-1:0]     acc_out,
    output                            overflow_flag
);

    wire signed [ACC_WIDTH-1:0] product;

    multiplier_booth
    #(
        .WIDTH(WIDTH)
    )
    u_multiplier_booth
    (
        .a(a),
        .b(b),
        .product(product)
    );

    accumulator_v2
    #(
        .WIDTH(WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    )
    u_accumulator_v2
    (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .product_in(product),
        .acc_out(acc_out),
        .overflow_flag(overflow_flag)
    );

endmodule

`default_nettype wire