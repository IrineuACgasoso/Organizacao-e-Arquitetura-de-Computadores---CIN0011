//  Senha: Azul(btn[0]) > Amarelo(btn[1]) > Amarelo(btn[1]) > Vermelho(btn[2])
//  Entradas:
//    clk (clock do sistema)
//    reset_l (reset assíncrono ativo em nível baixo)
//    btn[3:0] (botões: [0]=Azul [1]=Amarelo [2]=Vermelho [3]=Verde)
//  Saída:
//    unlock (1 quando a sequência correta é completada)

module safecrack (
    input  logic       clk,
    input  logic       reset_l,
    input  logic [3:0] btn,
    output logic       unlock
);

    typedef enum logic [4:0] {
        IDLE     = 5'b00001,   // bit 0
        S1       = 5'b00010,   // bit 1 — após Azul
        S2       = 5'b00100,   // bit 2 — após Amarelo (1º)
        S3       = 5'b01000,   // bit 3 — após Amarelo (2º)
        UNLOCKED = 5'b10000    // bit 4 — sequência completa
    } state_t;

    state_t state, next_state;


    // btn_pulse[i] = 1 SOMENTE no primeiro ciclo em que btn[i] sobe pra evitar que segurar o botão receba varios inputs

    logic [3:0] btn_prev;   // valor dos botões no ciclo anterior
    logic [3:0] btn_pulse;  // pulso de um ciclo na borda de subida

    always_ff @(posedge clk or negedge reset_l) begin
        if (!reset_l)
            btn_prev <= 4'b0000;
        else
            btn_prev <= btn;
    end

    assign btn_pulse = btn & ~btn_prev;

    // sequencial

    always_ff @(posedge clk or negedge reset_l) begin
        if (!reset_l)
            state <= IDLE;
        else
            state <= next_state;
    end

    //combinacional

    always_comb begin
        next_state = state;

        if (btn_pulse != 4'b0000) begin
            unique case (state)

                IDLE: begin
                    if ($onehot(btn_pulse) && btn_pulse == 4'b0001)
                        next_state = S1;       // Azul correto
                    else
                        next_state = IDLE;     // errado ou múltiplos
                end

                S1: begin
                    if ($onehot(btn_pulse) && btn_pulse == 4'b0010)
                        next_state = S2;       // 1º Amarelo correto
                    else
                        next_state = IDLE;
                end

                S2: begin
                    if ($onehot(btn_pulse) && btn_pulse == 4'b0010)
                        next_state = S3;       // 2º Amarelo correto
                    else
                        next_state = IDLE;
                end

                S3: begin
                    if ($onehot(btn_pulse) && btn_pulse == 4'b0100)
                        next_state = UNLOCKED; // Vermelho abre cofre
                    else
                        next_state = IDLE;
                end

                UNLOCKED: begin
                    // continua desbloqueado até reset_l
                    next_state = UNLOCKED;
                end

                default: next_state = IDLE;

            endcase
        end
    end

   
    // Saída: unlock eh '1' apenas no estado UNLOCKED

    assign unlock = (state == UNLOCKED) ? 1'b1 : 1'b0;

endmodule
