let
    fun = import ./fun.nix;
    op = import ./op.nix;
in rec {
    id = str: [ { res = str; str = str; } ];
    fail = str: [];
    ret = res: str: [ { res = res; str = str; } ];
    item = str: if str == ""
        then []
        else [ { res = fun.fst str; str = fun.rst str; } ];
    bind = p: g: str': fun.flatten (builtins.map ({ res, str }: (g res) str) (p str'));

    sat = pred: bind item (u: if pred u
        then ret u
        else fail);

    ass = pred: bind id (u: if pred u
        then id
        else fail);

    mut = p: q: str: (p str) ++ (q str);
    sel = p: q: str: let res = p str; in if res == []
        then q str
        else res;

    opt = p: str: let res = p str; in if res == []
        then id str
        else res;

    seq = p: q: bind p (_: q);

    char = c: sat (op.eq c);
    string = str: if str == ""
        then ret ""
        else seq (char (fun.fst str)) (seq (string (fun.rst str)) (ret str));

    many = p: mut (many1 p) (ret []);
    many1 = p: bind p (t: bind (many p) (ts: ret (fun.cons t ts)));

    times = n: p: if n == 0
        then id
        else seq p (times (n - 1) p);

    # TODO
    while = pred: bind (many (sat pred)) (fun.comp ret (fun.join ""));
    while1 = pred: bind (many1 (sat pred)) (fun.comp ret (fun.join ""));

    arr = mul: ps: if builtins.length ps == 1
        then builtins.head ps
        else mul (builtins.head ps) (arr mul (builtins.tail ps));

    strict = fun.comp builtins.fromJSON builtins.toJSON;
}
