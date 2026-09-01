{ page, ... }:
let
    optional = arg: pref: class: if arg != null
        then ''
            <td><a class="${ class }" href="/${ arg.meta.path }">
                ${pref}: ${ arg.meta.title }
            </a></td>
        ''
        else "";
in
''
<footer class="prevnext">
<table style="width: 100%;"><tr>
    ${ optional page.prev "Prev" "prev" }
    ${ optional page.next "Next" "next" }
</tr></table>
</footer>
''
