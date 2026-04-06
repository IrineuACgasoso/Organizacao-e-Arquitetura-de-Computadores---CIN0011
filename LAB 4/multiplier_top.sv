// multiplier_top.sv - Versão Combinacional (Ciclo 0)
// Baseado no conceito de Paralelismo Massivo para Alto Desempenho

`timescale 1ns/1ps

module multiplier_top (
    input  logic        clk,              // Não usado na lógica, mantido para o TB
    input  logic        rst_n,            // Não usado na lógica, mantido para o TB
    input  logic        start,            // Dispara o 'done' instantaneamente
    input  logic [31:0] multiplicand_in,
    input  logic [31:0] multiplier_in,
    output logic [63:0] product,
    output logic        done
);

    // -----------------------------------------------------------------------
    // AVALIAÇÃO EM CICLO 0
    // -----------------------------------------------------------------------
    // Ao usar o operador '*' fora de blocos sequenciais, o SystemVerilog 
    // infere um multiplicador de matriz (array multiplier) paralelo.
    
    assign product = 64'(multiplicand_in) * 64'(multiplier_in);

    // Como a conta é combinacional, o resultado está pronto assim que o start sobe.
    assign done = start;

endmodule