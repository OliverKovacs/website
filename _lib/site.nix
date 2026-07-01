let
    build = import ./build.nix;
    site = rec {
        fun = import ./fun.nix;
        help = import ./help.nix;
        op = import ./op.nix;
        config = (import ./config.nix) // (import ./../_config.nix);

        # TODO path handling
        data = build.importData config.path.data;
        includes = build.importIncludes config.path.includes;
        layouts = build.mkLayouts {} config.path.layouts;
        posts = build.mkPosts config.path.posts;
    };
in site
