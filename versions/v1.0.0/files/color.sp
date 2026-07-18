class VColorCore {
    function red(text) { printColor(text, "red"); return ""; }
    function green(text) { printColor(text, "green"); return ""; }
    function yellow(text) { printColor(text, "yellow"); return ""; }
    function blue(text) { printColor(text, "blue"); return ""; }
    function magenta(text) { printColor(text, "magenta"); return ""; }
    function cyan(text) { printColor(text, "cyan"); return ""; }
    function white(text) { printColor(text, "white"); return ""; }
    function black(text) { printColor(text, "black"); return ""; }

    function rgb(r, g, b, text) { 
        printColor(text, "rgb(" + valueToString(r) + "," + valueToString(g) + "," + valueToString(b) + ")");
        return ""; 
    }

    function hex(hexStr, text) {
        printColor(text, hexStr);
        return "";
    }

    // Raw Color Codes
    function getRed() { return "red"; }
    function getGreen() { return "green"; }
    function getBlue() { return "blue"; }
    function getYellow() { return "yellow"; }
    function getMagenta() { return "magenta"; }
    function getCyan() { return "cyan"; }
    function getWhite() { return "white"; }
    function getBlack() { return "black"; }
    
    function getRGB(r, g, b) { 
        return "rgb(" + valueToString(r) + "," + valueToString(g) + "," + valueToString(b) + ")"; 
    }
    
    function getHEX(hexStr) { 
        return hexStr; 
    }

    // Interpolates smoothly between two RGB colors per character!
    function gradientText(text, r1, g1, b1, r2, g2, b2) {
        var length = stringLength(text);
        if (length == 0) { return ""; }
        if (length == 1) { this.rgb(r1, g1, b1, text); return ""; }

        var i = 0;
        while (i < length) {
            var t = i / (length - 1);
            var r = floor(r1 + t * (r2 - r1));
            var g = floor(g1 + t * (g2 - g1));
            var b = floor(b1 + t * (b2 - b1));
            
            var charVal = stringCharAt(text, i);
            this.rgb(r, g, b, charVal);
            i = i + 1;
        }
        return "";
    }

    // Generates a rainbow color cycle over the text
    function rainbowText(text) {
        var length = stringLength(text);
        if (length == 0) { return ""; }
        var result = "";
        var i = 0;
        while (i < length) {
            var hue = (i / length) * 360;
            var h = hue / 60;
            var x = 1 - abs((h % 2) - 1);
            var r = 0; var g = 0; var b = 0;
            if (h >= 0 && h < 1) { r = 255; g = floor(x*255); b = 0; }
            else if (h >= 1 && h < 2) { r = floor(x*255); g = 255; b = 0; }
            else if (h >= 2 && h < 3) { r = 0; g = 255; b = floor(x*255); }
            else if (h >= 3 && h < 4) { r = 0; g = floor(x*255); b = 255; }
            else if (h >= 4 && h < 5) { r = floor(x*255); g = 0; b = 255; }
            else { r = 255; g = 0; b = floor(x*255); }
            
            var charVal = stringCharAt(text, i);
            this.rgb(r, g, b, charVal);
            i = i + 1;
        }
        return "";
    }
}

var VColor = createInstance("VColorCore");
