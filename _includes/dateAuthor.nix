{ help, page, ... }:
''
<nav class="dateauthor">
    <table><tr>
        ${
            if page ? date
                then ''
                    <td><time datetime="${ page.date }">
                        ${ help.formatDate (help.parseDate page.date) }
                    </time></td>
                ''
                else ""
        }
        <td><a id="author" href="/">
            ${ page.author }
        </a></td>
    </tr></table>
</nav>
''
