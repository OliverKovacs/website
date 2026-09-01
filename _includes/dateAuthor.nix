{ help, page, ... }:
''
<nav class="dateauthor">
    <table><tr>
        <td><time datetime="${ page.date }">
            ${ help.formatDate (help.parseDate page.date) }
        </time></td>
        <td><a id="author" href="/">
            ${ page.author }
        </a></td>
    </tr></table>
</nav>
''
