`timescale 1ns/1ps

module tb_multiplier_booth;

reg signed [7:0] a;
reg signed [7:0] b;

wire signed [15:0] product;

multiplier_booth #(.WIDTH(8)) dut (
    .a(a),
    .b(b),
    .product(product)
);

initial begin

    $dumpfile("waveforms/tb_multiplier_booth.vcd");
    $dumpvars(0, tb_multiplier_booth);

    a = 5; b = 3; #10;
    if(product !== 15) begin
        $display("FAIL: 5 * 3");
        $finish;
    end

    a = -5; b = 3; #10;
    if(product !== -15) begin
        $display("FAIL: -5 * 3");
        $finish;
    end

    a = 5; b = -3; #10;
    if(product !== -15) begin
        $display("FAIL: 5 * -3");
        $finish;
    end

    a = -5; b = -3; #10;
    if(product !== 15) begin
        $display("FAIL: -5 * -3");
        $finish;
    end

    a = 127; b = 127; #10;
    if(product !== 16129) begin
        $display("FAIL: 127 * 127");
        $finish;
    end

  a = -128;
b = 127;
#10;

$display("DEBUG: a=%0d b=%0d product=%0d expected=%0d",
          a, b, product, -16256);

if(product !== -16256) begin
    $display("FAIL: -128 * 127");
    $finish;
end

    $display("ALL BOOTH TESTS PASSED");
    $finish;

end

endmodule