{ pkgs ? import <nixpkgs> {} }: let
    build = import ./_lib/build.nix;
    site = import ./_lib/site.nix;

    postLines = build.mkPostLines pkgs site.posts;
    pageLines = build.mkPageLines ./.;
    copyLines = build.mkCopyLines ./.;
    feedLines = build.mkFeedLines site;

    drv = pkgs.stdenvNoCC.mkDerivation {
        pname = "website";
        version = "1";

        nativeBuildInputs = [ pkgs.pandoc pkgs.tree ];

        src = null;
        dontUnpack = true;
        # dontFixup = true;

        buildPhase = ''
            ${ copyLines }
            ${ postLines }
            ${ pageLines }
            ${ feedLines }
        '';

        installPhase = ''
            mkdir -p "$out"
            cp -r out/* "$out/"
            cp -r out/.* "$out/"
        '';
    };
in drv
