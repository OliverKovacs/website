let
    op = import ./op.nix;
    char = import ./char.nix;

    toCharArr = str: let
        at = (i: builtins.substring i 1 str);
    in builtins.map at (fun.range 0 ((builtins.stringLength str) - 1));

    mapChars = f: fun.comp (fun.join "") (fun.comp (builtins.map f) (fun.split ""));

    fun = rec {
        head = builtins.head;
        tail = builtins.tail;

        drop = n: arr: if (arr == [] || n == 0)
            then arr
            else drop (n - 1) (builtins.tail arr);

        take = n: arr: takeImpl n arr [];

        takeImpl = n: arr: out: if (arr == [] || n == 0)
            then out
            else takeImpl (n - 1) (builtins.tail arr) (out ++ [(builtins.head arr)]);

        slice = i: n: comp (take n) (drop i);

        cons = x: xs: [x] ++ xs;
        comp = f: g: x: f (g x);
        join = str: arr: if arr == []
            then ""
            else builtins.foldl' (e: op.add (op.add e str)) (builtins.head arr) (builtins.tail arr);

        fst = str: builtins.substring 0 1 str;
        rst = str: builtins.substring 1 (builtins.stringLength str - 1) str;
        flatten = arr: builtins.foldl' op.cat [] arr;
        range = l: u: if l == u
            then [ l ]
            else cons l (range (l + 1) u);

        swapargs = f: x: y: f y x;
        all = f: comp (builtins.foldl' op.and true) (builtins.map f);
        some = f: comp op.not (all (comp op.not f));
        includes = swapargs (comp some op.eq);

        zip = a: b: if a == [] || b == []
            then []
            else cons [ (head a) (head b) ] (zip (tail a) (tail b));

        attrEntries = set: let
            names = builtins.attrNames set;
            values = builtins.attrValues set;
        in zip names values;

        attrList = set: builtins.map
            (curry (n: v: { name = n; value = v; }))
            (attrEntries set);

        curry = f: x: (f (head x)) (head (tail x));
        uncurry = f: x: y: f [ x y ];

        test = regex: str: builtins.match regex str != null;

        split = sep: str: if sep == ""
            then toCharArr str
            else builtins.filter (op.neq []) (builtins.split sep str);

        min = x: y: if x < y
            then x
            else y;

        max = x: y: if x < y
            then y
            else x;

        par = path: let
            arr = split "/" path;
        in join "/" (slice 0 (builtins.length arr - 1) arr);

        strcmp = s1: s2: let
            char = import ./char.nix;
        in if s2 == ""
            then false
            else if s1 == ""
            then true
            else let
                o1 = char.ord (fst s1);
                o2 = char.ord (fst s2);
            in if o1 == o2
            then strcmp (rst s1) (rst s2)
            else o1 < o2;

        times = n: a: if n == 0
            then []
            else cons a (times (n - 1) a);

        rjust = c: n: str: let
            cnt = max 0 (n - (builtins.stringLength str));
        in (join "" (times cnt c)) + str;

        toLower = mapChars char.lower;
        toUpper = mapChars char.upper;
    };
in fun
