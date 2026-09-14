{ layouts, includes, posts, help, data, fun, ... }@site:
let
    page = {
        title = "Reading";
        id = "reading";
        noKatex = true;
        noCode = true;
    };
in
let
    heading = year: ''<h3 id="${ year }">${ year }</h3>'';
    list = builtins.replaceStrings [ "\n" ] [ "<br>\n" ];
    l2026 = ''
Max Frisch - Homo Faber
Robert Musil - Die Amsel / Kleine Prosa
Szerb Antal - Utas és Holdvilág
Hermann Hesse - Der Steppenwolf
Ludwig Wittgenstein - Philosophische Untersuchungen
Elfriede Jelinek - Die Liebhaberinnen
Thomas Bernhard - Auslöschung
Hermann Hesse - Die Nürnberger Reise
Elias Canetti - Die Stimmen von Marrakesch
Thomas Mann - Mario und der Zauberer
Thomas Mann - Tonio Kröger
Friedrich Dürrenmatt - Der Verdacht
August Strindberg - Ein Traumspiel
Hermann Hesse - Narziß und Goldmund
Elias Canetti - Die gerettete Zunge
Robert Musil - Drei Frauen
Kertész Imre - Sorstalanság
Krasznahorkai László - Sátántangó'';
    l2025 = ''
Bertolt Brecht - Mutter Courage und ihre Kinder
Heinrich Böll - Was soll aus dem Jungen bloß werden?
Thomas Bernhard - Holzfällen
Ludwig Wittgenstein - Tractatus Logico-Philosophicus
Leo Tolstoy - Anna Karenina
Bertolt Brecht - Die Dreigroschenoper
Peter Handke - Der kurze Brief zum langen Abschied
Thomas Bernhard - Der Untergeher
W. G. Sebald - Die Ringe des Saturn
Jorge Luis Borges - Tlön, Uqbar, Orbis Tertius
Albert Camus - Der Fremde
Albert Camus - Der Mythos des Sisyphos
Georg Büchner - Leonce und Lena
Fjodor Dostojewski - Weiße Nächte
Thomas Bernhard - Heldenplatz
Joseph von Eichendorff - Aus dem Leben eines Taugenichts
Oscar Wilde - The Picture of Dorian Gray
Jane Austin - Pride and Prejudice
Alexander Pushkin - Eugen Onegin
Jack London - To Build a Fire
Ödön von Horváth - Der ewige Spießer
Peter Handke - Wunschloses Unglück
W. G. Sebald - Schwindel. Gefühle.
W. G. Sebald - Austerlitz'';
in
layouts.withPage.other page ''
Some books I enjoyed reading.

<!-- TODO fix -->

${ heading "2026" }

${ list l2026 }

${ heading "2025" }

${ list l2025 }

${ heading "2024" }

Stefan Zweig - Schachnovelle
''
