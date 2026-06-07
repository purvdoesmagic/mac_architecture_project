`default_nettype none
`timescale 1ns/1ps

module adder_rca
#(
    parameter WIDTH = 8
)
(
    input  signed [WIDTH-1:0] a,
    input  signed [WIDTH-1:0] b,
    output signed [WIDTH-1:0] sum,
    output                    overflow
);

    wire [WIDTH:0] carry;

    assign carry[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_rca_stage
            // Ripple-carry full adder stage; sum naturally wraps to WIDTH bits.
            assign sum[i]      = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1]  = (a[i] & b[i]) |
                                 (a[i] & carry[i]) |
                                 (b[i] & carry[i]);
        end
    endgenerate

    // Signed overflow occurs when carry into and out of the sign bit differ.
    assign overflow = carry[WIDTH] ^ carry[WIDTH-1];

endmodule

`default_nettype wire
