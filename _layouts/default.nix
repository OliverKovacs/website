{ page, includes, content, ... }@site:
''
<!DOCTYPE html>
<html lang="${ page.lang or site.config.lang or "en" }">

  ${ includes.head }

  <body>
    <a id="skip" href="#main"><h2>Skip to main content</h2></a>

    ${
        if page.title == "Oliver Kovacs" then
            ''<canvas id="canvas" class="background"></canvas>''
        else ""
    }

    ${ content }

  </body>

</html>
''
