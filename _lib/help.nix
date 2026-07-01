let
    site = import ./site.nix;
    fun = import ./fun.nix;
in
rec {
    page = f: f (site);
    post = meta: page ({ layouts, ...}: let
        layout = builtins.getAttr meta.layout layouts.withPage;
    in layout meta);

    inCategory = category: { meta, ... }: fun.test ''.*${category}.*'' meta.category;
    map = fun.comp (fun.comp (fun.join "")) builtins.map;

    # TODO improve date handling
    # TODO assert valid
    parseDate = date: let
        norm = str: if str == "0" || (fun.fst str) != "0"
            then str
            else norm (fun.rst str);
        parseNum = str: builtins.fromJSON (norm str);
    in {
        year = parseNum (builtins.substring 0 4 date);
        month = parseNum (builtins.substring 5 2 date);
        day = parseNum (builtins.substring 8 2 date);
        hour = parseNum (builtins.substring 11 2 date);
        minute = parseNum (builtins.substring 14 2 date);
        second = parseNum (builtins.substring 17 2 date);
    };

    formatDate = { year, month, day, hour, minute, second }: let
        lut = [ "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec" ];
        y = builtins.toJSON year;
        m = builtins.elemAt lut (month - 1);
        d = builtins.toJSON day;
    in ''${y} ${m} ${d}'';

    toAscii = builtins.replaceStrings
        [ "ä" "Ä" "ö" "Ö" "ü" "Ü" "ß"]
        [ "ae" "AE" "oe" "OE" "u" "UE" "ss"];

    toSlug = str:
        let
            slugged = builtins.replaceStrings
                [ " " "_" "." "," "!" "?" "'" "\"" ]
                [ "-" "-" "-" "-" "-" "-" "-" "-" ]
                str;
            cleaned = builtins.replaceStrings [ "--" ] [ "-" ] slugged;
        in cleaned;

    stripQuotes = str: let
        len = builtins.stringLength str;
        fst = builtins.substring 0 1 str;
        lst = builtins.substring (len - 1) 1 str;
    in if len >= 2 && fst == "\"" && lst == "\""
        then builtins.substring 1 (len - 2) str
        else str;
}
