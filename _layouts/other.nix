{ layouts, includes, content, ... }:
layouts.default ''
<div class="content">
    <header>
        ${ includes.header }
    </header>

    <main id="main" class="home">
        ${ content }
    </main>
</div>
''
