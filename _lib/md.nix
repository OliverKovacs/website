# try to parse frontmatter of markdown file to nix attribute set
let
    p = import ./parsers.nix;
    fun = import ./fun.nix;
    op = import ./op.nix;
    help = import ./help.nix;

    all = str: [ { res = str; str = ""; } ];
    many = q: p.mut (many1 q) (p.ret {});
    many1 = q: p.bind q (t: p.bind (many q) (ts: p.ret (ts // t)));

    key = p.bind (p.while1 (c: c != " " && c != ":"))
        (k: p.ret k);

    value = p.bind (p.while1 (c: c != "" && c != "\n"))
        (v: p.ret v);

    sep = p.seq (p.char ":")
        (p.seq (p.many (p.char " "))
        (p.ass (fun.comp (op.neq " ") fun.fst)));

    keyvalue = p.bind key
        (k: p.seq sep (p.bind value
        (v: p.seq (p.char "\n")
        (p.ret (builtins.listToAttrs [ { name = k; value = v; } ])))));

    frontmatter = p.seq (p.string "---\n")
        (p.bind (many keyvalue)
        (u: p.seq (p.string "---\n")
        (p.seq (p.many (p.char "\n"))
        (p.seq (p.ass (fun.comp (op.neq "\n") fun.fst))
        (p.ret u)))));

    impl = str: (p.sel (p.bind frontmatter
        (u: p.bind all
        (v: p.ret {
            meta = builtins.mapAttrs (_: help.stripQuotes) u;
            markdown = v;
        })))
        (p.bind all
        (u: p.ret { meta = {}; markdown = u; }))) str;
in
rec {
    # TODO assert len, error handling
    parse = str: (builtins.head (impl str)).res;
}
