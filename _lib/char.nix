let
    chrLut = [
        "NUL"
        "SOH"
        "STX"
        "ETX"
        "EOT"
        "ENQ"
        "ACK"
        "BEL"
        "BS"
        "HT"
        "LF"
        "VT"
        "FF"
        "CR"
        "SO"
        "SI"
        "DLE"
        "DC1"
        "DC2"
        "DC3"
        "DC4"
        "NAK"
        "SYN"
        "ETB"
        "CAN"
        "EM "
        "SUB"
        "ESC"
        "FS"
        "GS"
        "RS"
        "US"
        " "
        "!"
        "\""
        "#"
        "$"
        "%"
        "&"
        "'"
        "("
        ")"
        "*"
        "+"
        ","
        "-"
        "."
        "/"
        "0"
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        ":"
        ";"
        "<"
        "="
        ">"
        "?"
        "@"
        "A"
        "B"
        "C"
        "D"
        "E"
        "F"
        "G"
        "H"
        "I"
        "J"
        "K"
        "L"
        "M"
        "N"
        "O"
        "P"
        "Q"
        "R"
        "S"
        "T"
        "U"
        "V"
        "W"
        "X"
        "Y"
        "Z"
        "["
        "\\"
        "]"
        "^"
        "_"
        "`"
        "a"
        "b"
        "c"
        "d"
        "e"
        "f"
        "g"
        "h"
        "i"
        "j"
        "k"
        "l"
        "m"
        "n"
        "o"
        "p"
        "q"
        "r"
        "s"
        "t"
        "u"
        "v"
        "w"
        "x"
        "y"
        "z"
        "{"
        "|"
        "}"
        "~"
        "DEL"
    ];

    ordLut = {
        "NUL" = 0;
        "SOH" = 1;
        "STX" = 2;
        "ETX" = 3;
        "EOT" = 4;
        "ENQ" = 5;
        "ACK" = 6;
        "BEL" = 7;
        "BS" = 8;
        "HT" = 9;
        "LF" = 10;
        "VT" = 11;
        "FF" = 12;
        "CR" = 13;
        "SO" = 14;
        "SI" = 15;
        "DLE" = 16;
        "DC1" = 17;
        "DC2" = 18;
        "DC3" = 19;
        "DC4" = 20;
        "NAK" = 21;
        "SYN" = 22;
        "ETB" = 23;
        "CAN" = 24;
        "EM " = 25;
        "SUB" = 26;
        "ESC" = 27;
        "FS" = 28;
        "GS" = 29;
        "RS" = 30;
        "US" = 31;
        " " = 32;
        "!" = 33;
        "\"" = 34;
        "#" = 35;
        "$" = 36;
        "%" = 37;
        "&" = 38;
        "'" = 39;
        "(" = 40;
        ")" = 41;
        "*" = 42;
        "+" = 43;
        "," = 44;
        "-" = 45;
        "." = 46;
        "/" = 47;
        "0" = 48;
        "1" = 49;
        "2" = 50;
        "3" = 51;
        "4" = 52;
        "5" = 53;
        "6" = 54;
        "7" = 55;
        "8" = 56;
        "9" = 57;
        ":" = 58;
        ";" = 59;
        "<" = 60;
        "=" = 61;
        ">" = 62;
        "?" = 63;
        "@" = 64;
        "A" = 65;
        "B" = 66;
        "C" = 67;
        "D" = 68;
        "E" = 69;
        "F" = 70;
        "G" = 71;
        "H" = 72;
        "I" = 73;
        "J" = 74;
        "K" = 75;
        "L" = 76;
        "M" = 77;
        "N" = 78;
        "O" = 79;
        "P" = 80;
        "Q" = 81;
        "R" = 82;
        "S" = 83;
        "T" = 84;
        "U" = 85;
        "V" = 86;
        "W" = 87;
        "X" = 88;
        "Y" = 89;
        "Z" = 90;
        "[" = 91;
        "\\" = 92;
        "]" = 93;
        "^" = 94;
        "_" = 95;
        "`" = 96;
        "a" = 97;
        "b" = 98;
        "c" = 99;
        "d" = 100;
        "e" = 101;
        "f" = 102;
        "g" = 103;
        "h" = 104;
        "i" = 105;
        "j" = 106;
        "k" = 107;
        "l" = 108;
        "m" = 109;
        "n" = 110;
        "o" = 111;
        "p" = 112;
        "q" = 113;
        "r" = 114;
        "s" = 115;
        "t" = 116;
        "u" = 117;
        "v" = 118;
        "w" = 119;
        "x" = 120;
        "y" = 121;
        "z" = 122;
        "{" = 123;
        "|" = 124;
        "}" = 125;
        "~" = 126;
        "DEL" = 127;
    };

    # check if x in [l, u)
    element = l: u: x: l <= x && x < u;

    char = rec {
        chr = o: assert ascii o; builtins.elemAt chrLut o;
        ord = c: assert (builtins.stringLength c) == 1; ordLut."${c}";
        ascii = element 0 128;
        alpha = element (char.ord "a") (char.ord "z" + 1);
        Alpha = element (char.ord "A") (char.ord "Z" + 1);
        num = element (char.ord "0") (char.ord "9" + 1);

        lower = c: let
            o = ord c;
        in if Alpha o
            then chr (o + ord "a" - ord "A")
            else c;

        upper = c: let
            o = ord c;
        in if alpha o
            then chr (o + ord "A" - ord "a")
            else c;
    };
in char
