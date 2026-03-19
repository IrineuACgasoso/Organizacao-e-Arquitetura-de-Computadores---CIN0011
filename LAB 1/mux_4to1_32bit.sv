module mux_4to1_32bit (
    output logic [31:0] f,     // Saída de 32 bits
    input  logic [31:0] a,     // Entrada 0 (32 bits)
    input  logic [31:0] b,     // Entrada 1 (32 bits)
    input  logic [31:0] c,     // Entrada 2 (32 bits)
    input  logic [31:0] d,     // Entrada 3 (32 bits)
    input  logic [1:0]  sel    // Seletor de 2 bits 
);

    always_comb begin
        case (sel)
            2'b00: f = a;
            2'b01: f = b;
            2'b10: f = c;
            2'b11: f = d;
            default: f = '0;
        endcase
    end

endmodule