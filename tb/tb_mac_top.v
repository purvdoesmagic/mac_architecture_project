`timescale 1ns/1ps

module tb_mac_top;

    reg clk;

    reg rst8;
    reg valid_in8;
    reg signed [7:0] a8;
    reg signed [7:0] b8;
    wire signed [15:0] acc_out8;
    wire overflow_flag8;

    reg rst16;
    reg valid_in16;
    reg signed [15:0] a16;
    reg signed [15:0] b16;
    wire signed [31:0] acc_out16;
    wire overflow_flag16;

    integer tests_run;
    integer errors;

    mac_top
    #(
        .WIDTH(8)
    )
    dut8
    (
        .clk(clk),
        .rst(rst8),
        .valid_in(valid_in8),
        .a(a8),
        .b(b8),
        .acc_out(acc_out8),
        .overflow_flag(overflow_flag8)
    );

    mac_top
    #(
        .WIDTH(16)
    )
    dut16
    (
        .clk(clk),
        .rst(rst16),
        .valid_in(valid_in16),
        .a(a16),
        .b(b16),
        .acc_out(acc_out16),
        .overflow_flag(overflow_flag16)
    );

    always begin
        #5 clk = ~clk;
    end

    task check8;
        input signed [15:0] expected_acc;
        input               expected_overflow;
        input [1023:0]      test_name;
        begin
            tests_run = tests_run + 1;
            if ((acc_out8 !== expected_acc) || (overflow_flag8 !== expected_overflow)) begin
                errors = errors + 1;
                $display("FAIL WIDTH=8  %0s acc_out=%0d overflow_flag=%0b expected_acc=%0d expected_overflow=%0b",
                         test_name, acc_out8, overflow_flag8, expected_acc, expected_overflow);
            end else begin
                $display("PASS WIDTH=8  %0s acc_out=%0d overflow_flag=%0b",
                         test_name, acc_out8, overflow_flag8);
            end
        end
    endtask

    task check16;
        input signed [31:0] expected_acc;
        input               expected_overflow;
        input [1023:0]      test_name;
        begin
            tests_run = tests_run + 1;
            if ((acc_out16 !== expected_acc) || (overflow_flag16 !== expected_overflow)) begin
                errors = errors + 1;
                $display("FAIL WIDTH=16 %0s acc_out=%0d overflow_flag=%0b expected_acc=%0d expected_overflow=%0b",
                         test_name, acc_out16, overflow_flag16, expected_acc, expected_overflow);
            end else begin
                $display("PASS WIDTH=16 %0s acc_out=%0d overflow_flag=%0b",
                         test_name, acc_out16, overflow_flag16);
            end
        end
    endtask

    task cycle8;
        input               valid_value;
        input signed [7:0]  a_value;
        input signed [7:0]  b_value;
        begin
            @(negedge clk);
            valid_in8 = valid_value;
            a8        = a_value;
            b8        = b_value;
            @(posedge clk);
            #1;
        end
    endtask

    task cycle16;
        input               valid_value;
        input signed [15:0] a_value;
        input signed [15:0] b_value;
        begin
            @(negedge clk);
            valid_in16 = valid_value;
            a16        = a_value;
            b16        = b_value;
            @(posedge clk);
            #1;
        end
    endtask

    task reset8;
        begin
            @(negedge clk);
            rst8      = 1'b1;
            valid_in8 = 1'b0;
            a8        = 8'sd0;
            b8        = 8'sd0;
            @(posedge clk);
            #1;
            check8(16'sd0, 1'b0, "synchronous reset clears state");
            @(negedge clk);
            rst8 = 1'b0;
        end
    endtask

    task reset16;
        begin
            @(negedge clk);
            rst16      = 1'b1;
            valid_in16 = 1'b0;
            a16        = 16'sd0;
            b16        = 16'sd0;
            @(posedge clk);
            #1;
            check16(32'sd0, 1'b0, "synchronous reset clears state");
            @(negedge clk);
            rst16 = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("waveforms/tb_mac_top.vcd");
        $dumpvars(0, tb_mac_top);

        clk         = 1'b0;
        rst8        = 1'b0;
        valid_in8   = 1'b0;
        a8          = 8'sd0;
        b8          = 8'sd0;
        rst16       = 1'b0;
        valid_in16  = 1'b0;
        a16         = 16'sd0;
        b16         = 16'sd0;
        tests_run   = 0;
        errors      = 0;

        reset8();
        cycle8(1'b1, 8'sd12, 8'sd11);
        check8(16'sd132, 1'b0, "positive product accumulation");
        cycle8(1'b1, -8'sd3, 8'sd20);
        check8(16'sd72, 1'b0, "negative product accumulation");
        cycle8(1'b1, -8'sd4, -8'sd5);
        check8(16'sd92, 1'b0, "negative times negative accumulation");
        cycle8(1'b0, 8'sd127, 8'sd127);
        check8(16'sd92, 1'b0, "valid_in low holds accumulated value");

        reset8();
        cycle8(1'b1, 8'sd127, 8'sd127);
        check8(16'sd16129, 1'b0, "127 times 127 first accumulation");
        cycle8(1'b1, 8'sd127, 8'sd127);
        check8(16'sd32258, 1'b0, "127 times 127 second accumulation");
        cycle8(1'b1, 8'sd127, 8'sd127);
        check8(16'sd32258, 1'b1, "positive overflow freezes accumulator");
        cycle8(1'b1, -8'sd1, 8'sd1);
        check8(16'sd32258, 1'b1, "overflow flag sticky after positive overflow");
        reset8();

        cycle8(1'b1, 8'sh80, 8'sd127);
        check8(-16'sd16256, 1'b0, "-128 times 127 first accumulation");
        cycle8(1'b1, 8'sh80, 8'sd127);
        check8(-16'sd32512, 1'b0, "-128 times 127 second accumulation");
        cycle8(1'b1, 8'sh80, 8'sd127);
        check8(-16'sd32512, 1'b1, "negative overflow freezes accumulator");
        reset8();

        cycle8(1'b1, 8'sh80, 8'sh80);
        check8(16'sd16384, 1'b0, "-128 times -128 boundary");
        reset8();

        reset16();
        cycle16(1'b1, 16'sd1234, 16'sd56);
        check16(32'sd69104, 1'b0, "positive product accumulation");
        cycle16(1'b1, -16'sd100, 16'sd25);
        check16(32'sd66604, 1'b0, "negative product accumulation");
        cycle16(1'b1, -16'sd10, -16'sd20);
        check16(32'sd66804, 1'b0, "negative times negative accumulation");
        cycle16(1'b0, 16'sd32767, 16'sd32767);
        check16(32'sd66804, 1'b0, "valid_in low holds accumulated value");

        reset16();
        cycle16(1'b1, 16'sd32767, 16'sd32767);
        check16(32'sd1073676289, 1'b0, "max positive first accumulation");
        cycle16(1'b1, 16'sd32767, 16'sd32767);
        check16(32'sd2147352578, 1'b0, "max positive second accumulation");
        cycle16(1'b1, 16'sd32767, 16'sd32767);
        check16(32'sd2147352578, 1'b1, "positive overflow freezes accumulator");
        reset16();

        cycle16(1'b1, 16'sh8000, 16'sd32767);
        check16(-32'sd1073709056, 1'b0, "min negative times max positive first accumulation");
        cycle16(1'b1, 16'sh8000, 16'sd32767);
        check16(-32'sd2147418112, 1'b0, "min negative times max positive second accumulation");
        cycle16(1'b1, 16'sh8000, 16'sd32767);
        check16(-32'sd2147418112, 1'b1, "negative overflow freezes accumulator");
        cycle16(1'b0, 16'sd0, 16'sd0);
        check16(-32'sd2147418112, 1'b1, "overflow flag sticky while hold");
        reset16();

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("TESTS FAILED: tests_run=%0d errors=%0d", tests_run, errors);
        end

        $finish;
    end

endmodule
