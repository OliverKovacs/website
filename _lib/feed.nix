# https://www.rfc-editor.org/info/rfc4287/
let
    fun = import ./fun.nix;
    help = import ./help.nix;
in rec {
    esc = str: assert !fun.test ".*\]\]>.*" str;
        ''<![CDATA[${str}]]>'';

    title = { config, ... }: if config ? title
        then ''<title type="html">${ esc config.title }</title>''
        else "<!-- title -->";

    subtitle = { config, ... }: if config ? subtitle
        then ''<subtitle type="html">${ esc config.subtitle }</subtitle>''
        else "<!-- subtitle -->";

    generator = let
        url = "https://github.com/OliverKovacs/website/blob/main/_lib/feed.nix";
        ver = "0.1.0";
        name = "Website generator script by Oliver Kovacs";
    in ''<generator uri="${ url }" version="${ ver }">${ name }</generator>'';

    link = href: rel: type: other:
        ''<link href="${ href }" rel="${ rel }" type="${ type }" ${ other }/>'';

    updated = { posts, ...}: let
        dates = builtins.map ({ meta, ... }: meta.date) posts;
        sorted = builtins.sort (s1: s2: !(fun.strcmp s1 s2)) dates;
    in if sorted != []
        then ''<updated>${ builtins.head sorted }</updated>''
        else "<!-- updated -->";

    id = { config, ... }: ''<id>https://${ config.host  }/feed.xml</id>'';

    author = post: if post ? author
        then "<author><name>${ post.author }</name></author>"
        else "<!-- author -->";

    category = post: if post ? category
        then ''<category term="${ post.category }" />''
        else "<!-- category -->";

    entry = { config, ... }: { meta, ... }: let
        href = "https://${ config.host }/${ meta.path }";
    in ''
        <entry>
            <title type="html">${ esc meta.title }</title>
            ${ link href "alternate" "text/html" ''title="${ meta.title }"''}
            <id>https://${ config.host }/${ meta.par }/${ meta.id }</id>
            <published>${ meta.date }</published>
            <updated>${ meta.updated }</updated>
            ${ author meta }
            ${ category meta }
            <summary></summary>
            <content type="text/html" src="${ href }"></content>
        </entry>
    '';

    generate = site: let
        base = ''https://${ site.config.host }'';
        lang = site.config.lang;
    in ''
        <?xml version="1.0" encoding="utf-8"?>
        <feed xmlns="http://www.w3.org/2005/Atom" >
        ${ title site }
        ${ subtitle site }
        ${ id site }
        ${ link "${ base }/feed.xml" "self" "application/atom+xml" "" }
        ${ link "${ base }/" "alternate" "text/html" ''hreflang="${ lang }"'' }
        ${ updated site }
        ${ generator }
        ${ help.map (entry site) site.posts }
        </feed>
    '';
}
