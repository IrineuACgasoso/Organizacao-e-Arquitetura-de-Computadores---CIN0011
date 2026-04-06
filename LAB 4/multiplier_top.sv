// Utilizando Paralelismo

`timescale 1ns/1ps

module multiplier_top (
    input  logic        clk,              
    input  logic        rst_n,          
    input  logic        start,           
    input  logic [31:0] multiplicand_in,
    input  logic [31:0] multiplier_in,
    output logic [63:0] product,
    output logic        done
);

    
    assign product = 64'(multiplicand_in) * 64'(multiplier_in);

    assign done = start;

endmodule