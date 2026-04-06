`timescale 1ns/1ps

module multiplier_tb;

    logic        clk;
    logic        rst_n;
    logic        start;
    logic [31:0] multiplicand_in;
    logic [31:0] multiplier_in;
    logic [63:0] product;
    logic        done;

    // Instancia o Top Combinacional
    multiplier_top dut (.*);

    // Gerador de Clock (ainda util para dar ritmo aos testes)
    initial clk = 0;
    always #5 clk = ~clk;

    // Tarefa de teste ultra-rapida
    task automatic run_test (
        input logic [31:0] a,
        input logic [31:0] b,
        input string       test_name
    );
        logic [63:0] expected;
        begin
            expected = 64'(a) * 64'(b);

            @(negedge clk);
            multiplicand_in = a;
            multiplier_in   = b;
            start           = 1'b1;

            // Nao precisamos mais esperar ciclos! 
            // O resultado ja esta pronto aqui.
            #1; // Pequeno delay de 1ns so para estabilidade visual na Wave

            if (product === expected)
                $display("[PASS] %s: %0d x %0d = %0d", test_name, a, b, product);
            else
                $display("[FAIL] %s: %0d x %0d = %0d (esperado %0d)", 
                         test_name, a, b, product, expected);

            start = 1'b0;
        end
    endtask
    
    initial begin
        // Reset inicial
        rst_n = 0; start = 0;
        multiplicand_in = '0; multiplier_in = '0;
        #20 rst_n = 1;

        // --- Lista completa de casos do roteiro ---
        run_test(32'd0,          32'd0,          "zero x zero");        // Adicionado
        run_test(32'd1,          32'd1,          "1 x 1");              // Adicionado
        run_test(32'd6,          32'd7,          "6 x 7");              // Já tinha
        run_test(32'd255,        32'd255,        "255 x 255");          // Já tinha
        run_test(32'd1000,       32'd1000,       "1000 x 1000");        // Adicionado
        run_test(32'hFFFFFFFF,   32'd1,          "MAX x 1");            // Adicionado
        run_test(32'hFFFFFFFF,   32'hFFFFFFFF,   "MAX x MAX");          // Já tinha
        run_test(32'hAAAAAAAA,   32'h55555555,   "Padrao alternado");   // Adicionado
        run_test(32'd123456789,  32'd987654321,  "Grande x Grande");    // Já tinha

        $display("Simulacao de Alto Desempenho Concluida.");
        $finish;
    end