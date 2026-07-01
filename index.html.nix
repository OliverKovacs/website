{ layouts, includes, posts, fun, data, help, ... }@site:
let
    page = {
        title = "Oliver Kovacs";
    };
in
layouts.withPage.home page ''
<h2 id="about">
    About <a href="#about">#</a>
</h2>

<p>I’m a computer science student at ETH Zürich, software engineer, and hacker.
Also known as dnydxn.
You can find my
<a href="/assets/pdf/Oliver_Kovacs-CV-public-en.pdf" target="_blank">CV here</a>.</p>

<h2 id="blog">
    Blog <a href="#blog">#</a>
</h2>
<ul>
${
    help.map
        ({ meta, ... }:
            ''<li>${ includes.uiCard {
                title = meta.title;
                text = ''${ meta.tags }<br>${ help.formatDate (help.parseDate meta.date) }'';
                src = meta.icon;
                href = meta.path;
            } }</li>'')
        (builtins.filter (help.inCategory "blog") posts)
}
</ul>

<h2 id="writeups">
    Writeups <a href="#writeups">#</a>
</h2>
<ul>
${
    help.map
        ({ meta, ... }:
            ''<li>${ includes.uiCard {
                title = meta.title;
                text = meta.text;
                src = meta.icon;
                href = meta.path;
            } }</li>'')
        (builtins.filter (help.inCategory "writeup") posts)
}
</ul>

<h2 id="projects">
    Projects <a href="#projects">#</a>
</h2>
<ul>
${
    help.map
        (el: ''<li>${ includes.uiCard el }</li>'')
        data.projects
}

<h2 id="publications">
    Publications <a href="#publications">#</a>
</h2>
<ul>
${
    help.map
        ({ meta, ... }:
            ''<li>${ includes.uiCard {
                title = meta.title;
                text = meta.text;
                src = meta.icon;
                href = meta.path;
            } }</li>'')
        (builtins.filter (help.inCategory "publication") posts)
}
</ul>

<h2 id="demos">
    <a href="./demos.html">Demos</a> <a href="#demos">#</a>
</h2>

<h2 id="photos">
    <a href="./photos.html">Photos</a> <a href="#photos">#</a>
</h2>

<h2 id="music">
    <a href="./music.html">Music</a> <a href="#music">#</a>
</h2>
''
