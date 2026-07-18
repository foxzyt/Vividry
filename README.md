# Vividry

Vividry is a low-level terminal manipulation library for the Sapphire scripting language. It abstracts ANSI escape codes, TrueColor (24-bit RGB) output, and provides a 2D rendering buffer along with non-blocking terminal input.

## Features
- **TrueColor (24-bit RGB):** Colors can be specified via HEX (`#RRGGBB`), RGB (`rgb(r,g,b)`), or standard color names. Includes helper functions for linear gradients and rainbow text cycling.
- **2D Drawing Buffer (VCanvas):** Implements a double-buffered matrix (characters and colors) to prevent flickering. Supports drawing lines, rectangles, triangles, circles, filled circles, and horizontal/vertical text.
- **Non-blocking Input (VInput):** Captures mouse clicks (via SGR tracking) and keyboard events without suspending execution.
- **Cursor Manipulation (VCursor):** Direct cursor positioning, scroll commands, screen clearing, and state save/restore utilities.

## Module Structure
The library is divided into the following files inside `versions/v1.0.0/files/`:
- `color.sp`: Color manipulation, gradients, and spectrum cycling (`VColor`).
- `cursor.sp`: Low-level ANSI sequences for cursor movement and window scrolling (`VCursor`).
- `canvas.sp`: 2D drawing canvas and double-buffered output pipeline (`VCanvas`).
- `input.sp`: Non-blocking stdin polling and SGR mouse event parsing (`VInput`).
- `main.sp`: Aggregator entry point importing the above modules.

## API Reference

### VColor
- `VColor.red(text)` / `.green(text)` / `.blue(text)` ...
- `VColor.rgb(r, g, b, text)`: Formats text with the specified RGB values.
- `VColor.hex(hexStr, text)`: Formats text with the specified Hex string.
- `VColor.gradientText(text, r1, g1, b1, r2, g2, b2)`: Generates a linear gradient across the text.
- `VColor.rainbowText(text)`: Outputs text in a cyclic HSV rainbow pattern.
- `VColor.getRGB(r, g, b)` / `VColor.getHEX(hex)`: Returns color descriptor strings for internal VM parsing.

### VCursor
- `VCursor.moveTo(x, y)`: Positions the cursor at 1-based coordinates.
- `VCursor.clearScreen()`: Clears the terminal screen and resets the cursor to `(1, 1)`.
- `VCursor.clearLine()`: Clears the current line.
- `VCursor.hide()` / `VCursor.show()`: Toggles cursor visibility.
- `VCursor.savePosition()` / `VCursor.restorePosition()`: Saves or restores the cursor location.
- `VCursor.scrollUp(n)` / `VCursor.scrollDown(n)`: Scrolls the terminal window by $n$ lines.

### VCanvas
- `VCanvas.init(width, height)`: Allocates the drawing buffer.
- `VCanvas.clear(bgChar, bgColor)`: Resets the entire buffer with the specified character and color.
- `VCanvas.drawPoint(x, y, char, color)`: Writes a single character to the buffer at 0-based coordinates.
- `VCanvas.drawText(x, y, text, color)`: Writes horizontal text.
- `VCanvas.drawTextVertical(x, y, text, color)`: Writes vertical text.
- `VCanvas.drawLine(x1, y1, x2, y2, char, color)`: Draws a line between two points.
- `VCanvas.drawRect(x, y, w, h, char, color)`: Draws a rectangular outline.
- `VCanvas.fillRect(x, y, w, h, char, color)`: Fills a rectangular area.
- `VCanvas.drawCircle(xc, yc, r, char, color)`: Draws a circle outline.
- `VCanvas.fillCircle(xc, yc, r, char, color)`: Draws a filled circle.
- `VCanvas.drawTriangle(x1, y1, x2, y2, x3, y3, char, color)`: Draws a triangle outline.
- `VCanvas.render()`: Flushes the buffer to the terminal (starting at `(1, 1)`).

### VInput
- `VInput.enableMouse()` / `VInput.disableMouse()`: Toggles SGR mouse click event reporting.
- `VInput.poll()`: Non-blocking read of standard input. Returns `nil` if no input is queued.
  - **Keyboard Event:** `{ type: "key", key: "<char_or_sequence>" }`
  - **Mouse Event:** `{ type: "mouse", button: <int>, x: <int>, y: <int>, action: "press" | "release" }`

## Usage Example

```javascript
import vividry@"1.0.0";

// Terminal Setup
printColor(VCursor.clearScreen(), "white");
printColor(VCursor.hide(), "white");
VInput.enableMouse();

var clickX = -1;
var clickY = -1;
var clickMsg = "Click inside the buffer!";
var running = true;

while (running) {
    VCanvas.init(50, 16);
    VCanvas.drawRect(2, 2, 46, 13, "#", VColor.getBlue());
    
    // Draw geometry
    VCanvas.drawTriangle(5, 12, 15, 3, 25, 12, "+", VColor.getGreen());
    VCanvas.fillCircle(38, 7, 3, "o", VColor.getHEX("#FF55FF"));
    
    // Draw click marker
    if (clickX >= 0) {
        VCanvas.drawPoint(clickX, clickY, "X", VColor.getRed());
    }
    
    VCanvas.render();
    
    // UI Panel below Canvas
    printColor(VCursor.moveTo(1, 17), "white");
    VColor.rainbowText(" VIVIDRY INTERACTIVE RENDER LOOP ");
    print("");
    printColor("Click position: " + clickMsg, "cyan");
    print("");
    printColor("Press 'Q' or 'Escape' to exit.", "white");
    print("");
    
    // Non-blocking input loop
    var event = VInput.poll();
    if (event != nil) {
        if (event["type"] == "key") {
            var k = event["key"];
            if (k == "q" || k == "Q" || k == "\033") {
                running = false;
            }
        } else if (event["type"] == "mouse") {
            // Translate console coordinates (1-based) to canvas coordinates (0-based)
            clickX = event["x"] - 1;
            clickY = event["y"] - 1;
            clickMsg = "X: " + valueToString(event["x"]) + ", Y: " + valueToString(event["y"]);
        }
    }
    
    sleep(30); // ~30 FPS
}

// Reset terminal state
VInput.disableMouse();
printColor(VCursor.clearScreen(), "white");
printColor(VCursor.show(), "white");
printColor("Interactive session ended.", "green");
print("");
```
