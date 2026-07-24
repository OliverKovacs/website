{ layouts, includes, posts, help, data, ... }@site:
let
    page = {
        title = "Music";
    };
in
layouts.withPage.other page ''
<br>

List of some music I like.

<br>
<br>
<br>
<!-- TODO fix -->

<ul id="music">
${
    help.map
        (el: ''<li>${ includes.uiCard el }</li>'')
        data.music
}
</ul>
''
