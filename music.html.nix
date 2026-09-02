{ layouts, includes, posts, help, data, ... }@site:
let
    page = {
        title = "Music";
        id = "music";
        noKatex = true;
        noCode = true;
    };
in
layouts.withPage.other page ''
List of some music I like.

<ul id="music" class="card-list">
${
    help.map
        (el: ''<li>${ includes.uiCard el }</li>'')
        data.music
}
</ul>
''
