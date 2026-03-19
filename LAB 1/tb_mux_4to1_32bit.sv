`timescale 1ns/1ps

module tb_mux_4to1_32bit;

    logic [31:0] a, b, c, d;
    logic [1:0]  sel;

    logic [31:0] f;

    mux_4to1_32bit dut (
        .f(f),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel)
    );

    initial begin
        $monitor($time, " | sel = %b | f = %h (Saída) | a = %h | b = %h | c = %h | d = %h", sel, f, a, b, c, d);

        a = 32'hAAAA_AAAA;
        b = 32'hBBBB_BBBB;
        c = 32'hCCCC_CCCC;
        d = 32'hDDDD_DDDD;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;

        a = 32'h1234_5678;
        b = 32'h9ABC_DEF0;
        c = 32'hDEAD_BEEF;
        d = 32'hCAFE_BABE;

        sel = 2'b00; #10;
        sel = 2'b01; #10;
        sel = 2'b10; #10;
        sel = 2'b11; #10;

        $stop;
    end

endmodule