{ layouts, includes, content, ... }:
layouts.default ''
<div class="content">
    <header>
        ${ includes.colorRow }
        ${ includes.title }
        ${ includes.contacts false }
    </header>

    <main id="main">
        ${ content }
    </main>
</div>
''
