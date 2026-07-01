let
    helper = { href, src }:
    ''
    <li>
        <a href="${ href }">
            <img src="/assets/img/icons/dark/${ src }">
            <!--<img class="light-mode-hide" src="./assets/img/icons/dark/{{ element.src }}">
            <img class="dark-mode-hide" src="./assets/img/icons/light/{{ element.src }}">-->
        </a>
    </li>
    '';
in
{ page, data, help, ... }:
''
<h1>
    <a href="/">
        <img alt="logo" id="pfp" src="/assets/img/projects/pfp.png">
        ${ page.title }
    </a>
</h1>
<nav class="contacts">
    <ul>
    ${ help.map helper data.contact }
    </ul>
</nav>
''
