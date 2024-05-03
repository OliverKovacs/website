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
            {% include ui-icon-obj.html prefix="./assets/img/languages/" element=element %}
        {% endfor %}
    </ul>
    <br>
    <br>
    <h2 class="primary">Technologies</h2>
    <ul id="technology-list">
        {% for element in site.data.technologies %}
            {% include ui-icon-obj.html prefix="./assets/img/technologies/" element=element %}
        {% endfor %}
    </ul>
</div>

<div class="page">
    <h2 class="primary">Writeups</h2>
    <ul id="project-list">
        {% for post in site.posts %}
            {% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}
        {% endfor %}
    </ul>
    <br>
    <br>
    <br>
    <h2 class="primary">Projects</h2>
    <ul id="project-list">
        {% for element in site.data.projects %}
            {% include ui-card-obj.html prefix="./assets/img/" element=element %}
        {% endfor %}
    </ul>
    <br>
    <br>
    <br>
    <h2 class="primary">Demos</h2>
    <ul id="demo-list">
        {% for element in site.data.demos %}
            {% include ui-card-obj.html prefix="./assets/img/" element=element %}
        {% endfor %}
    </ul>
</div>

<div class="page">
    <h2 class="primary">Music</h2>
    <ul id="music-list">
        {% for element in site.data.music %}
            {% include ui-card-obj.html prefix="./assets/img/music/" element=element %}
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
