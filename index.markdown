---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: Oliver Kovacs
layout: home
---

<div class="page">
    <h1 class="primary">
        <img alt="" id="pfp" src="assets/img/projects/pfp.png">
        {{ page.title }}
    </h1>
    <ul id="contact-list">
        {% for element in site.data.contact %}
            {% capture src %}./assets/img/contact/{{ element.src }}{% endcapture %}
            {% include ui-contact.html href=element.href src=src %}
        {% endfor %}
    </ul>
    <br>
    <br>
    Navigate using {% include ui-key.html content="j"%}{% include ui-key.html content="k"%}
    <br>
    <div style="height: 5px"></div>
    Rotate using {% include ui-key.html content="1"%}{% include ui-key.html content="2"%}{% include ui-key.html content="3"%}
    <br>
    <br>
    <br>
    <h2 class="primary">Languages</h2>
    <ul id="language-list">
        {% for element in site.data.languages %}
            {% capture src %}./assets/img/languages/{{ element.src }}{% endcapture %}
            {% include ui-icon.html href=element.href src=src text=element.text %}
        {% endfor %}
    </ul>
    <br>
    <br>
    <h2 class="primary">Technologies</h2>
    <ul id="technology-list">
        {% for element in site.data.technologies %}
            {% capture src %}./assets/img/technologies/{{ element.src }}{% endcapture %}
            {% include ui-icon.html href=element.href src=src text=element.text %}
        {% endfor %}
    </ul>
</div>

<div class="page">
    <h2 class="primary">Writeups</h2>
    <ul id="music-list">
        {% for element in site.data.writeups %}
            {% capture src %}./assets/img/{{ element.src }}{% endcapture %}
            {% include ui-card.html src=src title=element.title text=element.text %}
        {% endfor %}
    </ul>
    <br>
    <br>
    <br>
    <h2 class="primary">Projects</h2>
    <ul id="project-list">
        {% for element in site.data.projects %}
            {% capture src %}./assets/img/{{ element.src }}{% endcapture %}
            {% include ui-card.html src=src title=element.title text=element.text %}
        {% endfor %}
    </ul>
    <br>
    <br>
    <br>
    <h2 class="primary">Demos</h2>
    <ul id="demo-list">
        {% for element in site.data.demos %}
            {% capture src %}./assets/img/{{ element.src }}{% endcapture %}
            {% include ui-card.html src=src title=element.title text=element.text %}
        {% endfor %}
    </ul>
</div>

<div class="page">
    <h2 class="primary">Music</h2>
    <ul id="music-list">
        {% for element in site.data.music %}
            {% capture src %}./assets/img/music/{{ element.src }}{% endcapture %}
            {% include ui-card.html src=src title=element.title text=element.text %}
        {% endfor %}
    </ul>
</div>

<div class="page">
    <h2 class="primary">About</h2>
    <ul id="about">
        Made with 
        {% include ui-icon.html href="https://www.typescriptlang.org/" src="./assets/img/languages/ts.svg" text="TypeScript" %}
        {% include ui-icon.html href="https://jekyllrb.com/" src="./assets/img/technologies/jekyll.svg" text="Jekyll" %}
        {% include ui-icon.html href="https://developer.mozilla.org/en-US/docs/Web/Web_Components" src="./assets/img/technologies/webcomponents.svg" text="Web Components" %}
        {% include ui-icon.html href="https://www.khronos.org/webgl/" src="./assets/img/technologies/webgl.svg" text="WebGL" %}
    </ul>
    <ul id="about">
        Made by 
        {% include ui-icon.html href="https://github.com/OliverKovacs" src="./assets/img/projects/pfp.png" text="me" %}
    </ul>
    <ul id="about">
        Hosted on 
        {% include ui-icon.html href="https://pages.github.com/" src="./assets/img/contact/github.svg" text="GitHub" %}
    </ul>
    <br>
    <br>
    Press {% include ui-key.html content="Enter"%}
</div>
