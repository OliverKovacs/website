{ includes, ... }:
''
    <h2 id="info">
        Info
        <a href="#info">#</a>
    </h2>

    <p>
    Made with${
        includes.uiIcon { href = "https://nixos.org/"; src = "./assets/img/technologies/nix.svg"; text = "Nix"; }
    }${
        includes.uiIcon { href = "https://www.typescriptlang.org/"; src = "./assets/img/languages/ts.svg"; text = "TypeScript"; }
    }${
        includes.uiIcon { href = "https://www.khronos.org/webgl/"; src = "./assets/img/technologies/webgl.svg"; text = "WebGL"; }
    }
    </p>

    <p>
    Made by${ includes.uiIcon { href = "https://github.com/OliverKovacs"; src = "./assets/img/projects/pfp.png"; text = "me"; } }
    </p>

    <p>
    Hosted on${ includes.uiIcon { href = "https://pages.github.com/"; src = "./assets/img/contact/github.svg";  text = "GitHub"; } }
    </p>
''
