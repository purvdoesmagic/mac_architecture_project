`timescale 1ns/1ps

module tb_multiplier_array;

    reg signed [7:0]    a8;
    reg signed [7:0]    b8;
    wire signed [15:0]  product8;

    reg signed [15:0]   a16;
    reg signed [15:0]   b16;
    wire signed [31:0]  product16;

    reg signed [31:0]   a32;
    reg signed [31:0]   b32;
    wire signed [63:0]  product32;

    integer tests_run;
    integer errors;

    multiplier_array
    #(
        .WIDTH(8)
    )
    dut8
    (
        .a(a8),
        .b(b8),
        .product(product8)
    );

    multiplier_array
    #(
        .WIDTH(16)
    )
    dut16
    (
        .a(a16),
        .b(b16),
        .product(product16)
    );

    multiplier_array
    #(
        .WIDTH(32)
    )
    dut32
    (
        .a(a32),
        .b(b32),
        .product(product32)
    );

    task check8;
        input signed [7:0]   a_val;
        input signed [7:0]   b_val;
        input signed [15:0]  expected_product;
        input [1023:0]       test_name;
        begin
            a8 = a_val;
            b8 = b_val;
            #1;
            tests_run = tests_run + 1;
            if (product8 !== expected_product) begin
                errors = errors + 1;
                $display("FAIL WIDTH=8  %0s a=%0d b=%0d product=%0d expected=%0d",
                         test_name, a_val, b_val, product8, expected_product);
            end else begin
                $display("PASS WIDTH=8  %0s a=%0d b=%0d product=%0d",
                         test_name, a_val, b_val, product8);
            end
        end
    endtask

    task check16;
        input signed [15:0]  a_val;
        input signed [15:0]  b_val;
        input signed [31:0]  expected_product;
        input [1023:0]       test_name;
        begin
            a16 = a_val;
            b16 = b_val;
            #1;
            tests_run = tests_run + 1;
            if (product16 !== expected_product) begin
                errors = errors + 1;
                $display("FAIL WIDTH=16 %0s a=%0d b=%0d product=%0d expected=%0d",
                         test_name, a_val, b_val, product16, expected_product);
            end else begin
                $display("PASS WIDTH=16 %0s a=%0d b=%0d product=%0d",
                         test_name, a_val, b_val, product16);
            end
        end
    endtask

    task check32;
        input signed [31:0]  a_val;
        input signed [31:0]  b_val;
        input signed [63:0]  expected_product;
        input [1023:0]       test_name;
        begin
            a32 = a_val;
            b32 = b_val;
            #1;
            tests_run = tests_run + 1;
            if (product32 !== expected_product) begin
                errors = errors + 1;
                $display("FAIL WIDTH=32 %0s a=%0d b=%0d product=%0d expected=%0d",
                         test_name, a_val, b_val, product32, expected_product);
            end else begin
                $display("PASS WIDTH=32 %0s a=%0d b=%0d product=%0d",
                         test_name, a_val, b_val, product32);
            end
        end
    endtask

    initial begin
        $dumpfile("waveforms/tb_multiplier_array.vcd");
        $dumpvars(0, tb_multiplier_array);

        tests_run = 0;
        errors    = 0;

        a8  = 8'sd0;
        b8  = 8'sd0;
        a16 = 16'sd0;
        b16 = 16'sd0;
        a32 = 32'sd0;
        b32 = 32'sd0;
        #1;

        check8(8'sd0,        8'sd57,        16'sd0,                  "zero times positive");
        check8(8'sd12,       8'sd11,        16'sd132,                "positive times positive");
        check8(-8'sd12,      8'sd11,       -16'sd132,                "negative times positive");
        check8(8'sd12,      -8'sd11,       -16'sd132,                "positive times negative");
        check8(-8'sd12,     -8'sd11,        16'sd132,                "negative times negative");
        check8(8'sd127,      8'sd127,       16'sd16129,              "127 times 127 boundary");
        check8(8'sh80,       8'sh80,        16'sh4000,               "-128 times -128 boundary");
        check8(8'sh80,       8'sd127,      -16'sd16256,              "-128 times 127 mixed sign");

        check16(16'sd0,        16'sd1234,       32'sd0,              "zero times positive");
        check16(16'sd1234,     16'sd56,         32'sd69104,          "positive times positive");
        check16(-16'sd1234,    16'sd56,        -32'sd69104,          "negative times positive");
        check16(16'sd1234,    -16'sd56,        -32'sd69104,          "positive times negative");
        check16(-16'sd1234,   -16'sd56,         32'sd69104,          "negative times negative");
        check16(16'sd32767,    16'sd32767,      32'sd1073676289,     "max positive times max positive");
        check16(16'sh8000,     16'sh8000,       32'sh40000000,       "min negative times min negative");
        check16(16'sh8000,     16'sd32767,     -32'sd1073709056,     "min negative times max positive");

        check32(32'sd0,          32'sd123456,       64'sd0,                  "zero times positive");
        check32(32'sd123456,     32'sd789,          64'sd97406784,           "positive times positive");
        check32(-32'sd123456,    32'sd789,         -64'sd97406784,           "negative times positive");
        check32(32'sd123456,    -32'sd789,         -64'sd97406784,           "positive times negative");
        check32(-32'sd123456,   -32'sd789,          64'sd97406784,           "negative times negative");
        check32(32'sh7fffffff,   32'sd1,            64'sd2147483647,         "max positive times one");
        check32(32'sh80000000,   32'sh80000000,     64'sh4000000000000000,   "min negative times min negative");
        check32(32'sh80000000,   32'sh7fffffff,    -64'sd4611686016279904256, "min negative times max positive");

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("TESTS FAILED: tests_run=%0d errors=%0d", tests_run, errors);
        end

        $finish;
    end

endmodule
