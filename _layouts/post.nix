{ layouts, includes, content, page, ... }:
layouts.default
''
<div class="content">
    <header>
        ${ includes.colorRow }

        <h1 class="underline"><a href="/">
            ${ page.title }
        </a></h1>

        ${ includes.dateAuthor }
    </header>

    <main id="main" class="post">
        <article>
            ${ content }
        </article>
    </main>

    ${
        if page ? noPrevNext
            then ""
            else includes.prevNext
    }
</div>
''
