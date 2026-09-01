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

    <main id="main">
        <article>
            ${ content }
        </article>
    </main>

    ${ includes.prevNext }
</div>
''
