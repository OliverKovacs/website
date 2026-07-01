let
    fun = import ./fun.nix;
    help = import ./help.nix;
    op = import ./op.nix;
    md = import ./md.nix;
    site = import ./site.nix;
    feed = import ./feed.nix;

    pathJoin = path: file: path + ("/" + file);
    toId = meta: fun.toLower
        (help.toAscii
        (help.toSlug
        (help.stripQuotes
        (meta.title or "none"))));

    # TODO this is stupid
    rmExt = ext: builtins.replaceStrings [ext] [""];
in rec {
    readAll = path: builtins.map
        (e: fun.rst (fun.join "" (builtins.tail e)))
        (readAllImpl ({ value, ... }: value != "directory") [ path ]);

    readAllImpl = pred: path: let
        join = path: name: path ++ [("/" + name)];
        names = builtins.map ({ name, ... }: name);
        entries = fun.attrList (builtins.readDir (fun.join "" path));
        regular = names (builtins.filter pred entries);
        directory = names (builtins.filter ({ value, ... }: value == "directory") entries);
    in (builtins.map (join path) regular)
        ++ (fun.flatten (builtins.map (fun.comp (readAllImpl pred) (join path)) directory));

    getCopyFiles = path: let
        pred = f: !(fun.test "^.*\\.html\\.nix$" f)
            && !(fun.test "^\\.git/.*$" f)
            && !(fun.test "^\\.gitignore$" f)
            && !(fun.test "^_.*$" f)
            && !(fun.test "^result$" f)
            && !(fun.test "^Makefile$" f)
            && !(fun.test "^tsconfig.json$" f)
            && !(fun.test "^package.json$" f)
            && !(fun.test "^package-lock.json$" f)
            && !(fun.test "^TODO.md$" f)
            && !(fun.test "^README.md$" f);
    in builtins.filter pred (readAll path);

    getPageFiles = path: builtins.filter
        (fun.test "^.*\\.html\\.nix$")
        (readAll path);

    getNixFiles = path: builtins.filter
        (fun.test ".*\\.nix$")
        (readAll path);

    getJSONFiles = path: builtins.filter
        (fun.test ".*\\.json$")
        (readAll path);





    derivePost = pkgs: { meta, markdown }@post: let
        pandocDrv = pkgs.stdenvNoCC.mkDerivation {
            name = "pandoc-${ meta.id }";
            nativeBuildInputs = [ pkgs.pandoc ];
            dontUnpack = true;
            buildPhase = ''
                cat > "input.md" <<'EOF'
${ markdown }
EOF
                mkdir -p $out
                pandoc "input.md" -f markdown -t html -o $out/output.html
            '';
        };
        htmlDrv = let
            input = builtins.readFile "${ pandocDrv }/output.html";
        in pkgs.stdenvNoCC.mkDerivation {
            name = "html-${ meta.id }";
            dontUnpack = true;
            buildPhase = ''
                mkdir -p $out
                cat > $out/output.html <<'EOF'
${ help.post meta input }
EOF
            '';
        };
    in post // { file = "${ htmlDrv }/output.html"; };

    mkCopyLines = path: let
        files = getCopyFiles path;
        # TODO duplicates
        dirLines = fun.join "\n" (builtins.map
            (f: ''mkdir -p out/${f}'')
            (builtins.map fun.par files));
        copyLines = fun.join "\n" (builtins.map
            (f: ''cp -P ${ pathJoin path f } out/${ f }'')
            files);
    in ''
        ${ dirLines }
        ${ copyLines }
    '';

    mkPostLines = pkgs: posts: let
        drvs = builtins.map (derivePost pkgs) posts;
    in help.map
        ({ meta, file, ... }: ''
            mkdir -p out/${ meta.par }
            cp ${ file } out/${ meta.path }
        '')
        drvs;

    mkPageLines = path: let
        files = getPageFiles path;
    in help.map
        (page: ''
        cat > out/${rmExt ".nix" page} <<'EOF'
${ help.page (import (pathJoin path page)) }
EOF
        '')
        files;

    mkFeedLines = site: let
        xml = feed.generate site;
    in ''
        cat > "out/feed.xml" <<'EOF'
${ xml }
EOF
    '';




    mkPost = { meta, ... }@args: let
            id = toId meta;
            pad = n: x: fun.rjust "0" n (builtins.toJSON x);
            date = help.parseDate meta.date;
            yyyy = pad 4 date.year;
            mm = pad 2 date.month;
            dd = pad 2 date.day;
            par = "${ meta.category }/${ yyyy }/${ mm }/${ dd }";
        in args // {
            meta = meta // {
                id = id;
                par = par;
                updated = meta.updated or meta.date;
                path = "${ par }/${ id }.html";
            };
        };

    linkPrevNext = posts: let
        pp = fun.cons null posts;
        nn = (fun.drop 1 posts) ++ [null];
        aa = fun.zip posts (fun.zip pp nn);
        merge = fun.curry (post: fun.curry (prev: next: post
            // { meta = post.meta // { prev = prev; next = next; }; }));
    in builtins.map merge aa;

    mkPosts = path: linkPrevNext
        (builtins.map mkPost
        (builtins.map md.parse
        (builtins.map builtins.readFile
        (builtins.map (pathJoin path)
        (readAll path)))));



    # TODO improve
    importDir = path: builtins.listToAttrs
        (builtins.map (f: { name = rmExt ".nix" f; value = import (pathJoin path f); }) (getNixFiles path));

    # TODO improve
    importData = path: builtins.listToAttrs
        (builtins.map (f: { name = rmExt ".json" f; value = builtins.fromJSON (builtins.readFile (pathJoin path f)); })
        (getJSONFiles path));

    # TODO improve, do not reimport every time

    importMap = f: path: builtins.mapAttrs (_: f) (importDir path);

    importIncludes = importMap mkInclude;
    importLayouts = importMap mkLayout;
    importLayoutsWithPage = path: page: importMap (f: mkLayout f page) path;

    mkLayouts = page: path: (importLayoutsWithPage path page)
        // { withPage = importLayouts path; };

    mkInclude = f: f site;
    mkIncludeWithPage = page: f: f (site // { page = page; });

    mkLayout = f: page: content: f ((site // {
        includes = importMap (mkIncludeWithPage page) site.config.path.includes;
        layouts = mkLayouts page site.config.path.layouts;
    }) // { page = page; content = content; });
}
