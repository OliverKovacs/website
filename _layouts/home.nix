{ layouts, includes, content, ... }:
layouts.default
''
<canvas id="canvas" class="background"></canvas>

<div class="content">
    <header>
        ${ includes.title }
        ${ includes.contacts true }
    </header>

    <main id="main" class="home">
        ${ content }
    </main>

    <footer class="home dark">
        ${ includes.info }
        ${ includes.polyring }
    </footer>
</div>
''
