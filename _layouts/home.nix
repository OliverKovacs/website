{ layouts, includes, content, ... }:
layouts.default
''
<div class="content">
    <header>
        ${ includes.header }
        <!--<p>Navigate using <span class="key"> Tab </span></p>-->
        <!--<p>Rotate using <span class="key">1</span> <span class="key">2</span> <span class="key">3</span></p>-->
    </header>

    <main id="main" class="home">
        ${ content }
        <!--{% include anchor_headings.html html=content anchorBody="#" %}-->
    </main>

    ${ includes.footer }
</div>
''
