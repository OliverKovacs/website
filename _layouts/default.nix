{ page, includes, content, config, ... }:
''
<!DOCTYPE html>
<html lang="${ page.lang or config.lang or "en" }">

  ${ includes.head }

  <body>
    <a id="skip" href="#main"><h2>Skip to main content</h2></a>

    ${ content }

  </body>

</html>
''
