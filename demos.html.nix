{ layouts, includes, posts, help, data, ... }:
let
    page = {
        title = "Demos";
        noKatex = true;
        noCode = true;
    };
in
layouts.withPage.other page ''
<ul id="demos" class="card-list">
${
    help.map
        (el: ''<li>${ includes.uiCard el }</li>'')
        data.demos
}
''
