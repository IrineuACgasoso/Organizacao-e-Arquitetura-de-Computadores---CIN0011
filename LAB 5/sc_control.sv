`timescale 1ns / 1ps

module sc_control (
    input  logic [6:0] Opcode,
    output logic       ALUSrc,
    output logic       MemtoReg,
    output logic       RegWrite,
    output logic       MemRead,
    output logic       MemWrite,
    output logic       Branch,
    output logic [1:0] ALUOp
);

    // Definição dos Opcodes suportados (RISC-V Standard)
    localparam R_TYPE = 7'b0110011; // add, sub, and, or, slt
    localparam LOAD   = 7'b0000011; // lw
    localparam STORE  = 7'b0100011; // sw
    localparam BRANCH = 7'b1100011; // beq

    always_comb begin
        // --- 1. SET DEFAULTS (Prevenção de Latches) ---
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        ALUOp    = 2'b00;

        // --- 2. LOGIC CASE ---
        case (Opcode)
            R_TYPE: begin
                RegWrite = 1'b1; // Escreve no registrador de destino
                ALUOp    = 2'b10; // ALU deve olhar Funct3/7
            end

            LOAD: begin
                ALUSrc   = 1'b1; // Usa imediato para endereço
                MemtoReg = 1'b1; // Dado vem da memória para o registrador
                RegWrite = 1'b1; // Habilita escrita no registrador
                MemRead  = 1'b1; // Habilita leitura da memória
                ALUOp    = 2'b00; // Soma base + offset
            end

            STORE: begin
                ALUSrc   = 1'b1; // Usa imediato para endereço
                MemWrite = 1'b1; // Habilita escrita na memória
                ALUOp    = 2'b00; // Soma base + offset
            end

            BRANCH: begin
                Branch   = 1'b1; // Habilita sinal de desvio
                ALUOp    = 2'b01; // Força subtração para comparar Zero
            end

            default: ; // Mantém os defaults (segurança)
        endcase
    end

endmodule