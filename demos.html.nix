{ layouts, includes, posts, help, data, ... }@site:
let
    page = {
        title = "Demos";
    };
in
layouts.withPage.other page ''
<br>

<ul class="row-list">
${
    help.map
        (el: ''<li>${ includes.uiCard el }</li>'')
        data.demos
}
''
