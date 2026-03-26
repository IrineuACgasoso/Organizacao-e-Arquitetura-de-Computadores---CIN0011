`timescale 1ns/1ps

module safecrack_tb;

    // Sinais para conectar ao módulo
    logic       clk;
    logic       reset_l;
    logic [3:0] btn;
    logic       unlock;

    // Instancia o seu módulo (DUT - Device Under Test)
    safecrack dut (
        .clk     (clk),
        .reset_l (reset_l),
        .btn     (btn),
        .unlock  (unlock)
    );

    // Gerador de clock: 50MHz (período de 20ns)
    initial clk = 0;
    always #10 clk = ~clk;

    // Task para facilitar o aperto dos botões
    task press_button(input logic [3:0] b_val);
        @(negedge clk);
        btn = b_val;          // Aperta o botão
        repeat (5) @(posedge clk); 
        @(negedge clk);
        btn = 4'b0000;        // Solta o botão
        repeat (5) @(posedge clk);
    endtask

    // Sequência de Teste
    initial begin
        // --- Setup Inicial ---
        reset_l = 1'b1;
        btn = 4'b0000;
        
        // Aplica Reset (Ativo em nível baixo)
        #5 reset_l = 1'b0;
        #20 reset_l = 1'b1;
        #20;

        $display("--- Iniciando Simulação do SafeCrack ---");

        // 1. Testa Sequência Correta: Azul -> Amarelo -> Amarelo -> Vermelho(bit 2 no seu código)
        $display("Digitando sequência correta...");
        press_button(4'b0001); // Azul
        press_button(4'b0010); // Amarelo (1)
        press_button(4'b0010); // Amarelo (2)
        press_button(4'b0100); // Vermelho (conforme bit 2 do seu case S3)

        #20;
        if (unlock) 
            $display("[SUCESSO] O cofre abriu!");
        else 
            $display("[ERRO] O cofre deveria estar aberto, mas unlock = 0");

        // 2. Testa persistência (Segurar o estado UNLOCKED)
        press_button(4'b1000); // Tenta apertar outro botão com ele aberto
        if (unlock) 
            $display("[SUCESSO] Cofre continuou aberto como esperado.");

        // 3. Testa o Reset voltando para IDLE
        $display("Testando Reset...");
        reset_l = 1'b0;
        #20 reset_l = 1'b1;
        #20;
        if (!unlock) 
            $display("[SUCESSO] Cofre resetou e trancou novamente.");

        // 4. Testa Sequência Errada (Deve voltar para IDLE)
        $display("Testando sequência errada...");
        press_button(4'b0001); // Azul (Certo)
        press_button(4'b1000); // Verde (Errado)
        press_button(4'b0010); // Amarelo (Seria o certo se não tivesse errado antes)
        
        if (!unlock)
            $display("[SUCESSO] Cofre permaneceu trancado após erro.");

        #100 $display("--- Fim da Simulação ---");
        $finish;
    end

endmodule