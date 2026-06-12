`default_nettype none
`timescale 1ns/1ps

module multiplier_array
#(
    parameter WIDTH = 8
)
(
    input  signed [WIDTH-1:0]       a,
    input  signed [WIDTH-1:0]       b,
    output signed [(2*WIDTH)-1:0]   product
);

    localparam PRODUCT_WIDTH = (2*WIDTH);

    wire [WIDTH-1:0]         a_bits;
    wire [WIDTH-1:0]         b_bits;
    wire [WIDTH-1:0]         a_magnitude;
    wire [WIDTH-1:0]         b_magnitude;
    wire                     product_negative;
    wire [PRODUCT_WIDTH-1:0] multiplicand_ext;
    wire [PRODUCT_WIDTH-1:0] signed_product_bits;

    reg  [PRODUCT_WIDTH-1:0] unsigned_product;

    integer i;

    assign a_bits = a;
    assign b_bits = b;

    // Magnitudes allow the partial-product array to handle signed inputs,
    // including the most-negative two's-complement operand.
    assign a_magnitude = a[WIDTH-1] ? ((~a_bits) + 1'b1) : a_bits;
    assign b_magnitude = b[WIDTH-1] ? ((~b_bits) + 1'b1) : b_bits;

    assign product_negative = a[WIDTH-1] ^ b[WIDTH-1];
    assign multiplicand_ext = {{WIDTH{1'b0}}, a_magnitude};

    always @* begin
        unsigned_product = {PRODUCT_WIDTH{1'b0}};

        for (i = 0; i < WIDTH; i = i + 1) begin
            if (b_magnitude[i]) begin
                unsigned_product = unsigned_product + (multiplicand_ext << i);
            end
        end
    end

    assign signed_product_bits = product_negative ?
                                 ((~unsigned_product) + 1'b1) :
                                 unsigned_product;

    assign product = signed_product_bits;

endmodule

`default_nettype wire
