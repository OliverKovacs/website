{ layouts, includes, content, page, fun, help, ... }:
layouts.default
''
<div class="content">
    <header>
        ${ includes.colorRow }

        <h1>
            <a href="/">
                ${ page.title }
            </a>
        </h1>
        <nav>
        <table style="width: 100%;"><tr>
            </tr></table>
        </nav>
    </header>

    <main id="main">
        <article>
            ${ content }
        </article>
    </main>

    <footer>
    </footer>
</div>
''
