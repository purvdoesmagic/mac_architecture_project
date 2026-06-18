`default_nettype none
`timescale 1ns/1ps

module multiplier_booth
#(
    parameter WIDTH = 8
)
(
    input  signed [WIDTH-1:0] a,
    input  signed [WIDTH-1:0] b,
    output reg signed [(2*WIDTH)-1:0] product
);

integer i;

reg [WIDTH-1:0] a_mag;
reg [WIDTH-1:0] b_mag;

reg [(2*WIDTH)-1:0] partial_product;

reg result_sign;

always @(*) begin

    result_sign = a[WIDTH-1] ^ b[WIDTH-1];

    a_mag = a[WIDTH-1] ? (~a + 1'b1) : a;
    b_mag = b[WIDTH-1] ? (~b + 1'b1) : b;

    partial_product = 0;

    for(i = 0; i < WIDTH; i = i + 1) begin
        if(b_mag[i])
            partial_product =
                partial_product +
                ({{WIDTH{1'b0}}, a_mag} << i);
    end

    if(result_sign)
        product = -$signed(partial_product);
    else
        product = partial_product;

end

endmodule

`default_nettype wire