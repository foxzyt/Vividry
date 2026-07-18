class VCanvasCore {
    var width;
    var height;
    var charBuffer;
    var colorBuffer;
    
    function init(w, h) {
        this.width = w;
        this.height = h;
        this.charBuffer = [];
        this.colorBuffer = [];
        this.clear(" ", "white");
    }
    
    function clear(bgChar, bgColorCode) {
        this.charBuffer = [];
        this.colorBuffer = [];
        var y = 0;
        while (y < this.height) {
            var rowChars = [];
            var rowColors = [];
            var x = 0;
            while (x < this.width) {
                rowChars[x] = bgChar;
                rowColors[x] = bgColorCode;
                x = x + 1;
            }
            this.charBuffer[y] = rowChars;
            this.colorBuffer[y] = rowColors;
            y = y + 1;
        }
    }
    
    function drawPoint(x, y, charVal, colorCode) {
        if (x >= 0) {
            if (x < this.width) {
                if (y >= 0) {
                    if (y < this.height) {
                        this.charBuffer[y][x] = charVal;
                        this.colorBuffer[y][x] = colorCode;
                    }
                }
            }
        }
    }
    
    function drawText(x, y, text, colorCode) {
        var len = stringLength(text);
        var i = 0;
        while (i < len) {
            this.drawPoint(x + i, y, stringCharAt(text, i), colorCode);
            i = i + 1;
        }
    }
    
    function drawLine(x1, y1, x2, y2, charVal, colorCode) {
        var dx = abs(x2 - x1);
        var dy = abs(y2 - y1);
        var sx = -1;
        if (x1 < x2) { sx = 1; }
        var sy = -1;
        if (y1 < y2) { sy = 1; }
        var err = dx - dy;

        var currentX = x1;
        var currentY = y1;
        var done = false;

        while (!done) {
            this.drawPoint(currentX, currentY, charVal, colorCode);
            if (currentX == x2) {
                if (currentY == y2) {
                    done = true;
                }
            }
            if (!done) {
                var e2 = 2 * err;
                if (e2 > -dy) {
                    err = err - dy;
                    currentX = currentX + sx;
                }
                if (e2 < dx) {
                    err = err + dx;
                    currentY = currentY + sy;
                }
            }
        }
    }

    function drawRect(x, y, w, h, charVal, colorCode) {
        this.drawLine(x, y, x + w - 1, y, charVal, colorCode);
        this.drawLine(x, y + h - 1, x + w - 1, y + h - 1, charVal, colorCode);
        this.drawLine(x, y, x, y + h - 1, charVal, colorCode);
        this.drawLine(x + w - 1, y, x + w - 1, y + h - 1, charVal, colorCode);
    }
    
    function fillRect(x, y, w, h, charVal, colorCode) {
        var j = 0;
        while (j < h) {
            var i = 0;
            while (i < w) {
                this.drawPoint(x + i, y + j, charVal, colorCode);
                i = i + 1;
            }
            j = j + 1;
        }
    }

    function drawCircle(xc, yc, r, charVal, colorCode) {
        var x = 0;
        var y = r;
        var d = 3 - 2 * r;
        
        while (y >= x) {
            this.drawPoint(xc + x, yc + y, charVal, colorCode);
            this.drawPoint(xc - x, yc + y, charVal, colorCode);
            this.drawPoint(xc + x, yc - y, charVal, colorCode);
            this.drawPoint(xc - x, yc - y, charVal, colorCode);
            this.drawPoint(xc + y, yc + x, charVal, colorCode);
            this.drawPoint(xc - y, yc + x, charVal, colorCode);
            this.drawPoint(xc + y, yc - x, charVal, colorCode);
            this.drawPoint(xc - y, yc - x, charVal, colorCode);
            
            x = x + 1;
            if (d > 0) {
                y = y - 1;
                d = d + 4 * (x - y) + 10;
            } else {
                d = d + 4 * x + 6;
            }
        }
    }

    function fillCircle(xc, yc, r, charVal, colorCode) {
        var y = -r;
        while (y <= r) {
            var x = -r;
            while (x <= r) {
                if (x*x + y*y <= r*r) {
                    this.drawPoint(xc + x, yc + y, charVal, colorCode);
                }
                x = x + 1;
            }
            y = y + 1;
        }
    }

    function drawTriangle(x1, y1, x2, y2, x3, y3, charVal, colorCode) {
        this.drawLine(x1, y1, x2, y2, charVal, colorCode);
        this.drawLine(x2, y2, x3, y3, charVal, colorCode);
        this.drawLine(x3, y3, x1, y1, charVal, colorCode);
    }

    function drawTextVertical(x, y, text, colorCode) {
        var len = stringLength(text);
        var i = 0;
        while (i < len) {
            this.drawPoint(x, y + i, stringCharAt(text, i), colorCode);
            i = i + 1;
        }
    }
    
    function render() {
        // Move to top-left corner
        printColor("\033[1;1H", "white");
        
        var y = 0;
        while (y < this.height) {
            var x = 0;
            while (x < this.width) {
                var c = this.charBuffer[y][x];
                var col = this.colorBuffer[y][x];
                
                printColor(c, col);
                
                x = x + 1;
            }
            print(""); // Pula para a próxima linha
            y = y + 1;
        }
    }
}

var VCanvas = createInstance("VCanvasCore");
