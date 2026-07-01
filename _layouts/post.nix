{ layouts, includes, content, page, fun, help, ... }:
layouts.default
''
<div class="content">
    <header>
        ${ includes.colorRow }

        <h1>${ page.title }</h1>
        <nav>
        <table style="width: 100%;"><tr>
            <td><time datetime="${ page.date }">
                ${ help.formatDate (help.parseDate page.date) }
            </time></td>
            <td><a id="author" href="/">
                ${ page.author }
            </a></td>
            </tr></table>
        </nav>
    </header>

    <main id="main">
        <article>
            ${ content }
        </article>
    </main>

    <footer>
        <table style="width: 100%;"><tr>
            ${
                if page.prev != null
                    then ''
                        <td><a class="prev" href="/${ page.prev.meta.path }">
                            Previous: ${ page.prev.meta.title }
                        </a></td>
                    ''
                    else ""
            }
            ${
                if page.next != null
                    then ''
                        <td><a class="next" href="/${ page.next.meta.path }">
                            Next: ${ page.next.meta.title }
                        </a></td>
                    ''
                    else ""
            }
        </tr></table>
    </footer>
</div>
''
