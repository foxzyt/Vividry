class VInputCore {
    function enableMouse() {
        printColor("\033[?1000h\033[?1006h", "white");
    }
    
    function disableMouse() {
        printColor("\033[?1000l\033[?1006l", "white");
    }
    
    function poll() {
        var raw = readInput();
        if (raw == "") { return nil; }
        
        var lenVal = stringLength(raw);
        if (lenVal >= 8) {
            if (stringContains(raw, "[<")) {
                var lastChar = stringCharAt(raw, lenVal - 1);
                var action = "press";
                if (lastChar == "m") { action = "release"; }
                
                // Find where "<" is to split correctly
                // SGR is ESC + "[<" + button + ";" + x + ";" + y + "M"
                // index of "<" is 2
                var cleaned = stringSubstring(raw, 3, lenVal - 4);
                
                var parts = stringSplit(cleaned, ";");
                if (len(parts) >= 3) {
                    var btn = parseDouble(parts[0]);
                    var x = parseDouble(parts[1]);
                    var y = parseDouble(parts[2]);
                    
                    var event = {};
                    event["type"] = "mouse";
                    event["button"] = btn;
                    event["x"] = x;
                    event["y"] = y;
                    event["action"] = action;
                    return event;
                }
            }
        }
        
        var event = {};
        event["type"] = "key";
        event["key"] = raw;
        return event;
    }
}

var VInput = createInstance("VInputCore");
