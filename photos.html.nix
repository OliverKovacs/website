{ layouts, includes, posts, help, data, ... }@site:
let
    page = {
        title = "Photos";
    };
in
layouts.withPage.other page ''
<main>
    <br>
    Some photos I took.
    <br>
    <br>
    <br>
    ${
        help.map
            ({ location, date }: ''
                <figure class="photo">
                    <img src="./assets/img/photos/${ date }.jpg" alt="photo" tabindex="0"/>
                    <figcaption>
                        ${ location } ${ date }
                    </figcaption>
                </figure>
            '')
            data.photos
    }
</main>
''
