import vividry@"1.0.0";

// Teste de Limpeza e Cursor
printColor(VCursor.clearScreen(), "white");
printColor(VCursor.hide(), "white");

// Ativar o mouse interativo
VInput.enableMouse();

var clickX = -1;
var clickY = -1;
var clickMsg = "Clique em algum lugar no buffer!";
var running = true;

while (running) {
    // Inicializar e limpar o canvas a cada frame
    VCanvas.init(50, 16);
    VCanvas.drawRect(2, 2, 46, 13, "#", VColor.getBlue());
    
    // Desenhar elementos estáticos
    VCanvas.drawTriangle(5, 12, 15, 3, 25, 12, "+", VColor.getRGB(0, 255, 0));
    VCanvas.fillCircle(38, 7, 3, "o", VColor.getHEX("#FF55FF"));
    VCanvas.drawTextVertical(29, 4, "VIVIDRY", VColor.getYellow());
    VCanvas.drawText(18, 8, " SAPPHIRE ", VColor.getHEX("#FF0000"));
    
    // Desenhar a mensagem do clique anterior e a posição X
    if (clickX >= 0) {
        VCanvas.drawPoint(clickX, clickY, "X", VColor.getRed());
    }
    
    // Renderizar o Canvas no terminal
    VCanvas.render();
    
    // Exibir instruções abaixo do canvas (linhas 17 e 18)
    printColor(VCursor.moveTo(1, 17), "white");
    VColor.rainbowText(" MODO INTERATIVO ATIVADO (CLIQUE NO MOUSE E TECLADO) ");
    print("");
    printColor("Ultimo clique: " + clickMsg, "cyan");
    print("");
    printColor("Pressione 'Q' ou 'Escape' para sair.", "white");
    print("");
    
    // Ler entrada sem bloquear
    var event = VInput.poll();
    if (event != nil) {
        if (event["type"] == "key") {
            var k = event["key"];
            if (k == "q" || k == "Q" || k == "\033") {
                running = false;
            }
        } else if (event["type"] == "mouse") {
            var mx = event["x"];
            var my = event["y"];
            
            // Converter de 1-based (console) para 0-based (canvas)
            clickX = mx - 1;
            clickY = my - 1;
            clickMsg = "Coluna " + valueToString(mx) + ", Linha " + valueToString(my);
        }
    }
    
    sleep(30); // Controlar FPS (~30 fps)
}

// Desativar mouse e restaurar terminal
VInput.disableMouse();
printColor(VCursor.clearScreen(), "white");
printColor(VCursor.show(), "white");
printColor("Sessao interativa finalizada com sucesso!", "green");
print("");