`timescale 1ns/1ps

module tb_mac_top_v2;

reg clk;
reg rst;
reg valid_in;

reg signed [7:0] a;
reg signed [7:0] b;

wire signed [15:0] acc_out;
wire overflow_flag;

mac_top_v2
#(
    .WIDTH(8)
)
dut
(
    .clk(clk),
    .rst(rst),
    .valid_in(valid_in),
    .a(a),
    .b(b),
    .acc_out(acc_out),
    .overflow_flag(overflow_flag)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("waveforms/tb_mac_top_v2.vcd");
    $dumpvars(0, tb_mac_top_v2);

    clk = 0;
    rst = 1;
    valid_in = 0;
    a = 0;
    b = 0;

    #20;
    rst = 0;

    valid_in = 1;

    a = 5;
    b = 3;
    #10;

    a = 2;
    b = 4;
    #10;

    a = -5;
    b = 2;
    #10;

    valid_in = 0;
    #20;

    $display("FINAL ACCUMULATOR = %0d", acc_out);

    if(acc_out !== 13) begin
        $display("FAIL: Expected 13");
        $finish;
    end

    $display("ALL MAC_TOP_V2 TESTS PASSED");

    $finish;

end

endmodule
