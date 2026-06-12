`default_nettype none
`timescale 1ns/1ps

module adder_cla
#(
    parameter WIDTH = 8
)
(
    input  signed [WIDTH-1:0] a,
    input  signed [WIDTH-1:0] b,
    output signed [WIDTH-1:0] sum,
    output                    overflow
);

wire [WIDTH-1:0] p;
wire [WIDTH-1:0] g;
wire [WIDTH:0]   c;

assign c[0] = 1'b0;

genvar i;

generate
for(i=0;i<WIDTH;i=i+1)
begin : cla_stage

    assign p[i] = a[i] ^ b[i];
    assign g[i] = a[i] & b[i];

    assign c[i+1] = g[i] | (p[i] & c[i]);

    assign sum[i] = p[i] ^ c[i];

end
endgenerate

assign overflow = c[WIDTH] ^ c[WIDTH-1];

endmodule

`default_nettype wire