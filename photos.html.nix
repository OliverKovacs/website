{ layouts, includes, posts, help, data, ... }@site:
let
    page = {
        title = "Photos";
        noKatex = true;
        noCode = true;
    };
in
layouts.withPage.other page ''
Some photos I took.

<div id="photos">
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
</div>
''
