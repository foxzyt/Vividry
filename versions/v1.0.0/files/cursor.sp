var ESC = "\033";

class VCursorCore {
    function up(n) { return ESC + "[" + valueToString(n) + "A"; }
    function down(n) { return ESC + "[" + valueToString(n) + "B"; }
    function right(n) { return ESC + "[" + valueToString(n) + "C"; }
    function left(n) { return ESC + "[" + valueToString(n) + "D"; }
    function moveTo(x, y) { return ESC + "[" + valueToString(y) + ";" + valueToString(x) + "H"; }
    
    function clearScreen() { return ESC + "[2J" + this.moveTo(1, 1); }
    function clearLine() { return ESC + "[2K"; }
    function hide() { return ESC + "[?25l"; }
    function show() { return ESC + "[?25h"; }

    function savePosition() { return ESC + "[s"; }
    function restorePosition() { return ESC + "[u"; }
    function scrollUp(n) { return ESC + "[" + valueToString(n) + "S"; }
    function scrollDown(n) { return ESC + "[" + valueToString(n) + "T"; }
}

var VCursor = createInstance("VCursorCore");
