# TODO this is an ugly hack
let
    iconTheme = { href, src }:
    ''
    <li>
        <a href="${ href }">
            <img class="light-mode-hide" src="./assets/img/icons/dark/${ src }">
            <img class="dark-mode-hide" src="./assets/img/icons/light/${ src }">
        </a>
    </li>
    '';
    iconDark = { href, src }:
    ''
    <li>
        <a href="${ href }">
            <img src="/assets/img/icons/dark/${ src }">
        </a>
    </li>
    '';
    icon = forceDark: if forceDark
        then iconDark
        else iconTheme;
in
{ data, help, ... }: forceDark:
''
<nav class="contacts">
<ul>
${ help.map (icon forceDark) data.contact }
</ul>
</nav>
''
