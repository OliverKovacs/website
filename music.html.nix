{ layouts, includes, posts, help, data, ... }@site:
let
    page = {
        title = "Music";
        id = "music";
    };
in
layouts.withPage.other page ''
<br>

List of some music I like.

<br>
<br>

<!-- TODO fix -->

<ul id="music" class="card-list">
${
    help.map
        (el: ''<li>${ includes.uiCard el }</li>'')
        data.music
}
</ul>
''
