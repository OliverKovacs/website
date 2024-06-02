---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
title: Oliver Kovacs
layout: home
---

<div class="page">
    <h1>
        <img alt="" id="pfp" src="assets/img/projects/pfp.png">
        {{ page.title }}
    </h1>
    <ul>
        {% for element in site.data.contact %}
            {% capture src %}./assets/img/contact/{{ element.src }}{% endcapture %}
            {% include ui-contact.html href=element.href src=src %}
        {% endfor %}
    </ul>
    <br>
    <p>Navigate using <span class="key">j</span> <span class="key">k</span></p>
    <p>Rotate using <span class="key">1</span> <span class="key">2</span> <span class="key">3</span></p>
    <h2>Languages</h2>
    <ul class="vert-list">
        {% for element in site.data.languages %}
            {% include ui-icon-obj.html prefix="./assets/img/languages/" element=element %}
        {% endfor %}
    </ul>
    <h2>Technologies</h2>
    <ul id="technology-list">
        {% for element in site.data.technologies %}
            {% include ui-icon-obj.html prefix="./assets/img/technologies/" element=element %}
        {% endfor %}
    </ul>
    <h2>Blog</h2>
    <ul class="vert-list">
        {% for post in site.posts %}
            {% if post.categories contains "blog" %}
                {% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}
            {% endif %}
        {% endfor %}
    </ul>
    <h2>Writeups</h2>
    <ul class="vert-list">
        {% for post in site.posts %}
            {% if post.categories contains "writeup" %}
                {% include ui-card.html prefix="" src=post.icon href=post.url title=post.title text=post.text %}
            {% endif %}
        {% endfor %}
    </ul>
    <h2>Projects</h2>
    <ul class="vert-list">
        {% for element in site.data.projects %}
            {% include ui-card-obj.html prefix="./assets/img/" element=element %}
        {% endfor %}
    </ul>
    <h2>Demos</h2>
    <ul>
        {% for element in site.data.demos %}
            {% include ui-card-obj.html prefix="./assets/img/" element=element %}
        {% endfor %}
    </ul>
    <h2>Music</h2>
    <ul class="vert-list">
        {% for element in site.data.music %}
            {% include ui-card-obj.html prefix="./assets/img/music/" element=element %}
        {% endfor %}
    </ul>
    <h2>About</h2>
    <ul>
        Made with 
        {% include ui-icon.html href="https://www.typescriptlang.org/" src="./assets/img/languages/ts.svg" text="TypeScript" %}
        {% include ui-icon.html href="https://jekyllrb.com/" src="./assets/img/technologies/jekyll.svg" text="Jekyll" %}
        {% include ui-icon.html href="https://www.khronos.org/webgl/" src="./assets/img/technologies/webgl.svg" text="WebGL" %}
    </ul>
    <ul>
        Made by 
        {% include ui-icon.html href="https://github.com/OliverKovacs" src="./assets/img/projects/pfp.png" text="me" %}
    </ul>
    <ul>
        Hosted on 
        {% include ui-icon.html href="https://pages.github.com/" src="./assets/img/contact/github.svg" text="GitHub" %}
    </ul>
    <br>
    Press <span class="key">Enter</span>
    <br>
    <br>
    <br>
</div>
