// Senha: Azul(btn[0]) > Amarelo(btn[1]) > Amarelo(btn[1]) > Vermelho(btn[2])
// Estrutura padrão para Placas FPGA

module safecrack (
    input  logic       clk,
    input  logic       reset_l,
    input  logic [3:0] btn,
    output logic       unlock
);

    // 1. Definição de Estados (One-hot encoding como no seu original)
    typedef enum logic [4:0] {
        IDLE     = 5'b00001,
        S1       = 5'b00010, // Após Azul
        S2       = 5'b00100, // Após 1º Amarelo
        S3       = 5'b01000, // Após 2º Amarelo
        UNLOCKED = 5'b10000  // Cofre Aberto
    } state_t;

    state_t state, next_state;

    // 2. Lógica de Detecção de Borda (Edge Detector)
    // Essencial para placas: evita que um clique longo seja lido como vários cliques
    logic [3:0] btn_reg;
    logic [3:0] btn_pulse;

    always_ff @(posedge clk or negedge reset_l) begin
        if (!reset_l)
            btn_reg <= 4'b0000;
        else
            btn_reg <= btn;
    end

    assign btn_pulse = btn & ~btn_reg;

    // 3. Bloco Sequencial: Atualização do Estado
    always_ff @(posedge clk or negedge reset_l) begin
        if (!reset_l)
            state <= IDLE;
        else
            state <= next_state;
    end

    // 4. Bloco Combinacional: Lógica de Próximo Estado
    always_comb begin
        // Valor padrão para evitar Latches
        next_state = state;

        // Só processa se algum botão for pressionado (borda de subida)
        if (btn_pulse != 4'b0000) begin
            case (state)
                IDLE: begin
                    if (btn_pulse == 4'b0001) next_state = S1;   // Azul
                    else                      next_state = IDLE;
                end

                S1: begin
                    if (btn_pulse == 4'b0010) next_state = S2;   // Amarelo
                    else                      next_state = IDLE;
                end

                S2: begin
                    if (btn_pulse == 4'b0010) next_state = S3;   // Amarelo
                    else                      next_state = IDLE;
                end

                S3: begin
                    if (btn_pulse == 4'b0100) next_state = UNLOCKED; // Vermelho
                    else                      next_state = IDLE;
                end

                UNLOCKED: begin
                    next_state = UNLOCKED; // Trava no aberto até o Reset
                end

                default: next_state = IDLE;
            endcase
        end
    end

    // 5. Lógica de Saída
    assign unlock = (state == UNLOCKED);

endmodule