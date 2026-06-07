`timescale 1ns/1ps

module tb_adder_rca;

    reg signed [7:0]   a8;
    reg signed [7:0]   b8;
    wire signed [7:0]  sum8;
    wire               overflow8;

    reg signed [15:0]  a16;
    reg signed [15:0]  b16;
    wire signed [15:0] sum16;
    wire               overflow16;

    reg signed [31:0]  a32;
    reg signed [31:0]  b32;
    wire signed [31:0] sum32;
    wire               overflow32;

    integer tests_run;
    integer errors;

    adder_rca
    #(
        .WIDTH(8)
    )
    dut8
    (
        .a(a8),
        .b(b8),
        .sum(sum8),
        .overflow(overflow8)
    );

    adder_rca
    #(
        .WIDTH(16)
    )
    dut16
    (
        .a(a16),
        .b(b16),
        .sum(sum16),
        .overflow(overflow16)
    );

    adder_rca
    #(
        .WIDTH(32)
    )
    dut32
    (
        .a(a32),
        .b(b32),
        .sum(sum32),
        .overflow(overflow32)
    );

    task check8;
        input signed [7:0] a_val;
        input signed [7:0] b_val;
        input signed [7:0] expected_sum;
        input              expected_overflow;
        begin
            a8 = a_val;
            b8 = b_val;
            #1;
            tests_run = tests_run + 1;
            if ((sum8 !== expected_sum) || (overflow8 !== expected_overflow)) begin
                errors = errors + 1;
                $display("FAIL WIDTH=8  a=%0d b=%0d sum=%0d overflow=%0b expected_sum=%0d expected_overflow=%0b",
                         a_val, b_val, sum8, overflow8, expected_sum, expected_overflow);
            end else begin
                $display("PASS WIDTH=8  a=%0d b=%0d sum=%0d overflow=%0b",
                         a_val, b_val, sum8, overflow8);
            end
        end
    endtask

    task check16;
        input signed [15:0] a_val;
        input signed [15:0] b_val;
        input signed [15:0] expected_sum;
        input               expected_overflow;
        begin
            a16 = a_val;
            b16 = b_val;
            #1;
            tests_run = tests_run + 1;
            if ((sum16 !== expected_sum) || (overflow16 !== expected_overflow)) begin
                errors = errors + 1;
                $display("FAIL WIDTH=16 a=%0d b=%0d sum=%0d overflow=%0b expected_sum=%0d expected_overflow=%0b",
                         a_val, b_val, sum16, overflow16, expected_sum, expected_overflow);
            end else begin
                $display("PASS WIDTH=16 a=%0d b=%0d sum=%0d overflow=%0b",
                         a_val, b_val, sum16, overflow16);
            end
        end
    endtask

    task check32;
        input signed [31:0] a_val;
        input signed [31:0] b_val;
        input signed [31:0] expected_sum;
        input               expected_overflow;
        begin
            a32 = a_val;
            b32 = b_val;
            #1;
            tests_run = tests_run + 1;
            if ((sum32 !== expected_sum) || (overflow32 !== expected_overflow)) begin
                errors = errors + 1;
                $display("FAIL WIDTH=32 a=%0d b=%0d sum=%0d overflow=%0b expected_sum=%0d expected_overflow=%0b",
                         a_val, b_val, sum32, overflow32, expected_sum, expected_overflow);
            end else begin
                $display("PASS WIDTH=32 a=%0d b=%0d sum=%0d overflow=%0b",
                         a_val, b_val, sum32, overflow32);
            end
        end
    endtask

    initial begin
        $dumpfile("waveforms/tb_adder_rca.vcd");
        $dumpvars(0, tb_adder_rca);

        tests_run = 0;
        errors    = 0;

        a8  = 8'sd0;
        b8  = 8'sd0;
        a16 = 16'sd0;
        b16 = 16'sd0;
        a32 = 32'sd0;
        b32 = 32'sd0;
        #1;

        check8(8'sd12,       8'sd34,       8'sd46,        1'b0);
        check8(-8'sd12,     -8'sd23,      -8'sd35,        1'b0);
        check8(8'sd100,     -8'sd45,       8'sd55,        1'b0);
        check8(8'sd127,      8'sd1,        8'sh80,        1'b1);
        check8(8'sh80,      -8'sd1,        8'sd127,       1'b1);
        check8(8'sd127,      8'sd127,     -8'sd2,         1'b1);

        check16(16'sd1234,   16'sd4321,    16'sd5555,     1'b0);
        check16(-16'sd1234, -16'sd4321,   -16'sd5555,     1'b0);
        check16(16'sd20000, -16'sd12345,   16'sd7655,     1'b0);
        check16(16'sd32767,  16'sd1,       16'sh8000,     1'b1);
        check16(16'sh8000,  -16'sd1,       16'sd32767,    1'b1);

        check32(32'sd100000,     32'sd200000,      32'sd300000,      1'b0);
        check32(-32'sd100000,   -32'sd200000,     -32'sd300000,      1'b0);
        check32(32'sd123456789, -32'sd98765432,    32'sd24691357,    1'b0);
        check32(32'sh7fffffff,   32'sd1,           32'sh80000000,    1'b1);
        check32(32'sh80000000,  -32'sd1,           32'sh7fffffff,    1'b1);

        if (errors == 0) begin
            $display("ALL TESTS PASSED: tb_adder_rca tests_run=%0d", tests_run);
        end else begin
            $display("TESTS FAILED: tb_adder_rca tests_run=%0d errors=%0d", tests_run, errors);
        end

        $finish;
    end

endmodule
