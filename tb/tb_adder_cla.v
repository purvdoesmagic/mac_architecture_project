`timescale 1ns/1ps

module tb_adder_cla;

reg signed [7:0] a;
reg signed [7:0] b;

wire signed [7:0] sum;
wire overflow;

adder_cla #(.WIDTH(8)) dut (
    .a(a),
    .b(b),
    .sum(sum),
    .overflow(overflow)
);

initial begin

    $dumpfile("waveforms/tb_adder_cla.vcd");
    $dumpvars(0, tb_adder_cla);

    a = 50;
    b = 25;
    #10;

    a = -10;
    b = -20;
    #10;

    a = 127;
    b = 1;
    #10;

    a = -128;
    b = -1;
    #10;

    $display("CLA TEST COMPLETED");

    $finish;
end

endmodule