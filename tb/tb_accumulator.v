`timescale 1ns/1ps

module tb_accumulator;

    reg clk;

    reg signed [15:0] product_in8;
    reg               rst8;
    reg               valid_in8;
    wire signed [15:0] acc_out8;
    wire               overflow_flag8;

    reg signed [31:0] product_in16;
    reg               rst16;
    reg               valid_in16;
    wire signed [31:0] acc_out16;
    wire               overflow_flag16;

    integer tests_run;
    integer errors;

    accumulator
    #(
        .WIDTH(8)
    )
    dut8
    (
        .clk(clk),
        .rst(rst8),
        .valid_in(valid_in8),
        .product_in(product_in8),
        .acc_out(acc_out8),
        .overflow_flag(overflow_flag8)
    );

    accumulator
    #(
        .WIDTH(16)
    )
    dut16
    (
        .clk(clk),
        .rst(rst16),
        .valid_in(valid_in16),
        .product_in(product_in16),
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
        input signed [15:0] product_value;
        begin
            @(negedge clk);
            valid_in8   = valid_value;
            product_in8 = product_value;
            @(posedge clk);
            #1;
        end
    endtask

    task cycle16;
        input               valid_value;
        input signed [31:0] product_value;
        begin
            @(negedge clk);
            valid_in16   = valid_value;
            product_in16 = product_value;
            @(posedge clk);
            #1;
        end
    endtask

    task reset8;
        begin
            @(negedge clk);
            rst8        = 1'b1;
            valid_in8   = 1'b0;
            product_in8 = 16'sd0;
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
            rst16        = 1'b1;
            valid_in16   = 1'b0;
            product_in16 = 32'sd0;
            @(posedge clk);
            #1;
            check16(32'sd0, 1'b0, "synchronous reset clears state");
            @(negedge clk);
            rst16 = 1'b0;
        end
    endtask

    initial begin
        $dumpfile("waveforms/tb_accumulator.vcd");
        $dumpvars(0, tb_accumulator);

        clk          = 1'b0;
        rst8         = 1'b0;
        valid_in8    = 1'b0;
        product_in8  = 16'sd0;
        rst16        = 1'b0;
        valid_in16   = 1'b0;
        product_in16 = 32'sd0;
        tests_run    = 0;
        errors       = 0;

        reset8();
        cycle8(1'b1, 16'sd100);
        check8(16'sd100, 1'b0, "positive accumulation");
        cycle8(1'b0, 16'sd25);
        check8(16'sd100, 1'b0, "valid_in low holds state");
        cycle8(1'b1, -16'sd40);
        check8(16'sd60, 1'b0, "mixed sign accumulation");
        cycle8(1'b1, 16'sd7);
        check8(16'sd67, 1'b0, "multi-cycle accumulation");

        reset8();
        cycle8(1'b1, 16'sd32767);
        check8(16'sd32767, 1'b0, "positive boundary no overflow");
        cycle8(1'b1, 16'sd1);
        check8(16'sd32767, 1'b1, "positive overflow freezes accumulator");
        cycle8(1'b1, -16'sd10);
        check8(16'sd32767, 1'b1, "overflow flag sticky while valid");
        cycle8(1'b0, 16'sd0);
        check8(16'sd32767, 1'b1, "overflow flag sticky while hold");
        reset8();

        cycle8(1'b1, -16'sd32768);
        check8(-16'sd32768, 1'b0, "negative boundary no overflow");
        cycle8(1'b1, -16'sd1);
        check8(-16'sd32768, 1'b1, "negative overflow freezes accumulator");
        cycle8(1'b1, 16'sd10);
        check8(-16'sd32768, 1'b1, "negative overflow sticky while valid");
        reset8();

        reset16();
        cycle16(1'b1, 32'sd1000000);
        check16(32'sd1000000, 1'b0, "positive accumulation");
        cycle16(1'b0, 32'sd250000);
        check16(32'sd1000000, 1'b0, "valid_in low holds state");
        cycle16(1'b1, -32'sd250000);
        check16(32'sd750000, 1'b0, "mixed sign accumulation");
        cycle16(1'b1, 32'sd750000);
        check16(32'sd1500000, 1'b0, "multi-cycle accumulation");

        reset16();
        cycle16(1'b1, 32'sd2147483640);
        check16(32'sd2147483640, 1'b0, "positive boundary no overflow");
        cycle16(1'b1, 32'sd100);
        check16(32'sd2147483640, 1'b1, "positive overflow freezes accumulator");
        cycle16(1'b1, -32'sd1000);
        check16(32'sd2147483640, 1'b1, "overflow flag sticky while valid");
        reset16();

        cycle16(1'b1, -32'sd2147483640);
        check16(-32'sd2147483640, 1'b0, "negative boundary no overflow");
        cycle16(1'b1, -32'sd100);
        check16(-32'sd2147483640, 1'b1, "negative overflow freezes accumulator");
        cycle16(1'b0, 32'sd0);
        check16(-32'sd2147483640, 1'b1, "negative overflow sticky while hold");
        reset16();

        if (errors == 0) begin
            $display("ALL TESTS PASSED");
        end else begin
            $display("TESTS FAILED: tests_run=%0d errors=%0d", tests_run, errors);
        end

        $finish;
    end

endmodule
